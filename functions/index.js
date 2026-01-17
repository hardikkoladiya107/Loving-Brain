const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const {sendNotification, sendMulticastNotification} = require("./notification");
exports.sampleTest = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase! Test");
});
exports.sampleTest2 = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase! Test");
});


const admin = require("firebase-admin");
if (!admin.apps.length) admin.initializeApp();
const db = admin.firestore();

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


exports.dailyRoutineReminderNotification = onRequest(async (req, res) => {
  try {
    const now = new Date();
    const usersSnapshot = await admin.firestore().collection("children").get();
    const dates = [];
    const matched = [];
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      // safely handle undefined
      const routines = userData.routines || [];
      routines.forEach((routine) => {
        const ts = routine.time_stamp && routine.time_stamp.toDate ?
            routine.time_stamp.toDate() : null;
        dates.push(ts);
        if (/* ts.getDate() === now.getDate() &&
             ts.getMonth() === now.getMonth() &&*/
          ts.getHours() === now.getHours() &&
             ts.getMinutes() === now.getMinutes()) {
          matched.push({
            childId: doc.id,
            routine,
          });
        }
      });
    });

    const usersRef = db.collection("users");
    const usersDocs = await usersRef.get();
    const usersWithMatchedChildren = [];
    const fcmTokens = [];

    matched.forEach((match) => {
      usersDocs.forEach((userDoc) => {
        const userData = userDoc.data();
        const childRefs = userData.children || [];
        const hasChild = childRefs.some(
            (ref) => ref.id === match.childId,
        );

        if (hasChild) {
          fcmTokens.push(userData.fcm_token);
          usersWithMatchedChildren.push({
            userId: userDoc.id,
            childId: match.childId,
            routine: match.routine,
            fcm_token: userData.fcm_token,
          });
        }
      });
    });


    if (fcmTokens.length === 0) {
      return res.status(200).send({message: "No valid FCM tokens found"});
    }

    const result = await sendMulticastNotification(
        fcmTokens,
        "Daily Routine Notification",
        "Daily Routine Notification",
    );

    return res.status(200).send({
      success: result.success,
      dates: dates,
      matched: matched,
      now: now,
      usersWithMatchedChildren: usersWithMatchedChildren,
      fcmTokens: fcmTokens,
      response: result.success ?
         {
           successCount: result.successCount,
           failureCount: result.failureCount,
         } :
         result.error,
    });
  } catch (error) {
    logger.error("Error sending notifications", {error});
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});


exports.sharedEventReminderNotification = onRequest(async (req, res) => {
  try {
    const now = new Date();
    const sharedEventSnapshot = await admin.firestore()
        .collection("shared_event").get();
    const allSharedEventImpData = [];
    const matched = [];
    sharedEventSnapshot.forEach((doc) => {
      const userData = doc.data();
      const assignedTo = userData.assigned_to || [];
      const createdBy = userData.created_by;
      const startTime = userData.start_time;
      const selectedDate = userData.date;
      const eventDate = selectedDate && selectedDate.toDate ?
          selectedDate.toDate() : null;
      const eventStartTime = startTime && startTime.toDate ?
          startTime.toDate() : null;
      const istOffset = 5.5 * 60 * 60 * 1000; // +5:30 hours
      const eventDateIST = new Date(eventDate.getTime() + istOffset);
      const eventStartTimeIST = new Date(
          eventStartTime.getTime() + istOffset,
      );
      const nowInIst = new Date(now.getTime() + istOffset);
      if (eventDateIST.getDate() === nowInIst.getDate() &&
          eventDateIST.getMonth() === nowInIst.getMonth() &&
          eventStartTimeIST.getHours() === nowInIst.getHours() &&
          eventStartTimeIST.getMinutes() === nowInIst.getMinutes()) {
        matched.push(...assignedTo);
        matched.push(createdBy);
      }

      allSharedEventImpData.push({
        created_by: createdBy,
        assigned_to: assignedTo,
        eventDate: eventDate,
        eventStartTime: eventStartTime,
        now: nowInIst,
        eventDateIST: eventDateIST,
        eventStartTimeIST: eventStartTimeIST,
        matched: matched,
      });
    });

    if (matched.length === 0) {
      return res.status(200).send({message: "no matched found"});
    }
    const fcmTokens = [];
    const uniqueMatched = [...new Set(matched)];
    const usersSnapshot = await admin.firestore()
        .collection("users")
        .where("uid", "in", uniqueMatched)
        .get();
    usersSnapshot.forEach((doc) => {
      const userData = doc.data();
      fcmTokens.push(userData.fcm_token);
    });
    const uniqueFcmTokens = [...new Set(fcmTokens)];
    if (uniqueFcmTokens.length === 0) {
      return res.status(200).send({message: "No valid FCM tokens found"});
    }

    const result = await sendMulticastNotification(
        uniqueFcmTokens,
        "Shared Event Notification",
        "Shared Event Notification",
    );

    return res.status(200).send({
      success: result.success,
      response: result.success ?
             {
               successCount: result.successCount,
               failureCount: result.failureCount,
             } :
             result.error,
      allSharedEventImpData: allSharedEventImpData,
      fcmTokens: uniqueFcmTokens,
    });
  } catch (error) {
    logger.error("Error sending notifications", {error});
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});
