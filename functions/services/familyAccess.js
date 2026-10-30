/**
 * Pure helpers and Admin-SDK membership operations for co-parent invites
 * and child access. Callables live in familyController.js.
 */
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const {HttpsError} = require("firebase-functions/v2/https");
const {sendNotification} = require("../notification");
const {evaluateDelivery, claimDailySlot} = require("./notificationDelivery");
const {buildBrevoInvitationBody} = require("../utils/emailTemplate");
const {
  normalizeEmail,
  maskEmail,
  resolvePrimaryParentUid,
  permissionsForRole,
  buildChildrenCsv,
  nextDefaultChild,
  inviteOpenBlockReason,
} = require("./familyAccessHelpers");

const INVITE_COLLECTION = "co-parent-invitation";
const USERS_COLLECTION = "users";
const CHILDREN_COLLECTION = "children";
const SHARED_EVENT_COLLECTION = "shared_event";
const STATUS_REQUESTED = "REQUESTED";
const STATUS_ACCEPTED = "ACCEPTED";
const STATUS_REJECTED = "REJECTED";
const STATUS_CANCELLED = "CANCELLED";
const INVITE_TTL_MS = 14 * 24 * 60 * 60 * 1000;
const SENDER_EMAIL = "hardikkoladiya107@gmail.com";
const SENDER_NAME = "Loving Brain";
const BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";
const INVITE_BASE_URL = "https://www.lovingbrain.com/invite";
const INVITE_LINK_EXPIRED_MESSAGE =
  "This invitation link is invalid or has expired.";

const CHILD_SUBCOLLECTIONS = [
  "sleep_logs",
  "behaviours",
  "events",
  "states",
  "tantrum_logs",
  "mood_logs",
  "health_logs",
  "quick_notes",
  "experiments",
  "caregiver_permissions",
];

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} email
 * @return {Promise<{uid: string, data: object}|null>}
 */
async function findUserByEmail(db, email) {
  const clean = normalizeEmail(email);
  if (!clean) return null;
  const snap = await db
      .collection(USERS_COLLECTION)
      .where("email", "==", clean)
      .limit(1)
      .get();
  if (!snap.empty) {
    return {uid: snap.docs[0].id, data: snap.docs[0].data() || {}};
  }
  return null;
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} childId
 * @return {Promise<void>}
 */
async function deleteChildSubcollections(db, childId) {
  const childRef = db.collection(CHILDREN_COLLECTION).doc(childId);
  for (const name of CHILD_SUBCOLLECTIONS) {
    const snap = await childRef.collection(name).get();
    const batchSize = 400;
    let batch = db.batch();
    let count = 0;
    for (const doc of snap.docs) {
      batch.delete(doc.ref);
      count += 1;
      if (count >= batchSize) {
        await batch.commit();
        batch = db.batch();
        count = 0;
      }
    }
    if (count > 0) await batch.commit();
  }
  try {
    await db.collection("energy_bridge").doc(childId).delete();
  } catch (e) {
    logger.warn("energy_bridge delete skipped", {childId, error: String(e)});
  }
}

/**
 * Unlink one caregiver from one child and promote default_child when needed.
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<void>}
 */
