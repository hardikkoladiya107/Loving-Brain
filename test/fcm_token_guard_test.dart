import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/fcm_token_guard.dart';

void main() {
  group('FcmTokenGuard', () {
    test('logged-in session may keep and refresh the token', () {
      expect(
        FcmTokenGuard.sessionIsLoggedIn(
          isLoginFlag: true,
          prefsUid: 'user-a',
        ),
        isTrue,
      );
      expect(
        FcmTokenGuard.shouldDetachOnColdStart(
          isLoginFlag: true,
          prefsUid: 'user-a',
        ),
        isFalse,
      );
      expect(
        FcmTokenGuard.remoteUidToClear(
          isLoginFlag: true,
          prefsUid: 'user-a',
          authUid: 'user-a',
        ),
        isNull,
      );
    });

    test('login flag without a uid is not a session', () {
      expect(
        FcmTokenGuard.sessionIsLoggedIn(
          isLoginFlag: true,
          prefsUid: '  ',
        ),
        isFalse,
      );
    });

    test('cache clear keeps auth uid so the remote token can be removed', () {
      expect(
        FcmTokenGuard.shouldDetachOnColdStart(
          isLoginFlag: false,
          prefsUid: null,
        ),
        isTrue,
      );
      expect(
        FcmTokenGuard.remoteUidToClear(
          isLoginFlag: false,
          prefsUid: null,
          authUid: 'user-a',
        ),
        'user-a',
      );
    });

    test('full storage wipe has no uid so only the local token can be deleted', () {
      expect(
        FcmTokenGuard.remoteUidToClear(
          isLoginFlag: false,
          prefsUid: null,
          authUid: null,
        ),
        isNull,
      );
      expect(
        FcmTokenGuard.shouldDetachOnColdStart(
          isLoginFlag: false,
          prefsUid: null,
        ),
        isTrue,
      );
    });
  });
}
