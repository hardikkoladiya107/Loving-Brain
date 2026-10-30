/**
 * emailTemplate.js
 * Generates responsive, branded HTML email templates for Loving Brain.
 */

const DEFAULT_LOGO_URL =
  "https://storage.googleapis.com/hugsand-heart-u86wap.firebasestorage.app/app_assets/loving_brain_logo.png";

/**
 * Returns a fully styled HTML email for OTP verification.
 * @param {string} otpCode 6-digit verification code.
 * @param {string} [logoUrl] Optional hosted image URL for the logo.
 * @param {string} [reference] Footer reference, printed bottom-right.
 * @returns {string} Fully formatted HTML string.
 */
function getOtpEmailHtml(otpCode, logoUrl = DEFAULT_LOGO_URL, reference = "") {
  const brandLogoHtml = `
    <img src="${logoUrl}" alt="Loving Brain" width="76" height="76" style="display: block; margin: 0 auto 14px auto; border: 0; outline: none; text-decoration: none; max-width: 76px; height: auto;" />
  `;

  return `
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="x-apple-disable-message-reformatting" />
  <title>Loving Brain Verification Code</title>
  <!--[if mso]>
  <style type="text/css">
    body, table, td {font-family: Arial, Helvetica, sans-serif !important;}
  </style>
  <![endif]-->
</head>
<body style="margin: 0; padding: 0; background-color: #FEF8F4; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;">
  <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #FEF8F4; padding: 40px 16px;">
    <tr>
      <td align="center">
        <!-- Main Container Card -->
        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 480px; background-color: #FFFFFF; border-radius: 28px; border: 1px solid #F5EAE4; box-shadow: 0 8px 30px rgba(240, 109, 77, 0.08); overflow: hidden;">
          
          <!-- Header Banner -->
          <tr>
            <td align="center" style="padding: 40px 32px 18px 32px; background: linear-gradient(180deg, #FFF7F2 0%, #FFFFFF 100%);">
              ${brandLogoHtml}
              <h1 style="margin: 0; font-size: 26px; font-weight: 800; color: #212E5A; letter-spacing: -0.5px;">
                Loving Brain
              </h1>
              <p style="margin: 6px 0 0 0; font-size: 13px; color: #8A8A8A; font-weight: 500; letter-spacing: 0.2px;">
                Understand patterns. Know what to try next.
              </p>
            </td>
          </tr>

          <!-- Main Body -->
          <tr>
            <td style="padding: 12px 36px 36px 36px; text-align: center;">
              <h2 style="margin: 0 0 10px 0; font-size: 20px; font-weight: 700; color: #212E5A;">
                Your Verification Code
              </h2>
              <p style="margin: 0 0 28px 0; font-size: 14px; line-height: 22px; color: #545454;">
                Welcome to Loving Brain! Use the verification code below to confirm your email and access your account.
              </p>

              <!-- OTP Code Display Card -->
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 24px;">
                <tr>
                  <td align="center">
                    <div style="display: inline-block; background-color: #FFF2ED; border: 2px dashed #F06D4D; border-radius: 20px; padding: 18px 36px; text-align: center;">
                      <span style="font-family: 'Courier New', Courier, monospace, sans-serif; font-size: 32px; font-weight: 800; color: #F06D4D; letter-spacing: 8px; margin-left: 8px; display: inline-block;">
                        ${escapeHtml(otpCode)}
                      </span>
                    </div>
                  </td>
                </tr>
              </table>

              <!-- Expiration Notice -->
              <div style="background-color: #FAF8F6; border-radius: 14px; padding: 12px 18px; margin-bottom: 16px; border: 1px solid #F0ECE9;">
                <p style="margin: 0; font-size: 13px; color: #495057; font-weight: 600;">
                  ⏱️ This code will expire in <span style="color: #F06D4D;">10 minutes</span>.
                </p>
              </div>

              <!-- Security Warning -->
              <p style="margin: 0; font-size: 12px; line-height: 18px; color: #939393;">
                If you didn't request this verification code, you can safely ignore this email. Never share this code with anyone.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 22px 32px; background-color: #FAF6F3; border-top: 1px solid #F1E9E3; text-align: center;">
              <p style="margin: 0 0 6px 0; font-size: 12px; font-weight: 600; color: #6C757D;">
                Loving Brain
              </p>
              <p style="margin: 0; font-size: 11px; line-height: 16px; color: #ADB5BD;">
                Nurturing calm, connected families.<br />
                This is an automated security email. Please do not reply directly.
              </p>
            </td>
          </tr>
          ${referenceFooterRow(reference)}

        </table>
        <!-- End Main Container Card -->
      </td>
    </tr>
  </table>
</body>
</html>
  `.trim();
}

