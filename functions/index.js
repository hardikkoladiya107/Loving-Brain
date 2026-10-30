/**
 * Firebase Cloud Functions â€“ entry point.
 *
 * Exports:
 * - Triggers: onRoutineWrite, onSharedEventWrite (Firestore â†’ Cloud Tasks)
 * - HTTP: sendScheduledNotification (Tasks â†’ FCM), sendNotificationToAll,
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
const {onEnergyBridgeWrite} = require("./triggers/energyBridgeTriggers");
const {onEnergyBridgeSchedule} = require(
    "./triggers/energyBridgeSchedulerTriggers",
);
const {onUserDelete} = require("./triggers/userTriggers");
const {
  sendEmailOtp,
  verifyEmailOtp,
  sendInvitationEmail,
  resolveAuthIdentity,
} = require("./controllers/authController");
const {
  brainyChat,
  transcribeAudio,
  purgeExpiredBrainyConversations,
} = require("./controllers/brainyController");
const {
  createCoParentInvitation,
  getInvitationPreview,
  acceptInvitation,
  rejectInvitation,
  cancelInvitation,
  revokeCaregiver,
  leaveChild,
  removeChild,
  deleteMyAccount,
  resendInvitationEmail,
} = require("./controllers/familyController");

exports.sendScheduledNotification = sendScheduledNotification;
exports.sendNotificationToAll = sendNotificationToAll;
exports.sendPushNotification = sendPushNotification;
exports.onRoutineWrite = onRoutineWrite;
exports.onSharedEventWrite = onSharedEventWrite;
exports.onEnergyBridgeWrite = onEnergyBridgeWrite;
exports.onEnergyBridgeSchedule = onEnergyBridgeSchedule;
exports.onUserDelete = onUserDelete;
exports.sendEmailOtp = sendEmailOtp;
exports.verifyEmailOtp = verifyEmailOtp;
exports.sendInvitationEmail = sendInvitationEmail;
exports.resolveAuthIdentity = resolveAuthIdentity;
exports.brainyChat = brainyChat;
exports.transcribeAudio = transcribeAudio;
exports.purgeExpiredBrainyConversations = purgeExpiredBrainyConversations;
exports.createCoParentInvitation = createCoParentInvitation;
exports.getInvitationPreview = getInvitationPreview;
exports.acceptInvitation = acceptInvitation;
exports.rejectInvitation = rejectInvitation;
exports.cancelInvitation = cancelInvitation;
exports.revokeCaregiver = revokeCaregiver;
exports.leaveChild = leaveChild;
exports.removeChild = removeChild;
exports.deleteMyAccount = deleteMyAccount;
exports.resendInvitationEmail = resendInvitationEmail;

