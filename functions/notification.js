

const admin = require("firebase-admin");


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
    data: {
      ...data, // attach custom data if needed
    },
    android: {
      priority: "high",
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
        },
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("✅ Notification sent successfully:", response);
    return { success: true, response };
  } catch (error) {
    console.error("❌ Error sending notification:", error);
    return { success: false, error };
  }
}

module.exports = { sendNotification };
