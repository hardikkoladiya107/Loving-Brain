import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../model/api_result_status.dart';
import '../../../../../repo/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void changeProps({
    String? emailAddress,
    String? password,
    String? emailAddressError,
    String? passwordError,
    bool? obscureTextPassword,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        emailAddress: emailAddress ?? state.emailAddress,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        password: password ?? state.password,
        emailAddressError: emailAddressError ?? state.emailAddressError,
        passwordError: passwordError ?? state.passwordError,
        obscureTextPassword: obscureTextPassword ?? state.obscureTextPassword,
      ),
    );
  }

  Future<void> googleAuthenticate() async {
    changeProps(apiResultStatus: ApiResultStatus.loading());
    var apiResult = await AuthRepo.instance.signInWithGoogle();
    changeProps(apiResultStatus: apiResult);
  }

  Future<void> signInWithApple() async {
    changeProps(apiResultStatus: ApiResultStatus.loading());
    var apiResult = await AuthRepo.instance.signInWithApple();
    changeProps(apiResultStatus: apiResult);
  }

  Future<void> performLogin() async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      var apiResult = await AuthRepo.instance.signInWithEmailAndPassword(
        email: state.emailAddress,
        password: state.password,
      );
      changeProps(apiResultStatus: apiResult);
    }
  }

  bool _isValidate() {
    if (state.emailAddress.trim().isEmpty ||
        !state.emailAddress.trim().isValidEmail ||
        state.password.trim().isEmpty ||
        state.password.length < 6) {
      if (state.emailAddress.trim().isEmpty) {
        changeProps(emailAddressError: LocaleKeys.pleaseEnterEmailAddress.tr());
      } else if (!state.emailAddress.trim().isValidEmail) {
        changeProps(emailAddressError: LocaleKeys.pleaseEnterValidEmail.tr());
      } else {
        changeProps(emailAddressError: "");
      }

      if (state.password.trim().isEmpty) {
        changeProps(passwordError: LocaleKeys.pleaseEnterPassword.tr());
      } else if (state.password.length < 6) {
        changeProps(passwordError: LocaleKeys.passwordShouldBeMoreLetters.tr());
      } else {
        changeProps(passwordError: "");
      }
      return false;
    }

    changeProps(passwordError: "", emailAddressError: "");
    return true;
  }

  void clearFields() {
    changeProps(
      emailAddress: "",
      emailAddressError: "",
      password: "",
      passwordError: "",
      obscureTextPassword: true,
    );
  }
}
