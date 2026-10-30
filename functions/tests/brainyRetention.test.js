const {describe, it} = require("node:test");
const assert = require("node:assert/strict");
const {
  isOlderThanRetentionDays,
  CONVERSATION_RETENTION_DAYS,
} = require("../services/brainyRetention");

describe("brainyRetention", () => {
  it("uses 90-day retention constant", () => {
    assert.equal(CONVERSATION_RETENTION_DAYS, 90);
  });

  it("keeps a 10-day conversation", () => {
    const now = new Date("2026-10-30T12:00:00Z");
    const createdAt = new Date("2026-10-20T12:00:00Z");
    assert.equal(isOlderThanRetentionDays(createdAt, now), false);
  });

  it("drops a 91-day conversation", () => {
    const now = new Date("2026-10-30T12:00:00Z");
    const createdAt = new Date("2026-07-31T12:00:00Z");
    assert.equal(isOlderThanRetentionDays(createdAt, now), true);
  });

  it("keeps a conversation exactly at 90 days", () => {
    const now = new Date("2026-10-30T12:00:00Z");
    const createdAt = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
    assert.equal(isOlderThanRetentionDays(createdAt, now), false);
  });

  it("rejects invalid dates", () => {
    assert.equal(isOlderThanRetentionDays(null, new Date()), false);
    assert.equal(isOlderThanRetentionDays(new Date(), null), false);
  });
});
