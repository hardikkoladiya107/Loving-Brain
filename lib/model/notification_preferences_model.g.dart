// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferencesModel(
  sleepReminders: json['sleepReminders'] as bool? ?? true,
  checkInReminders: json['checkInReminders'] as bool? ?? true,
  mentorshipUpdates: json['mentorshipUpdates'] as bool? ?? false,
  weeklyReview: json['weeklyReview'] as bool? ?? true,
  quietHoursStart: json['quietHoursStart'] as String? ?? '21:00',
  quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
  sleepReminderTime: json['sleepReminderTime'] as String? ?? '7:15 PM',
  checkInReminderTime: json['checkInReminderTime'] as String? ?? '8:30 PM',
  maxDailyCap: (json['maxDailyCap'] as num?)?.toInt() ?? 3,
);

Map<String, dynamic> _$NotificationPreferencesModelToJson(
  _NotificationPreferencesModel instance,
) => <String, dynamic>{
  'sleepReminders': instance.sleepReminders,
  'checkInReminders': instance.checkInReminders,
  'mentorshipUpdates': instance.mentorshipUpdates,
  'weeklyReview': instance.weeklyReview,
  'quietHoursStart': instance.quietHoursStart,
  'quietHoursEnd': instance.quietHoursEnd,
  'sleepReminderTime': instance.sleepReminderTime,
  'checkInReminderTime': instance.checkInReminderTime,
  'maxDailyCap': instance.maxDailyCap,
};
