/**
 * Decides whether a server push may be delivered.
 * Quiet hours use the parent's IANA timezone when the profile has one.
 */

const admin = require("firebase-admin");

const DEFAULT_PREFS = {
  sleepReminders: true,
  checkInReminders: true,
  mentorshipUpdates: false,
  weeklyReview: true,
  quietHoursStart: "21:00",
  quietHoursEnd: "07:00",
  maxDailyCap: 3,
};

const INVALID_TOKEN_CODES = new Set([
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
  "messaging/invalid-argument",
]);

/**
 * @param {string} raw
 * @param {string} fallback
 * @return {{hour: number, minute: number}}
 */
function parseClock(raw, fallback) {
  const source = (raw || fallback || "").toString().trim().toLowerCase();
  const hasAm = source.includes("am");
  const hasPm = source.includes("pm");
  const numeric = source.replace(/am|pm/g, "").trim();
  const parts = numeric.split(":");
  if (parts.length < 2) {
    return parseClock(fallback, "00:00");
  }
  let hour = Number.parseInt(parts[0], 10);
  const minute = Number.parseInt(parts[1].replace(/[^0-9]/g, ""), 10);
  if (Number.isNaN(hour) || Number.isNaN(minute)) {
    if (fallback && raw !== fallback) {
      return parseClock(fallback, "00:00");
    }
    return {hour: 21, minute: 0};
  }
  if (hasPm && hour < 12) hour += 12;
  if (hasAm && hour === 12) hour = 0;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    return parseClock(fallback, "00:00");
  }
  return {hour, minute};
}

/**
 * @param {Date} date
 * @param {string} timeZone
 * @return {{hour: number, minute: number, dayKey: string}}
 */
function zonedParts(date, timeZone) {
  const zone = timeZone && timeZone.trim() ? timeZone.trim() : "UTC";
  try {
    const fmt = new Intl.DateTimeFormat("en-US", {
      timeZone: zone,
      hour: "2-digit",
      minute: "2-digit",
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hourCycle: "h23",
    });
    const mapped = {};
    for (const part of fmt.formatToParts(date)) {
      mapped[part.type] = part.value;
    }
    return {
      hour: Number(mapped.hour),
      minute: Number(mapped.minute),
      dayKey: `${mapped.year}-${mapped.month}-${mapped.day}`,
    };
  } catch (error) {
    if (zone !== "UTC") {
      return zonedParts(date, "UTC");
    }
    throw error;
  }
}

/**
 * @param {object} userData
 * @return {object}
 */
function readPrefs(userData) {
  const raw = userData && userData.notification_preferences;
  const source = raw && typeof raw === "object" ? raw : {};
  const cap = Number(source.maxDailyCap);
  return {
    sleepReminders: source.sleepReminders !== false,
    checkInReminders: source.checkInReminders !== false,
    mentorshipUpdates: source.mentorshipUpdates === true,
    weeklyReview: source.weeklyReview !== false,
    quietHoursStart: source.quietHoursStart ||
      DEFAULT_PREFS.quietHoursStart,
    quietHoursEnd: source.quietHoursEnd || DEFAULT_PREFS.quietHoursEnd,
    maxDailyCap: Number.isFinite(cap) && cap > 0 ?
      cap :
      DEFAULT_PREFS.maxDailyCap,
  };
}

/**
 * @param {object} userData
 * @return {string}
 */
function readTimeZone(userData) {
  const location = userData &&
    (userData.location_data || userData.locationData);
  const zone = location && location.timezone;
  if (typeof zone === "string" && zone.trim()) {
    return zone.trim();
  }
  return "UTC";
}

/**
 * @param {object} prefs
 * @param {number} hour
 * @param {number} minute
 * @return {boolean}
 */
function isInsideQuietHours(prefs, hour, minute) {
  const start = parseClock(prefs.quietHoursStart, "21:00");
  const end = parseClock(prefs.quietHoursEnd, "07:00");
  const current = hour * 60 + minute;
  const startMinutes = start.hour * 60 + start.minute;
  const endMinutes = end.hour * 60 + end.minute;
  if (startMinutes > endMinutes) {
    return current >= startMinutes || current < endMinutes;
  }
  return current >= startMinutes && current < endMinutes;
}

/**
 * @param {object} prefs
 * @param {string} kind
 * @return {boolean}
 */