async function unlinkCaregiverFromChild(db, params) {
  const {childId, targetUid} = params;
  const childRef = db.collection(CHILDREN_COLLECTION).doc(childId);
  const userRef = db.collection(USERS_COLLECTION).doc(targetUid);
  const [childSnap, userSnap] = await Promise.all([
    childRef.get(),
    userRef.get(),
  ]);
  if (!childSnap.exists) {
    throw new HttpsError("not-found", "Child not found.");
  }
  const childData = childSnap.data() || {};
  const primaryUid = resolvePrimaryParentUid(childData);
  if (primaryUid === targetUid) {
    throw new HttpsError(
        "failed-precondition",
        "The primary parent cannot be removed from their own child.",
    );
  }
  const parentIds = Array.isArray(childData.parent_reference_ids) ?
    childData.parent_reference_ids.map(String) :
    [];
  if (!parentIds.includes(targetUid)) {
    throw new HttpsError(
        "failed-precondition",
        "User is not linked to this child.",
    );
  }

  const batch = db.batch();
  batch.update(childRef, {
    parent_reference_ids: admin.firestore.FieldValue.arrayRemove(targetUid),
  });
  batch.delete(childRef.collection("caregiver_permissions").doc(targetUid));

  if (userSnap.exists) {
    const userData = userSnap.data() || {};
    const updates = {
      children: admin.firestore.FieldValue.arrayRemove(childRef),
    };
    const defaultId =
      userData.default_child && userData.default_child.id ?
        userData.default_child.id :
        null;
    if (defaultId === childId) {
      const next = nextDefaultChild(userData, childRef);
      updates.default_child = next || admin.firestore.FieldValue.delete();
    }
    if (
      params.clearPartnerAgainstUid &&
      userData.partner_user_id === params.clearPartnerAgainstUid
    ) {
      updates.partner_user_id = admin.firestore.FieldValue.delete();
    }
    batch.update(userRef, updates);
  }

  await batch.commit();
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<{invitationId: string, emailSent: boolean}>}
 */
