const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const {
  isInvalidTokenError,
  clearInvalidToken,
} = require("./services/notificationDelivery");

/**
 * FCM data payloads must be string key/value pairs.
 * @param {object} data - Raw data payload.
 * @return {object} Stringified data payload.
 */
function stringifyDataPayload(data = {}) {
  const stringified = {};
  for (const [key, value] of Object.entries(data)) {
    if (value !== undefined && value !== null) {
      stringified[key] = String(value);
    }
  }
  return stringified;
}

/**
 * Builds APNS config for iOS delivery.
 * @param {string} title - Notification title.
 * @param {string} body - Notification body.
 * @return {object} APNS config block.
 */
function buildApnsConfig(title, body) {
  return {
    headers: {
      "apns-priority": "10",
    },
    payload: {
      aps: {
        alert: {
          title,
          body,
        },
        sound: "default",
      },
    },
  };
}

/**
 * Sends a single notification to a specific token.
 * @param {string} token - The FCM registration token.
 * @param {string} title - The notification title.
 * @param {string} body - The notification body.
 * @param {object} data - Optional data payload.
 * @return {Promise<object>} - Result of the operation.
 */
async function sendNotification(token, title, body, data = {}) {
  if (!token || !title || !body) {
    throw new Error("Missing required parameters: token, title, body");
  }

  const message = {
    token,
    notification: {
      title,
      body,
    },
    data: stringifyDataPayload(data),
    android: {
      priority: "high",
    },
    apns: buildApnsConfig(title, body),
  };

  try {
    const response = await admin.messaging().send(message);
    logger.info("✅ Notification sent successfully:", {response});
    return {success: true, response};
  } catch (error) {
    logger.error("❌ Error sending notification:", {error});
    if (isInvalidTokenError(error)) {
      try {
        await clearInvalidToken(admin.firestore(), token);
      } catch (cleanupError) {
        logger.error("Failed to clear invalid FCM token", {cleanupError});
      }
    }
    return {success: false, error};
  }
}

/**
 * Sends a multicast notification to multiple tokens.
 * @param {string[]} tokens - Array of FCM registration tokens.
 * @param {string} title - The notification title.
 * @param {string} body - The notification body.
 * @param {object} data - Optional data payload.
 * @return {Promise<object>} - Result of the operation.
 */
async function sendMulticastNotification(tokens, title, body, data = {}) {
  if (!tokens || !tokens.length || !title || !body) {
    if (tokens && tokens.length === 0) {
      return {success: true, successCount: 0, failureCount: 0};
    }
    throw new Error("Missing required parameters: tokens, title, body");
  }

  const message = {
    tokens,
    notification: {
      title,
      body,
    },
    data: stringifyDataPayload(data),
    android: {
      priority: "high",
      notification: {
        sound: "default",
      },
    },
    apns: buildApnsConfig(title, body),
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    if (Array.isArray(response.responses)) {
      for (let index = 0; index < response.responses.length; index++) {
        const item = response.responses[index];
        if (!item.success && isInvalidTokenError(item.error)) {
          try {
            await clearInvalidToken(admin.firestore(), tokens[index]);
          } catch (cleanupError) {
            logger.error("Failed to clear invalid FCM token", {cleanupError});
          }
        }
      }
    }
    logger.info("✅ Multicast notification sent successfully:", {
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
      responses: response.responses,
    };
  } catch (error) {
    // If error is strictly about the sending failure
    logger.error("❌ Error sending multicast notification:", {error});
    return {success: false, error};
  }
}

module.exports = {sendNotification, sendMulticastNotification};
