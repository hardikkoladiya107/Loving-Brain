const { onCall, HttpsError } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const { getOtpEmailHtml, getInvitationEmailHtml } = require("../utils/emailTemplate");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

// 👈 Formally define the secret key object

const SENDER_EMAIL = "hardikkoladiya107@gmail.com";
const SENDER_NAME = "Loving Brain";
const BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";

/**
 * sendEmailOtp
 * Generates a 4-digit OTP, saves it to Firestore, and sends it via Brevo.
 */
exports.sendEmailOtp = onCall(async (request) => { // 👈 Expose the secret to this function
  const data = request.data || {};
  const email = data.email?.trim()?.toLowerCase();

  if (!email) {
    throw new HttpsError("invalid-argument", "Email is required.");
  }

  // Extract the resolved secret value at function execution runtime
  const apiKey = process.env.BREVO_API_KEY;

  if (!apiKey) {
    logger.error("BREVO_API_KEY configuration is missing at runtime.");
    throw new HttpsError("failed-precondition", "Email service is unconfigured.");
  }

  // 1. Generate 4-digit OTP
  const otpCode = Math.floor(1000 + Math.random() * 9000).toString();

  // 2. Save OTP to Firestore with expiration (e.g., 10 minutes)
  const expiresAt = admin.firestore.Timestamp.fromMillis(Date.now() + 10 * 60 * 1000);
  await db.collection("otps").doc(email).set({
    otp: otpCode,
    expiresAt: expiresAt,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 3. Send email using Brevo via native fetch (Node 18+)
  try {
    const response = await fetch(BREVO_API_URL, {
      method: "POST",
      headers: {
        "api-key": apiKey, // 👈 Uses the cleanly resolved key variable
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        sender: { name: SENDER_NAME, email: SENDER_EMAIL },
        to: [{ email: email }],
        subject: "Your Loving Brain Verification Code",
        htmlContent: getOtpEmailHtml(otpCode),
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error(`Brevo email failed with status ${response.status}: ${errorText}`);
      throw new HttpsError("internal", "Failed to send OTP email via Brevo.");
    } else {
      const successData = await response.json();
      logger.info(`Brevo email sent successfully! Response: ${JSON.stringify(successData)}`);
    }
  } catch (error) {
    logger.error("Error sending OTP email:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to send OTP email.");
  }

  return { success: true, message: "OTP sent successfully." };
});

/**
 * verifyEmailOtp
 * Verifies the 4-digit OTP and returns a Custom Auth Token.
 */
exports.verifyEmailOtp = onCall(async (request) => {
  const data = request.data || {};
  const email = data.email?.trim()?.toLowerCase();
  const otpCode = data.otp?.trim();

  if (!email || !otpCode) {
    throw new HttpsError("invalid-argument", "Email and OTP are required.");
  }

  // 1. Fetch OTP from Firestore
  const otpDocRef = db.collection("otps").doc(email);
  const otpDoc = await otpDocRef.get();

  if (!otpDoc.exists) {
    throw new HttpsError("not-found", "No pending OTP found for this email.");
  }

  const otpData = otpDoc.data();

  // 2. Validate OTP and Expiration
  if (otpData.otp !== otpCode) {
    throw new HttpsError("permission-denied", "Invalid OTP.");
  }

  if (otpData.expiresAt.toMillis() < Date.now()) {
    throw new HttpsError("permission-denied", "OTP has expired.");
  }

  // 3. Delete OTP so it cannot be reused
  await otpDocRef.delete();

  // 4. Get or Create Firebase Auth User
  let userRecord;
  try {
    userRecord = await admin.auth().getUserByEmail(email);
  } catch (error) {
    if (error.code === "auth/user-not-found") {
      // Create new user if they don't exist
      userRecord = await admin.auth().createUser({
        email: email,
        emailVerified: true,
      });
    } else {
      logger.error("Error fetching user:", error);
      throw new HttpsError("internal", "Error authenticating user.");
    }
  }

  // 5. Generate Custom Token
  try {
    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    return { success: true, token: customToken };
  } catch (error) {
    logger.error("Error generating custom token:", error);
    throw new HttpsError("internal", "Error generating authentication token.");
  }
});

/**
 * sendInvitationEmail
 * Sends a co-parent or caregiver invitation email via Brevo using server credentials.
 */
exports.sendInvitationEmail = onCall(async (request) => {
  const data = request.data || {};
  const toEmail = data.toEmail ? data.toEmail.trim().toLowerCase() : "";
  const fromParentName = data.fromParentName ? data.fromParentName.trim() : "A parent";
  const childrenNames = data.childrenNames ? data.childrenNames.trim() : "your child";
  const invitationId = data.invitationId ? data.invitationId.trim() : "";

  if (!toEmail || !invitationId) {
    throw new HttpsError("invalid-argument", "toEmail and invitationId are required.");
  }

  const apiKey = process.env.BREVO_API_KEY;
  if (!apiKey) {
    logger.error("BREVO_API_KEY configuration is missing at runtime.");
    throw new HttpsError("failed-precondition", "Email service is unconfigured.");
  }

  const invitationLink = `https://www.lovingbrain.com/${invitationId}`;
  const htmlContent = getInvitationEmailHtml(fromParentName, childrenNames, invitationLink);

  try {
    const response = await fetch(BREVO_API_URL, {
      method: "POST",
      headers: {
        "api-key": apiKey,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        sender: { name: SENDER_NAME, email: SENDER_EMAIL },
        to: [{ email: toEmail }],
        subject: `${fromParentName} invited you to co-parent on Loving Brain 💜`,
        htmlContent: htmlContent,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      logger.error(`Brevo invite email failed with status ${response.status}: ${errorText}`);
      throw new HttpsError("internal", "Failed to send invitation email via Brevo.");
    } else {
      const successData = await response.json();
      logger.info(`Brevo invite email sent successfully! Response: ${JSON.stringify(successData)}`);
      return { success: true, message: "Invitation email sent successfully." };
    }
  } catch (error) {
    logger.error("Error sending invitation email:", error);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to send invitation email.");
  }
});
