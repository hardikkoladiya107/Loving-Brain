import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Release-only Crashlytics setup for Loving Brain.
///
/// Collection stays off in debug and profile so local runs do not fill the
/// dashboard. Only the Firebase Auth uid is attached to a report.
class CrashReporting {
  CrashReporting._();

  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Call once after [Firebase.initializeApp].
  static Future<void> initialise() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    if (!kReleaseMode) {
      return;
    }

    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await setUser(currentUser.uid);
    }
  }

  static Future<void> setUser(String uid) async {
    final String trimmed = uid.trim();
    if (trimmed.isEmpty) {
      return;
    }
    await _crashlytics.setUserIdentifier(trimmed);
  }

  static Future<void> clearUser() async {
    await _crashlytics.setUserIdentifier('');
  }

  /// Non-fatal report for isolates that do not share the main handlers
  /// (for example the FCM background handler).
  static Future<void> recordNonFatal(
    Object error,
    StackTrace stack, {
    String? reason,
  }) async {
    if (!kReleaseMode) {
      return;
    }
    await _crashlytics.recordError(error, stack, reason: reason, fatal: false);
  }
}
