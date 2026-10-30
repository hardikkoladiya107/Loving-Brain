/**
 * Callable Cloud Functions for co-parent invites and child membership.
 * All privileged cross-account writes run here with the Admin SDK.
 */
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const familyAccess = require("../services/familyAccess");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * @param {import('firebase-functions/v2/https').CallableRequest} request
 * @return {string}
 */
function requireAuth(request) {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  return request.auth.uid;
}

/**
 * @param {import('firebase-functions/v2/https').CallableRequest} request
 * @return {string}
 */
function authEmail(request) {
  const tokenEmail =
    request.auth && request.auth.token && request.auth.token.email ?
      String(request.auth.token.email) :
      "";
  return familyAccess.normalizeEmail(tokenEmail);
}

exports.createCoParentInvitation = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const toEmail = typeof data.toEmail === "string" ? data.toEmail : "";
  const role = typeof data.role === "string" ? data.role : "Co-Parent";
  const fromParentName =
    typeof data.fromParentName === "string" ? data.fromParentName : "";
  let childIds = [];
  if (Array.isArray(data.childIds)) {
    childIds = data.childIds.map(String);
  } else if (typeof data.childId === "string" && data.childId.trim()) {
    childIds = [data.childId.trim()];
  }
  return familyAccess.createCoParentInvitation(db, {
    fromUid: uid,
    toEmail,
    role,
    childIds,
    fromParentName,
  });
});

exports.getInvitationPreview = onCall(async (request) => {
  const data = request.data || {};
  const invitationId =
    typeof data.invitationId === "string" ? data.invitationId.trim() : "";
  const requesterUid =
    request.auth && request.auth.uid ? request.auth.uid : null;
  return familyAccess.getInvitationPreview(db, invitationId, requesterUid);
});

exports.acceptInvitation = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const invitationId =
    typeof data.invitationId === "string" ? data.invitationId.trim() : "";
  let userEmail = authEmail(request);
  if (!userEmail) {
    const userSnap = await db.collection("users").doc(uid).get();
    if (userSnap.exists) {
      userEmail = familyAccess.normalizeEmail((userSnap.data() || {}).email);
    }
  }
  return familyAccess.acceptInvitation(db, {
    invitationId,
    uid,
    userEmail,
  });
});

exports.rejectInvitation = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const invitationId =
    typeof data.invitationId === "string" ? data.invitationId.trim() : "";
  let userEmail = authEmail(request);
  if (!userEmail) {
    const userSnap = await db.collection("users").doc(uid).get();
    if (userSnap.exists) {
      userEmail = familyAccess.normalizeEmail((userSnap.data() || {}).email);
    }
  }
  return familyAccess.rejectInvitation(db, {
    invitationId,
    uid,
    userEmail,
  });
});

exports.cancelInvitation = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const invitationId =
    typeof data.invitationId === "string" ? data.invitationId.trim() : "";
  return familyAccess.cancelInvitation(db, {invitationId, uid});
});

exports.revokeCaregiver = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const childId = typeof data.childId === "string" ? data.childId.trim() : "";
  const targetUid =
    typeof data.targetUid === "string" ? data.targetUid.trim() : "";
  return familyAccess.revokeCaregiver(db, {
    childId,
    targetUid,
    callerUid: uid,
  });
});

exports.leaveChild = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const childId = typeof data.childId === "string" ? data.childId.trim() : "";
  return familyAccess.leaveChild(db, {childId, callerUid: uid});
});

exports.removeChild = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const childId = typeof data.childId === "string" ? data.childId.trim() : "";
  return familyAccess.removeChild(db, {childId, callerUid: uid});
});

exports.deleteMyAccount = onCall(async (request) => {
  const uid = requireAuth(request);
  return familyAccess.deleteMyAccount(db, uid);
});

/**
 * Resend invitation email for a pending invite created by the caller.
 */
exports.resendInvitationEmail = onCall(async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  const invitationId =
    typeof data.invitationId === "string" ? data.invitationId.trim() : "";
  if (!invitationId) {
    throw new HttpsError("invalid-argument", "invitationId is required.");
  }
  const inviteRef = db.collection("co-parent-invitation").doc(invitationId);
  const snap = await inviteRef.get();
  if (!snap.exists) throw new HttpsError("not-found", "Invitation not found.");
  const invite = snap.data() || {};
  if (invite.from_uid !== uid) {
    throw new HttpsError("permission-denied", "Only the inviter can resend.");
  }
  if (invite.status !== familyAccess.STATUS_REQUESTED) {
    throw new HttpsError("failed-precondition", "Invitation is not pending.");
  }
  const expiresAt = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000).toISOString();
  await inviteRef.update({expires_at: expiresAt});

  const fromSnap = await db.collection("users").doc(uid).get();
  const fromData = fromSnap.exists ? fromSnap.data() || {} : {};
  const fromParentName =
    fromData.parent_name || fromData.display_name || "A parent";
  const childIds = Array.isArray(invite.child_ids) ?
    invite.child_ids :
    String(invite.children || "")
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
  const names = [];
  for (const childId of childIds) {
    const childSnap = await db.collection("children").doc(childId).get();
    if (childSnap.exists && (childSnap.data() || {}).child_name) {
      names.push(String((childSnap.data() || {}).child_name));
    }
  }
  const apiKey = process.env.BREVO_API_KEY;
  if (!apiKey) {
    throw new HttpsError("failed-precondition", "Email service is unconfigured.");
  }
  const {buildBrevoInvitationBody} = require("../utils/emailTemplate");
  const invitationLink = `https://www.lovingbrain.com/invite/${invitationId}`;
  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      "api-key": apiKey,
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: JSON.stringify(buildBrevoInvitationBody({
      toEmail: invite.to_parent,
      fromParentName,
      childrenNames: names.length ? names.join(" & ") : "your child",
      invitationId,
      invitationLink,
      sender: {name: "Loving Brain", email: "hardikkoladiya107@gmail.com"},
    })),
  });
  if (!response.ok) {
    throw new HttpsError("internal", "Failed to resend invitation email.");
  }
  return {success: true, invitationId, expiresAt};
});