function categoryAllowed(prefs, kind) {
  switch ((kind || "").toLowerCase()) {
    case "routine":
    case "sleep":
    case "wind_down":
      return prefs.sleepReminders;
    case "energy_bridge":
    case "check_in":
    case "gentle_check_in":
    case "calm":
    case "calm_heads_up":
      return prefs.checkInReminders;
    case "mentorship":
    case "session":
      return prefs.mentorshipUpdates;
    case "weekly_review":
      return prefs.weeklyReview;
    case "shared_event":
    case "co_parent_invitation":
    case "announcement":
      return true;
    default:
      return true;
  }
}

/**
 * @param {object} userData
 * @param {string} kind
 * @param {Date} now
 * @return {{allow: boolean, reason: string, prefs: object,
 *   dayKey: string, timeZone: string}}
 */
function evaluateDelivery(userData, kind, now) {
  const data = userData || {};
  if (data.is_notification === false) {
    return {
      allow: false,
      reason: "notifications_disabled",
      prefs: readPrefs(data),
      dayKey: "",
      timeZone: "UTC",
    };
  }
  const prefs = readPrefs(data);
  const timeZone = readTimeZone(data);
  const zoned = zonedParts(now, timeZone);
  if (!categoryAllowed(prefs, kind)) {
    return {
      allow: false,
      reason: "toggle_off",
      prefs,
      dayKey: zoned.dayKey,
      timeZone,
    };
  }
  if (isInsideQuietHours(prefs, zoned.hour, zoned.minute)) {
    return {
      allow: false,
      reason: "quiet_hours",
      prefs,
      dayKey: zoned.dayKey,
      timeZone,
    };
  }
  const sameDay = data.notification_sent_day === zoned.dayKey;
  const count = sameDay ? Number(data.notification_sent_count || 0) : 0;
  if (count >= prefs.maxDailyCap) {
    return {
      allow: false,
      reason: "daily_cap",
      prefs,
      dayKey: zoned.dayKey,
      timeZone,
    };
  }
  return {
    allow: true,
    reason: "ok",
    prefs,
    dayKey: zoned.dayKey,
    timeZone,
  };
}

/**
 * @param {object} error
 * @return {boolean}
 */
function isInvalidTokenError(error) {
  const code = error && (error.code || error.errorInfo && error.errorInfo.code);
  return INVALID_TOKEN_CODES.has(code);
}

/**
 * Removes a dead device token from every user that still stores it.
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} token
 * @return {Promise<void>}
 */
async function clearInvalidToken(db, token) {
  if (!db || !token) return;
  const snap = await db.collection("users")
      .where("fcm_token", "==", token)
      .get();
  for (const doc of snap.docs) {
    await doc.ref.update({
      fcm_token: admin.firestore.FieldValue.delete(),
    });
  }
}

/**
 * Reserves one shared daily slot. Returns false when the cap is already full.
 * @param {FirebaseFirestore.DocumentReference} ref
 * @param {object} userData
 * @param {object} decision
 * @return {Promise<boolean>}
 */
async function claimDailySlot(ref, userData, decision) {
  if (!ref || typeof ref.update !== "function") {
    return true;
  }
  const currentDay = (userData && userData.notification_sent_day) || "";
  const currentCount = currentDay === decision.dayKey ?
    Number(userData.notification_sent_count || 0) :
    0;
  if (currentCount >= decision.prefs.maxDailyCap) {
    return false;
  }
  await ref.update({
    notification_sent_day: decision.dayKey,
    notification_sent_count: currentCount + 1,
  });
  return true;
}

module.exports = {
  evaluateDelivery,
  isInvalidTokenError,
  clearInvalidToken,
  claimDailySlot,
  selectDeliverableTokens,
  readPrefs,
  zonedParts,
};

/**
 * Filters user documents by toggle, quiet hours, and the shared daily cap.
 * Claims a slot for each user that will actually be notified.
 * @param {FirebaseFirestore.QueryDocumentSnapshot[]} docs
 * @param {string} kind
 * @param {Date} now
 * @return {Promise<string[]>}
 */
async function selectDeliverableTokens(docs, kind, now) {
  const tokens = [];
  for (const doc of docs) {
    const data = typeof doc.data === "function" ? doc.data() || {} : {};
    const decision = evaluateDelivery(data, kind, now);
    if (!decision.allow) continue;
    const claimed = await claimDailySlot(doc.ref, data, decision);
    if (!claimed) continue;
    const token = data.fcm_token;
    if (typeof token === "string" && token.trim()) {
      tokens.push(token.trim());
    }
  }
  return [...new Set(tokens)];
}
