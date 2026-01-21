const {CloudTasksClient} = require("@google-cloud/tasks");
const logger = require("firebase-functions/logger");

const client = new CloudTasksClient();

/**
 * Schedules a task in Google Cloud Tasks.
 * @param {string} project - The GCP project ID.
 * @param {string} location - The GCP location (e.g., 'us-central1').
 * @param {string} queue - The Cloud Tasks queue name.
 * @param {string} functionUrl - The URL of the worker function to call.
 * @param {object} payload - The JSON payload to send to the worker.
 * @param {number} scheduleTimeSeconds - The epoch timestamp (in seconds)
 * when the task should run.
 */
async function scheduleTask(
    project, location, queue, functionUrl, payload, scheduleTimeSeconds) {
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

  try {
    const [response] = await client.createTask({parent, task});
    logger.info(`Started task ${response.name}`);
    return response.name;
  } catch (error) {
    logger.error("Error scheduling task:", error);
    throw error;
  }
}

module.exports = {scheduleTask};
