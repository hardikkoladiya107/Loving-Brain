const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
exports.sampleTest = onRequest((request, response) => {
    logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase! Test");
});
exports.sampleTest2 = onRequest((request, response) => {
    logger.info("Hello logs!", { structuredData: true });
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
    const message = {
      tokens: tokens,
      notification: {
        title: "Streak Update!!",
        body: "Don’t forget to check in today to keep your streak alive!",
      },
      data: {},
      android: {
        priority: "high",
        notification: {
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    };
    const response = await admin.messaging().sendEachForMulticast(message);
    logger.info("Notifications sent", { response });
    return res.status(200).send({
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses,
    });
  } catch (error) {
    logger.error("Error sending notifications", { error });
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});

exports.sendPushNotification = onRequest(async (req, res) => {
  try {
    if (req.method !== "POST") {
      return res.status(405).send({ error: "Only POST requests are allowed" });
    }
    const { token, title, body, data } = req.body;
    if (!token || !title || !body) {
      return res.status(400).send({
        error: "Missing required fields: token, title, and body are mandatory",
      });
    }
    const message = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: data || {},
      android: {
        priority: "high",
        notification: {
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    };
    const response = await admin.messaging().send(message);
    logger.info("Notification sent successfully", { response });
    return res.status(200).send({
      success: true,
      messageId: response,
    });
  } catch (error) {
    logger.error("Error sending notification", { error });
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
      const routines = userData.routines || []; // ✅ safely handle undefined
      routines.forEach((routine) => {
        const ts = routine.time_stamp?.toDate?.();
         dates.push(ts);
         if (/*ts.getDate() === now.getDate() &&
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
              (ref) => ref.id === match.childId
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

     const message = {
          tokens: fcmTokens,
          notification: {
            title: "Daily Routine Notification",
            body: "Daily Routine Notification",
          },
          data: {},
          android: {
            priority: "high",
            notification: {
              sound: "default",
            },
          },
          apns: {
            payload: {
              aps: {
                sound: "default",
              },
            },
          },
        };
     const response = await admin.messaging().sendEachForMulticast(message);
     return res.status(200).send({
        success: true,
        dates: dates,
        matched: matched,
        now: now,
        usersWithMatchedChildren: usersWithMatchedChildren,
        fcmTokens: fcmTokens,
        response: response,
    });
  } catch (error) {
    logger.error("Error sending notifications", { error });
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});



exports.sharedEventReminderNotification = onRequest(async (req, res) => {
  try {
     const now = new Date();
    const shared_event_snapshot = await admin.firestore().collection("shared_event").get();
     const allSharedEventImpData = [];
      const matched = [];
     shared_event_snapshot.forEach((doc) => {
          const userData = doc.data();
          const assigned_to = userData.assigned_to || [];
          const created_by = userData.created_by;
          const start_time = userData.start_time;
          const end_time = userData.end_time;
          const selectedDate = userData.date;
          const eventDate = selectedDate?.toDate?.();
          const eventStartTime = start_time?.toDate?.();
          const istOffset = 5.5 * 60 * 60 * 1000; // +5:30 hours
          const eventDateIST = new Date(eventDate.getTime() + istOffset);
          const eventStartTimeIST = new Date(eventStartTime.getTime() + istOffset);
          const nowInIst = new Date(now.getTime() + istOffset);
          if (eventDateIST.getDate() === nowInIst.getDate() &&
                eventDateIST.getMonth() === nowInIst.getMonth() &&
                eventStartTimeIST.getHours() === nowInIst.getHours() &&
                eventStartTimeIST.getMinutes() === nowInIst.getMinutes()) {
                    matched.push(...assigned_to);
                    matched.push(created_by);
                }

          allSharedEventImpData.push({
             created_by: created_by,
             assigned_to: assigned_to,
             eventDate: eventDate,
             eventStartTime: eventStartTime,
             now:nowInIst,
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
          fcmTokens.push(userData.fcm_token)
        });
        const uniqueFcmTokens = [...new Set(fcmTokens)];
        if (uniqueFcmTokens.length === 0) {
             return res.status(200).send({message: "No valid FCM tokens found"});
        }
        const message = {
              tokens: uniqueFcmTokens,
              notification: {
                title: "Shared Event Notification",
                body: "Shared Event Notification",
              },
              data: {},
              android: {
                priority: "high",
                notification: {
                  sound: "default",
                },
              },
              apns: {
                payload: {
                  aps: {
                    sound: "default",
                  },
                },
              },
            };
     const response = await admin.messaging().sendEachForMulticast(message);
     return res.status(200).send({
        success: true,
        response: response,
        allSharedEventImpData: allSharedEventImpData,
        fcmTokens: uniqueFcmTokens,
    });
  } catch (error) {
    logger.error("Error sending notifications", { error });
    return res.status(500).send({
      success: false,
      error: error.message,
    });
  }
});