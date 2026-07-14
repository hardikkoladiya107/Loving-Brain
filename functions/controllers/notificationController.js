/**
 * HTTP handlers: sendScheduledNotification (Tasks), sendNotificationToAll,
 * sendPushNotification.
 */
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {
  sendNotification,
  sendMulticastNotification,
} = require("../notification");
const {
  FCM_MULTICAST_LIMIT,
  NOTIFICATION_COPY,
} = require("../config/constants");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

/**
 * Builds notification title/body for routine.
 * @param {string} description - Optional routine description from payload.
 * @return {{title: string, body: string}}
 */
function getRoutineNotificationCopy(description) {
  const copy = NOTIFICATION_COPY.ROUTINE;
  const title = copy.TITLE;
  const body = (description && description.trim()) ?
      copy.BODY_WITH_DESCRIPTION.replace("{{description}}",
          description.trim().slice(0, 80)) :
      copy.BODY;
  return {title, body};
}

/**
 * Builds notification title/body for shared event.
 * @param {string} eventTitle - Optional event title from Firestore.
 * @return {{title: string, body: string}}
 */
function getSharedEventNotificationCopy(eventTitle) {
  const copy = NOTIFICATION_COPY.SHARED_EVENT;
  const title = copy.TITLE;
  const body = (eventTitle && eventTitle.trim()) ?
      copy.BODY_WITH_TITLE.replace(
          "{{title}}", eventTitle.trim().slice(0, 80)) :
      copy.BODY;
  return {title, body};
}

exports.sendScheduledNotification = onRequest(async (req, res) => {
  try {
    if (req.method !== "POST") {
      return res.status(405).send("Method not allowed");
    }
    const body = req.body || {};
    const {type, docId, childId, description} = body;

    if (!type) {
      return res.status(400).send("Missing type");
    }
    if (type !== "routine" &&
        type !== "shared_event" &&
        type !== "energy_bridge") {
      return res.status(400).send("Invalid type");
    }

    logger.info("Received scheduled notification task", {type, docId});

    if (type === "energy_bridge") {
      if (!childId) {
        return res.status(400).send("Missing childId");
      }
      const timerRef = db.collection("energy_bridge").doc(childId);
      const timerSnap = await timerRef.get();
      if (!timerSnap.exists) {
        logger.warn("Energy bridge timer no longer exists, skipping");
        return res.status(200).send("OK");
      }
      const timerData = timerSnap.data() || {};
      if (timerData.is_active !== true || timerData.fired === true) {
        logger.info("Energy bridge timer inactive or already fired, skipping", {
          childId,
        });
        return res.status(200).send("OK");
      }
      await timerRef.set({
        is_active: false,
        fired: true,
        fired_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});
      logger.info("Energy bridge timer marked fired by scheduler", {childId});
    } else if (type === "routine") {
      if (!childId) {
        return res.status(400).send("Missing childId");
      }
      const childDoc = await db.collection("children").doc(childId).get();
      if (!childDoc.exists) {
        logger.warn("Child document no longer exists, skipping");
        return res.status(200).send("OK");
      }

      const childRef = db.collection("children").doc(childId);
      const usersSnapshot = await db
          .collection("users")
          .where("children", "array-contains", childRef)
          .get();

      const tokens = [];
      usersSnapshot.forEach((doc) => {
        const t = doc.data().fcm_token;
        if (t && typeof t === "string" && t.trim()) tokens.push(t.trim());
      });

      if (tokens.length > 0) {
        const {title, body: notificationBody} =
          getRoutineNotificationCopy(description);
        await sendMulticastBatched(
            tokens,
            title,
            notificationBody,
        );
      }
    } else if (type === "shared_event") {
      if (!docId) {
        return res.status(400).send("Missing docId");
      }
      const eventDoc = await db.collection("shared_event").doc(docId).get();
      if (!eventDoc.exists) {
        logger.warn("Event no longer exists, skipping");
        return res.status(200).send("OK");
      }
      const eventData = eventDoc.data();
      const assignedTo = eventData.assigned_to || [];
      const createdBy = eventData.created_by;
      const uidsToNotify = [
        ...assignedTo.filter((u) => u),
        ...(createdBy ? [createdBy] : []),
      ];
      const uniqueUids = [...new Set(uidsToNotify)];

      if (uniqueUids.length === 0) {
        return res.status(200).send("OK");
      }

      const tokens = [];
      const uidChunkSize = 10;
      for (let i = 0; i < uniqueUids.length; i += uidChunkSize) {
        const chunk = uniqueUids.slice(i, i + uidChunkSize);
        const userDocs = await db.collection("users")
            .where("uid", "in", chunk)
            .get();
        userDocs.forEach((uDoc) => {
          const t = uDoc.data().fcm_token;
          if (t && typeof t === "string" && t.trim()) tokens.push(t.trim());
        });
      }
      const uniqueTokens = [...new Set(tokens)];
      if (uniqueTokens.length > 0) {
        const eventTitle = eventData.title || "";
        const {title, body: notificationBody} =
          getSharedEventNotificationCopy(eventTitle);
        await sendMulticastBatched(
            uniqueTokens,
            title,
            notificationBody,
        );
      }
    }

    return res.status(200).send("OK");
  } catch (error) {
    logger.error("Error in sendScheduledNotification", error);
    return res.status(500).send(error.message || "Internal error");
  }
});

