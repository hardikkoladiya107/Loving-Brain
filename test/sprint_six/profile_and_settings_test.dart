import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart';
import 'package:loving_brain/ui/help_safety/bloc/help_safety_cubit.dart';
import 'package:loving_brain/ui/notifications/bloc/notifications_cubit.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/privacy_data/bloc/privacy_data_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 6 - Screen 59: Parent Profile Cubit & State', () {
    test('ParentProfileV2Cubit validates input fields properly', () {
      final ParentProfileV2Cubit cubit = ParentProfileV2Cubit();
      cubit.init();

      expect(cubit.state.name, isNotNull);
      expect(cubit.state.relationship, isNotNull);

      // Verify updating fields
      cubit.updateField(name: 'Jane Doe', relationship: 'Mother');
      expect(cubit.state.name, 'Jane Doe');
      expect(cubit.state.relationship, 'Mother');

      cubit.close();
    });

    test('ParentProfileV2Cubit rejects empty name on save', () async {
      final ParentProfileV2Cubit cubit = ParentProfileV2Cubit();
      cubit.init();
      cubit.updateField(name: '   ');

      await cubit.saveProfile();
      expect(cubit.state.saveStatus, isA<Error>());

      cubit.close();
    });
  });

  group('Sprint 6 - Screen 60: Child Profile Cubit & State', () {
    test('ChildProfileV2Cubit initializes and modifies child properties', () {
      final ChildProfileV2Cubit cubit = ChildProfileV2Cubit();
      cubit.init();

      cubit.updateField(
        name: 'Leo',
        concerns: 'Teething and waking up at 3 AM',
      );
      expect(cubit.state.name, 'Leo');
      expect(cubit.state.concerns, 'Teething and waking up at 3 AM');

      final DateTime newDob = DateTime(2023, 6, 15);
      cubit.updateDob(newDob);
      expect(cubit.state.childDob, newDob);
      expect(cubit.state.dob, contains('2023'));

      cubit.close();
    });
  });

  group('Sprint 6 - Screen 61: Notification Preferences & Engagement Rules', () {
    test(
      'NotificationPreferencesModel respects quiet hours & max daily cap of 3',
      () {
        const NotificationPreferencesModel prefs = NotificationPreferencesModel(
          sleepReminders: true,
          checkInReminders: true,
          mentorshipUpdates: true,
          weeklyReview: true,
          quietHoursStart: '21:00',
          quietHoursEnd: '07:00',
          maxDailyCap: 3,
        );

        expect(prefs.maxDailyCap, 3);
        expect(prefs.isNotificationAllowed(deliveredTodayCount: 0), isTrue);
        expect(prefs.isNotificationAllowed(deliveredTodayCount: 2), isTrue);
        // Beyond daily cap of 3
        expect(prefs.isNotificationAllowed(deliveredTodayCount: 3), isFalse);
        expect(prefs.isNotificationAllowed(deliveredTodayCount: 5), isFalse);

        // Quiet hours verification
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 22, minute: 0)),
          isTrue,
        );
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 23, minute: 30)),
          isTrue,
        );
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 2, minute: 0)),
          isTrue,
        );
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 6, minute: 59)),
          isTrue,
        );
        // Active hours outside quiet hours
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 7, minute: 1)),
          isFalse,
        );
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 14, minute: 30)),
          isFalse,
        );
        expect(
          prefs.isInsideQuietHours(const TimeOfDay(hour: 20, minute: 59)),
          isFalse,
        );
      },
    );

    test('NotificationsCubit toggles preferences cleanly', () async {
      final NotificationsCubit cubit = NotificationsCubit();
      cubit.init();

      final bool initialSleep = cubit.state.sleepEnabled;
      await cubit.toggleSleep();
      expect(cubit.state.sleepEnabled, !initialSleep);

      final bool initialCheckIn = cubit.state.checkInEnabled;
      await cubit.toggleCheckIn();
      expect(cubit.state.checkInEnabled, !initialCheckIn);

      await cubit.updateQuietHours(start: '22:00', end: '06:30');
      expect(cubit.state.quietHoursStart, '22:00');
      expect(cubit.state.quietHoursEnd, '06:30');

      cubit.close();
    });
  });

  group('Sprint 6 - Screen 62: Privacy & Data Exports', () {
    test('PrivacyDataCubit initialises with child name', () {
      final PrivacyDataCubit cubit = PrivacyDataCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.isDeletingAccount, isFalse);
      expect(cubit.state.isAccountDeleted, isFalse);

      cubit.close();
    });

    test(
      'PrivacyData exportUserData succeeds with structured JSON output',
      () async {
        final PrivacyDataCubit cubit = PrivacyDataCubit();
        cubit.init();

        await cubit.exportData();
        expect(cubit.state.exportStatus, isA<Data<dynamic>>());
        expect(cubit.state.exportedData, isNotNull);
        expect(cubit.state.exportedData!['export_date'], isNotNull);
        expect(cubit.state.exportedData!['format_version'], '2.0');

        cubit.close();
      },
    );

    test(
      'OfflineSyncRepo importUserData merges records successfully',
      () async {
        final Map<String, dynamic> mockBackup = <String, dynamic>{
          'app': 'LovingBrain',
          'export_version': '2.0',
          'child_profile': <String, dynamic>{
            'childName': 'Test Kid',
            'childAge': '2 years',
          },
          'sleep_logs': <dynamic>[
            <String, dynamic>{'wakeTime': '07:00 AM', 'bedTime': '08:00 PM'},
          ],
          'tantrum_logs': <dynamic>[
            <String, dynamic>{'intensity': 'Medium', 'trigger': 'Transition'},
          ],
        };

        final ApiResultStatus<int> res = await OfflineSyncRepo.instance
            .importUserData(payload: mockBackup);

        expect(res, isA<Data<int>>());
        final int imported = (res as Data<int>).data;
        expect(imported, greaterThanOrEqualTo(1));
      },
    );
  });

  group('Sprint 6 - Screen 63: Help & Safety', () {
    test(
      'HelpSafetyCubit initializes default emergency and support endpoints',
      () {
        final HelpSafetyCubit cubit = HelpSafetyCubit();
        cubit.init();

        expect(cubit.state.emergencyPhone, 'tel:911');
        expect(cubit.state.supportEmail, 'support@lovingbrain.com');
        expect(cubit.state.faqUrl, contains('lovingbrain.com'));

        cubit.close();
      },
    );
  });
}
