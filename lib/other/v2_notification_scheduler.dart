import 'package:intl/intl.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';

/// Unified V2 Notification Engine implementing the 8 specification types,
/// daily cap (max 3/day), quiet hours (9pm–7am), and cancel-on-complete rules
/// (v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md, 06_APP_STATES_EDGE_CASES.md §8).
class V2NotificationScheduler {
  V2NotificationScheduler._();

  static const String _deliveredCountKey = 'v2_notifications_delivered_count';
  static const String _deliveredDateKey = 'v2_notifications_delivered_date';

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

  /// Returns the count of notifications delivered today
  static int getDeliveredTodayCount() {
    final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String lastDate = preferences.getString(_deliveredDateKey) ?? '';
    if (lastDate != todayStr) {
      preferences.putString(_deliveredDateKey, todayStr);
      preferences.putInt(_deliveredCountKey, 0);
      return 0;
    }
    return preferences.getInt(_deliveredCountKey) ?? 0;
  }

  /// Records that a notification was dispatched
  static void recordDelivery() {
    final int current = getDeliveredTodayCount();
    preferences.putInt(_deliveredCountKey, current + 1);
  }

  /// Checks if a notification can be scheduled/sent according to caps and quiet hours
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

    final int count = getDeliveredTodayCount();
    if (!prefs.isNotificationAllowed(type: type, deliveredTodayCount: count)) {
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
    recordDelivery();
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
    recordDelivery();
    return true;
  }

  // Cancel Calm Heads-Up when parent already opened calm plan
  static Future<void> cancelCalmHeadsUp(String childId) async {
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixCalmHeadsUp, childId),
    );
  }

  // 4. Gentle check-in (8:30 PM if no logs today)
  static Future<bool> scheduleGentleCheckIn({
    required String childId,
    required DateTime checkInTime,
    required bool hasLogsToday,
  }) async {
    if (hasLogsToday) return false;
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
    recordDelivery();
    return true;
  }

  static Future<void> cancelGentleCheckIn(String childId) async {
    await NotificationUtil.cancelNotification(
      notificationId(idPrefixGentleCheckIn, childId),
    );
  }

  // 5. Weekly review ready (Sunday morning)
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
    recordDelivery();
    return true;
  }

  // 6. Mentorship booking event (immediate confirm/change/cancel)
  static Future<bool> notifyMentorshipBookingEvent({
    required String sessionId,
    required String mentorName,
    required String statusText,
  }) async {
    final int id = notificationId(idPrefixMentorshipBooking, sessionId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentorship',
      body: 'Your session with $mentorName is $statusText.',
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

    if (t24h.isAfter(now)) {
      await NotificationUtil.scheduleNotification(
        id: notificationId(idPrefixMentorshipReminder24h, sessionId),
        title: 'LovingBrain · Mentorship Tomorrow',
        body:
            'Your mentorship session with $mentorName is tomorrow at ${DateFormat('h:mm a').format(sessionTime)}.',
        payload: 'mentorship_reminder',
        scheduledDate: t24h,
      );
    }

    if (t1h.isAfter(now)) {
      await NotificationUtil.scheduleNotification(
        id: notificationId(idPrefixMentorshipReminder1h, sessionId),
        title: 'LovingBrain · Mentorship in 1 Hour',
        body: 'Your mentorship session starts in 1 hour.',
        payload: 'mentorship_reminder',
        scheduledDate: t1h,
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
    final int id = notificationId(idPrefixWaitlistAvailability, mentorId);
    await NotificationUtil.showLocalNotification(
      id: id,
      title: 'LovingBrain · Mentor Available',
      body: 'A mentor slot with $mentorName has opened this week.',
      payload: 'waitlist_availability',
    );
    return true;
  }
}
