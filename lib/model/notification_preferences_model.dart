import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences_model.freezed.dart';
part 'notification_preferences_model.g.dart';

/// Notification preferences model conforming to V2 Specification
/// (v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md and Screen 61).
///
/// Invariants:
/// - Maximum normal push notifications: 3 per day. Most days are 0-2.
/// - Quiet hours default: 9:00 PM - 7:00 AM local time.
/// - NO broken-streak messages, guilt, or repeated prompts for missing logs.
@freezed
abstract class NotificationPreferencesModel
    with _$NotificationPreferencesModel {
  const NotificationPreferencesModel._();

  const factory NotificationPreferencesModel({
    @Default(true) bool sleepReminders,
    @Default(true) bool checkInReminders,
    @Default(false) bool mentorshipUpdates,
    @Default(true) bool weeklyReview,
    @Default('21:00') String quietHoursStart,
    @Default('07:00') String quietHoursEnd,
    @Default('7:15 PM') String sleepReminderTime,
    @Default('8:30 PM') String checkInReminderTime,
    @Default(false) bool sleepReminderTimeCustomized,
    @Default(3) int maxDailyCap,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);

  /// Default clinical/parenting notification settings
  factory NotificationPreferencesModel.defaultPreferences() =>
      const NotificationPreferencesModel();

  /// Parses `21:00`, `9:00 PM`, `7:15 AM`, and similar into hour/minute.
  /// Returns null when the string cannot be understood.
  static (int hour, int minute)? parseTimeOfDayString(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    try {
      final String lower = trimmed.toLowerCase();
      final bool hasAm = lower.contains('am');
      final bool hasPm = lower.contains('pm');
      final String numeric = lower
          .replaceAll('am', '')
          .replaceAll('pm', '')
          .trim();
      final List<String> parts = numeric.split(':');
      if (parts.length < 2) {
        return null;
      }
      int hour = int.parse(parts[0].trim());
      final int minute = int.parse(
        parts[1].replaceAll(RegExp(r'[^0-9]'), '').trim(),
      );
      if (hasAm || hasPm) {
        if (hasPm && hour < 12) {
          hour += 12;
        } else if (hasAm && hour == 12) {
          hour = 0;
        }
      }
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }
      return (hour, minute);
    } catch (_) {
      return null;
    }
  }

  /// Formats hour/minute as `HH:mm` for quiet-hours persistence.
  static String formatHHmm(int hour, int minute) {
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Builds a [DateTime] on [day] from a stored reminder time string.
  static DateTime? resolveDateTimeOn({
    required DateTime day,
    required String timeString,
  }) {
    final (int, int)? parsed = parseTimeOfDayString(timeString);
    if (parsed == null) {
      return null;
    }
    return DateTime(day.year, day.month, day.day, parsed.$1, parsed.$2);
  }

  /// Strictly checks if a notification is allowed, respecting the daily cap of 3
  bool isNotificationAllowed({
    String type = 'sleep',
    int deliveredTodayCount = 0,
    bool alreadyCountedForId = false,
  }) {
    if (!alreadyCountedForId && deliveredTodayCount >= maxDailyCap) {
      return false;
    }
    switch (type.toLowerCase()) {
      case 'sleep':
      case 'wind_down':
        return sleepReminders;
      case 'check_in':
      case 'gentle_check_in':
      case 'calm':
      case 'calm_heads_up':
        return checkInReminders;
      case 'mentorship':
      case 'session':
        return mentorshipUpdates;
      case 'weekly_review':
        return weeklyReview;
      default:
        return false;
    }
  }

  /// Verifies whether the local time falls inside quiet hours.
  /// Unparseable start/end values fall back to the default 21:00–07:00 window
  /// instead of treating the time as outside quiet hours.
  bool isInsideQuietHours(dynamic localTime) {
    try {
      final int hour = localTime is DateTime
          ? localTime.hour
          : (localTime.hour as int);
      final int minute = localTime is DateTime
          ? localTime.minute
          : (localTime.minute as int);

      final (int, int) start =
          parseTimeOfDayString(quietHoursStart) ??
          parseTimeOfDayString('21:00')!;
      final (int, int) end =
          parseTimeOfDayString(quietHoursEnd) ?? parseTimeOfDayString('07:00')!;

      final int currentMinutes = hour * 60 + minute;
      final int startMinutes = start.$1 * 60 + start.$2;
      final int endMinutes = end.$1 * 60 + end.$2;

      if (startMinutes > endMinutes) {
        // Quiet hours span midnight, e.g. 21:00 to 07:00
        return currentMinutes >= startMinutes || currentMinutes < endMinutes;
      }
      return currentMinutes >= startMinutes && currentMinutes < endMinutes;
    } catch (_) {
      return true;
    }
  }

  /// Mentorship reminders and a sleep time the parent chose may arrive
  /// during quiet hours. Everything else may not.
  bool quietHoursException(String kind) {
    if (kind == 'mentorship_reminder') {
      return true;
    }
    if (kind == 'sleep_window' && sleepReminderTimeCustomized) {
      return true;
    }
    return false;
  }

  /// True when a push arriving at [now] must be dropped.
  bool blocksIncomingNow({required String kind, required DateTime now}) {
    if (!isInsideQuietHours(now)) {
      return false;
    }
    return !quietHoursException(kind);
  }

  /// True when a pending local alarm must be removed.
  /// Future alarms whose clock falls inside quiet hours are removed.
  /// Alarms that are already late are removed only while it is still quiet.
  bool dropsScheduledReminder({
    required String kind,
    required DateTime? scheduled,
    required DateTime now,
  }) {
    if (scheduled == null) {
      return false;
    }
    final bool scheduledInside = isInsideQuietHours(scheduled);
    final bool overdueWhileQuiet =
        scheduled.isBefore(now) && isInsideQuietHours(now);
    if (!scheduledInside && !overdueWhileQuiet) {
      return false;
    }
    return !quietHoursException(kind);
  }
}
