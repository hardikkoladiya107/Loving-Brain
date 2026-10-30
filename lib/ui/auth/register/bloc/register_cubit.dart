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

  void reset() {
    _submittingMethod = '';
    emit(RegisterState());
  }

  void changeProps({
    bool? obscureTextPassword,
    bool? obscureTextConfirmPassword,
    String? phoneNumber,
    String? phoneNumberError,
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
    String? linkedEmail,
    String? linkedPhone,
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
        phoneNumber: phoneNumber ?? state.phoneNumber,
        phoneNumberError: phoneNumberError ?? state.phoneNumberError,
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
        linkedEmail: linkedEmail ?? state.linkedEmail,
        linkedPhone: linkedPhone ?? state.linkedPhone,
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
      phoneNumber: '',
      phoneNumberError: '',
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
      linkedEmail: '',
      linkedPhone: '',
    );
  }

  Future<void> sendOtp() async {
    final String rawPhone = state.phoneNumber.trim();
    final String rawEmail = state.emailAddress.trim();

    if (rawPhone.isEmpty && rawEmail.isEmpty) {
      changeProps(
        phoneNumberError: 'Please enter your mobile number or email address',
        emailAddressError: 'Please enter your mobile number or email address',
      );
      return;
    }

    String cleanPhone = '';
    String? phoneError;
    if (rawPhone.isNotEmpty) {
      cleanPhone = rawPhone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (cleanPhone.startsWith('0') && cleanPhone.length == 11) {
        cleanPhone = cleanPhone.substring(1);
      }

      // Validate country code — only Indian (+91) supported, mobile numbers start 6-9
      if (cleanPhone.startsWith('+')) {
        if (!cleanPhone.startsWith('+91')) {
          phoneError = 'We only allow Indian mobile numbers (+91) at this time';
        } else {
          final String digits = cleanPhone.substring(3);
          if (digits.length != 10 ||
              !RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) {
            phoneError = 'Please enter a valid 10-digit Indian mobile number';
          }
        }
      } else {
        if (cleanPhone.startsWith('91') &&
            cleanPhone.length == 12 &&
            RegExp(r'^91[6-9]\d{9}$').hasMatch(cleanPhone)) {
          cleanPhone = '+$cleanPhone';
        } else if (cleanPhone.length == 10 &&
            RegExp(r'^[6-9]\d{9}$').hasMatch(cleanPhone)) {
          // Auto-add +91 as requested
          cleanPhone = '+91$cleanPhone';
        } else {
          phoneError = 'Please enter a valid 10-digit Indian mobile number';
        }
      }
    }

    String cleanEmail = '';
    String? emailError;
    if (rawEmail.isNotEmpty) {
      cleanEmail = rawEmail.toLowerCase();
      if (!cleanEmail.isValidEmail) {
        emailError = 'Please enter a valid email address';
      }
    }

    // Validate whichever field is filled and clear the other field's error (V14-04)
    if (rawPhone.isEmpty) {
      phoneError = '';
    }
    if (rawEmail.isEmpty) {
      emailError = '';
    }

    if ((phoneError != null && phoneError.isNotEmpty) ||
        (emailError != null && emailError.isNotEmpty)) {
      changeProps(
        phoneNumberError: phoneError ?? '',
        emailAddressError: emailError ?? '',
      );
      return;
    }

    // Branch 1: User provided phone number (either phone alone or both phone & email)
    if (cleanPhone.isNotEmpty) {
      changeProps(
        phoneNumber: cleanPhone,
        phoneNumberError: '',
        emailAddressError: '',
        linkedEmail: cleanEmail,
        linkedPhone: cleanPhone,
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
    } else {
      // Branch 2: User provided email only
      changeProps(
        emailAddress: cleanEmail,
        emailAddressError: '',
        phoneNumberError: '',
        linkedEmail: cleanEmail,
        linkedPhone: '',
        apiResultStatus: const ApiResultStatus.loading(),
        isAuthSubmitting: true,
        submittingMethod: 'email',
        isPhoneAuth: false,
        phoneVerificationId: '',
        phoneResendToken: null,
      );

      final ApiResultStatus apiResult = await AuthRepo.instance.sendEmailOtp(
        email: cleanEmail,
      );

      changeProps(
        apiResultStatus: apiResult,
        isAuthSubmitting: false,
        submittingMethod: '',
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