const APP_STORE_URL = "https://apps.apple.com/app/loving-brain/id6470000000";
const PLAY_STORE_URL =
  "https://play.google.com/store/apps/details?id=com.app.loving_brain";

/**
 * @param {string} value
 * @return {string}
 */
/**
 * Bottom-right reference line used on every Loving Brain email.
 * @param {string} reference
 * @return {string}
 */
function referenceFooterRow(reference) {
  if (!reference) return "";
  return `
          <tr>
            <td align="right" style="padding: 0 16px 14px 16px;">
              <p style="margin: 0; font-size: 11px; line-height: 14px; color: #9A9A9A; text-align: right;">Ref: ${escapeHtml(reference)}</p>
            </td>
          </tr>`;
}

function escapeHtml(value) {
  return String(value ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
}

/**
 * Single-line text safe for a subject line.
 * @param {string} value
 * @param {string} fallback
 * @param {number} max
 * @return {string}
 */
function oneLine(value, fallback, max) {
  const clean = String(value || "")
      .replace(/[\r\n\t]+/g, " ")
      .replace(/\s+/g, " ")
      .trim();
  const text = clean || fallback;
  if (text.length <= max) return text;
  return `${text.slice(0, Math.max(0, max - 3))}...`;
}

/**
 * Small footer reference, same shape as `176165021031-d8`.
 * The stamp changes on every send. The two-letter suffix comes from the invite id.
 * @param {string} invitationId
 * @param {number} sentAtMs
 * @return {string}
 */
function invitationReference(invitationId, sentAtMs) {
  const stamp = String(Math.max(0, Number(sentAtMs) || 0));
  const idSource = String(invitationId || "x0").replace(/[^a-zA-Z0-9]/g, "");
  const suffix = (idSource.slice(-2) || "x0").toLowerCase();
  return `${stamp}-${suffix}`;
}

/**
 * @param {object} input
 * @return {object}
 */
function buildInvitationEmail(input) {
  const fromParentName = oneLine(input.fromParentName, "A parent", 40);
  const childrenNames = oneLine(input.childrenNames, "your child", 60);
  const invitationLink = String(input.invitationLink || "").trim();
  const invitationId = String(input.invitationId || "").trim();
  const sentAtMs = Number(input.sentAtMs) || Date.now();
  const reference = invitationReference(invitationId, sentAtMs);
  const logoUrl = input.logoUrl || DEFAULT_LOGO_URL;
  const appStoreUrl = input.appStoreUrl || APP_STORE_URL;
  const playStoreUrl = input.playStoreUrl || PLAY_STORE_URL;
  const subject = `${fromParentName} invited you to Loving Brain`;
  const htmlContent = renderInvitationEmailHtml({
    fromParentName,
    childrenNames,
    invitationLink,
    reference,
    logoUrl,
    appStoreUrl,
    playStoreUrl,
  });
  const textContent = [
    `${fromParentName} invited you to care for ${childrenNames} on Loving Brain.`,
    "",
    `Open the invitation: ${invitationLink}`,
    "",
    "This invitation expires in 14 days.",
    "",
    `App Store: ${appStoreUrl}`,
    `Google Play: ${playStoreUrl}`,
    "",
    "If you did not expect this, you can ignore this email.",
    "",
    `Ref: ${reference}`,
  ].join("\n");

  return {
    reference,
    subject,
    htmlContent,
    textContent,
    headers: {
      "X-Entity-Ref-ID": `${invitationId || reference}.${sentAtMs}`,
    },
  };
}

/**
 * Brevo body for one invitation send. The subject stays clean.
 * A unique X-Entity-Ref-ID keeps each send out of the previous Gmail thread.
 * @param {object} input
 * @return {object}
 */
/**
 * OTP email payload. Each send gets its own footer reference and thread header.
 * @param {object} input
 * @return {object}
 */
function buildBrevoOtpBody(input) {
  const sentAtMs = Number(input.sentAtMs) || Date.now();
  const toEmail = String(input.toEmail || "").trim();
  const otpCode = String(input.otpCode || "").trim();
  const reference = invitationReference(toEmail || "otp", sentAtMs);
  const logoUrl = input.logoUrl || DEFAULT_LOGO_URL;
  const sender = input.sender || {
    name: "Loving Brain",
    email: "hardikkoladiya107@gmail.com",
  };
  return {
    sender,
    to: [{email: toEmail}],
    subject: "Your Loving Brain Verification Code",
    htmlContent: getOtpEmailHtml(otpCode, logoUrl, reference),
    textContent: [
      "Your Loving Brain verification code is:",
      otpCode,
      "",
      "This code expires in 10 minutes.",
      "If you did not request it, you can ignore this email.",
      "",
      `Ref: ${reference}`,
    ].join("\n"),
    headers: {
      "X-Entity-Ref-ID": `otp.${reference}`,
    },
  };
}

function buildBrevoInvitationBody(input) {
  const mail = buildInvitationEmail(input);
  const sender = input.sender || {
    name: "Loving Brain",
    email: "hardikkoladiya107@gmail.com",
  };
  return {
    sender,
    to: [{email: String(input.toEmail || "").trim()}],
    subject: mail.subject,
    htmlContent: mail.htmlContent,
    textContent: mail.textContent,
    headers: mail.headers,
  };
}

/**
 * @param {object} input
 * @return {string}
 */
function renderInvitationEmailHtml(input) {
  const safeName = escapeHtml(input.fromParentName);
  const safeChild = escapeHtml(input.childrenNames);
  const safeLink = escapeHtml(input.invitationLink);
  const safeLogo = escapeHtml(input.logoUrl);
  const safeAppStore = escapeHtml(input.appStoreUrl);
  const safePlay = escapeHtml(input.playStoreUrl);
  const preheader = escapeHtml(
      `${input.fromParentName} invited you to care for ${input.childrenNames}.`,
  );

  return `
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="x-apple-disable-message-reformatting" />
  <title>You're invited</title>
</head>
<body style="margin: 0; padding: 0; background-color: #FEF8F4; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
  <div style="display: none; max-height: 0; overflow: hidden; mso-hide: all;">
    ${preheader}
  </div>
  <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #FEF8F4;">
    <tr>
      <td align="center" style="padding: 32px 16px;">
        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 480px; background-color: #FFFFFF; border: 1px solid #F0E6E0; border-radius: 16px;">
          <tr>
            <td align="center" style="padding: 28px 32px 8px 32px;">
              <img src="${safeLogo}" alt="Loving Brain" width="48" height="48" style="display: block; margin: 0 auto 12px auto; border: 0; outline: none; text-decoration: none;" />
              <p style="margin: 0; font-size: 13px; font-weight: 700; letter-spacing: 0.4px; color: #212E5A;">Loving Brain</p>
            </td>
          </tr>
          <tr>
            <td style="padding: 12px 32px 28px 32px; text-align: center;">
              <h1 style="margin: 0 0 12px 0; font-size: 22px; line-height: 28px; font-weight: 700; color: #212E5A;">You're invited</h1>
              <p style="margin: 0 0 24px 0; font-size: 15px; line-height: 22px; color: #3D3D3D;">
                <strong>${safeName}</strong> invited you to care for <strong>${safeChild}</strong>.
              </p>
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" style="margin: 0 auto 20px auto;">
                <tr>
                  <td align="center" bgcolor="#F06D4D" style="border-radius: 8px;">
                    <a href="${safeLink}" style="display: inline-block; padding: 12px 28px; font-size: 15px; font-weight: 700; color: #FFFFFF; text-decoration: none;">Open invitation</a>
                  </td>
                </tr>
              </table>
              <p style="margin: 0 0 8px 0; font-size: 12px; line-height: 18px; color: #8A8A8A;">
                Expires in 14 days
              </p>
              <p style="margin: 0; font-size: 12px; line-height: 18px; color: #8A8A8A;">
                <a href="${safeAppStore}" style="color: #665FCE; text-decoration: underline;">App Store</a>
                &nbsp;·&nbsp;
                <a href="${safePlay}" style="color: #665FCE; text-decoration: underline;">Google Play</a>
              </p>
            </td>
          </tr>
          <tr>
            <td style="padding: 14px 20px 6px 20px; border-top: 1px solid #F3EBE6; text-align: center;">
              <p style="margin: 0; font-size: 11px; line-height: 16px; color: #B0A8A4;">
                If you did not expect this, you can ignore this email.
              </p>
            </td>
          </tr>
          ${referenceFooterRow(input.reference)}
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `.trim();
}

module.exports = {
  getOtpEmailHtml,
  invitationReference,
  buildInvitationEmail,
  buildBrevoInvitationBody,
  buildBrevoOtpBody,
};

