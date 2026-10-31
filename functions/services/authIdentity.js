/**
 * Account identity helpers: OTP hashing and resolving one parent profile per email/phone.
 */
const admin = require("firebase-admin");
const {HttpsError} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const helpers = require("./authIdentityHelpers");

const {
  OTP_MAX_ATTEMPTS,
  OTP_TTL_MS,
  OTP_SEND_COOLDOWN_MS,
  APP_REVIEW_EMAIL,
  normalizeEmail,
  isAppReviewEmail,
  isAppReviewOtp,
  generateOtpCode,
  hashOtp,
  createSalt,
} = helpers;

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} email
 * @return {Promise<{uid: string, data: object}|null>}
 */
async function findUserDocByEmail(db, email) {
  const clean = normalizeEmail(email);
  if (!clean) return null;
  const snap = await db.collection("users").where("email", "==", clean).limit(1).get();
  if (!snap.empty) {
    return {uid: snap.docs[0].id, data: snap.docs[0].data() || {}};
  }
  return null;
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} phone
 * @return {Promise<{uid: string, data: object}|null>}
 */
async function findUserDocByPhone(db, phone) {
  const clean = (phone || "").trim();
  if (!clean) return null;
  const snap = await db
      .collection("users")
      .where("phone_number", "==", clean)
      .limit(1)
      .get();
  if (!snap.empty) {
    return {uid: snap.docs[0].id, data: snap.docs[0].data() || {}};
  }
  return null;
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} email
 * @return {Promise<string>}
 */
async function resolveUidForEmail(db, email) {
  const clean = normalizeEmail(email);
  if (!clean) {
    throw new HttpsError("invalid-argument", "Email is required.");
  }

  const existingDoc = await findUserDocByEmail(db, clean);
  if (existingDoc) {
    try {
      await admin.auth().getUser(existingDoc.uid);
      try {
        await admin.auth().updateUser(existingDoc.uid, {
          email: clean,
          emailVerified: true,
        });
      } catch (e) {
        if (e.code !== "auth/email-already-exists") {
          logger.warn("updateUser email attach", {error: String(e)});
        }
      }
      return existingDoc.uid;
    } catch (error) {
      if (error.code !== "auth/user-not-found") {
        throw new HttpsError("internal", "Error resolving existing user.");
      }
      await admin.auth().createUser({
        uid: existingDoc.uid,
        email: clean,
        emailVerified: true,
      });
      return existingDoc.uid;
    }
  }

  try {
    const byEmail = await admin.auth().getUserByEmail(clean);
    return byEmail.uid;
  } catch (error) {
    if (error.code !== "auth/user-not-found") {
      throw new HttpsError("internal", "Error authenticating user.");
    }
  }

  const created = await admin.auth().createUser({
    email: clean,
    emailVerified: true,
  });
  return created.uid;
}

/**
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<{merged: boolean, canonicalUid: string}>}
 */
async function mergeProfileOntoAuthUid(db, params) {
  const {authUid, email, phone} = params;
  const cleanEmail = normalizeEmail(email);
  const cleanPhone = (phone || "").trim();

  let legacy = null;
  if (cleanEmail) legacy = await findUserDocByEmail(db, cleanEmail);
  if (!legacy && cleanPhone) legacy = await findUserDocByPhone(db, cleanPhone);

  if (!legacy || legacy.uid === authUid) {
    return {merged: false, canonicalUid: authUid};
  }

  const legacyUid = legacy.uid;
  const legacyData = legacy.data || {};
  const authRef = db.collection("users").doc(authUid);
  const legacyRef = db.collection("users").doc(legacyUid);
  const authSnap = await authRef.get();
  const authData = authSnap.exists ? authSnap.data() || {} : {};

  const merged = {
    ...legacyData,
    ...authData,
    uid: authUid,
    email: cleanEmail || authData.email || legacyData.email || "",
    phone_number: cleanPhone || authData.phone_number || legacyData.phone_number || "",
  };
  await authRef.set(merged, {merge: true});

  const childIds = new Set();
  if (Array.isArray(legacyData.children)) {
    for (const ref of legacyData.children) {
      if (ref && ref.id) childIds.add(ref.id);
    }
  }
  try {
    const linked = await db
        .collection("children")
        .where("parent_reference_ids", "array-contains", legacyUid)
        .get();
    for (const doc of linked.docs) childIds.add(doc.id);
  } catch (e) {
    logger.warn("merge child query", {error: String(e)});
  }

  for (const childId of childIds) {
    const childRef = db.collection("children").doc(childId);
    const childSnap = await childRef.get();
    if (!childSnap.exists) continue;
    const childData = childSnap.data() || {};
    const parents = Array.isArray(childData.parent_reference_ids) ?
      childData.parent_reference_ids.map(String) :
      [];
    const nextParents = parents
        .filter((id) => id !== legacyUid)
        .concat(parents.includes(authUid) ? [] : [authUid]);
    const updates = {parent_reference_ids: nextParents};
    if (childData.primary_parent_uid === legacyUid) {
      updates.primary_parent_uid = authUid;
    }
    await childRef.update(updates);
  }

  for (const field of ["from_uid", "to_uid"]) {
    const snap = await db
        .collection("co-parent-invitation")
        .where(field, "==", legacyUid)
        .get();
    for (const doc of snap.docs) {
      await doc.ref.update({[field]: authUid});
    }
  }

  await legacyRef.delete();
  try {
    await admin.auth().deleteUser(legacyUid);
  } catch (e) {
    if (e.code !== "auth/user-not-found") {
      logger.warn("legacy auth delete", {error: String(e)});
    }
  }

  return {merged: true, canonicalUid: authUid};
}

