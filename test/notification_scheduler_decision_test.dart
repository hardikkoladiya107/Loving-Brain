import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  group('V2NotificationScheduler decision rules', () {
    test('same notification id reserves one daily-cap slot', () async {
      await preferences.saveNotificationPreferences(
        const NotificationPreferencesModel(
          sleepReminders: true,
          checkInReminders: true,
          mentorshipUpdates: true,
          weeklyReview: true,
          maxDailyCap: 3,
        ).toJson(),
      );

      final DateTime day = DateTime(2026, 10, 30, 18, 0);
      const int idA = 100001;
      const int idB = 100002;
      const int idC = 100003;
      const int idD = 100004;

      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: day,
          notificationId: idA,
        ),
        isTrue,
      );
      V2NotificationScheduler.reserveCapSlotIfNeeded(
        notificationId: idA,
        date: day,
      );
      // Replacing the same id does not consume another slot
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: day,
          notificationId: idA,
        ),
        isTrue,
      );
      V2NotificationScheduler.reserveCapSlotIfNeeded(
        notificationId: idA,
        date: day,
      );
      expect(V2NotificationScheduler.getCountForDate(day), 1);

      V2NotificationScheduler.reserveCapSlotIfNeeded(
        notificationId: idB,
        date: day,
      );
      V2NotificationScheduler.reserveCapSlotIfNeeded(
        notificationId: idC,
        date: day,
      );
      expect(V2NotificationScheduler.getCountForDate(day), 3);

      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'check_in',
          targetTime: day,
          notificationId: idD,
        ),
        isFalse,
      );
      // Already-reserved id still allowed after cap is full
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: day,
          notificationId: idA,
        ),
        isTrue,
      );
    });

    test('empty-day counter increments once per calendar date', () {
      expect(V2NotificationScheduler.getConsecutiveEmptyDays(), 0);

      final DateTime day1 = DateTime(2026, 10, 30, 20, 30);
      V2NotificationScheduler.incrementConsecutiveEmptyDays(forDate: day1);
      V2NotificationScheduler.incrementConsecutiveEmptyDays(forDate: day1);
      V2NotificationScheduler.incrementConsecutiveEmptyDays(forDate: day1);
      expect(V2NotificationScheduler.getConsecutiveEmptyDays(), 1);

      final DateTime day2 = DateTime(2026, 10, 31, 20, 30);
      V2NotificationScheduler.incrementConsecutiveEmptyDays(forDate: day2);
      expect(V2NotificationScheduler.getConsecutiveEmptyDays(), 2);
    });

    test('quiet hours block waitlist but allow confirmed mentorship', () async {
      await preferences.saveNotificationPreferences(
        const NotificationPreferencesModel(
          mentorshipUpdates: true,
          quietHoursStart: '21:00',
          quietHoursEnd: '07:00',
          maxDailyCap: 3,
        ).toJson(),
      );

      final DateTime insideQuiet = DateTime(2026, 10, 30, 22, 30);

      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'mentorship',
          targetTime: insideQuiet,
          bypassQuietHours: false,
        ),
        isFalse,
      );
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'mentorship',
          targetTime: insideQuiet,
          bypassQuietHours: true,
        ),
        isTrue,
      );
    });

    test('user-defined sleep bypasses quiet hours; forecast sleep does not', () async {
      await preferences.saveNotificationPreferences(
        const NotificationPreferencesModel(
          sleepReminders: true,
          quietHoursStart: '21:00',
          quietHoursEnd: '07:00',
          maxDailyCap: 3,
        ).toJson(),
      );

      final DateTime insideQuiet = DateTime(2026, 10, 30, 21, 30);

      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: insideQuiet,
          bypassQuietHours: false,
        ),
        isFalse,
      );
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: insideQuiet,
          bypassQuietHours: true,
        ),
        isTrue,
      );
    });

    test('toggle off refuses scheduling for that type', () async {
      await preferences.saveNotificationPreferences(
        const NotificationPreferencesModel(
          sleepReminders: false,
          checkInReminders: false,
          mentorshipUpdates: false,
          weeklyReview: false,
          quietHoursStart: '21:00',
          quietHoursEnd: '07:00',
          maxDailyCap: 3,
        ).toJson(),
      );

      final DateTime afternoon = DateTime(2026, 10, 30, 15, 0);
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'sleep',
          targetTime: afternoon,
        ),
        isFalse,
      );
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'check_in',
          targetTime: afternoon,
        ),
        isFalse,
      );
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'weekly_review',
          targetTime: afternoon,
        ),
        isFalse,
      );
      expect(
        V2NotificationScheduler.canSendNotification(
          type: 'mentorship',
          targetTime: afternoon,
          bypassQuietHours: true,
        ),
        isFalse,
      );
    });
  });

  group('NotificationPreferencesModel time helpers', () {
    test('parseTimeOfDayString accepts 12h and 24h', () {
      expect(
        NotificationPreferencesModel.parseTimeOfDayString('21:00'),
        (21, 0),
      );
      expect(
        NotificationPreferencesModel.parseTimeOfDayString('9:00 PM'),
        (21, 0),
      );
      expect(
        NotificationPreferencesModel.parseTimeOfDayString('12:00 AM'),
        (0, 0),
      );
      expect(
        NotificationPreferencesModel.parseTimeOfDayString('12:30 PM'),
        (12, 30),
      );
      expect(
        NotificationPreferencesModel.parseTimeOfDayString('garbage'),
        isNull,
      );
    });

    test('formatHHmm pads hours and minutes', () {
      expect(NotificationPreferencesModel.formatHHmm(9, 5), '09:05');
      expect(NotificationPreferencesModel.formatHHmm(21, 0), '21:00');
    });

    test('12h quiet hours match HH:mm overnight window', () {
      const NotificationPreferencesModel prefs = NotificationPreferencesModel(
        quietHoursStart: '9:00 PM',
        quietHoursEnd: '7:00 AM',
      );
      expect(
        prefs.isInsideQuietHours(const TimeOfDay(hour: 22, minute: 0)),
        isTrue,
      );
      expect(
        prefs.isInsideQuietHours(const TimeOfDay(hour: 6, minute: 59)),
        isTrue,
      );
      expect(
        prefs.isInsideQuietHours(const TimeOfDay(hour: 7, minute: 0)),
        isFalse,
      );
    });
  });
}
