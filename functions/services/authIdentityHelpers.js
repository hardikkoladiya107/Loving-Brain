/**
 * Pure OTP and identity helpers (no Firebase Admin dependency).
 */
const crypto = require("crypto");

const OTP_MAX_ATTEMPTS = 5;
const OTP_TTL_MS = 10 * 60 * 1000;
const OTP_SEND_COOLDOWN_MS = 60 * 1000;

/** App Review sign-in. This inbox is not mailed a code. */
const APP_REVIEW_EMAIL = "applereview@lovingbrain.com";
const APP_REVIEW_OTP = "590274";

/**
 * @param {string|null|undefined} email
 * @return {string}
 */
function normalizeEmail(email) {
  return (email || "").trim().toLowerCase();
}

/**
 * @param {string|null|undefined} email
 * @return {boolean}
 */
function isAppReviewEmail(email) {
  return normalizeEmail(email) === APP_REVIEW_EMAIL;
}

/**
 * Fixed code for the App Review account only.
 * @param {string|null|undefined} email
 * @param {string|null|undefined} otp
 * @return {boolean}
 */
function isAppReviewOtp(email, otp) {
  const code = String(otp || "").trim();
  return isAppReviewEmail(email) && code === APP_REVIEW_OTP;
}

/**
 * @return {string}
 */
function generateOtpCode() {
  return String(crypto.randomInt(100000, 1000000));
}

/**
 * @param {string} otp
 * @param {string} salt
 * @return {string}
 */
function hashOtp(otp, salt) {
  return crypto
      .createHash("sha256")
      .update(`${salt}:${otp}`)
      .digest("hex");
}

/**
 * @return {string}
 */
function createSalt() {
  return crypto.randomBytes(16).toString("hex");
}

/**
 * Evaluate a verification attempt against stored OTP metadata.
 * @param {object|null} stored
 * @param {string} submittedOtp
 * @param {number} nowMs
 * @return {{ok: boolean, reason?: string, attempts?: number, locked?: boolean}}
 */
function evaluateOtpAttempt(stored, submittedOtp, nowMs) {
  if (!stored || !stored.hash || !stored.salt) {
    return {ok: false, reason: "missing"};
  }
  const expiresAt = Number(stored.expires_at || 0);
  if (expiresAt && expiresAt < (nowMs || Date.now())) {
    return {ok: false, reason: "expired"};
  }
  const attempts = Number(stored.attempts || 0);
  if (attempts >= OTP_MAX_ATTEMPTS) {
    return {ok: false, reason: "locked", locked: true, attempts};
  }
  const expected = hashOtp(String(submittedOtp || "").trim(), stored.salt);
  if (expected !== stored.hash) {
    const nextAttempts = attempts + 1;
    return {
      ok: false,
      reason: nextAttempts >= OTP_MAX_ATTEMPTS ? "locked" : "mismatch",
      attempts: nextAttempts,
      locked: nextAttempts >= OTP_MAX_ATTEMPTS,
    };
  }
  return {ok: true, attempts};
}

/**
 * Decide which uid a verified email/phone should resolve to.
 * Prefer an existing Firestore user document uid over a newly created Auth uid.
 * @param {object} opts
 * @return {{uid: string, mergeFromUid?: string}}
 */
function resolveTargetUid(opts) {
  const {existingUserUid, authUid} = opts;
  if (existingUserUid && existingUserUid !== authUid) {
    return {uid: existingUserUid};
  }
  if (existingUserUid) {
    return {uid: existingUserUid};
  }
  return {uid: authUid};
}

/**
 * For Google/Apple: if email already belongs to another uid, merge that
 * profile onto the current auth uid.
 * @param {object} opts
 * @return {{action: string, keepUid: string, deleteUid?: string}}
 */
function resolveSocialIdentityMerge(opts) {
  const {existingUserUid, authUid} = opts;
  if (!existingUserUid || existingUserUid === authUid) {
    return {action: "keep", keepUid: authUid};
  }
  return {
    action: "merge-onto-auth",
    keepUid: authUid,
    deleteUid: existingUserUid,
  };
}

/**
 * Which pending invites should receive to_uid for this signed-in user.
 * @param {Array<object>} invites
 * @param {string} email
 * @param {string} uid
 * @return {Array<string>} invitation document ids
 */
function invitesNeedingToUidBackfill(invites, email, uid) {
  const clean = normalizeEmail(email);
  if (!clean || !uid) return [];
  return (invites || [])
      .filter((invite) => {
        if (!invite || (invite.status || "") !== "REQUESTED") return false;
        if (normalizeEmail(invite.to_parent) !== clean) return false;
        return invite.to_uid !== uid;
      })
      .map((invite) => String(invite.id || ""))
      .filter((id) => id.length > 0);
}

module.exports = {
  OTP_MAX_ATTEMPTS,
  OTP_TTL_MS,
  OTP_SEND_COOLDOWN_MS,
  APP_REVIEW_EMAIL,
  APP_REVIEW_OTP,
  normalizeEmail,
  isAppReviewEmail,
  isAppReviewOtp,
  generateOtpCode,
  hashOtp,
  createSalt,
  evaluateOtpAttempt,
  resolveTargetUid,
  resolveSocialIdentityMerge,
  invitesNeedingToUidBackfill,
};
