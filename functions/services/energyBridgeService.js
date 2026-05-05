const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const {sendMulticastNotification} = require("../notification");
const {NOTIFICATION_COPY} = require("../config/constants");

/**
 * Core business logic for energy bridge fired notifications.
 * Extracted for testability.
 *
 * @param {object} event Firestore trigger event
 * @param {object} deps dependency overrides for tests
 * @return {Promise<void>}
 */
async function handleEnergyBridgeWrite(event, deps = {}) {
  const db = deps.db || admin.firestore();
  const log = deps.logger || logger;
  const sendMulticast = deps.sendMulticastNotification || sendMulticastNotification;
  const notificationCopy = deps.notificationCopy || NOTIFICATION_COPY;

  if (!event.data) return;

  const childId = event.params.childId;
  const beforeData = event.data.before.data() || {};
  const afterData = event.data.after.data() || {};

  const wasFired = beforeData.fired === true;
  const isFired = afterData.fired === true;
  const alreadySent = !!afterData.fired_push_sent_at;
  if (wasFired || !isFired || alreadySent) return;

  try {
    const timerRef = db.collection("energy_bridge").doc(childId);
    const shouldSend = await db.runTransaction(async (transaction) => {
      const timerSnap = await transaction.get(timerRef);
      if (!timerSnap.exists) return false;
      const timerData = timerSnap.data() || {};
      if (timerData.fired !== true || timerData.fired_push_sent_at) {
        return false;
      }
      transaction.update(timerRef, {
        fired_push_sent_at: admin.firestore.FieldValue.serverTimestamp(),
      });
      return true;
    });

    if (!shouldSend) return;

    const childDoc = await db.collection("children").doc(childId).get();
    if (!childDoc.exists) return;

    const childData = childDoc.data() || {};
    const parentUids = Array.isArray(childData.parent_reference_ids) ?
      childData.parent_reference_ids
          .filter((uid) => typeof uid === "string" && uid.trim()) :
      [];
    if (parentUids.length === 0) return;

    const tokens = [];
    const uidChunkSize = 10;
    for (let i = 0; i < parentUids.length; i += uidChunkSize) {
      const chunk = parentUids.slice(i, i + uidChunkSize);
      const usersSnap = await db.collection("users")
          .where("uid", "in", chunk)
          .get();
      usersSnap.forEach((userDoc) => {
        const token = userDoc.data().fcm_token;
        if (token && typeof token === "string" && token.trim()) {
          tokens.push(token.trim());
        }
      });
    }

    const uniqueTokens = [...new Set(tokens)];
    if (uniqueTokens.length === 0) return;

    const childName = (childData.child_name || "").toString().trim();
    const durationMinutes = Number(afterData.duration_minutes || 105);
    const notificationBody = `Time to slow things down - ${
      childName || "Your child"
    } has been in high energy for ${durationMinutes} minutes`;

    await sendMulticast(
        uniqueTokens,
        notificationCopy.ENERGY_BRIDGE.TITLE,
        notificationBody,
        {
          type: "energy_bridge",
          child_id: childId,
          screen: "smart_moment",
        },
    );
    log.info("Energy bridge fired push sent", {
      childId,
      recipients: uniqueTokens.length,
    });
  } catch (error) {
    log.error("Failed to send energy bridge fired push", {
      childId,
      error,
    });
  }
}

module.exports = {handleEnergyBridgeWrite};
