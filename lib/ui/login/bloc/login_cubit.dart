import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/manager/apple_sign_in/apple_signin_manager.dart';

import '../../../manager/google_sign_in/google_signin_manager.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void changeProps(String? message, String? email, String? password) {
    emit(
      state.copyWith(
        message: message ?? state.message,
        email: email ?? state.email,
        password: password ?? state.password,
      ),
    );
  }

  Future<void> googleAuthenticate() async {
    await GoogleSignInManager.instance.authenticate();
  }

  Future<void> signInWithApple() async {
    await AppleSignInManager.instance.authenticate();
  }

  Future<void> performLogin() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: state.email.trim(),
      password: state.password.trim(),
    );
  }

  bool _isValidate() {
    return false;
  }
}
