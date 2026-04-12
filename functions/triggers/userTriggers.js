/**
 * Firestore trigger: when a user document is deleted from the 'users' collection,
 * delete the corresponding user from Firebase Authentication.
 */
const {onDocumentDeleted} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

if (!admin.apps.length) admin.initializeApp();

exports.onUserDelete = onDocumentDeleted("users/{userId}", async (event) => {
  const userId = event.params.userId;
  try {
    await admin.auth().deleteUser(userId);
    logger.info(`Successfully deleted Auth user for document ID: ${userId}`);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      logger.info(`Auth user ${userId} not found or already deleted.`);
    } else {
      logger.error(`Error deleting Auth user ${userId}`, error);
    }
  }
});
