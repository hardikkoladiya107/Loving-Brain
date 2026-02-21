/**
 * Firebase Cloud Functions – entry point.
 *
 * Exports:
 * - Triggers: onRoutineWrite, onSharedEventWrite (Firestore → Cloud Tasks)
 * - HTTP: sendScheduledNotification (Tasks → FCM), sendNotificationToAll,
 *   sendPushNotification
 *
 * See functions/README.md for folder structure and flow.
 */
const {
  sendScheduledNotification,
  sendNotificationToAll,
  sendPushNotification,
} = require("./controllers/notificationController");
const {onRoutineWrite} = require("./triggers/routineTriggers");
const {onSharedEventWrite} = require("./triggers/eventTriggers");

exports.sendScheduledNotification = sendScheduledNotification;
exports.sendNotificationToAll = sendNotificationToAll;
exports.sendPushNotification = sendPushNotification;
exports.onRoutineWrite = onRoutineWrite;
exports.onSharedEventWrite = onSharedEventWrite;
