import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_state.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void changeProps({
    bool? obscureTextPassword,
    bool? obscureTextConfirmPassword,
    String? emailAddress,
    String? password,
    String? confirmPassword,
    String? emailAddressError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isTermsAndConditionAccepted,
    ApiResultStatus? apiResultStatus,
  }) {
    emit(
      state.copyWith(
        obscureTextPassword: obscureTextPassword ?? state.obscureTextPassword,
        obscureTextConfirmPassword:
            obscureTextConfirmPassword ?? state.obscureTextConfirmPassword,
        emailAddress: emailAddress ?? state.emailAddress,
        password: password ?? state.password,
        confirmPassword: confirmPassword ?? state.confirmPassword,
        emailAddressError: emailAddressError ?? state.emailAddressError,
        passwordError: passwordError ?? state.passwordError,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        confirmPasswordError:
            confirmPasswordError ?? state.confirmPasswordError,
        isTermsAndConditionAccepted:
            isTermsAndConditionAccepted ?? state.isTermsAndConditionAccepted,
      ),
    );
  }

  bool _isValidate() {
    if (state.emailAddress.trim().isEmpty ||
        !state.emailAddress.trim().isValidEmail ||
        state.password.trim().isEmpty ||
        state.password.length < 6 ||
        state.confirmPassword.trim().isEmpty ||
        state.password.trim() != state.confirmPassword ||
        !state.isTermsAndConditionAccepted) {
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

      if (state.confirmPassword.trim().isEmpty) {
        changeProps(
          confirmPasswordError: LocaleKeys.pleaseEnterConfirmPassword.tr(),
        );
      } else if (state.password.isNotEmpty &&
          state.password.trim() != state.confirmPassword) {
        changeProps(
          confirmPasswordError: LocaleKeys.passwordAndConfirmPasswordShouldSame
              .tr(),
        );
      } else {
        changeProps(confirmPasswordError: "");
      }

      if (!state.isTermsAndConditionAccepted) {
        changeProps(apiResultStatus: ApiResultStatus.error(error: Exception("Please accept Terms and Conditions")));
      }
      return false;
    }

    changeProps(
      confirmPasswordError: "",
      passwordError: "",
      emailAddressError: "",
    );
    return true;
  }

  Future<void> register() async {
    if (_isValidate()) {
      changeProps(apiResultStatus: ApiResultStatus.loading());
      if (await AuthRepo.instance.isAccountExistWithEmail(
        email: state.emailAddress.trim(),
      )) {
        changeProps(
          apiResultStatus: ApiResultStatus.error(
            error: Exception(LocaleKeys.accountAlreadyExists.tr()),
          ),
        );
        return;
      }
      final credential = await AuthRepo.instance.createUserWithEmailAndPassword(
        email: state.emailAddress.trim(),
        password: state.password.trim(),
      );
      changeProps(apiResultStatus: credential);
    }
  }

  void clearFields() {
    changeProps(
      emailAddress: "",
      emailAddressError: "",
      password: "",
      passwordError: "",
      confirmPassword: "",
      obscureTextPassword: true,
      obscureTextConfirmPassword: true,
      confirmPasswordError: "",
    );
  }
}
