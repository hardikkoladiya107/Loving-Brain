const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const {scheduleTask} = require("../utils/scheduler");

// Configuration
const PROJECT_ID = process.env.GCLOUD_PROJECT;
// Adjust if your functions are in a different region
const LOCATION = "us-central1";
const QUEUE_NAME = "notification-queue";
// eslint-disable-next-line max-len
const FUNCTION_URL = `https://${LOCATION}-${PROJECT_ID}.cloudfunctions.net/sendScheduledNotification`;

exports.onSharedEventWrite = onDocumentWritten("shared_event/{eventId}",
    async (event) => {
      if (!event.data) return; // Deleted

      const eventId = event.params.eventId;
      const newData = event.data.after.data();

      if (!newData || !newData.start_time) return;

      if (newData.start_time && newData.start_time.toDate) {
        const startTime = newData.start_time.toDate();
        const now = new Date();

        if (startTime > now) {
          const scheduleTimeSeconds = Math.floor(startTime.getTime() / 1000);

          try {
            await scheduleTask(
                PROJECT_ID,
                LOCATION,
                QUEUE_NAME,
                FUNCTION_URL,
                {
                  type: "shared_event",
                  docId: eventId,
                  timestamp: scheduleTimeSeconds,
                },
                scheduleTimeSeconds,
            );
            logger.info(`Scheduled shared event notification for ${eventId}`);
          } catch (error) {
            logger.error("Failed to schedule shared event", error);
          }
        }
      }
    });
