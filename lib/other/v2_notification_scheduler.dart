import 'package:intl/intl.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';

/// Unified V2 Notification Engine implementing the 8 specification types,
/// daily cap (max 3/day), quiet hours (9pm–7am), and cancel-on-complete rules
/// (v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md, 06_APP_STATES_EDGE_CASES.md §8).
class V2NotificationScheduler {
  V2NotificationScheduler._();

  static const String _consecutiveEmptyDaysKey =
      'v2_consecutive_empty_days_checkin';
  static const String _emptyDayLastIncrementKey =
      'v2_empty_day_last_increment_date';
  static const String _mentorshipTrackedIdsKey =
      'v2_mentorship_tracked_session_ids';
  static const String _reservedIdsPrefix = 'v2_notif_reserved_';

  /// Stable Notification ID prefixes for each of the 8 notification types
  static const int idPrefixSleepWindow = 100000;
  static const int idPrefixSleepEstimateChanged = 200000;
  static const int idPrefixCalmHeadsUp = 300000;
  static const int idPrefixGentleCheckIn = 400000;
  static const int idPrefixWeeklyReview = 500000;
  static const int idPrefixMentorshipBooking = 600000;
  static const int idPrefixMentorshipReminder24h = 700000;
  static const int idPrefixMentorshipReminder1h = 750000;
  static const int idPrefixWaitlistAvailability = 800000;

  static const int weeklyReviewNotificationId = idPrefixWeeklyReview + 1;

  static int notificationId(int prefix, String entityId) {
    return prefix + (entityId.hashCode.abs() % 99999);
  }

  static NotificationPreferencesModel loadPreferences() {
    final Map<String, dynamic>? rawPrefs = preferences
        .getNotificationPreferences();
    if (rawPrefs != null) {
      return NotificationPreferencesModel.fromJson(rawPrefs);
    }
    return NotificationPreferencesModel.defaultPreferences();
  }

  /// Returns count of notifications planned/delivered on a specific date (Doc 03 §1)
  static int getCountForDate(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    return preferences.getInt('v2_notif_count_$dateStr') ?? 0;
  }

