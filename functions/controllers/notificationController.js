const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const {sendMulticastNotification} = require("../notification");

if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

exports.sendScheduledNotification = onRequest(async (req, res) => {
  try {
    const {type, docId, childId} = req.body;

    logger.info("Received scheduled notification task", {type, docId});

    if (type === "routine") {
      // Validate Routine
      const childDoc = await db.collection("children").doc(childId).get();
      if (!childDoc.exists) {
        logger.warn("Child document no longer exists, skipping notification");
        return res.status(200).send("Child not found");
      }

      // Finding the parent to send to
      const childRef = db.collection("children").doc(childId);
      const usersSnapshot = await db
          .collection("users")
          .where("children", "array-contains", childRef)
          .get();

      const tokens = [];
      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (userData.fcm_token) tokens.push(userData.fcm_token);
      });

      if (tokens.length > 0) {
        await sendMulticastNotification(
            tokens,
            "Daily Routine Notification",
            "Time for your routine!",
        );
      }
    } else if (type === "shared_event") {
      // Validate Shared Event
      const eventDoc = await db.collection("shared_event").doc(docId).get();
      if (!eventDoc.exists) {
        logger.warn("Event no longer exists, skipping notification");
        return res.status(200).send("Event not found");
      }
      const eventData = eventDoc.data();

      const assignedTo = eventData.assigned_to || [];
      const createdBy = eventData.created_by;

      const uidsToNotify = [...assignedTo, createdBy];
      const uniqueUids = [...new Set(uidsToNotify)];

      if (uniqueUids.length === 0) {
        return res.status(200).send("No users to notify");
      }

      const tokens = [];
      const chunkSize = 10;
      for (let i = 0; i < uniqueUids.length; i += chunkSize) {
        const chunk = uniqueUids.slice(i, i + chunkSize);
        if (chunk.length === 0) continue;
        const userDocs = await db.collection("users")
            .where("uid", "in", chunk)
            .get();
        userDocs.forEach((uDoc) => {
          const uData = uDoc.data();
          if (uData.fcm_token) tokens.push(uData.fcm_token);
        });
      }

      const uniqueTokens = [...new Set(tokens)];
      if (uniqueTokens.length > 0) {
        await sendMulticastNotification(uniqueTokens,
            "Shared Event Notification",
            "You have a shared event coming up!");
      }
    }

    return res.status(200).send("OK");
  } catch (error) {
    logger.error("Error in sendScheduledNotification", error);
    return res.status(500).send(error.message);
  }
});

const {sendNotification} = require("../notification");

exports.sendNotificationToAll = onRequest(async (req, res) => {
  try {
    const usersSnapshot = await admin.firestore().collection("users").get();
    const tokens = [];
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      if (userData.fcm_token && userData.fcm_token.trim() !== "") {
        tokens.push(userData.fcm_token);
      }
    });

    if (tokens.length === 0) {
      return res.status(400).send({error: "No valid FCM tokens found"});
    }

    const result = await sendMulticastNotification(
        tokens,
        "Streak Update!!",
        "Don’t forget to check in today to keep your streak alive!",
    );

    if (!result.success) {
      throw result.error;
    }

    return res.status(200).send({
      success: true,
      successCount: result.successCount,
      failureCount: result.failureCount,
      responses: result.responses,
    });
  } catch (error) {
    logger.error("Error sending notifications", {error});
    return res.status(500).send({
      success: false,
      error: error.message,
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

