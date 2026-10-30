/** Conversations older than this many days are removed from history. */
const CONVERSATION_RETENTION_DAYS = 90;

/**
 * @param {Date} createdAt
 * @param {Date} now
 * @param {number} [retentionDays]
 * @return {boolean}
 */
function isOlderThanRetentionDays(
    createdAt,
    now,
    retentionDays = CONVERSATION_RETENTION_DAYS,
) {
  if (!(createdAt instanceof Date) || Number.isNaN(createdAt.getTime())) {
    return false;
  }
  if (!(now instanceof Date) || Number.isNaN(now.getTime())) {
    return false;
  }
  const ms = retentionDays * 24 * 60 * 60 * 1000;
  return now.getTime() - createdAt.getTime() > ms;
}

module.exports = {
  CONVERSATION_RETENTION_DAYS,
  isOlderThanRetentionDays,
};