  /// Increments the planned/delivered count for a specific date
  static void incrementCountForDate(DateTime date) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    final int current = getCountForDate(date);
    preferences.putInt('v2_notif_count_$dateStr', current + 1);
  }

  static String _reservedKey(DateTime date) {
    return '$_reservedIdsPrefix${DateFormat('yyyy-MM-dd').format(date)}';
  }

  static bool isIdReservedForDate(int notificationId, DateTime date) {
    final List<String> reserved =
        preferences.getStringList(_reservedKey(date)) ?? <String>[];
    return reserved.contains(notificationId.toString());
  }

  /// Reserves one daily-cap slot for [notificationId] on [date].
  /// Replacing the same id on the same day does not increment again.
  static bool reserveCapSlotIfNeeded({
    required int notificationId,
    required DateTime date,
  }) {
    if (isIdReservedForDate(notificationId, date)) {
      return true;
    }
    final List<String> reserved =
        preferences.getStringList(_reservedKey(date)) ?? <String>[];
    reserved.add(notificationId.toString());
    preferences.putStringList(_reservedKey(date), reserved);
    incrementCountForDate(date);
    return true;
  }

  /// Returns the count of notifications delivered today
  static int getDeliveredTodayCount() {
    return getCountForDate(DateTime.now());
  }

  /// Records that a notification was dispatched
  static void recordDelivery({int? notificationId}) {
    final DateTime now = DateTime.now();
    if (notificationId != null) {
      reserveCapSlotIfNeeded(notificationId: notificationId, date: now);
      return;
    }
    incrementCountForDate(now);
  }

  /// Stores sent notification event in history
  static void recordSent({
    required String type,
    required String title,
    String? payload,
  }) {
    try {
      final List<String> list =
          preferences.getStringList('v2_notif_sent_log') ?? <String>[];
      final String entry =
          '${DateTime.now().toIso8601String()}|$type|$title|${payload ?? ""}';
      list.add(entry);
      if (list.length > 100) {
        list.removeRange(0, list.length - 100);
      }
      preferences.putStringList('v2_notif_sent_log', list);
    } catch (_) {}
  }

  /// Stores opened notification event in history
  static void recordOpened(String payload) {
    try {
      final List<String> list =
          preferences.getStringList('v2_notif_opened_log') ?? <String>[];
      final String entry = '${DateTime.now().toIso8601String()}|$payload';
      list.add(entry);
      if (list.length > 100) {
        list.removeRange(0, list.length - 100);
      }
      preferences.putStringList('v2_notif_opened_log', list);
    } catch (_) {}
  }

  /// Tracks consecutive empty days without user logs for gentle check-in
  static int getConsecutiveEmptyDays() {
    return preferences.getInt(_consecutiveEmptyDaysKey) ?? 0;
  }

  static void resetConsecutiveEmptyDays() {
    preferences.putInt(_consecutiveEmptyDaysKey, 0);
    preferences.putString(_emptyDayLastIncrementKey, '');
  }

  /// Increments the empty-day counter at most once per calendar date.
  static void incrementConsecutiveEmptyDays({DateTime? forDate}) {
    final DateTime day = forDate ?? DateTime.now();
    final String dateStr = DateFormat('yyyy-MM-dd').format(day);
    final String? last = preferences.getString(_emptyDayLastIncrementKey);
    if (last == dateStr) {
      return;
    }
    preferences.putString(_emptyDayLastIncrementKey, dateStr);
    final int current = getConsecutiveEmptyDays();
    preferences.putInt(_consecutiveEmptyDaysKey, current + 1);
  }

  static void trackMentorshipSession(String sessionId) {
    if (sessionId.isEmpty) {
      return;
    }
    final List<String> ids =
        preferences.getStringList(_mentorshipTrackedIdsKey) ?? <String>[];
    if (!ids.contains(sessionId)) {
      ids.add(sessionId);
      preferences.putStringList(_mentorshipTrackedIdsKey, ids);
    }
  }

  static List<String> trackedMentorshipSessionIds() {
    return preferences.getStringList(_mentorshipTrackedIdsKey) ?? <String>[];
  }

  static Future<void> cancelAllTrackedMentorshipNotifications() async {
    final List<String> ids = trackedMentorshipSessionIds();
    for (final String sessionId in ids) {
      await cancelMentorshipReminders(sessionId);
      await NotificationUtil.cancelNotification(
        notificationId(idPrefixMentorshipBooking, sessionId),
      );
    }
    preferences.putStringList(_mentorshipTrackedIdsKey, <String>[]);
  }

  /// Checks if a notification can be scheduled/sent according to caps and quiet hours on target day
  static bool canSendNotification({
    required String type,
    required DateTime targetTime,
    bool bypassQuietHours = false,
    int? notificationId,
  }) {
    final NotificationPreferencesModel prefs = loadPreferences();

    final bool alreadyCounted =
        notificationId != null &&
        isIdReservedForDate(notificationId, targetTime);
    final int countOnTargetDay = getCountForDate(targetTime);
    if (!prefs.isNotificationAllowed(
      type: type,
      deliveredTodayCount: countOnTargetDay,
      alreadyCountedForId: alreadyCounted,
    )) {
      return false;
    }

    if (!bypassQuietHours && prefs.isInsideQuietHours(targetTime)) {
      return false;
    }

    return true;
  }

  // 1. Sleep window approaching (20-30m before wind-down, confidence >= moderate)
  // When [userDefinedNotifyTime] is set, schedule at that clock instead of wind-down - 25m.
  static Future<bool> scheduleSleepWindow({
    required String childId,
    required String childName,
    required DateTime windDownStart,
    DateTime? userDefinedNotifyTime,
  }) async {
    final bool isUserDefined = userDefinedNotifyTime != null;
    final DateTime notifyTime =
        userDefinedNotifyTime ??
        windDownStart.subtract(const Duration(minutes: 25));
    if (notifyTime.isBefore(DateTime.now())) {
      return false;
    }

    final int id = notificationId(idPrefixSleepWindow, childId);
    if (!canSendNotification(
      type: 'sleep',
      targetTime: notifyTime,
      bypassQuietHours: isUserDefined,
      notificationId: id,
    )) {
      return false;
    }

    final String timeStr = DateFormat('h:mm a').format(windDownStart);
    final bool scheduled = await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Sleep Window',
      body: 'Wind-down may start around $timeStr tonight for $childName.',
      payload: 'sleep_window',
      scheduledDate: notifyTime,
    );
    if (!scheduled) {
      return false;
    }
    reserveCapSlotIfNeeded(notificationId: id, date: notifyTime);
    recordSent(
      type: 'sleep',
      title: 'LovingBrain · Sleep Window',
      payload: 'sleep_window',
    );
    return true;
  }

  // Cancel sleep window when parent already logged sleep
  static Future<void> cancelSleepWindow(String childId) async {
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixSleepWindow, childId),
    );
  }

  // 2. Sleep estimate changed (meaningful shift >=15m)
  static Future<bool> notifySleepEstimateChanged({
    required String childId,
    required String childName,
    required String newBedtime,
  }) async {
    final DateTime now = DateTime.now();
    final int id = notificationId(idPrefixSleepEstimateChanged, childId);
    if (!canSendNotification(
      type: 'sleep',
      targetTime: now,
      notificationId: id,
    )) {
      return false;
    }

    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Sleep Plan Updated',
      body:
          'Today\'s rest moved $childName\'s bedtime estimate to $newBedtime.',
      payload: 'sleep_estimate_changed',
    );
    recordDelivery(notificationId: id);
    recordSent(
      type: 'sleep',
      title: 'LovingBrain · Sleep Plan Updated',
      payload: 'sleep_estimate_changed',
    );
    return true;
  }

  // 3. Calm Heads-Up (30-60 min before harder window, signals >= 2)
  static Future<bool> scheduleCalmHeadsUp({
    required String childId,
    required String childName,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) async {
    final DateTime notifyTime = windowStart.subtract(
      const Duration(minutes: 45),
    );
    if (notifyTime.isBefore(DateTime.now())) {
      return false;
    }

    final int id = notificationId(idPrefixCalmHeadsUp, childId);
    if (!canSendNotification(
      type: 'calm',
      targetTime: notifyTime,
      notificationId: id,
    )) {
      return false;
    }

    final String startStr = DateFormat('h:mm a').format(windowStart);
    final String endStr = DateFormat('h:mm a').format(windowEnd);
    final bool scheduled = await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Calm Heads-Up',
      body:
          'A harder window may be more likely around $startStr–$endStr. Here’s what may help.',
      payload: 'calm_heads_up',
      scheduledDate: notifyTime,
    );
    if (!scheduled) {
      return false;
    }
    reserveCapSlotIfNeeded(notificationId: id, date: notifyTime);
    recordSent(
      type: 'calm',
      title: 'LovingBrain · Calm Heads-Up',
      payload: 'calm_heads_up',
    );
    return true;
  }

  // Cancel Calm Heads-Up when parent already opened calm plan
  static Future<void> cancelCalmHeadsUp(String childId) async {
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixCalmHeadsUp, childId),
    );
  }

  // 4. Gentle check-in (user-selected time or ~8:30 PM if no logs today)
  static Future<bool> scheduleGentleCheckIn({
    required String childId,
    required DateTime checkInTime,
    required bool hasLogsToday,
  }) async {
    if (hasLogsToday) {
      await cancelGentleCheckIn(childId);
      return false;
    }

    // Stop gentle check-in after a short run of 3 empty days without logs (Doc 03 §4)
    if (getConsecutiveEmptyDays() >= 3) {
      return false;
    }

    if (checkInTime.isBefore(DateTime.now())) {
      return false;
    }

    final int id = notificationId(idPrefixGentleCheckIn, childId);
    if (!canSendNotification(
      type: 'check_in',
      targetTime: checkInTime,
      notificationId: id,
    )) {
      return false;
    }

    final bool scheduled = await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Quick Update',
      body: 'One quick update can help us understand today better.',
      payload: 'gentle_check_in',
      scheduledDate: checkInTime,
    );
    if (!scheduled) {
      return false;
    }
    reserveCapSlotIfNeeded(notificationId: id, date: checkInTime);
    incrementConsecutiveEmptyDays(forDate: checkInTime);
    recordSent(
      type: 'check_in',
      title: 'LovingBrain · Quick Update',
      payload: 'gentle_check_in',
    );
    return true;
  }

  static Future<void> cancelGentleCheckIn(
    String childId, {
    bool resetEmptyDays = true,
  }) async {
    if (resetEmptyDays) {
      resetConsecutiveEmptyDays();
    }
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixGentleCheckIn, childId),
    );
  }

  // 5. Weekly review ready (Sunday morning, 1/week when enough data exists)
  static Future<bool> scheduleWeeklyReview({
    required DateTime sundayDate,
  }) async {
    if (sundayDate.isBefore(DateTime.now())) {
      return false;
    }

    if (!canSendNotification(
      type: 'weekly_review',
      targetTime: sundayDate,
      notificationId: weeklyReviewNotificationId,
    )) {
      return false;
    }

    final bool scheduled = await NotificationUtil.scheduleNotification(
      id: weeklyReviewNotificationId,
      title: 'LovingBrain · Weekly Review',
      body: 'Your weekly review is ready: one change, one pattern, one focus.',
      payload: 'weekly_review',
      scheduledDate: sundayDate,
    );
    if (!scheduled) {
      return false;
    }
    reserveCapSlotIfNeeded(
      notificationId: weeklyReviewNotificationId,
      date: sundayDate,
    );
    recordSent(
      type: 'weekly_review',
      title: 'LovingBrain · Weekly Review',
      payload: 'weekly_review',
    );
    return true;
  }

  static Future<void> cancelWeeklyReview() async {
    await NotificationUtil.cancelNotification(weeklyReviewNotificationId);
  }

  // 6. Mentorship booking event (immediate confirm/change/cancel)
  static Future<bool> notifyMentorshipBookingEvent({
    required String sessionId,
    required String mentorName,
    required String statusText,
  }) async {
    final DateTime now = DateTime.now();
    final String normalized = statusText.trim().toLowerCase();
    // Doc 03 quiet-hours exception: user-booked mentorship update.
    // Unconfirmed "requested" does not break through quiet hours.
    final bool bypassQuietHours =
        normalized == 'confirmed' ||
        normalized == 'changed' ||
        normalized == 'cancelled';
    final int id = notificationId(idPrefixMentorshipBooking, sessionId);
    if (!canSendNotification(
      type: 'mentorship',
      targetTime: now,
      bypassQuietHours: bypassQuietHours,
      notificationId: id,
    )) {
      return false;
    }

    trackMentorshipSession(sessionId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentorship',
      body: 'Your session with $mentorName is $statusText.',
      payload: 'mentorship_booking',
    );
    recordDelivery(notificationId: id);
    recordSent(
      type: 'mentorship',
      title: 'LovingBrain · Mentorship',
      payload: 'mentorship_booking',
    );
    return true;
  }

  // 7. Mentorship reminder (24h and 1h before session)
  static Future<void> scheduleMentorshipReminders({
    required String sessionId,
    required String mentorName,
    required DateTime sessionTime,
  }) async {
    final DateTime t24h = sessionTime.subtract(const Duration(hours: 24));
    final DateTime t1h = sessionTime.subtract(const Duration(hours: 1));
    final DateTime now = DateTime.now();
    trackMentorshipSession(sessionId);

    final int id24h = notificationId(idPrefixMentorshipReminder24h, sessionId);
    if (t24h.isAfter(now) &&
        canSendNotification(
          type: 'mentorship',
          targetTime: t24h,
          bypassQuietHours: true,
          notificationId: id24h,
        )) {
      final bool scheduled = await NotificationUtil.scheduleNotification(
        id: id24h,
        title: 'LovingBrain · Mentorship Tomorrow',
        body:
            'Your mentorship session with $mentorName is tomorrow at ${DateFormat('h:mm a').format(sessionTime)}.',
        payload: 'mentorship_reminder',
        scheduledDate: t24h,
      );
      if (scheduled) {
        reserveCapSlotIfNeeded(notificationId: id24h, date: t24h);
        recordSent(
          type: 'mentorship',
          title: 'LovingBrain · Mentorship Tomorrow',
          payload: 'mentorship_reminder',
        );
      }
    }

    final int id1h = notificationId(idPrefixMentorshipReminder1h, sessionId);
    if (t1h.isAfter(now) &&
        canSendNotification(
          type: 'mentorship',
          targetTime: t1h,
          bypassQuietHours: true,
          notificationId: id1h,
        )) {
      final bool scheduled = await NotificationUtil.scheduleNotification(
        id: id1h,
        title: 'LovingBrain · Mentorship in 1 Hour',
        body: 'Your mentorship session starts in 1 hour.',
        payload: 'mentorship_reminder',
        scheduledDate: t1h,
      );
      if (scheduled) {
        reserveCapSlotIfNeeded(notificationId: id1h, date: t1h);
        recordSent(
          type: 'mentorship',
          title: 'LovingBrain · Mentorship in 1 Hour',
          payload: 'mentorship_reminder',
        );
      }
    }
  }

  static Future<void> cancelMentorshipReminders(String sessionId) async {
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixMentorshipReminder24h, sessionId),
    );
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixMentorshipReminder1h, sessionId),
    );
  }

  // 8. Waitlist availability — does not break quiet hours (confirmed sessions only)
  static Future<bool> notifyWaitlistSlotAvailable({
    required String mentorId,
    required String mentorName,
  }) async {
    final DateTime now = DateTime.now();
    final int id = notificationId(idPrefixWaitlistAvailability, mentorId);
    if (!canSendNotification(
      type: 'mentorship',
      targetTime: now,
      bypassQuietHours: false,
      notificationId: id,
    )) {
      return false;
    }

    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentor Available',
      body: 'A mentor slot with $mentorName has opened this week.',
      payload: 'waitlist_availability',
    );
    recordDelivery(notificationId: id);
    recordSent(
      type: 'mentorship',
      title: 'LovingBrain · Mentor Available',
      payload: 'waitlist_availability',
    );
    return true;
  }

  /// Cancels or replaces pending local notifications after preference changes.
  static Future<void> applyPreferenceSideEffects({
    required NotificationPreferencesModel previous,
    required NotificationPreferencesModel next,
    required List<String> childIds,
    required String childName,
  }) async {
    final List<String> ids = childIds
        .where((String id) => id.isNotEmpty)
        .toList();
    final DateTime now = DateTime.now();

    if (!next.sleepReminders) {
      for (final String childId in ids) {
        await cancelSleepWindow(childId);
      }
    } else if (next.sleepReminderTimeCustomized &&
        (previous.sleepReminderTime != next.sleepReminderTime ||
            !previous.sleepReminderTimeCustomized ||
            !previous.sleepReminders)) {
      final DateTime? notifyTime =
          NotificationPreferencesModel.resolveDateTimeOn(
            day: now,
            timeString: next.sleepReminderTime,
          );
      if (notifyTime != null && notifyTime.isAfter(now)) {
        for (final String childId in ids) {
          await scheduleSleepWindow(
            childId: childId,
            childName: childName,
            windDownStart: notifyTime.add(const Duration(minutes: 25)),
            userDefinedNotifyTime: notifyTime,
          );
        }
      }
    }

    if (!next.checkInReminders) {
      for (final String childId in ids) {
        await cancelGentleCheckIn(childId);
      }
    } else if (!previous.checkInReminders ||
        previous.checkInReminderTime != next.checkInReminderTime) {
      final DateTime? checkInTime =
          NotificationPreferencesModel.resolveDateTimeOn(
            day: now,
            timeString: next.checkInReminderTime,
          );
      for (final String childId in ids) {
        await cancelGentleCheckIn(childId, resetEmptyDays: false);
        if (checkInTime != null && checkInTime.isAfter(now)) {
          await scheduleGentleCheckIn(
            childId: childId,
            checkInTime: checkInTime,
            hasLogsToday: false,
          );
        }
      }
    }

    if (!next.weeklyReview) {
      await cancelWeeklyReview();
    }

    if (!next.mentorshipUpdates) {
      await cancelAllTrackedMentorshipNotifications();
    }
  }
}
