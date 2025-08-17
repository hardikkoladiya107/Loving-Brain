import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInManager {
  AppleSignInManager._internal();

  static final AppleSignInManager _instance = AppleSignInManager._internal();

  static AppleSignInManager get instance => _instance;

  Future<void> authenticate() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential);
  }
}
