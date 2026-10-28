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

  static int notificationId(int prefix, String entityId) {
    return prefix + (entityId.hashCode.abs() % 99999);
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

  /// Returns the count of notifications delivered today
  static int getDeliveredTodayCount() {
    return getCountForDate(DateTime.now());
  }

  /// Records that a notification was dispatched
  static void recordDelivery() {
    incrementCountForDate(DateTime.now());
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
  }

  static void incrementConsecutiveEmptyDays() {
    final int current = getConsecutiveEmptyDays();
    preferences.putInt(_consecutiveEmptyDaysKey, current + 1);
  }

  /// Checks if a notification can be scheduled/sent according to caps and quiet hours on target day
  static bool canSendNotification({
    required String type,
    required DateTime targetTime,
    bool isMentorshipException = false,
  }) {
    final Map<String, dynamic>? rawPrefs = preferences
        .getNotificationPreferences();
    final NotificationPreferencesModel prefs = rawPrefs != null
        ? NotificationPreferencesModel.fromJson(rawPrefs)
        : NotificationPreferencesModel.defaultPreferences();

    final int countOnTargetDay = getCountForDate(targetTime);
    if (!prefs.isNotificationAllowed(
      type: type,
      deliveredTodayCount: countOnTargetDay,
    )) {
      return false;
    }

    if (!isMentorshipException && prefs.isInsideQuietHours(targetTime)) {
      return false;
    }

    return true;
  }

  // 1. Sleep window approaching (20-30m before wind-down, confidence >= moderate)
  static Future<bool> scheduleSleepWindow({
    required String childId,
    required String childName,
    required DateTime windDownStart,
  }) async {
    final DateTime notifyTime = windDownStart.subtract(
      const Duration(minutes: 25),
    );
    if (notifyTime.isBefore(DateTime.now())) return false;

    if (!canSendNotification(type: 'sleep', targetTime: notifyTime)) {
      return false;
    }

    final String timeStr = DateFormat('h:mm a').format(windDownStart);
    final int id = notificationId(idPrefixSleepWindow, childId);

    await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Sleep Window',
      body: 'Wind-down may start around $timeStr tonight for $childName.',
      payload: 'sleep_window',
      scheduledDate: notifyTime,
    );
    incrementCountForDate(notifyTime);
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
    if (!canSendNotification(type: 'sleep', targetTime: now)) {
      return false;
    }

    final int id = notificationId(idPrefixSleepEstimateChanged, childId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Sleep Plan Updated',
      body:
          'Today\'s rest moved $childName\'s bedtime estimate to $newBedtime.',
      payload: 'sleep_estimate_changed',
    );
    recordDelivery();
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
    if (notifyTime.isBefore(DateTime.now())) return false;

    if (!canSendNotification(type: 'calm', targetTime: notifyTime)) {
      return false;
    }

    final String startStr = DateFormat('h:mm a').format(windowStart);
    final String endStr = DateFormat('h:mm a').format(windowEnd);
    final int id = notificationId(idPrefixCalmHeadsUp, childId);

    await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Calm Heads-Up',
      body:
          'A harder window may be more likely around $startStr–$endStr. Here’s what may help.',
      payload: 'calm_heads_up',
      scheduledDate: notifyTime,
    );
    incrementCountForDate(notifyTime);
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

  // 4. Gentle check-in (8:30 PM if no logs today, max 3 consecutive empty days)
  static Future<bool> scheduleGentleCheckIn({
    required String childId,
    required DateTime checkInTime,
    required bool hasLogsToday,
  }) async {
    if (hasLogsToday) {
      resetConsecutiveEmptyDays();
      return false;
    }

    // Stop gentle check-in after a short run of 3 empty days without logs (Doc 03 §4)
    if (getConsecutiveEmptyDays() >= 3) {
      return false;
    }

    if (checkInTime.isBefore(DateTime.now())) return false;

    if (!canSendNotification(type: 'check_in', targetTime: checkInTime)) {
      return false;
    }

    final int id = notificationId(idPrefixGentleCheckIn, childId);
    await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Quick Update',
      body: 'One quick update can help us understand today better.',
      payload: 'gentle_check_in',
      scheduledDate: checkInTime,
    );
    incrementCountForDate(checkInTime);
    incrementConsecutiveEmptyDays();
    recordSent(
      type: 'check_in',
      title: 'LovingBrain · Quick Update',
      payload: 'gentle_check_in',
    );
    return true;
  }

  static Future<void> cancelGentleCheckIn(String childId) async {
    resetConsecutiveEmptyDays();
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixGentleCheckIn, childId),
    );
  }

  // 5. Weekly review ready (Sunday morning, 1/week when enough data exists)
  static Future<bool> scheduleWeeklyReview({
    required DateTime sundayDate,
  }) async {
    if (sundayDate.isBefore(DateTime.now())) return false;

    if (!canSendNotification(type: 'weekly_review', targetTime: sundayDate)) {
      return false;
    }

    const int id = idPrefixWeeklyReview + 1;
    await NotificationUtil.scheduleNotification(
      id: id,
      title: 'LovingBrain · Weekly Review',
      body: 'Your weekly review is ready: one change, one pattern, one focus.',
      payload: 'weekly_review',
      scheduledDate: sundayDate,
    );
    incrementCountForDate(sundayDate);
    recordSent(
      type: 'weekly_review',
      title: 'LovingBrain · Weekly Review',
      payload: 'weekly_review',
    );
    return true;
  }

  // 6. Mentorship booking event (immediate confirm/change/cancel)
  static Future<bool> notifyMentorshipBookingEvent({
    required String sessionId,
    required String mentorName,
    required String statusText,
  }) async {
    final DateTime now = DateTime.now();
    if (!canSendNotification(
      type: 'mentorship',
      targetTime: now,
      isMentorshipException: true,
    )) {
      return false;
    }

    final int id = notificationId(idPrefixMentorshipBooking, sessionId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentorship',
      body: 'Your session with $mentorName is $statusText.',
      payload: 'mentorship_booking',
    );
    recordDelivery();
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

    if (t24h.isAfter(now) &&
        canSendNotification(
          type: 'mentorship',
          targetTime: t24h,
          isMentorshipException: true,
        )) {
      await NotificationUtil.scheduleNotification(
        id: notificationId(idPrefixMentorshipReminder24h, sessionId),
        title: 'LovingBrain · Mentorship Tomorrow',
        body:
            'Your mentorship session with $mentorName is tomorrow at ${DateFormat('h:mm a').format(sessionTime)}.',
        payload: 'mentorship_reminder',
        scheduledDate: t24h,
      );
      incrementCountForDate(t24h);
      recordSent(
        type: 'mentorship',
        title: 'LovingBrain · Mentorship Tomorrow',
        payload: 'mentorship_reminder',
      );
    }

    if (t1h.isAfter(now) &&
        canSendNotification(
          type: 'mentorship',
          targetTime: t1h,
          isMentorshipException: true,
        )) {
      await NotificationUtil.scheduleNotification(
        id: notificationId(idPrefixMentorshipReminder1h, sessionId),
        title: 'LovingBrain · Mentorship in 1 Hour',
        body: 'Your mentorship session starts in 1 hour.',
        payload: 'mentorship_reminder',
        scheduledDate: t1h,
      );
      incrementCountForDate(t1h);
      recordSent(
        type: 'mentorship',
        title: 'LovingBrain · Mentorship in 1 Hour',
        payload: 'mentorship_reminder',
      );
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

  // 8. Waitlist availability
  static Future<bool> notifyWaitlistSlotAvailable({
    required String mentorId,
    required String mentorName,
  }) async {
    final DateTime now = DateTime.now();
    if (!canSendNotification(
      type: 'mentorship',
      targetTime: now,
      isMentorshipException: true,
    )) {
      return false;
    }

    final int id = notificationId(idPrefixWaitlistAvailability, mentorId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentor Available',
      body: 'A mentor slot with $mentorName has opened this week.',
      payload: 'waitlist_availability',
    );
    recordDelivery();
    recordSent(
      type: 'mentorship',
      title: 'LovingBrain · Mentor Available',
      payload: 'waitlist_availability',
    );
    return true;
  }
}
