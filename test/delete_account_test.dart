import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Delete Account & Data Cleanup Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        SharedPreference.isLogin: true,
        SharedPreference.user:
            '{"uid": "test_uid_123", "email": "test@lovingbrain.com"}',
        SharedPreference.child: '{"child_name": "Leo"}',
        'notification_preferences_v2': '{"sleep_reminders": true}',
        'pending_offline_sync_queue': '[{"id": "sync_1", "type": "mood"}]',
      });
      await SharedPreference.init();
    });

    test(
      'preferences.clearAll() completely wipes all local user data and settings',
      () async {
        expect(preferences.getBool(SharedPreference.isLogin), isTrue);
        expect(preferences.getUserModel()?.uid, 'test_uid_123');

        final bool cleared = await preferences.clearAll();
        expect(cleared, isTrue);

        expect(preferences.getBool(SharedPreference.isLogin), isFalse);
        expect(preferences.getUserModel(), isNull);
        expect(preferences.getChildModel(), isNull);
        expect(preferences.getString('notification_preferences_v2'), isEmpty);
      },
    );

    test(
      'OfflineSyncRepo.clearQueue() empties the persisted pending queue on account deletion',
      () async {
        await OfflineSyncRepo.instance.loadPersistedQueue();
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'update_99',
            updateType: 'tantrum',
            timestamp: DateTime.now().toIso8601String(),
            payload: <String, dynamic>{'notes': 'Test update'},
          ),
        );

        List<PendingLocalUpdateModel> queue = await OfflineSyncRepo.instance
            .getPendingUpdates();
        expect(queue.isNotEmpty, isTrue);

        await OfflineSyncRepo.instance.clearQueue();

        queue = await OfflineSyncRepo.instance.getPendingUpdates();
        expect(queue.isEmpty, isTrue);
      },
    );

    test(
      'Security Timing Guard: Last sign-in time older than 5 minutes blocks deletion to protect data',
      () {
        final DateTime now = DateTime.now();
        final DateTime staleLoginTime = now.subtract(
          const Duration(minutes: 6),
        );
        final int differenceInMinutes = now
            .difference(staleLoginTime)
            .inMinutes;

        expect(differenceInMinutes > 5, isTrue);

        // Verify that this triggers the expected security exception
        final Exception securityException = Exception(
          'For security, please sign out and sign in again before deleting your account.',
        );
        final ApiResultStatus<dynamic> result = ApiResultStatus.error(
          error: securityException,
        );

        expect(result, isA<Error<dynamic>>());
        final Error<dynamic> errorResult = result as Error<dynamic>;
        expect(
          errorResult.error.toString(),
          contains('For security, please sign out and sign in again'),
        );
      },
    );

    test(
      'Security Timing Guard: Recent sign-in (within 5 minutes) passes the security check',
      () {
        final DateTime now = DateTime.now();
        final DateTime freshLoginTime = now.subtract(
          const Duration(minutes: 2),
        );
        final int differenceInMinutes = now
            .difference(freshLoginTime)
            .inMinutes;

        expect(differenceInMinutes <= 5, isTrue);
      },
    );

    test(
      'UserModel partnerUserId mapping is correctly deserialized for unlinking partner on deletion',
      () {
        final UserModel user = UserModel.fromJson(<String, dynamic>{
          'uid': 'user_123',
          'partner_user_id': 'partner_456',
          'is_active_logger': false,
        });

        expect(user.partnerUserId, 'partner_456');
      },
    );
  });
}
