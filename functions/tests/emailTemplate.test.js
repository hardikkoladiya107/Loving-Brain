const test = require("node:test");
const assert = require("node:assert/strict");
const {
  getOtpEmailHtml,
  invitationReference,
  buildInvitationEmail,
  buildBrevoInvitationBody,
} = require("../utils/emailTemplate");

const link = "https://www.lovingbrain.com/invite/l8fnSa0VSOKST2Ss7Mve";

test("invitation reference is unique per send and traceable to the invite", () => {
  const first = invitationReference("l8fnSa0VSOKST2Ss7Mve", 1_700_000_000_000);
  const second = invitationReference("l8fnSa0VSOKST2Ss7Mve", 1_700_000_000_001);
  const other = invitationReference("aaaaaaaaaaaaZZZZZZ", 1_700_000_000_000);
  assert.match(first, /^1700000000000-ve$/);
  assert.notEqual(first, second);
  assert.notEqual(first, other);
});

test("reference is only in the footer, not the subject", () => {
  const first = buildInvitationEmail({
    fromParentName: "QA Parent C",
    childrenNames: "QA Child C",
    invitationLink: link,
    invitationId: "l8fnSa0VSOKST2Ss7Mve",
    sentAtMs: 1_700_000_000_000,
  });
  const second = buildInvitationEmail({
    fromParentName: "QA Parent C",
    childrenNames: "QA Child C",
    invitationLink: link,
    invitationId: "l8fnSa0VSOKST2Ss7Mve",
    sentAtMs: 1_700_000_060_000,
  });

  assert.equal(first.subject, "QA Parent C invited you to Loving Brain");
  assert.equal(first.subject.includes(first.reference), false);
  assert.notEqual(first.headers["X-Entity-Ref-ID"], second.headers["X-Entity-Ref-ID"]);
  assert.ok(first.htmlContent.includes(`Ref: ${first.reference}`));
  assert.equal(first.htmlContent.includes(`Reference ${first.reference}`), false);
  assert.ok(first.htmlContent.includes("Open invitation"));
  assert.ok(first.htmlContent.includes(link));
  assert.ok(first.htmlContent.includes("App Store"));
  assert.ok(first.htmlContent.includes("Google Play"));
  assert.equal(first.htmlContent.includes("Loving Brain is a Mobile App"), false);
  assert.equal(first.htmlContent.includes("api.qrserver.com"), false);
  assert.ok(first.textContent.includes(first.reference));
});

test("invitation email escapes names and stays a valid Brevo payload", () => {
  const mail = buildInvitationEmail({
    fromParentName: "Alex <script>",
    childrenNames: "Sam & Jo",
    invitationLink: link,
    invitationId: "invite123",
    sentAtMs: 1_700_000_000_000,
  });
  assert.ok(mail.htmlContent.includes("Alex &lt;script&gt;"));
  assert.ok(mail.htmlContent.includes("Sam &amp; Jo"));
  assert.equal(mail.subject.includes("\n"), false);

  const body = buildBrevoInvitationBody({
    toEmail: "caregiver@example.com",
    fromParentName: "Alex",
    childrenNames: "Maya",
    invitationLink: link,
    invitationId: "invite123",
    sentAtMs: 1_700_000_000_000,
    sender: {name: "Loving Brain", email: "hello@lovingbrain.com"},
  });
  assert.deepEqual(Object.keys(body).sort(), [
    "headers",
    "htmlContent",
    "sender",
    "subject",
    "textContent",
    "to",
  ]);
  assert.equal(body.to[0].email, "caregiver@example.com");
  assert.ok(body.headers["X-Entity-Ref-ID"].startsWith("invite123."));
});

test("getOtpEmailHtml includes OTP and security notices", () => {
  const html = getOtpEmailHtml("5678");
  assert.ok(html.includes("5678"));
  assert.ok(html.includes("10 minutes"));
});
