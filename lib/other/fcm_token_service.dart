import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loving_brain/other/fcm_token_guard.dart';
import 'package:loving_brain/other/preferances.dart';

/// Writes and removes the device FCM token on the signed-in user document.
class FcmTokenService {
  FcmTokenService._();

  static bool sessionIsLoggedIn() {
    return FcmTokenGuard.sessionIsLoggedIn(
      isLoginFlag: preferences.getBool(SharedPreference.isLogin) ?? false,
      prefsUid: preferences.getUserModel()?.uid,
    );
  }

  /// Removes this device's token from the signed-in user, then invalidates it.
  /// Call while Firebase Auth is still signed in, and after the token-refresh
  /// listener has been cancelled so a replacement token is not written back.
  static Future<void> detachFcmFromSignedInUser() async {
    try {
      final User? authUser = FirebaseAuth.instance.currentUser;
      if (authUser != null && authUser.uid.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authUser.uid)
            .update(<String, dynamic>{
              'fcm_token': FieldValue.delete(),
            });
      }
    } catch (_) {}
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }

  /// Logged-out launch, including a cache clear that never ran logout.
  /// Clears the Firestore field when Auth still has the uid, always deletes
  /// the local token, and signs out a leftover Auth session.
  static Future<void> releaseFcmTokenIfSessionClosed() async {
    try {
      if (sessionIsLoggedIn()) {
        return;
      }
      final User? authUser = FirebaseAuth.instance.currentUser;
      final String? remoteUid = FcmTokenGuard.remoteUidToClear(
        isLoginFlag: preferences.getBool(SharedPreference.isLogin) ?? false,
        prefsUid: preferences.getUserModel()?.uid,
        authUid: authUser?.uid,
      );
      if (remoteUid != null && authUser != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(remoteUid)
              .update(<String, dynamic>{
                'fcm_token': FieldValue.delete(),
              });
        } catch (_) {}
        try {
          await FirebaseAuth.instance.signOut();
        } catch (_) {}
      }
      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {}
    } catch (_) {}
  }
}
