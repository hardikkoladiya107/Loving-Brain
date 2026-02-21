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
    if (type !== "routine" && type !== "shared_event") {
      return res.status(400).send("Invalid type");
    }

    logger.info("Received scheduled notification task", {type, docId});

    if (type === "routine") {
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
  try {
    const usersSnapshot = await admin.firestore().collection("users").get();
    const tokens = [];
    usersSnapshot.forEach((doc) => {
      const t = doc.data().fcm_token;
      if (t && typeof t === "string" && t.trim()) tokens.push(t.trim());
    });

    if (tokens.length === 0) {
      return res.status(400).send({error: "No valid FCM tokens found"});
    }

    const {TITLE: streakTitle, BODY: streakBody} = NOTIFICATION_COPY.STREAK;
    await sendMulticastBatched(
        tokens,
        streakTitle,
        streakBody,
    );

    return res.status(200).send({
      success: true,
      message: "Notifications sent in batches",
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

