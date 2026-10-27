const test = require("node:test");
const assert = require("node:assert/strict");
const { getInvitationEmailHtml, getOtpEmailHtml } = require("../utils/emailTemplate");

test("getInvitationEmailHtml includes mobile app instructions and store links", () => {
  const html = getInvitationEmailHtml(
    "Hardik",
    "Emma",
    "https://www.lovingbrain.com/invite123"
  );

  assert.ok(html.includes("Loving Brain is a Mobile App"));
  assert.ok(html.includes("App Store"));
  assert.ok(html.includes("Google Play"));
  assert.ok(html.includes("Accept Invitation &amp; Open App"));
  assert.ok(html.includes("https://www.lovingbrain.com/invite123"));
  assert.ok(html.includes("api.qrserver.com/v1/create-qr-code"));
});

test("getOtpEmailHtml includes OTP and security notices", () => {
  const html = getOtpEmailHtml("5678");
  assert.ok(html.includes("5678"));
  assert.ok(html.includes("10 minutes"));
});
