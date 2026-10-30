/// Decides when a device FCM token may be written or must be removed.
/// Kept free of Firebase so session rules can be tested without a device.
class FcmTokenGuard {
  FcmTokenGuard._();

  static bool sessionIsLoggedIn({
    required bool isLoginFlag,
    required String? prefsUid,
  }) {
    return isLoginFlag && (prefsUid?.trim().isNotEmpty ?? false);
  }

  /// Cold start with no local session must drop the device token.
  /// Clearing cache does not run logout, so the Firestore field can still
  /// point at this phone until the token is deleted.
  static bool shouldDetachOnColdStart({
    required bool isLoginFlag,
    required String? prefsUid,
  }) {
    return !sessionIsLoggedIn(isLoginFlag: isLoginFlag, prefsUid: prefsUid);
  }

  /// Firestore field can be cleared only while Firebase Auth still knows the uid.
  /// After a full storage wipe that uid is gone, and only the local token delete remains.
  static String? remoteUidToClear({
    required bool isLoginFlag,
    required String? prefsUid,
    required String? authUid,
  }) {
    if (sessionIsLoggedIn(isLoginFlag: isLoginFlag, prefsUid: prefsUid)) {
      return null;
    }
    final String uid = (authUid ?? '').trim();
    if (uid.isEmpty) {
      return null;
    }
    return uid;
  }
}
