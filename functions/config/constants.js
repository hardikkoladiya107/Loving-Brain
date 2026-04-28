/**
 * Shared constants for Cloud Functions.
 * Notification copy and limits used by notification controller and triggers.
 */

/** Max FCM tokens per multicast request (Google API limit). */
const FCM_MULTICAST_LIMIT = 500;

/** Default notification copy when no context is available. */
const NOTIFICATION_COPY = {
  /** Daily routine reminder. */
  ROUTINE: {
    TITLE: "Daily routine",
    BODY: "Time for your routine!",
    BODY_WITH_DESCRIPTION: "Reminder: {{description}}",
  },
  /** Shared event (co-parenting) reminder. */
  SHARED_EVENT: {
    TITLE: "Schedule reminder",
    BODY: "You have an event coming up.",
    BODY_WITH_TITLE: "Coming up: {{title}}",
  },
  /** Broadcast to all users (e.g. streak). */
  STREAK: {
    TITLE: "Streak update",
    BODY: "Don't forget to check in today to keep your streak alive!",
  },
  /** Energy Bridge fired reminder. */
  ENERGY_BRIDGE: {
    TITLE: "Energy Bridge",
    BODY: "Time to slow things down and begin a calming transition.",
  },
};

module.exports = {
  FCM_MULTICAST_LIMIT,
  NOTIFICATION_COPY,
};
