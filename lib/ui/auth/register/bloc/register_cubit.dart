import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_state.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void init() {
    emit(RegisterState());
  }

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
    bool? isAuthSubmitting,
    int? currentStep,
    bool? isEmailChecking,
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
        isAuthSubmitting: isAuthSubmitting ?? state.isAuthSubmitting,
        currentStep: currentStep ?? state.currentStep,
        isEmailChecking: isEmailChecking ?? state.isEmailChecking,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 0 → Step 1: validate email then advance
  // ---------------------------------------------------------------------------
  Future<void> nextStep() async {
    final String email = state.emailAddress.trim();
    if (email.isEmpty) {
      changeProps(emailAddressError: LocaleKeys.pleaseEnterEmailAddress.tr());
      return;
    }
    if (!email.isValidEmail) {
      changeProps(emailAddressError: LocaleKeys.pleaseEnterValidEmail.tr());
      return;
    }

    // Check if account already exists
    changeProps(emailAddressError: '', isEmailChecking: true);
    final bool exists =
        await AuthRepo.instance.isAccountExistWithEmail(email: email);
    changeProps(isEmailChecking: false);

    if (exists) {
      changeProps(
        emailAddressError: LocaleKeys.accountAlreadyExists.tr(),
      );
      return;
    }

    // Advance to password step
    changeProps(currentStep: 1);
  }

  // ---------------------------------------------------------------------------
  // Back from step 1 → step 0
  // ---------------------------------------------------------------------------
  void previousStep() {
    changeProps(currentStep: 0);
  }

  // ---------------------------------------------------------------------------
  // Step 1: validate passwords and register
  // ---------------------------------------------------------------------------
  bool _isPasswordValid() {
    bool valid = true;

    if (state.password.trim().isEmpty) {
      changeProps(passwordError: LocaleKeys.pleaseEnterPassword.tr());
      valid = false;
    } else if (state.password.length < 6) {
      changeProps(passwordError: LocaleKeys.passwordShouldBeMoreLetters.tr());
      valid = false;
    } else {
      changeProps(passwordError: '');
    }

    if (state.confirmPassword.trim().isEmpty) {
      changeProps(
        confirmPasswordError: LocaleKeys.pleaseEnterConfirmPassword.tr(),
      );
      valid = false;
    } else if (state.password.trim() != state.confirmPassword.trim()) {
      changeProps(
        confirmPasswordError:
            LocaleKeys.passwordAndConfirmPasswordShouldSame.tr(),
      );
      valid = false;
    } else {
      changeProps(confirmPasswordError: '');
    }

    if (!state.isTermsAndConditionAccepted) {
      changeProps(
        apiResultStatus: ApiResultStatus.error(
          error: Exception('Please accept Terms and Conditions'),
        ),
      );
      valid = false;
    }

    return valid;
  }

  Future<void> register() async {
    if (!_isPasswordValid()) return;

    changeProps(
      apiResultStatus: ApiResultStatus.loading(),
      isAuthSubmitting: true,
    );

    final ApiResultStatus<dynamic> credential =
        await AuthRepo.instance.createUserWithEmailAndPassword(
          email: state.emailAddress.trim(),
          password: state.password.trim(),
        );
    changeProps(apiResultStatus: credential, isAuthSubmitting: false);
  }

  void clearFields() {
    changeProps(
      emailAddress: '',
      emailAddressError: '',
      password: '',
      passwordError: '',
      confirmPassword: '',
      obscureTextPassword: true,
      obscureTextConfirmPassword: true,
      confirmPasswordError: '',
      isTermsAndConditionAccepted: false,
      apiResultStatus: ApiResultStatus.initial(),
      isAuthSubmitting: false,
      currentStep: 0,
      isEmailChecking: false,
    );
  }
}

