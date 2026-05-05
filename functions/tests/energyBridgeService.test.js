const test = require("node:test");
const assert = require("node:assert/strict");
const {handleEnergyBridgeWrite} = require("../services/energyBridgeService");

class FakeDocSnap {
  constructor(data) {
    this._data = data;
    this.exists = data != null;
  }

  data() {
    return this._data;
  }
}

class FakeDb {
  constructor({timerDoc, childDoc, usersByUid}) {
    this.timerDoc = timerDoc;
    this.childDoc = childDoc;
    this.usersByUid = usersByUid;
    this.updatedTimer = null;
  }

  collection(name) {
    if (name === "energy_bridge") {
      return {
        doc: (id) => ({
          id,
          get: async () => new FakeDocSnap(this.timerDoc),
        }),
      };
    }
    if (name === "children") {
      return {
        doc: (id) => ({
          id,
          get: async () => new FakeDocSnap(this.childDoc),
        }),
      };
    }
    if (name === "users") {
      return {
        where: (_field, _op, values) => ({
          get: async () => ({
            forEach: (cb) => {
              values.forEach((uid) => {
                const token = this.usersByUid[uid];
                if (token !== undefined) {
                  cb({
                    data: () => ({fcm_token: token}),
                  });
                }
              });
            },
          }),
        }),
      };
    }
    throw new Error(`Unexpected collection: ${name}`);
  }

  async runTransaction(fn) {
    const tx = {
      get: async () => new FakeDocSnap(this.timerDoc),
      update: (_ref, payload) => {
        this.updatedTimer = payload;
      },
    };
    return fn(tx);
  }
}

function buildEvent({before = {}, after = {}, childId = "child-1"}) {
  return {
    params: {childId},
    data: {
      before: {data: () => before},
      after: {data: () => after},
    },
  };
}

test("sends multicast with deduplicated parent tokens", async () => {
  const db = new FakeDb({
    timerDoc: {fired: true, fired_push_sent_at: null},
    childDoc: {
      child_name: "Liam",
      parent_reference_ids: ["u1", "u2", "u3"],
    },
    usersByUid: {
      u1: "token-a",
      u2: "token-a",
      u3: "token-b",
    },
  });
  let payload = null;
  const sent = [];

  await handleEnergyBridgeWrite(
      buildEvent({
        before: {fired: false},
        after: {fired: true, duration_minutes: 105},
      }),
      {
        db,
        logger: {info: () => {}, error: () => {}},
        sendMulticastNotification: async (tokens, title, body, data) => {
          sent.push({tokens, title, body, data});
        },
        notificationCopy: {
          ENERGY_BRIDGE: {TITLE: "LovingBrain ⚡"},
        },
      },
  );

  assert.equal(sent.length, 1);
  payload = sent[0];
  assert.deepEqual(payload.tokens, ["token-a", "token-b"]);
  assert.equal(payload.title, "LovingBrain ⚡");
  assert.match(
      payload.body,
      /Time to slow things down - Liam has been in high energy for 105 minutes/,
  );
  assert.equal(payload.data.type, "energy_bridge");
  assert.equal(payload.data.screen, "smart_moment");
});

test("does not send when fired already acknowledged", async () => {
  const db = new FakeDb({
    timerDoc: {fired: true, fired_push_sent_at: "already-set"},
    childDoc: {
      child_name: "Liam",
      parent_reference_ids: ["u1"],
    },
    usersByUid: {u1: "token-a"},
  });
  let called = false;

  await handleEnergyBridgeWrite(
      buildEvent({
        before: {fired: false},
        after: {fired: true, fired_push_sent_at: "x"},
      }),
      {
        db,
        logger: {info: () => {}, error: () => {}},
        sendMulticastNotification: async () => {
          called = true;
        },
      },
  );

  assert.equal(called, false);
});