/**
 * Sends multicast in batches of FCM_MULTICAST_LIMIT to respect API limit.
 * @param {string[]} tokens - FCM tokens.
 * @param {string} title - Notification title.
 * @param {string} body - Notification body.
 */
async function sendMulticastBatched(tokens, title, body) {
  for (let i = 0; i < tokens.length; i += FCM_MULTICAST_LIMIT) {
    const chunk = tokens.slice(i, i + FCM_MULTICAST_LIMIT);
    await sendMulticastNotification(chunk, title, body);
  }
}

exports.sendNotificationToAll = onRequest(async (req, res) => {
  // Set CORS headers so the admin dashboard can call this
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  try {
    // Accept custom title/body from POST body; fall back to streak defaults
    const {title: reqTitle, body: reqBody} = req.body || {};
    const {TITLE: streakTitle, BODY: streakBody} = NOTIFICATION_COPY.STREAK;
    const title = (reqTitle && reqTitle.trim()) ? reqTitle.trim() : streakTitle;
    const body = (reqBody && reqBody.trim()) ? reqBody.trim() : streakBody;

    // Only send to users who have notifications enabled and a valid FCM token
    const usersSnapshot = await admin.firestore()
        .collection("users")
        .where("is_notification", "==", true)
        .get();

    const tokens = [];
    usersSnapshot.forEach((doc) => {
      const t = doc.data().fcm_token;
      if (t && typeof t === "string" && t.trim()) tokens.push(t.trim());
    });

    if (tokens.length === 0) {
      return res.status(200).send({
        success: true,
        message: "No eligible users found (no tokens or notifications disabled)",
        sent: 0,
      });
    }

    await sendMulticastBatched(tokens, title, body);
    logger.info(`Broadcast notification sent to ${tokens.length} users.`);

    return res.status(200).send({
      success: true,
      message: "Notifications sent successfully",
      sent: tokens.length,
    });
  } catch (error) {
    logger.error("Error sending notifications", {error});
    return res.status(500).send({
      success: false,
      error: error.message || "Internal error",
    });
  }
});


exports.sendPushNotification = onRequest(async (req, res) => {
  try {
    if (req.method !== "POST") {
      return res.status(405).send({error: "Only POST requests are allowed"});
    }
    const {token, title, body, data} = req.body;
    if (!token || !title || !body) {
      return res.status(400).send({
        error: "Missing required fields: token, title, and body are mandatory",
      });
    }

    const result = await sendNotification(token, title, body, data);

    if (!result.success) {
      throw result.error;
    }

    return res.status(200).send({
      success: true,
      messageId: result.response,
    });
  } catch (error) {
    logger.error("Error sending notification", {error});
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});

