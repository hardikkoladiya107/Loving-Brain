const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {sendMulticastNotification} = require("../notification");
const {NOTIFICATION_COPY} = require("../config/constants");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

exports.onEnergyBridgeWrite = onDocumentWritten("energy_bridge/{childId}",
    async (event) => {
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
          childData.parent_reference_ids.filter((uid) => typeof uid === "string" && uid.trim()) :
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

        await sendMulticastNotification(
            uniqueTokens,
            NOTIFICATION_COPY.ENERGY_BRIDGE.TITLE,
            NOTIFICATION_COPY.ENERGY_BRIDGE.BODY,
            {
              type: "energy_bridge",
              child_id: childId,
            },
        );
        logger.info("Energy bridge fired push sent", {
          childId,
          recipients: uniqueTokens.length,
        });
      } catch (error) {
        logger.error("Failed to send energy bridge fired push", {
          childId,
          error,
        });
      }
    });
