/**
 * Import function triggers from their respective submodules
 * and export them to the entry point.
 */
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Controllers
const {
  sendScheduledNotification,
  sendNotificationToAll,
  sendPushNotification,
} = require("./controllers/notificationController");

// Triggers
const {onRoutineWrite} = require("./triggers/routineTriggers");
const {onSharedEventWrite} = require("./triggers/eventTriggers");

// Exports
exports.sendScheduledNotification = sendScheduledNotification;
exports.sendNotificationToAll = sendNotificationToAll;
exports.sendPushNotification = sendPushNotification;
exports.onRoutineWrite = onRoutineWrite;
exports.onSharedEventWrite = onSharedEventWrite;

// Sample tests (keeping these as they were in the original file)
exports.sampleTest = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase! Test");
});

exports.sampleTest2 = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase! Test");
});
