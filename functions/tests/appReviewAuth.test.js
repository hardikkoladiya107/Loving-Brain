const test = require("node:test");
const assert = require("node:assert/strict");
const authIdentity = require("../services/authIdentityHelpers");

test("app review otp matches only the review email and code", () => {
  assert.equal(
      authIdentity.isAppReviewOtp(
          "AppleReview@LovingBrain.com",
          authIdentity.APP_REVIEW_OTP,
      ),
      true,
  );
  assert.equal(
      authIdentity.isAppReviewOtp(
          authIdentity.APP_REVIEW_EMAIL,
          "000000",
      ),
      false,
  );
  assert.equal(
      authIdentity.isAppReviewOtp(
          "parent@lovingbrain.com",
          authIdentity.APP_REVIEW_OTP,
      ),
      false,
  );
});
