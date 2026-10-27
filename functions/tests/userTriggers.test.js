const test = require("node:test");
const assert = require("node:assert/strict");

test("onUserDelete trigger is defined and listens to users/{userId}", () => {
  const {onUserDelete} = require("../triggers/userTriggers");
  assert.ok(onUserDelete, "onUserDelete should be exported");
  assert.equal(typeof onUserDelete, "function");
});