/**
 * Attach the signed-in uid to every pending invite for that email.
 * Needed when the invite was created before the invitee had an account.
 * @param {FirebaseFirestore.Firestore} db
 * @param {object} params
 * @return {Promise<number>}
 */
async function backfillInvitationToUid(db, params) {
  const clean = normalizeEmail(params.email);
  const uid = params.uid || "";
  if (!clean || !uid) return 0;
  const snap = await db
      .collection("co-parent-invitation")
      .where("to_parent", "==", clean)
      .where("status", "==", "REQUESTED")
      .get();
  let count = 0;
  for (const doc of snap.docs) {
    const data = doc.data() || {};
    if (data.to_uid === uid) continue;
    await doc.ref.update({to_uid: uid});
    count += 1;
  }
  return count;
}

/**
 * Give the App Review account a finished parent profile and one sample child
 * so reviewers open Today instead of onboarding.
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} uid
 * @return {Promise<void>}
 */
async function ensureAppReviewProfile(db, uid) {
  const userRef = db.collection("users").doc(uid);
  const snap = await userRef.get();
  const data = snap.exists ? (snap.data() || {}) : {};
  const children = Array.isArray(data.children) ? data.children : [];
  const ready = data.is_onboarding_completed === true &&
    Boolean(data.parent_name) &&
    (Boolean(data.default_child) || children.length > 0);
  if (ready) return;

  const childRef = db.collection("children").doc();
  const childDob = admin.firestore.Timestamp.fromDate(
      new Date("2024-06-15T00:00:00.000Z"),
  );
  await childRef.set({
    child_name: "Mia",
    child_gender: "Girl",
    child_age: "2 years",
    child_dob: childDob,
    relationship_to_child: "Mother",
    parent_reference_ids: [uid],
    primary_parent_uid: uid,
    concerns: ["Sleep"],
    primary_concern: "Sleep",
    success_goal: "Easier bedtimes",
    usual_wake_time: "7:00 AM",
    usual_bedtime: "7:30 PM",
    usual_naps: "1",
    night_wakings: "1-2",
    difficult_times: ["Bedtime"],
    possible_triggers: ["Tired"],
  });

  await userRef.set({
    uid,
    email: APP_REVIEW_EMAIL,
    display_name: "Apple Review",
    parent_name: "Apple Review",
    relationship_to_child: "Mother",
    preferred_language: "English",
    is_onboarding_completed: true,
    is_google_sign_in: false,
    is_apple_in: false,
    streak: 0,
    children: admin.firestore.FieldValue.arrayUnion(childRef),
    default_child: childRef,
  }, {merge: true});
}

module.exports = {
  OTP_MAX_ATTEMPTS,
  OTP_TTL_MS,
  OTP_SEND_COOLDOWN_MS,
  APP_REVIEW_EMAIL,
  normalizeEmail,
  isAppReviewEmail,
  isAppReviewOtp,
  generateOtpCode,
  hashOtp,
  createSalt,
  findUserDocByEmail,
  findUserDocByPhone,
  resolveUidForEmail,
  mergeProfileOntoAuthUid,
  backfillInvitationToUid,
  ensureAppReviewProfile,
};
