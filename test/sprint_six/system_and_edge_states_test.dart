import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/ui/family_sharing_consent/bloc/family_sharing_consent_cubit.dart';
import 'package:loving_brain/ui/mentorship_unavailable/bloc/mentorship_unavailable_cubit.dart';
import 'package:loving_brain/ui/microphone_permission/bloc/microphone_permission_cubit.dart';
import 'package:loving_brain/ui/notifications_permission/bloc/notifications_permission_cubit.dart';
import 'package:loving_brain/ui/sleep_low_confidence/bloc/sleep_low_confidence_cubit.dart';
import 'package:loving_brain/ui/sleep_no_data/bloc/sleep_no_data_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 6 - Screen 64: No Sleep Data Yet Cubit & State', () {
    test('SleepNoDataCubit provides fallback age-based guidance', () {
      final SleepNoDataCubit cubit = SleepNoDataCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.childAge, isNotEmpty);
      expect(cubit.state.isLoading, isFalse);

      cubit.close();
    });
  });

  group('Sprint 6 - Screens 67 & 68: Offline Sync Queue & Recovery', () {
    test(
      'OfflineSyncRepo queues and flushes pending updates with client update IDs',
      () async {
        final OfflineSyncRepo repo = OfflineSyncRepo.instance;

        final PendingLocalUpdateModel update1 = PendingLocalUpdateModel.create(
          clientUpdateId: 'test_client_id_001',
          updateType: 'sleep',
          timestamp: '2026-10-14T10:00:00Z',
          payload: <String, dynamic>{
            'bedtime': '20:00',
            'wake_time': '06:30',
            'quality': 4,
          },
        );

        final ApiResultStatus<bool> queueResult = await repo.queuePendingUpdate(
          update1,
        );
        expect(queueResult, isA<Data<bool>>());

        final List<PendingLocalUpdateModel> pending = await repo
            .getPendingUpdates();
        expect(
          pending.any(
            (PendingLocalUpdateModel u) =>
                u.clientUpdateId == 'test_client_id_001',
          ),
          isTrue,
        );

        final ApiResultStatus<int> syncResult = await repo.syncPendingUpdates();
        expect(syncResult, isA<Data<int>>());
      },
    );
  });

  group('Sprint 6 - Screen 69: Low Confidence Sleep Window', () {
    test('SleepLowConfidenceCubit initializes wide honest window state', () {
      final SleepLowConfidenceCubit cubit = SleepLowConfidenceCubit();
      cubit.init();

      expect(cubit.state.confidence, 'low');
      expect(cubit.state.nightsCount, 4);
      expect(cubit.state.windowTimeRange, '7:15 – 8:30 PM');
      expect(cubit.state.explanation, isNotEmpty);

      cubit.close();
    });
  });

  group('Sprint 6 - Screen 71: Mentorship Waitlist', () {
    test('MentorshipUnavailableCubit transitions when user joins waitlist', () {
      final MentorshipUnavailableCubit cubit = MentorshipUnavailableCubit();
      cubit.init();

      expect(cubit.state.isWaitlistJoined, isFalse);
      expect(cubit.state.waitlistStatus, isA<Initial>());

      cubit.joinWaitlist();
      expect(cubit.state.isWaitlistJoined, isTrue);
      expect(cubit.state.waitlistStatus, isA<Data<dynamic>>());

      cubit.close();
    });
  });

  group('Sprint 6 - Screens 72 & 73: Permission Explainers', () {
    test('NotificationsPermissionCubit grants notification permission', () {
      final NotificationsPermissionCubit cubit = NotificationsPermissionCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.isGranted, isFalse);

      cubit.grantPermission();
      expect(cubit.state.isGranted, isTrue);

      cubit.close();
    });

    test('MicrophonePermissionCubit grants microphone permission', () {
      final MicrophonePermissionCubit cubit = MicrophonePermissionCubit();
      cubit.init();

      expect(cubit.state.isGranted, isFalse);

      cubit.grantPermission();
      expect(cubit.state.isGranted, isTrue);

      cubit.close();
    });
  });

  group('Sprint 6 - Screen 74: Family Sharing Consent Explainer', () {
    test('FamilySharingConsentCubit grants consent for invite flow', () {
      final FamilySharingConsentCubit cubit = FamilySharingConsentCubit();
      cubit.init();

      expect(cubit.state.childName, isNotEmpty);
      expect(cubit.state.isConsentGiven, isFalse);

      cubit.grantConsent();
      expect(cubit.state.isConsentGiven, isTrue);

      cubit.close();
    });
  });
}
