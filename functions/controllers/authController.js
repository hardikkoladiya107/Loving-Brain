const {onCall, HttpsError} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {
  getOtpEmailHtml,
  buildBrevoInvitationBody,
} = require("../utils/emailTemplate");
const authIdentity = require("../services/authIdentity");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

const SENDER_EMAIL = "hardikkoladiya107@gmail.com";
const SENDER_NAME = "Loving Brain";
const BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";

/**
 * sendEmailOtp
 * Generates a 6-digit OTP, stores a hash in Firestore, and emails via Brevo.
 */
exports.sendEmailOtp = onCall(async (request) => {
  const data = request.data || {};
  const email = authIdentity.normalizeEmail(data.email);

  if (!email) {
    throw new HttpsError("invalid-argument", "Email is required.");
  }

  const apiKey = process.env.BREVO_API_KEY;
  if (!apiKey) {
    logger.error("BREVO_API_KEY configuration is missing at runtime.");
    throw new HttpsError("failed-precondition", "Email service is unconfigured.");
  }

  const otpDocRef = db.collection("otps").doc(email);
  const existing = await otpDocRef.get();
  if (existing.exists) {
    const existingData = existing.data() || {};
    const createdAt = existingData.createdAt;
    if (createdAt && typeof createdAt.toMillis === "function") {
      const age = Date.now() - createdAt.toMillis();
      if (age < authIdentity.OTP_SEND_COOLDOWN_MS) {
        throw new HttpsError(
            "resource-exhausted",
            "Please wait before requesting another code.",
        );
      }
    }
  }

  const otpCode = authIdentity.generateOtpCode();
  const salt = authIdentity.createSalt();
  const otpHash = authIdentity.hashOtp(otpCode, salt);
  const expiresAt = admin.firestore.Timestamp.fromMillis(
      Date.now() + authIdentity.OTP_TTL_MS,
  );

  await otpDocRef.set({
    otpHash,
    salt,
    attempts: 0,
    expiresAt,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  try {
    const response = await fetch(BREVO_API_URL, {
      method: "POST",
      headers: {
        "api-key": apiKey,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        sender: {name: SENDER_NAME, email: SENDER_EMAIL},
        to: [{email}],
        subject: "Your Loving Brain Verification Code",
        htmlContent: getOtpEmailHtml(otpCode),
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error(
          `Brevo email failed with status ${response.status}: ${errorText}`,
      );
      throw new HttpsError("internal", "Failed to send OTP email via Brevo.");
    }
  } catch (error) {
    logger.error("Error sending OTP email:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to send OTP email.");
  }

  return {success: true, message: "OTP sent successfully."};
});

/**
 * verifyEmailOtp
 * Verifies the OTP hash and returns a Custom Auth Token for the canonical uid.
 */
exports.verifyEmailOtp = onCall(async (request) => {
  const data = request.data || {};
  const email = authIdentity.normalizeEmail(data.email);
  const otpCode = data.otp ? String(data.otp).trim() : "";

  if (!email || !otpCode) {
    throw new HttpsError("invalid-argument", "Email and OTP are required.");
  }

  const otpDocRef = db.collection("otps").doc(email);

  await db.runTransaction(async (tx) => {
    const otpDoc = await tx.get(otpDocRef);
    if (!otpDoc.exists) {
      throw new HttpsError("not-found", "No pending OTP found for this email.");
    }

    const otpData = otpDoc.data() || {};
    const attempts = Number(otpData.attempts || 0);
    if (attempts >= authIdentity.OTP_MAX_ATTEMPTS) {
      tx.delete(otpDocRef);
      throw new HttpsError(
          "resource-exhausted",
          "Too many invalid attempts. Request a new code.",
      );
    }

    if (!otpData.expiresAt || otpData.expiresAt.toMillis() < Date.now()) {
      tx.delete(otpDocRef);
      throw new HttpsError("permission-denied", "OTP has expired.");
    }

    const expectedHash = otpData.otpHash;
    const salt = otpData.salt || "";
    const actualHash = authIdentity.hashOtp(otpCode, salt);
    if (!expectedHash || actualHash !== expectedHash) {
      tx.update(otpDocRef, {attempts: attempts + 1});
      throw new HttpsError("permission-denied", "Invalid OTP.");
    }

    tx.delete(otpDocRef);
  });

  const uid = await authIdentity.resolveUidForEmail(db, email);
  try {
    const token = await admin.auth().createCustomToken(uid);
    return {success: true, token, uid};
  } catch (error) {
    logger.error("Error generating custom token:", error);
    throw new HttpsError("internal", "Error generating authentication token.");
  }
});

/**
 * resolveAuthIdentity
 * After Google/Apple/phone sign-in, merge any legacy profile for the same
 * email/phone onto the authenticated uid.
 */
exports.resolveAuthIdentity = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const uid = request.auth.uid;
  const data = request.data || {};
  const email = authIdentity.normalizeEmail(
      data.email || (request.auth.token && request.auth.token.email) || "",
  );
  const phone =
    typeof data.phone === "string" ?
      data.phone.trim() :
      (request.auth.token && request.auth.token.phone_number) || "";

  const result = await authIdentity.mergeProfileOntoAuthUid(db, {
    authUid: uid,
    email,
    phone,
  });

  const userRef = db.collection("users").doc(uid);
  const snap = await userRef.get();
  if (!snap.exists) {
    await userRef.set(
        {
          uid,
          email: email || "",
          phone_number: phone || "",
          display_name:
          (request.auth.token && request.auth.token.name) || "Parent",
          streak: 0,
          last_opened: admin.firestore.FieldValue.serverTimestamp(),
          is_onboarding_completed: false,
        },
        {merge: true},
    );
  } else {
    const updates = {};
    if (email) updates.email = email;
    if (phone) updates.phone_number = phone;
    if (Object.keys(updates).length > 0) {
      await userRef.set(updates, {merge: true});
    }
  }

  return {success: true, ...result};
});

/**
 * sendInvitationEmail
 * Kept for backward compatibility; prefer createCoParentInvitation.
 */
exports.sendInvitationEmail = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const data = request.data || {};
  const toEmail = data.toEmail ?
    authIdentity.normalizeEmail(data.toEmail) :
    "";
  const fromParentName = data.fromParentName ?
    data.fromParentName.trim() :
    "A parent";
  const childrenNames = data.childrenNames ?
    data.childrenNames.trim() :
    "your child";
  const invitationId = data.invitationId ? data.invitationId.trim() : "";

  if (!toEmail || !invitationId) {
    throw new HttpsError(
        "invalid-argument",
        "toEmail and invitationId are required.",
    );
  }

  const inviteSnap = await db
      .collection("co-parent-invitation")
      .doc(invitationId)
      .get();
  if (!inviteSnap.exists) {
    throw new HttpsError("not-found", "Invitation not found.");
  }
  const invite = inviteSnap.data() || {};
  if (invite.from_uid && invite.from_uid !== request.auth.uid) {
    throw new HttpsError("permission-denied", "Not allowed to send this invite.");
  }

  const apiKey = process.env.BREVO_API_KEY;
  if (!apiKey) {
    logger.error("BREVO_API_KEY configuration is missing at runtime.");
    throw new HttpsError("failed-precondition", "Email service is unconfigured.");
  }

  const invitationLink = `https://www.lovingbrain.com/invite/${invitationId}`;
  const mail = buildBrevoInvitationBody({
    toEmail,
    fromParentName,
    childrenNames,
    invitationId,
    invitationLink,
    sender: {name: SENDER_NAME, email: SENDER_EMAIL},
  });

  try {
    const response = await fetch(BREVO_API_URL, {
      method: "POST",
      headers: {
        "api-key": apiKey,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify(mail),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error(
          `Brevo invite email failed with status ${response.status}: ${errorText}`,
      );
      throw new HttpsError(
          "internal",
          "Failed to send invitation email via Brevo.",
      );
    }
    return {success: true, message: "Invitation email sent successfully."};
  } catch (error) {
    logger.error("Error sending invitation email:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to send invitation email.");
  }
});
