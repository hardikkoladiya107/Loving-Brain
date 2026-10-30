const test = require("node:test");
const assert = require("node:assert/strict");
const {
  evaluateDelivery,
  isInvalidTokenError,
  claimDailySlot,
  selectDeliverableTokens,
} = require("../services/notificationDelivery");

const noon = new Date("2026-06-15T12:00:00Z");
const late = new Date("2026-06-15T22:30:00Z");

test("routine is blocked when sleep reminders are off", () => {
  const decision = evaluateDelivery({
    notification_preferences: {sleepReminders: false},
    location_data: {timezone: "UTC"},
  }, "routine", noon);
  assert.equal(decision.allow, false);
  assert.equal(decision.reason, "toggle_off");
});

test("energy bridge is blocked during quiet hours in the parent timezone", () => {
  const decision = evaluateDelivery({
    notification_preferences: {
      checkInReminders: true,
      quietHoursStart: "21:00",
      quietHoursEnd: "07:00",
    },
    location_data: {timezone: "UTC"},
  }, "energy_bridge", late);
  assert.equal(decision.allow, false);
  assert.equal(decision.reason, "quiet_hours");
});

test("12-hour quiet hours still block an evening send", () => {
  const decision = evaluateDelivery({
    notification_preferences: {
      quietHoursStart: "9:00 PM",
      quietHoursEnd: "7:00 AM",
    },
    location_data: {timezone: "UTC"},
  }, "shared_event", late);
  assert.equal(decision.reason, "quiet_hours");
});

test("daily cap blocks the next send on the same local day", () => {
  const decision = evaluateDelivery({
    notification_preferences: {maxDailyCap: 3},
    notification_sent_day: "2026-06-15",
    notification_sent_count: 3,
    location_data: {timezone: "UTC"},
  }, "announcement", noon);
  assert.equal(decision.allow, false);
  assert.equal(decision.reason, "daily_cap");
});

test("a send is allowed at midday when reminders are on and the cap is open", () => {
  const decision = evaluateDelivery({
    fcm_token: "token-a",
    location_data: {timezone: "UTC"},
  }, "energy_bridge", noon);
  assert.equal(decision.allow, true);
  assert.equal(decision.reason, "ok");
});

test("device offset decides quiet hours and the local day", () => {
  const decision = evaluateDelivery({
    notification_utc_offset_minutes: 330,
    location_data: {timezone: "UTC"},
    notification_preferences: {
      quietHoursStart: "21:00",
      quietHoursEnd: "07:00",
    },
  }, "routine", new Date("2026-06-15T20:00:00Z"));
  assert.equal(decision.allow, false);
  assert.equal(decision.reason, "quiet_hours");
  assert.equal(decision.dayKey, "2026-06-16");
});

test("a bad payload does not count as a dead device token", () => {
  assert.equal(
      isInvalidTokenError({code: "messaging/invalid-argument"}),
      false,
  );
  assert.equal(
      isInvalidTokenError({
        code: "messaging/registration-token-not-registered",
      }),
      true,
  );
});

test("blank token does not reserve a daily slot", async () => {
  let claims = 0;
  const doc = {
    data: () => ({
      fcm_token: "  ",
      location_data: {timezone: "UTC"},
    }),
    ref: {
      firestore: {
        runTransaction() {
          claims += 1;
          return Promise.resolve(true);
        },
      },
    },
  };
  const deliveries = await selectDeliverableTokens([doc], "routine", noon);
  assert.equal(deliveries.length, 0);
  assert.equal(claims, 0);
});

test("two claims cannot both pass a cap of one", async () => {
  const store = {
    notification_sent_day: "2026-06-15",
    notification_sent_count: 0,
  };
  const decision = evaluateDelivery({
    ...store,
    notification_preferences: {maxDailyCap: 1},
    location_data: {timezone: "UTC"},
  }, "routine", noon);
  let tail = Promise.resolve();
  const ref = {
    firestore: {
      runTransaction(fn) {
        const run = tail.then(async () => {
          const tx = {
            get: async () => ({
              exists: true,
              data: () => Object.assign({}, store),
            }),
            update(_ref, payload) {
              Object.assign(store, payload);
            },
          };
          return fn(tx);
        });
        tail = run.then(() => {}, () => {});
        return run;
      },
    },
  };
  const results = await Promise.all([
    claimDailySlot(ref, store, decision),
    claimDailySlot(ref, store, decision),
  ]);
  assert.equal(results.filter(Boolean).length, 1);
  assert.equal(store.notification_sent_count, 1);
});

test("explicit is_notification false blocks every kind", () => {
  const decision = evaluateDelivery({
    is_notification: false,
    location_data: {timezone: "UTC"},
  }, "co_parent_invitation", noon);
  assert.equal(decision.allow, false);
  assert.equal(decision.reason, "notifications_disabled");
});
