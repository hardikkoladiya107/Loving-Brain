const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const {scheduleTask} = require("../utils/scheduler");

// Configuration - Ideally these should be environment variables
const PROJECT_ID = process.env.GCLOUD_PROJECT;
// Adjust if your functions are in a different region
const LOCATION = "us-central1";
const QUEUE_NAME = "notification-queue";
// eslint-disable-next-line max-len
const FUNCTION_URL = `https://${LOCATION}-${PROJECT_ID}.cloudfunctions.net/sendScheduledNotification`;

exports.onRoutineWrite = onDocumentWritten("children/{childId}",
    async (event) => {
      if (!event.data) return; // Deleted

      const childId = event.params.childId;
      const newData = event.data.after.data();

      if (!newData || !newData.routines) return;

      const routines = newData.routines;

      for (const routine of routines) {
        if (routine.time_stamp && routine.time_stamp.toDate) {
          const routineTime = routine.time_stamp.toDate();
          const now = new Date();

          if (routineTime > now) {
            // Schedule if in the future
            const scheduleTimeSeconds = Math.floor(
                routineTime.getTime() / 1000,
            );

            try {
              await scheduleTask(
                  PROJECT_ID,
                  LOCATION,
                  QUEUE_NAME,
                  FUNCTION_URL,
                  {
                    type: "routine",
                    childId: childId,
                    timestamp: scheduleTimeSeconds,
                  },
                  scheduleTimeSeconds,
              );
              logger.info(
                  `Scheduled routine notification for child ${childId}`,
              );
            } catch (error) {
              logger.error("Failed to schedule routine", error);
            }
          }
        }
      }
    });
