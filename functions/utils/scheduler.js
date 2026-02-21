const {CloudTasksClient} = require("@google-cloud/tasks");
const logger = require("firebase-functions/logger");

const client = new CloudTasksClient();

/** Region where Cloud Functions and the queue live (must match). */
const LOCATION = "us-central1";

/** Cloud Tasks queue used for scheduled notifications. */
const QUEUE_NAME = "notification-queue";

/**
 * Returns config for scheduling notification tasks.
 * Call from trigger context so GCLOUD_PROJECT is set.
 * @return {{projectId: string, location: string, queueName: string,
 *   functionUrl: string}}
 */
function getSchedulingConfig() {
  const projectId = process.env.GCLOUD_PROJECT;
  if (!projectId) {
    throw new Error("GCLOUD_PROJECT is not set");
  }
  return {
    projectId,
    location: LOCATION,
    queueName: QUEUE_NAME,
    functionUrl:
      `https://${LOCATION}-${projectId}.cloudfunctions.net/sendScheduledNotification`,
  };
}

/**
 * Sanitizes a string for use as Cloud Tasks task ID (letters, numbers, -, _).
 * @param {string} id - Raw id (e.g. childId or eventId).
 * @return {string} Sanitized id.
 */
function sanitizeTaskId(id) {
  return String(id).replace(/[^a-zA-Z0-9_-]/g, "_");
}

/**
 * Schedules a task in Google Cloud Tasks.
 * @param {string} project - The GCP project ID.
 * @param {string} location - The GCP location (e.g., 'us-central1').
 * @param {string} queue - The Cloud Tasks queue name.
 * @param {string} functionUrl - The URL of the worker function to call.
 * @param {object} payload - The JSON payload to send to the worker.
 * @param {number} scheduleTimeSeconds - The epoch timestamp (in seconds)
 * when the task should run.
 * @param {string} [taskId] - Optional task ID for deduplication. If provided
 * and a task with this ID already exists, create is skipped (avoids duplicate
 * notifications on document re-writes).
 */
async function scheduleTask(
    project, location, queue, functionUrl, payload, scheduleTimeSeconds,
    taskId = null) {
  const parent = client.queuePath(project, location, queue);

  const task = {
    httpRequest: {
      httpMethod: "POST",
      url: functionUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: Buffer.from(JSON.stringify(payload)).toString("base64"),
    },
    scheduleTime: {
      seconds: scheduleTimeSeconds,
    },
  };

  if (taskId) {
    const safeId = sanitizeTaskId(taskId);
    if (safeId.length > 0) {
      task.name = `${parent}/tasks/${safeId}`;
    }
  }

  try {
    const [response] = await client.createTask({parent, task});
    logger.info(`Started task ${response.name}`);
    return response.name;
  } catch (error) {
    const msg = error.message || "";
    const isAlreadyExists = error.code === 6 ||
      /ALREADY_EXISTS|already exists/i.test(msg);
    if (isAlreadyExists && taskId) {
      logger.info("Task already scheduled, skipping duplicate", {taskId});
      return null;
    }
    logger.error("Error scheduling task:", error);
    throw error;
  }
}

module.exports = {scheduleTask, getSchedulingConfig};
