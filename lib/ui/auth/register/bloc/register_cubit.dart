import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_state.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../repo/auth_repo.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  /// Tracks which button initiated submission: `'email'`, `'google'`, `'apple'`, or `''`.
  String _submittingMethod = '';
  String get submittingMethod => _submittingMethod;

  void init() {
    _submittingMethod = '';
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
    bool? isPhoneAuth,
    String? phoneVerificationId,
    int? phoneResendToken,
    String? submittingMethod,
  }) {
    if (submittingMethod != null) {
      _submittingMethod = submittingMethod;
    } else if (isAuthSubmitting == false) {
      _submittingMethod = '';
    }
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
        isPhoneAuth: isPhoneAuth ?? state.isPhoneAuth,
        phoneVerificationId: phoneVerificationId ?? state.phoneVerificationId,
        phoneResendToken: phoneResendToken ?? state.phoneResendToken,
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
    final bool exists = await AuthRepo.instance.isAccountExistWithEmail(
      email: email,
    );
    changeProps(isEmailChecking: false);

    if (exists) {
      changeProps(emailAddressError: LocaleKeys.accountAlreadyExists.tr());
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
        confirmPasswordError: LocaleKeys.passwordAndConfirmPasswordShouldSame
            .tr(),
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
      submittingMethod: 'email',
    );

    final ApiResultStatus<dynamic> credential = await AuthRepo.instance
        .createUserWithEmailAndPassword(
          email: state.emailAddress.trim(),
          password: state.password.trim(),
        );
    changeProps(
      apiResultStatus: credential,
      isAuthSubmitting: false,
      submittingMethod: '',
    );
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
      isPhoneAuth: false,
      phoneVerificationId: '',
      phoneResendToken: null,
      submittingMethod: '',
    );
  }

  Future<void> sendOtp() async {
    final String input = state.emailAddress.trim();
    if (input.isEmpty) {
      changeProps(
        emailAddressError: 'Please enter your email or mobile number',
      );
      return;
    }

    final bool isEmail = input.contains('@');
    if (isEmail) {
      if (!input.isValidEmail) {
        changeProps(emailAddressError: LocaleKeys.pleaseEnterValidEmail.tr());
        return;
      }

      changeProps(
        emailAddressError: '',
        apiResultStatus: const ApiResultStatus.loading(),
        isAuthSubmitting: true,
        submittingMethod: 'email',
        isPhoneAuth: false,
        phoneVerificationId: '',
        phoneResendToken: null,
      );

      final ApiResultStatus apiResult = await AuthRepo.instance.sendEmailOtp(
        email: input,
      );

      changeProps(
        apiResultStatus: apiResult,
        isAuthSubmitting: false,
        submittingMethod: '',
      );
    } else {
      // Mobile Number validation and Firebase Phone Auth (India-first with auto +91)
      String cleanPhone = input.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      // Strip leading zero if 11 digits (e.g. 09876543210 -> 9876543210)
      if (cleanPhone.startsWith('0') && cleanPhone.length == 11) {
        cleanPhone = cleanPhone.substring(1);
      }

      // If user did not provide a leading '+', handle India auto-prefix
      if (!cleanPhone.startsWith('+')) {
        if (cleanPhone.startsWith('91') && cleanPhone.length == 12) {
          cleanPhone = '+$cleanPhone';
        } else if (cleanPhone.length == 10 &&
            RegExp(r'^\d{10}$').hasMatch(cleanPhone)) {
          cleanPhone = '+91$cleanPhone';
        } else {
          changeProps(
            emailAddressError: 'Please enter a valid 10-digit mobile number',
          );
          return;
        }
      }

      // Validate normalized E.164 phone number (10-digit Indian number or valid E.164)
      final RegExp phoneRegex = RegExp(r'^\+[0-9]{10,15}$');
      if (!phoneRegex.hasMatch(cleanPhone) ||
          (cleanPhone.startsWith('+91') && cleanPhone.length != 13)) {
        changeProps(
          emailAddressError: 'Please enter a valid 10-digit mobile number',
        );
        return;
      }

      changeProps(
        emailAddress: cleanPhone,
        emailAddressError: '',
        apiResultStatus: const ApiResultStatus.loading(),
        isAuthSubmitting: true,
        submittingMethod: 'phone',
        isPhoneAuth: true,
      );

      await AuthRepo.instance.sendPhoneOtp(
        phoneNumber: cleanPhone,
        onCodeSent: (String verificationId, int? resendToken) {
          changeProps(
            phoneVerificationId: verificationId,
            phoneResendToken: resendToken,
            apiResultStatus: const ApiResultStatus.data(data: true),
            isAuthSubmitting: false,
            submittingMethod: '',
          );
        },
        onError: (Exception error) {
          changeProps(
            apiResultStatus: ApiResultStatus.error(error: error),
            isAuthSubmitting: false,
            submittingMethod: '',
          );
        },
        onAutoVerified: (UserModel userModel) {
          changeProps(
            apiResultStatus: ApiResultStatus.data(data: userModel.toJson()),
            isAuthSubmitting: false,
            submittingMethod: '',
          );
        },
      );
    }
  }

  Future<void> googleAuthenticate() async {
    changeProps(
      apiResultStatus: const ApiResultStatus.loading(),
      isAuthSubmitting: true,
      submittingMethod: 'google',
    );
    final ApiResultStatus<dynamic> apiResult = await AuthRepo.instance
        .signInWithGoogle();
    changeProps(
      apiResultStatus: apiResult,
      isAuthSubmitting: false,
      submittingMethod: '',
    );
  }

  Future<void> signInWithApple() async {
    changeProps(
      apiResultStatus: const ApiResultStatus.loading(),
      isAuthSubmitting: true,
      submittingMethod: 'apple',
    );
    final ApiResultStatus<dynamic> apiResult = await AuthRepo.instance
        .signInWithApple();
    changeProps(
      apiResultStatus: apiResult,
      isAuthSubmitting: false,
      submittingMethod: '',
    );
  }
}
