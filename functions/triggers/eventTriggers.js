const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const {scheduleTask, getSchedulingConfig} = require("../utils/scheduler");

exports.onSharedEventWrite = onDocumentWritten("shared_event/{eventId}",
    async (event) => {
      if (!event.data) return;

      const eventId = event.params.eventId;
      const newData = event.data.after.data();
      const stamp = newData && newData.start_time;
      if (!stamp || !stamp.toDate) return;

      const startTime = stamp.toDate();
      if (startTime <= new Date()) return;

      const scheduleTimeSeconds = Math.floor(startTime.getTime() / 1000);
      const taskId = `evt_${eventId}_${scheduleTimeSeconds}`;
      const {projectId, location, queueName, functionUrl} =
        getSchedulingConfig();

      try {
        await scheduleTask(
            projectId,
            location,
            queueName,
            functionUrl,
            {
              type: "shared_event",
              docId: eventId,
              timestamp: scheduleTimeSeconds,
            },
            scheduleTimeSeconds,
            taskId,
        );
        logger.info("Scheduled shared event notification", {eventId});
      } catch (error) {
        logger.error("Failed to schedule shared event", {eventId, error});
      }
    });
