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
    @Default(3) int maxDailyCap,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);

  /// Default clinical/parenting notification settings
  factory NotificationPreferencesModel.defaultPreferences() =>
      const NotificationPreferencesModel();

  /// Strictly checks if a notification is allowed, respecting the daily cap of 3
  bool isNotificationAllowed({
    String type = 'sleep',
    int deliveredTodayCount = 0,
  }) {
    if (deliveredTodayCount >= maxDailyCap) {
      return false;
    }
    switch (type.toLowerCase()) {
      case 'sleep':
      case 'wind_down':
        return sleepReminders;
      case 'check_in':
      case 'gentle_check_in':
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

  /// Verifies whether the local time falls inside quiet hours
  bool isInsideQuietHours(dynamic localTime) {
    try {
      final int hour = localTime is DateTime
          ? localTime.hour
          : (localTime.hour as int);
      final int minute = localTime is DateTime
          ? localTime.minute
          : (localTime.minute as int);

      final List<String> startParts = quietHoursStart.split(':');
      final List<String> endParts = quietHoursEnd.split(':');
      final int startHour = int.parse(startParts[0]);
      final int startMinute = int.parse(startParts[1]);
      final int endHour = int.parse(endParts[0]);
      final int endMinute = int.parse(endParts[1]);

      final int currentMinutes = hour * 60 + minute;
      final int startMinutes = startHour * 60 + startMinute;
      final int endMinutes = endHour * 60 + endMinute;

      if (startMinutes > endMinutes) {
        // Quiet hours span midnight, e.g. 21:00 to 07:00
        return currentMinutes >= startMinutes || currentMinutes < endMinutes;
      } else {
        return currentMinutes >= startMinutes && currentMinutes < endMinutes;
      }
    } catch (_) {
      return false;
    }
  }
}
