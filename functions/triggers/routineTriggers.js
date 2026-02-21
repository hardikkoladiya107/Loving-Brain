/**
 * Firestore trigger: when a child document is written, schedule a Cloud Task
 * for each future routine time. The task will call sendScheduledNotification
 * to push a reminder to users linked to that child.
 */
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const {scheduleTask, getSchedulingConfig} = require("../utils/scheduler");

exports.onRoutineWrite = onDocumentWritten("children/{childId}",
    async (event) => {
      if (!event.data) return;

      const childId = event.params.childId;
      const newData = event.data.after.data();
      if (!newData || !newData.routines || !newData.routines.length) return;

      const {projectId, location, queueName, functionUrl} =
        getSchedulingConfig();

      for (const routine of newData.routines) {
        const stamp = routine.time_stamp;
        if (!stamp || !stamp.toDate) continue;

        const routineTime = stamp.toDate();
        if (routineTime <= new Date()) continue;

        const scheduleTimeSeconds = Math.floor(routineTime.getTime() / 1000);
        const taskId = `rout_${childId}_${scheduleTimeSeconds}`;
        const description = routine.description || "";

        try {
          await scheduleTask(
              projectId,
              location,
              queueName,
              functionUrl,
              {
                type: "routine",
                childId,
                timestamp: scheduleTimeSeconds,
                description,
              },
              scheduleTimeSeconds,
              taskId,
          );
          logger.info("Scheduled routine notification", {childId});
        } catch (error) {
          logger.error("Failed to schedule routine", {childId, error});
        }
      }
    });
