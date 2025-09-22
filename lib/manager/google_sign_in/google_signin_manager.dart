import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInManager {
  GoogleSignInManager._internal();

  static final GoogleSignInManager _instance = GoogleSignInManager._internal();

  static GoogleSignInManager get instance => _instance;

  final GoogleSignIn signIn = GoogleSignIn.instance;

  void initialise() {
    unawaited(
      signIn.initialize().then((_) {
        // signIn.authenticationEvents
        //     .listen(_handleAuthenticationEvent)
        //     .onError(_handleAuthenticationError);
      }),
    );
  }

  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<GoogleSignInAccount?> authenticate() async {
    try {
      if (signIn.supportsAuthenticate()) {
        final GoogleSignInAccount googleUser = await signIn.authenticate(
          scopeHint: ['email'],
        );
        return googleUser;
      }
      return null;
    } on GoogleSignInException catch (e) {
      e;
      return null;
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

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? googleSignInAccount = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    if (googleSignInAccount == null) {
      return;
    }
    final googleAuth = googleSignInAccount.authentication; // now synchronous
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    print(userCredential.user?.email);
  }

  void _handleAuthenticationError(Object e) {
    signOut();
  }
}
