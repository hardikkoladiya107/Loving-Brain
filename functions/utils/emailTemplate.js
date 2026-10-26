/**
 * emailTemplate.js
 * Generates responsive, branded HTML email templates for Loving Brain.
 */

const DEFAULT_LOGO_URL =
  "https://storage.googleapis.com/hugsand-heart-u86wap.firebasestorage.app/app_assets/loving_brain_logo.png";

/**
 * Returns a fully styled HTML email for OTP verification.
 * @param {string} otpCode 4-digit verification code.
 * @param {string} [logoUrl] Optional hosted image URL for the logo.
 * @returns {string} Fully formatted HTML string.
 */
function getOtpEmailHtml(otpCode, logoUrl = DEFAULT_LOGO_URL) {
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
                      <span style="font-family: 'Courier New', Courier, monospace, sans-serif; font-size: 38px; font-weight: 800; color: #F06D4D; letter-spacing: 12px; margin-left: 12px; display: inline-block;">
                        ${otpCode}
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

        </table>
        <!-- End Main Container Card -->
      </td>
    </tr>
  </table>
</body>
</html>
  `.trim();
}

/**
 * Returns a fully styled HTML email for Co-Parent / Caregiver invitation.
 * @param {string} fromParentName Name of the inviter.
 * @param {string} childrenNames Name of the child.
 * @param {string} invitationLink Universal deep link.
 * @param {string} [logoUrl] Optional hosted image URL.
 * @return {string} Fully formatted HTML string.
 */
function getInvitationEmailHtml(
  fromParentName,
  childrenNames,
  invitationLink,
  logoUrl = DEFAULT_LOGO_URL
) {
  const brandLogoHtml = `
    <img src="${logoUrl}" alt="Loving Brain" width="76" height="76" style="display: block; margin: 0 auto 14px auto; border: 0; outline: none; text-decoration: none; max-width: 76px; height: auto;" />
  `;

  return `
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>You've Been Invited to Loving Brain</title>
</head>
<body style="margin: 0; padding: 0; background-color: #FEF8F4; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
  <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #FEF8F4; padding: 40px 16px;">
    <tr>
      <td align="center">
        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 480px; background-color: #FFFFFF; border-radius: 28px; border: 1px solid #F5EAE4; box-shadow: 0 8px 30px rgba(240, 109, 77, 0.08); overflow: hidden;">
          <tr>
            <td align="center" style="padding: 40px 32px 18px 32px; background: linear-gradient(180deg, #FFF7F2 0%, #FFFFFF 100%);">
              ${brandLogoHtml}
              <h1 style="margin: 0; font-size: 26px; font-weight: 800; color: #212E5A;">Loving Brain</h1>
              <p style="margin: 6px 0 0 0; font-size: 13px; color: #8A8A8A; font-weight: 500;">Parenting Together, Beautifully</p>
            </td>
          </tr>
          <tr>
            <td style="padding: 12px 36px 36px 36px; text-align: center;">
              <h2 style="margin: 0 0 10px 0; font-size: 20px; font-weight: 700; color: #212E5A;">You've been invited! 🎉</h2>
              <p style="margin: 0 0 18px 0; font-size: 14px; line-height: 22px; color: #545454;">
                <strong style="color: #665FCE;">${fromParentName}</strong> has invited you to collaborate and support <strong style="color: #F06D4D;">${childrenNames}</strong> on Loving Brain.
              </p>
              <p style="margin: 0 0 28px 0; font-size: 13px; line-height: 20px; color: #767676;">
                Stay synchronized on sleep forecasts, routines, and daily plans—all in one calm, supportive space.
              </p>
              <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 24px;">
                <tr>
                  <td align="center">
                    <a href="${invitationLink}" style="display: inline-block; background: linear-gradient(135deg, #F06D4D 0%, #FF8A65 100%); color: #FFFFFF; font-size: 16px; font-weight: 700; text-decoration: none; padding: 16px 36px; border-radius: 50px; box-shadow: 0 6px 20px rgba(240, 109, 77, 0.35);">
                      Accept Invitation &amp; Open App
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin: 0 0 6px 0; font-size: 12px; color: #9E9E9E;">Or open this link directly:</p>
              <p style="margin: 0 0 24px 0; font-size: 12px; color: #665FCE; word-break: break-all;">${invitationLink}</p>
              <p style="margin: 0; font-size: 11px; line-height: 16px; color: #ADB5BD;">
                If you did not expect this invitation, you can safely ignore this email. The link expires after 14 days.
              </p>
            </td>
          </tr>
          <tr>
            <td style="padding: 22px 32px; background-color: #FAF6F3; border-top: 1px solid #F1E9E3; text-align: center;">
              <p style="margin: 0; font-size: 11px; line-height: 16px; color: #ADB5BD;">
                © 2025 Loving Brain · All rights reserved
              </p>
            </td>
          </tr>
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
  getInvitationEmailHtml,
};

