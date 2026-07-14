/**
 * Firestore trigger: when energy_bridge/{childId} is written with an active
 * timer, schedule a Cloud Task at fire_at. The worker sets fired=true so
 * onEnergyBridgeWrite can push to both parents even when the app is closed.
 */
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const {scheduleTask, getSchedulingConfig} = require("../utils/scheduler");

exports.onEnergyBridgeSchedule = onDocumentWritten(
    "energy_bridge/{childId}",
    async (event) => {
      if (!event.data) return;

      const childId = event.params.childId;
      const afterData = event.data.after.data() || {};

      if (!afterData.is_active || afterData.fired === true) {
        return;
      }

      const fireAt = afterData.fire_at;
      if (!fireAt || typeof fireAt.toDate !== "function") {
        return;
      }

      const fireDate = fireAt.toDate();
      if (fireDate <= new Date()) {
        return;
      }

      const scheduleTimeSeconds = Math.floor(fireDate.getTime() / 1000);
      const taskId = `eb_${childId}`;

      try {
        const {projectId, location, queueName, functionUrl} =
          getSchedulingConfig();
        await scheduleTask(
            projectId,
            location,
            queueName,
            functionUrl,
            {
              type: "energy_bridge",
              childId,
            },
            scheduleTimeSeconds,
            taskId,
        );
        logger.info("Scheduled energy bridge fire task", {childId, taskId});
      } catch (error) {
        logger.error("Failed to schedule energy bridge task", {childId, error});
      }
    },
);
