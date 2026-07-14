import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInManager {
  GoogleSignInManager._internal();

  static final GoogleSignInManager _instance = GoogleSignInManager._internal();

  static GoogleSignInManager get instance => _instance;

  final GoogleSignIn signIn = GoogleSignIn.instance;
  Future<void>? _initializationFuture;
  static const String _serverClientId =
      '779880600850-18h1ttsrfpsj0r4l8vk5qehdujoedn9c.apps.googleusercontent.com';

  /// On Android, omit [serverClientId] so the plugin reads the Web client ID from
  /// `google-services.json` (avoids mismatch). Other platforms still pass it for Firebase ID tokens.
  Future<void> initialise() {
    _initializationFuture ??= defaultTargetPlatform == TargetPlatform.android
        ? signIn.initialize()
        : signIn.initialize(serverClientId: _serverClientId);
    return _initializationFuture!;
  }

  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<GoogleSignInAccount?> authenticate() async {
    try {
      if (_initializationFuture == null) {
        throw Exception(
          'Google Sign-In is not initialized. Call GoogleSignInManager.initialise() at app startup.',
        );
      }
      if (signIn.supportsAuthenticate()) {
        final GoogleSignInAccount googleUser = await signIn.authenticate(
          scopeHint: <String>['email', 'profile'],
        );
        return googleUser;
      }
      final GoogleSignInAccount? googleUser = await signIn
          .attemptLightweightAuthentication();
      if (googleUser == null) {
        throw Exception('Google Sign-In could not start on this device.');
      }
      return googleUser;
    } on GoogleSignInException catch (e) {
      // Android Credential Manager often reports OAuth misconfiguration as
      // `canceled` (same code as user dismiss). See google_sign_in_android README.
      if (e.code == GoogleSignInExceptionCode.canceled &&
          defaultTargetPlatform == TargetPlatform.android) {
        final String message =
            'Google Sign-In failed (Android). The system reported "canceled", which '
            'often means Firebase OAuth is misconfigured, not that you tapped back. '
            'Fix: Firebase Console → Project settings → Android app '
            '"com.app.loving_brain" → add SHA-1 and SHA-256 for the keystore you use to run '
            'this build (debug and/or release), then download a fresh google-services.json. '
            'SDK detail: ${e.description ?? "no_description"}';
        debugPrint(message);
        throw Exception(message);
      }
      final String message =
          'Google Sign-In failed. code=${e.code.name}, description=${e.description ?? "no_description"}';
      debugPrint(message);
      throw Exception(message);
    } on Exception catch (e) {
      debugPrint('Google Sign-In exception: $e');
      rethrow;
    } catch (e) {
      debugPrint('Google Sign-In unexpected error: $e');
      throw Exception('Google Sign-In unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      e;
    }
  }

  Future<void> disconnect() async {
    try {
      await GoogleSignIn.instance.disconnect();
    } catch (e) {
      e;
    }
  }
}
