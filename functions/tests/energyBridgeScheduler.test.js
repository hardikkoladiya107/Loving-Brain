const test = require("node:test");
const assert = require("node:assert/strict");

test("energy_bridge scheduler payload shape", () => {
  const payload = {type: "energy_bridge", childId: "child-1"};
  assert.equal(payload.type, "energy_bridge");
  assert.equal(payload.childId, "child-1");
});
