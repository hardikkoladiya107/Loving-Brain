const test = require("node:test");
const assert = require("node:assert/strict");
const familyAccess = require("../services/familyAccessHelpers");
const authIdentity = require("../services/authIdentityHelpers");

test("normalizeEmail trims and lowercases", () => {
  assert.equal(familyAccess.normalizeEmail("  Parent@Email.COM "), "parent@email.com");
});

test("maskEmail hides local part", () => {
  assert.equal(familyAccess.maskEmail("alex@example.com"), "a***@example.com");
});

test("resolvePrimaryParentUid prefers primary_parent_uid", () => {
  assert.equal(
      familyAccess.resolvePrimaryParentUid({
        primary_parent_uid: "owner1",
        parent_reference_ids: ["owner1", "other"],
      }),
      "owner1",
  );
});

test("resolvePrimaryParentUid falls back to first parent_reference_ids", () => {
  assert.equal(
      familyAccess.resolvePrimaryParentUid({
        parent_reference_ids: ["owner1", "other"],
      }),
      "owner1",
  );
});

test("permissionsForRole disables behaviour for grandparent", () => {
  const perms = familyAccess.permissionsForRole("Grandparent");
  assert.equal(perms.can_view_behaviour, false);
  assert.equal(perms.can_view_health_notes, false);
  assert.equal(perms.can_view_sleep, true);
});

test("permissionsForRole defaults health off for partner", () => {
  const perms = familyAccess.permissionsForRole("Partner");
  assert.equal(perms.can_view_health_notes, false);
  assert.equal(perms.can_view_behaviour, true);
});

test("buildChildrenCsv joins ids", () => {
  assert.equal(familyAccess.buildChildrenCsv(["a", " b ", ""]), "a,b");
});

test("nextDefaultChild skips removed child", () => {
  const removed = {id: "c1"};
  const next = {id: "c2"};
  const result = familyAccess.nextDefaultChild(
      {children: [removed, next]},
      removed,
  );
  assert.equal(result.id, "c2");
});

test("non-owner cannot create an invite", () => {
  const err = familyAccess.validateCreateInvite({
    fromUid: "coparent",
    fromEmail: "co@test.com",
    toEmail: "other@test.com",
    childIds: ["child1"],
    childrenById: {
      child1: {
        primary_parent_uid: "owner",
        parent_reference_ids: ["owner", "coparent"],
      },
    },
    pendingInvites: [],
  });
  assert.equal(err, "not-primary");
});

test("duplicate invite for same email and overlapping child is rejected", () => {
  const err = familyAccess.validateCreateInvite({
    fromUid: "owner",
    fromEmail: "owner@test.com",
    toEmail: "invitee@test.com",
    childIds: ["child1"],
    childrenById: {
      child1: {
        primary_parent_uid: "owner",
        parent_reference_ids: ["owner"],
      },
    },
    pendingInvites: [
      {
        status: "REQUESTED",
        from_uid: "owner",
        to_parent: "invitee@test.com",
        child_ids: ["child1"],
      },
    ],
  });
  assert.equal(err, "duplicate-invite");
});

test("expired invite cannot be accepted", () => {
  const err = familyAccess.validateAcceptInvite(
      {
        status: "REQUESTED",
        to_parent: "a@test.com",
        expires_at: "2020-01-01T00:00:00.000Z",
      },
      {uid: "u1", userEmail: "a@test.com", nowMs: Date.parse("2024-01-01")},
  );
  assert.equal(err, "expired");
});

test("cancelled invite cannot be accepted", () => {
  const err = familyAccess.validateAcceptInvite(
      {status: "CANCELLED", to_parent: "a@test.com"},
      {uid: "u1", userEmail: "a@test.com", nowMs: Date.now()},
  );
  assert.equal(err, "no-longer-valid");
});

test("accept keeps existing default_child", () => {
  assert.equal(
      familyAccess.shouldSetDefaultChildOnAccept({
        default_child: {id: "existing"},
      }),
      false,
  );
  assert.equal(
      familyAccess.shouldSetDefaultChildOnAccept({default_child: null}),
      true,
  );
});

test("accept of a second family appends parent without replacing first child parents", () => {
  const after = familyAccess.parentIdsAfterAccept(
      ["primary_a", "coparent_b"],
      "new_join",
  );
  assert.deepEqual(after, ["primary_a", "coparent_b", "new_join"]);
  assert.equal(after[0], "primary_a");
});

test("revoke removes one child and promotes remaining as default", () => {
  const next = familyAccess.nextDefaultChild(
      {children: [{id: "shared"}, {id: "own"}]},
      {id: "shared"},
  );
  assert.equal(next.id, "own");
});

test("primary cannot leave or be revoked", () => {
  assert.equal(
      familyAccess.validateUnlinkCaregiver(
          {
            primary_parent_uid: "owner",
            parent_reference_ids: ["owner", "co"],
          },
          "owner",
      ),
      "cannot-remove-primary",
  );
});

test("partner_user_id cleared only when it equals removed uid", () => {
  assert.equal(
      familyAccess.shouldClearPartnerUserId(
          {partner_user_id: "co"},
          "co",
      ),
      true,
  );
  assert.equal(
      familyAccess.shouldClearPartnerUserId(
          {partner_user_id: "other"},
          "co",
      ),
      false,
  );
});

test("OTP helpers produce 6 digit codes and stable hashes", () => {
  const code = authIdentity.generateOtpCode();
  assert.match(code, /^\d{6}$/);
  const salt = authIdentity.createSalt();
  const hash1 = authIdentity.hashOtp(code, salt);
  const hash2 = authIdentity.hashOtp(code, salt);
  assert.equal(hash1, hash2);
  assert.notEqual(authIdentity.hashOtp("000000", salt), hash1);
});

test("OTP_MAX_ATTEMPTS is 5", () => {
  assert.equal(authIdentity.OTP_MAX_ATTEMPTS, 5);
});

test("OTP locks after 5 bad codes", () => {
  const salt = authIdentity.createSalt();
  const hash = authIdentity.hashOtp("123456", salt);
  let stored = {hash, salt, attempts: 0, expires_at: Date.now() + 60000};
  for (let i = 1; i <= 4; i++) {
    const result = authIdentity.evaluateOtpAttempt(stored, "000000", Date.now());
    assert.equal(result.ok, false);
    assert.equal(result.locked, false);
    stored = {...stored, attempts: result.attempts};
  }
  const locked = authIdentity.evaluateOtpAttempt(stored, "000000", Date.now());
  assert.equal(locked.ok, false);
  assert.equal(locked.locked, true);
  assert.equal(locked.reason, "locked");
});

test("email and phone resolve to the existing uid", () => {
  assert.deepEqual(
      authIdentity.resolveTargetUid({
        existingUserUid: "existing_user",
        authUid: "new_auth",
      }),
      {uid: "existing_user"},
  );
  assert.deepEqual(
      authIdentity.resolveTargetUid({
        existingUserUid: null,
        authUid: "new_auth",
      }),
      {uid: "new_auth"},
  );
});

test("social identity merges old profile onto current auth uid", () => {
  assert.deepEqual(
      authIdentity.resolveSocialIdentityMerge({
        existingUserUid: "old_profile",
        authUid: "google_uid",
      }),
      {
        action: "merge-onto-auth",
        keepUid: "google_uid",
        deleteUid: "old_profile",
      },
  );
});
