/**
 * Firebase Cloud Functions entry point.
 * Scheduling: onRoutineWrite / onSharedEventWrite schedule tasks;
 * sendScheduledNotification is the HTTP target for those tasks.
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