async function createCoParentInvitation(db, params) {
  const {
    fromUid,
    toEmail,
    role,
    childIds,
    fromParentName,
  } = params;
  const cleanEmail = normalizeEmail(toEmail);
  const uniqueChildIds = [...new Set((childIds || []).map(String).filter(Boolean))];

  if (!fromUid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  if (!cleanEmail) {
    throw new HttpsError("invalid-argument", "toEmail is required.");
  }
  if (uniqueChildIds.length === 0) {
    throw new HttpsError("invalid-argument", "Select at least one child.");
  }

  const fromUserSnap = await db.collection(USERS_COLLECTION).doc(fromUid).get();
  if (!fromUserSnap.exists) {
    throw new HttpsError("failed-precondition", "User profile not found.");
  }
  const fromUser = fromUserSnap.data() || {};
  const fromEmail = normalizeEmail(fromUser.email);
  if (fromEmail && fromEmail === cleanEmail) {
    throw new HttpsError("invalid-argument", "Cannot invite yourself.");
  }

  const childNames = [];
  for (const childId of uniqueChildIds) {
    const childSnap = await db.collection(CHILDREN_COLLECTION).doc(childId).get();
    if (!childSnap.exists) {
      throw new HttpsError("not-found", `Child ${childId} not found.`);
    }
    const childData = childSnap.data() || {};
    const primary = resolvePrimaryParentUid(childData);
    if (primary !== fromUid) {
      throw new HttpsError(
          "permission-denied",
          "Only the primary parent can invite caregivers for this child.",
      );
    }
    const parentIds = Array.isArray(childData.parent_reference_ids) ?
      childData.parent_reference_ids.map(String) :
      [];
    const existingInvitee = await findUserByEmail(db, cleanEmail);
    if (existingInvitee && parentIds.includes(existingInvitee.uid)) {
      throw new HttpsError(
          "already-exists",
          "This person is already linked to that child.",
      );
    }
    if (childData.child_name) childNames.push(String(childData.child_name));
  }

  const pendingSnap = await db
      .collection(INVITE_COLLECTION)
      .where("to_parent", "==", cleanEmail)
      .where("status", "==", STATUS_REQUESTED)
      .get();
  for (const doc of pendingSnap.docs) {
    const data = doc.data() || {};
    const existingIds = Array.isArray(data.child_ids) ?
      data.child_ids.map(String) :
      String(data.children || "")
          .split(",")
          .map((s) => s.trim())
          .filter(Boolean);
    const overlap = uniqueChildIds.some((id) => existingIds.includes(id));
    if (overlap && data.from_uid === fromUid) {
      throw new HttpsError(
          "already-exists",
          "A pending invitation already exists for this email and child.",
      );
    }
  }

  const invitee = await findUserByEmail(db, cleanEmail);
  const now = Date.now();
  const invitePayload = {
    from_parent: fromEmail || normalizeEmail(fromUser.parent_email) || "",
    from_uid: fromUid,
    to_parent: cleanEmail,
    to_uid: invitee ? invitee.uid : null,
    role: (role || "Co-Parent").trim() || "Co-Parent",
    child_ids: uniqueChildIds,
    children: buildChildrenCsv(uniqueChildIds),
    status: STATUS_REQUESTED,
    created_at: new Date(now).toISOString(),
    expires_at: new Date(now + INVITE_TTL_MS).toISOString(),
    calender_events: true,
  };

  const inviteRef = await db.collection(INVITE_COLLECTION).add(invitePayload);
  const invitationId = inviteRef.id;
  const displayName =
    (fromParentName && String(fromParentName).trim()) ||
    fromUser.parent_name ||
    fromUser.display_name ||
    "A parent";
  const childrenNames =
    childNames.length > 0 ? childNames.join(" & ") : "your child";

  let emailSent = false;
  const apiKey = process.env.BREVO_API_KEY;
  if (apiKey) {
    try {
      const invitationLink = `${INVITE_BASE_URL}/${invitationId}`;
      const response = await fetch(BREVO_API_URL, {
        method: "POST",
        headers: {
          "api-key": apiKey,
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: JSON.stringify(buildBrevoInvitationBody({
          toEmail: cleanEmail,
          fromParentName: displayName,
          childrenNames,
          invitationId,
          invitationLink,
          sender: {name: SENDER_NAME, email: SENDER_EMAIL},
        })),
      });
      emailSent = response.ok;
      if (!response.ok) {
        const errorText = await response.text();
        logger.error("Brevo invite email failed", {
          status: response.status,
          errorText,
        });
      }
    } catch (error) {
      logger.error("Brevo invite email exception", {error: String(error)});
    }
  } else {
    logger.error("BREVO_API_KEY missing; invitation email not sent.");
  }

  if (invitee) {
    const notifRef = db
        .collection(USERS_COLLECTION)
        .doc(invitee.uid)
        .collection("notifications")
        .doc(invitationId);
    await notifRef.set({
      type: "co_parent_invitation",
      invitation_id: invitationId,
      from_uid: fromUid,
      from_name: displayName,
      child_names: childrenNames,
      status: STATUS_REQUESTED,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
    });
    const token = invitee.data.fcm_token;
    const decision = evaluateDelivery(
        invitee.data,
        "co_parent_invitation",
        new Date(),
    );
    const userRef = db.collection(USERS_COLLECTION).doc(invitee.uid);
    const claimed = decision.allow ?
      await claimDailySlot(userRef, invitee.data, decision) :
      false;
    if (token && decision.allow && claimed) {
      await sendNotification(
          token,
          "Co-parent invitation",
          `${displayName} invited you to care for ${childrenNames}`,
          {
            type: "co_parent_invitation",
            invitationId,
          },
      );
    }
  }

  return {invitationId, emailSent};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} invitationId
 * @param {string|null} requesterUid
 * @return {Promise<object>}
 */
async function getInvitationPreview(db, invitationId, requesterUid) {
  if (!invitationId) {
    throw new HttpsError("invalid-argument", "invitationId is required.");
  }
  const snap = await db.collection(INVITE_COLLECTION).doc(invitationId).get();
  if (!snap.exists) {
    throw new HttpsError("not-found", "Invitation not found.");
  }
  const data = snap.data() || {};
  if (inviteOpenBlockReason(data)) {
    throw new HttpsError("failed-precondition", INVITE_LINK_EXPIRED_MESSAGE);
  }
  let inviterName = "A parent";
  if (data.from_uid) {
    const fromSnap = await db.collection(USERS_COLLECTION).doc(data.from_uid).get();
    if (fromSnap.exists) {
      const fromData = fromSnap.data() || {};
      inviterName =
        fromData.parent_name || fromData.display_name || inviterName;
    }
  }
  const childIds = Array.isArray(data.child_ids) ?
    data.child_ids.map(String) :
    String(data.children || "")
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
  const childNames = [];
  for (const childId of childIds) {
    const childSnap = await db.collection(CHILDREN_COLLECTION).doc(childId).get();
    if (childSnap.exists) {
      const name = (childSnap.data() || {}).child_name;
      if (name) childNames.push(String(name));
    }
  }
  const preview = {
    invitationId,
    status: data.status || "",
    expiresAt: data.expires_at || null,
    fromParentName: inviterName,
    childNames,
    invitedEmailMasked: maskEmail(data.to_parent),
    role: data.role || "Co-Parent",
  };
  if (requesterUid) {
    preview.toParent = data.to_parent || "";
    if (requesterUid === data.from_uid || requesterUid === data.to_uid) {
      preview.childIds = childIds;
    }
  }
  return preview;
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function acceptInvitation(db, params) {
  const {invitationId, uid, userEmail} = params;
  if (!uid) throw new HttpsError("unauthenticated", "Sign in required.");
  if (!invitationId) {
    throw new HttpsError("invalid-argument", "invitationId is required.");
  }

  const inviteRef = db.collection(INVITE_COLLECTION).doc(invitationId);
  const inviteSnap = await inviteRef.get();
  if (!inviteSnap.exists) {
    throw new HttpsError("not-found", "Invitation not found.");
  }
  const invite = inviteSnap.data() || {};
  if (invite.status === STATUS_ACCEPTED) {
    if (
      invite.accepted_by_uid === uid ||
      (invite.to_uid && invite.to_uid === uid)
    ) {
      return {status: STATUS_ACCEPTED, invitationId};
    }
  }
  if (inviteOpenBlockReason(invite)) {
    throw new HttpsError("failed-precondition", INVITE_LINK_EXPIRED_MESSAGE);
  }

  const invitedEmail = normalizeEmail(invite.to_parent);
  const loggedEmail = normalizeEmail(userEmail);
  const emailMatch = invitedEmail && loggedEmail && invitedEmail === loggedEmail;
  const uidMatch = invite.to_uid && invite.to_uid === uid;
  if (!emailMatch && !uidMatch) {
    throw new HttpsError(
        "permission-denied",
        "This invitation is not for your account.",
    );
  }

  const childIds = Array.isArray(invite.child_ids) ?
    invite.child_ids.map(String) :
    String(invite.children || "")
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
  if (childIds.length === 0) {
    throw new HttpsError("failed-precondition", "Invitation has no children.");
  }

  const userRef = db.collection(USERS_COLLECTION).doc(uid);
  const userSnap = await userRef.get();
  const userData = userSnap.exists ? userSnap.data() || {} : {};
  const hasDefault =
    userData.default_child != null &&
    (userData.default_child.id || String(userData.default_child).length > 0);

  const inviterUid = invite.from_uid || null;
  const rolePerms = permissionsForRole(invite.role);
  const batch = db.batch();
  const childRefs = [];

  for (const childId of childIds) {
    const childRef = db.collection(CHILDREN_COLLECTION).doc(childId);
    const childSnap = await childRef.get();
    if (!childSnap.exists) {
      throw new HttpsError("not-found", `Child ${childId} not found.`);
    }
    const childData = childSnap.data() || {};
    const primary = resolvePrimaryParentUid(childData);
    const updates = {
      parent_reference_ids: admin.firestore.FieldValue.arrayUnion(uid),
    };
    if (!childData.primary_parent_uid && primary) {
      updates.primary_parent_uid = primary;
    }
    batch.update(childRef, updates);
    batch.set(
        childRef.collection("caregiver_permissions").doc(uid),
        {
          ...rolePerms,
          caregiver_uid: uid,
          caregiver_email: invitedEmail || loggedEmail,
          name: userData.parent_name || userData.display_name || "",
          updated_at: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true},
    );
    childRefs.push(childRef);
  }

  const userUpdates = {
    children: admin.firestore.FieldValue.arrayUnion(...childRefs),
    email: loggedEmail || invitedEmail || userData.email || "",
  };
  if (!hasDefault && childRefs.length > 0) {
    userUpdates.default_child = childRefs[0];
  }
  if (inviterUid) {
    userUpdates.linked_user_ids = admin.firestore.FieldValue.arrayUnion(inviterUid);
  }
  batch.set(userRef, userUpdates, {merge: true});

  if (inviterUid) {
    const inviterRef = db.collection(USERS_COLLECTION).doc(inviterUid);
    batch.set(
        inviterRef,
        {linked_user_ids: admin.firestore.FieldValue.arrayUnion(uid)},
        {merge: true},
    );
  }

  batch.update(inviteRef, {
    status: STATUS_ACCEPTED,
    accepted_by_uid: uid,
    accepted_at: new Date().toISOString(),
    to_uid: uid,
  });

  if (invite.to_uid || uid) {
    const notifUid = invite.to_uid || uid;
    const notifRef = db
        .collection(USERS_COLLECTION)
        .doc(notifUid)
        .collection("notifications")
        .doc(invitationId);
    batch.set(notifRef, {status: STATUS_ACCEPTED, read: true}, {merge: true});
  }

  await batch.commit();
  return {status: STATUS_ACCEPTED, invitationId, childIds};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function rejectInvitation(db, params) {
  const {invitationId, uid, userEmail} = params;
  const inviteRef = db.collection(INVITE_COLLECTION).doc(invitationId);
  const snap = await inviteRef.get();
  if (!snap.exists) throw new HttpsError("not-found", "Invitation not found.");
  const invite = snap.data() || {};
  if (inviteOpenBlockReason(invite)) {
    throw new HttpsError("failed-precondition", INVITE_LINK_EXPIRED_MESSAGE);
  }
  const invitedEmail = normalizeEmail(invite.to_parent);
  const loggedEmail = normalizeEmail(userEmail);
  const allowed =
    (invite.to_uid && invite.to_uid === uid) ||
    (invitedEmail && loggedEmail && invitedEmail === loggedEmail);
  if (!allowed) {
    throw new HttpsError("permission-denied", "Not allowed to reject this invite.");
  }
  await inviteRef.update({
    status: STATUS_REJECTED,
    rejected_by_uid: uid,
    rejected_at: new Date().toISOString(),
  });
  if (invite.to_uid || uid) {
    await db
        .collection(USERS_COLLECTION)
        .doc(invite.to_uid || uid)
        .collection("notifications")
        .doc(invitationId)
        .set({status: STATUS_REJECTED, read: true}, {merge: true});
  }
  return {status: STATUS_REJECTED, invitationId};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function cancelInvitation(db, params) {
  const {invitationId, uid} = params;
  const inviteRef = db.collection(INVITE_COLLECTION).doc(invitationId);
  const snap = await inviteRef.get();
  if (!snap.exists) throw new HttpsError("not-found", "Invitation not found.");
  const invite = snap.data() || {};
  if (invite.from_uid !== uid) {
    throw new HttpsError("permission-denied", "Only the inviter can cancel.");
  }
  if (invite.status !== STATUS_REQUESTED) {
    throw new HttpsError("failed-precondition", "Invitation is not pending.");
  }
  await inviteRef.update({
    status: STATUS_CANCELLED,
    cancelled_at: new Date().toISOString(),
  });
  if (invite.to_uid) {
    await db
        .collection(USERS_COLLECTION)
        .doc(invite.to_uid)
        .collection("notifications")
        .doc(invitationId)
        .set({status: STATUS_CANCELLED, read: true}, {merge: true});
  }
  return {status: STATUS_CANCELLED, invitationId};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function revokeCaregiver(db, params) {
  const {childId, targetUid, callerUid} = params;
  if (!childId || !targetUid || !callerUid) {
    throw new HttpsError("invalid-argument", "childId and targetUid are required.");
  }
  const childSnap = await db.collection(CHILDREN_COLLECTION).doc(childId).get();
  if (!childSnap.exists) throw new HttpsError("not-found", "Child not found.");
  const childData = childSnap.data() || {};
  const primary = resolvePrimaryParentUid(childData);
  if (primary !== callerUid) {
    throw new HttpsError(
        "permission-denied",
        "Only the primary parent can revoke access.",
    );
  }
  if (targetUid === primary) {
    throw new HttpsError(
        "failed-precondition",
        "Cannot revoke the primary parent's access.",
    );
  }
  await unlinkCaregiverFromChild(db, {
    childId,
    targetUid,
    clearPartnerAgainstUid: callerUid,
  });
  // Also clear partner on primary if it pointed at target
  const primaryRef = db.collection(USERS_COLLECTION).doc(callerUid);
  const primarySnap = await primaryRef.get();
  if (primarySnap.exists) {
    const data = primarySnap.data() || {};
    if (data.partner_user_id === targetUid) {
      await primaryRef.update({
        partner_user_id: admin.firestore.FieldValue.delete(),
      });
    }
  }
  return {success: true, childId, targetUid};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function leaveChild(db, params) {
  const {childId, callerUid} = params;
  if (!childId || !callerUid) {
    throw new HttpsError("invalid-argument", "childId is required.");
  }
  const childSnap = await db.collection(CHILDREN_COLLECTION).doc(childId).get();
  if (!childSnap.exists) throw new HttpsError("not-found", "Child not found.");
  const childData = childSnap.data() || {};
  const primary = resolvePrimaryParentUid(childData);
  if (primary === callerUid) {
    throw new HttpsError(
        "failed-precondition",
        "The primary parent cannot leave their own child profile.",
    );
  }
  await unlinkCaregiverFromChild(db, {
    childId,
    targetUid: callerUid,
    clearPartnerAgainstUid: primary,
  });
  if (primary) {
    const primaryRef = db.collection(USERS_COLLECTION).doc(primary);
    const primarySnap = await primaryRef.get();
    if (primarySnap.exists) {
      const data = primarySnap.data() || {};
      if (data.partner_user_id === callerUid) {
        await primaryRef.update({
          partner_user_id: admin.firestore.FieldValue.delete(),
        });
      }
    }
  }
  return {success: true, childId};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} childId
 * @return {Promise<void>}
 */
async function deleteSharedEventsForChild(db, childId) {
  for (const field of ["child_id", "childId"]) {
    try {
      const snap = await db
          .collection(SHARED_EVENT_COLLECTION)
          .where(field, "==", childId)
          .get();
      for (const doc of snap.docs) {
        await doc.ref.delete();
      }
    } catch (e) {
      logger.warn("shared event cleanup", {field, childId, error: String(e)});
    }
  }
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<object>}
 */
async function removeChild(db, params) {
  const {childId, callerUid} = params;
  if (!childId || !callerUid) {
    throw new HttpsError("invalid-argument", "childId is required.");
  }
  const childRef = db.collection(CHILDREN_COLLECTION).doc(childId);
  const childSnap = await childRef.get();
  if (!childSnap.exists) throw new HttpsError("not-found", "Child not found.");
  const childData = childSnap.data() || {};
  const primary = resolvePrimaryParentUid(childData);
  if (primary !== callerUid) {
    throw new HttpsError(
        "permission-denied",
        "Only the primary parent can remove this child.",
    );
  }
  const parentIds = Array.isArray(childData.parent_reference_ids) ?
    childData.parent_reference_ids.map(String) :
    [];

  await deleteChildSubcollections(db, childId);
  await deleteSharedEventsForChild(db, childId);

  for (const parentUid of parentIds) {
    const userRef = db.collection(USERS_COLLECTION).doc(parentUid);
    const userSnap = await userRef.get();
    if (!userSnap.exists) continue;
    const userData = userSnap.data() || {};
    const updates = {
      children: admin.firestore.FieldValue.arrayRemove(childRef),
    };
    const defaultId =
      userData.default_child && userData.default_child.id ?
        userData.default_child.id :
        null;
    if (defaultId === childId) {
      const next = nextDefaultChild(userData, childRef);
      updates.default_child = next || admin.firestore.FieldValue.delete();
    }
    await userRef.update(updates);
  }

  // Delete invites that reference this child
  const inviteSnap = await db.collection(INVITE_COLLECTION).get();
  for (const doc of inviteSnap.docs) {
    const data = doc.data() || {};
    const ids = Array.isArray(data.child_ids) ?
      data.child_ids.map(String) :
      String(data.children || "")
          .split(",")
          .map((s) => s.trim())
          .filter(Boolean);
    if (ids.includes(childId)) {
      await doc.ref.delete();
    }
  }

  await childRef.delete();
  return {success: true, childId};
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} uid
 * @return {Promise<object>}
 */
async function deleteMyAccount(db, uid) {
  if (!uid) throw new HttpsError("unauthenticated", "Sign in required.");
  const userRef = db.collection(USERS_COLLECTION).doc(uid);
  const userSnap = await userRef.get();
  const userData = userSnap.exists ? userSnap.data() || {} : {};
  const email = normalizeEmail(userData.email);

  const childIds = new Set();
  if (Array.isArray(userData.children)) {
    for (const ref of userData.children) {
      if (ref && ref.id) childIds.add(ref.id);
    }
  }
  try {
    const linked = await db
        .collection(CHILDREN_COLLECTION)
        .where("parent_reference_ids", "array-contains", uid)
        .get();
    for (const doc of linked.docs) childIds.add(doc.id);
  } catch (e) {
    logger.warn("child query during delete", {error: String(e)});
  }

  const deletedChildIds = [];
  for (const childId of childIds) {
    const childRef = db.collection(CHILDREN_COLLECTION).doc(childId);
    const childSnap = await childRef.get();
    if (!childSnap.exists) continue;
    const childData = childSnap.data() || {};
    const primary = resolvePrimaryParentUid(childData);
    if (primary === uid) {
      await deleteChildSubcollections(db, childId);
      await deleteSharedEventsForChild(db, childId);
      const parentIds = Array.isArray(childData.parent_reference_ids) ?
        childData.parent_reference_ids.map(String) :
        [];
      for (const parentUid of parentIds) {
        if (parentUid === uid) continue;
        const otherRef = db.collection(USERS_COLLECTION).doc(parentUid);
        const otherSnap = await otherRef.get();
        if (!otherSnap.exists) continue;
        const otherData = otherSnap.data() || {};
        const updates = {
          children: admin.firestore.FieldValue.arrayRemove(childRef),
        };
        if (otherData.default_child && otherData.default_child.id === childId) {
          const next = nextDefaultChild(otherData, childRef);
          updates.default_child = next || admin.firestore.FieldValue.delete();
        }
        if (otherData.partner_user_id === uid) {
          updates.partner_user_id = admin.firestore.FieldValue.delete();
        }
        await otherRef.update(updates);
      }
      await childRef.delete();
      deletedChildIds.push(childId);
    } else {
      await childRef.update({
        parent_reference_ids: admin.firestore.FieldValue.arrayRemove(uid),
      });
      try {
        await childRef.collection("caregiver_permissions").doc(uid).delete();
      } catch (_) {
        // ignore
      }
      if (primary) {
        const primaryRef = db.collection(USERS_COLLECTION).doc(primary);
        const primarySnap = await primaryRef.get();
        if (primarySnap.exists) {
          const pdata = primarySnap.data() || {};
          if (pdata.partner_user_id === uid) {
            await primaryRef.update({
              partner_user_id: admin.firestore.FieldValue.delete(),
            });
          }
        }
      }
    }
  }

  // Delete invitations by uid and email
  const inviteQueries = [];
  inviteQueries.push(
      db.collection(INVITE_COLLECTION).where("from_uid", "==", uid).get(),
  );
  inviteQueries.push(
      db.collection(INVITE_COLLECTION).where("to_uid", "==", uid).get(),
  );
  if (email) {
    inviteQueries.push(
        db.collection(INVITE_COLLECTION).where("from_parent", "==", email).get(),
    );
    inviteQueries.push(
        db.collection(INVITE_COLLECTION).where("to_parent", "==", email).get(),
    );
  }
  const inviteResults = await Promise.all(inviteQueries);
  const deletedInviteIds = new Set();
  for (const snap of inviteResults) {
    for (const doc of snap.docs) {
      if (!deletedInviteIds.has(doc.id)) {
        await doc.ref.delete();
        deletedInviteIds.add(doc.id);
      }
    }
  }
  for (const childId of deletedChildIds) {
    const allInvites = await db.collection(INVITE_COLLECTION).get();
    for (const doc of allInvites.docs) {
      const data = doc.data() || {};
      const ids = Array.isArray(data.child_ids) ?
        data.child_ids.map(String) :
        String(data.children || "")
            .split(",")
            .map((s) => s.trim())
            .filter(Boolean);
      if (ids.includes(childId) && !deletedInviteIds.has(doc.id)) {
        await doc.ref.delete();
        deletedInviteIds.add(doc.id);
      }
    }
  }

  // Shared events by user
  for (const field of ["created_by", "userId"]) {
    try {
      const snap = await db
          .collection(SHARED_EVENT_COLLECTION)
          .where(field, "==", uid)
          .get();
      for (const doc of snap.docs) await doc.ref.delete();
    } catch (e) {
      logger.warn("shared event user cleanup", {field, error: String(e)});
    }
  }

  // User subcollections
  for (const name of [
    "conversations",
    "saved_guidance",
    "journals",
    "mood",
    "connect_prompt_history",
    "notifications",
  ]) {
    try {
      const snap = await userRef.collection(name).get();
      for (const doc of snap.docs) {
        if (name === "conversations") {
          const chats = await doc.ref.collection("chats").get();
          for (const chat of chats.docs) await chat.ref.delete();
        }
        await doc.ref.delete();
      }
    } catch (e) {
      logger.warn("user subcollection cleanup", {name, error: String(e)});
    }
  }

  if (userSnap.exists) {
    await userRef.delete();
  }

  try {
    await admin.auth().deleteUser(uid);
  } catch (error) {
    if (error.code !== "auth/user-not-found") {
      throw new HttpsError(
          "internal",
          error.message || "Failed to delete auth user.",
      );
    }
  }

  return {success: true};
}

module.exports = {
  normalizeEmail,
  maskEmail,
  resolvePrimaryParentUid,
  permissionsForRole,
  buildChildrenCsv,
  findUserByEmail,
  nextDefaultChild,
  unlinkCaregiverFromChild,
  createCoParentInvitation,
  getInvitationPreview,
  acceptInvitation,
  rejectInvitation,
  cancelInvitation,
  revokeCaregiver,
  leaveChild,
  removeChild,
  deleteMyAccount,
  STATUS_REQUESTED,
  STATUS_ACCEPTED,
  STATUS_REJECTED,
  STATUS_CANCELLED,
};
