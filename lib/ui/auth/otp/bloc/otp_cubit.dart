import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/api_result_status.dart';
import '../../../../model/user_model.dart';
import '../../../../repo/auth_repo.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState());

  Timer? _resendTimer;
  Timer? _lockoutTimer;

  void init({
    String? destination,
    String? verificationId,
    int? resendToken,
    bool isPhoneAuth = false,
  }) {
    emit(const OtpState());
    changeProps(
      destination: destination ?? '',
      verificationId: verificationId ?? '',
      resendToken: resendToken,
      isPhoneAuth: isPhoneAuth,
    );
    startResendTimer();
  }

  void startResendTimer() {
    _resendTimer?.cancel();
    changeProps(resendCountdown: 30, canResend: false);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        changeProps(resendCountdown: 0, canResend: true);
      } else {
        changeProps(
          resendCountdown: state.resendCountdown - 1,
          canResend: false,
        );
      }
    });
  }

  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    changeProps(lockoutSeconds: 120, isLocked: true);
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state.lockoutSeconds <= 1) {
        timer.cancel();
        changeProps(isLocked: false, lockoutSeconds: 0, failedAttempts: 0);
      } else {
        changeProps(lockoutSeconds: state.lockoutSeconds - 1, isLocked: true);
      }
    });
  }

  void changeProps({
    String? otpCode,
    String? otpError,
    ApiResultStatus? verifyStatus,
    ApiResultStatus? resendStatus,
    bool? isSubmitting,
    int? resendCountdown,
    bool? canResend,
    String? destination,
    String? verificationId,
    int? resendToken,
    bool? isPhoneAuth,
    int? failedAttempts,
    bool? isLocked,
    int? lockoutSeconds,
  }) {
    emit(
      state.copyWith(
        otpCode: otpCode ?? state.otpCode,
        otpError: otpError ?? state.otpError,
        verifyStatus: verifyStatus ?? ApiResultStatus.initial(),
        resendStatus: resendStatus ?? ApiResultStatus.initial(),
        isSubmitting: isSubmitting ?? state.isSubmitting,
        resendCountdown: resendCountdown ?? state.resendCountdown,
        canResend: canResend ?? state.canResend,
        destination: destination ?? state.destination,
        verificationId: verificationId ?? state.verificationId,
        resendToken: resendToken ?? state.resendToken,
        isPhoneAuth: isPhoneAuth ?? state.isPhoneAuth,
        failedAttempts: failedAttempts ?? state.failedAttempts,
        isLocked: isLocked ?? state.isLocked,
        lockoutSeconds: lockoutSeconds ?? state.lockoutSeconds,
      ),
    );
  }

  void onOtpChanged(String value) {
    if (state.isLocked) return;
    changeProps(otpCode: value, otpError: '');
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    _lockoutTimer?.cancel();
    changeProps(
      resendStatus: const ApiResultStatus.loading(),
      isLocked: false,
      lockoutSeconds: 0,
      failedAttempts: 0,
      otpError: '',
    );
    try {
      if (state.isPhoneAuth) {
        await AuthRepo.instance.sendPhoneOtp(
          phoneNumber: state.destination,
          forceResendingToken: state.resendToken,
          onCodeSent: (String newVerificationId, int? newResendToken) {
            changeProps(
              verificationId: newVerificationId,
              resendToken: newResendToken,
              resendStatus: const ApiResultStatus.data(data: true),
            );
            startResendTimer();
          },
          onError: (Exception error) {
            changeProps(resendStatus: ApiResultStatus.error(error: error));
          },
          onAutoVerified: (UserModel userModel) {
            changeProps(
              verifyStatus: ApiResultStatus.data(data: userModel.toJson()),
            );
          },
        );
      } else {
        final ApiResultStatus apiResult = await AuthRepo.instance.sendEmailOtp(
          email: state.destination,
        );
        changeProps(resendStatus: apiResult);
        if (apiResult is Data) {
          startResendTimer();
        }
      }
    } catch (e) {
      changeProps(
        resendStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }

  Future<void> verifyOtp({VoidCallback? onSuccess}) async {
    if (state.isLocked) {
      changeProps(
        otpError:
            'Too many failed attempts. Please wait ${state.lockoutSeconds}s or request a new code.',
      );
      return;
    }

    final String code = state.otpCode.trim();
    if (code.isEmpty) {
      changeProps(otpError: 'Please enter verification code');
      return;
    }
    final int requiredLength = state.isPhoneAuth ? 6 : 4;
    if (code.length < requiredLength) {
      changeProps(
        otpError: 'Please enter $requiredLength-digit verification code',
      );
      return;
    }

    changeProps(
      verifyStatus: const ApiResultStatus.loading(),
      isSubmitting: true,
      otpError: '',
    );
    try {
      final ApiResultStatus apiResult = state.isPhoneAuth
          ? await AuthRepo.instance.verifyPhoneOtp(
              verificationId: state.verificationId,
              smsCode: code,
              phoneNumber: state.destination,
            )
          : await AuthRepo.instance.verifyEmailOtp(
              email: state.destination,
              otpCode: code,
            );

      if (apiResult is Data) {
        changeProps(
          verifyStatus: apiResult,
          isSubmitting: false,
          failedAttempts: 0,
        );
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        final int attempts = state.failedAttempts + 1;
        if (attempts >= 5) {
          _startLockoutTimer();
          changeProps(
            failedAttempts: attempts,
            isLocked: true,
            lockoutSeconds: 120,
            otpError:
                'Too many incorrect attempts (5/5). Locked for 2 minutes. Please request a new code.',
            verifyStatus: apiResult,
            isSubmitting: false,
          );
        } else {
          changeProps(
            failedAttempts: attempts,
            otpError: 'Invalid verification code ($attempts/5 attempts)',
            verifyStatus: apiResult,
            isSubmitting: false,
          );
        }
      }
    } catch (e) {
      final int attempts = state.failedAttempts + 1;
      if (attempts >= 5) {
        _startLockoutTimer();
        changeProps(
          failedAttempts: attempts,
          isLocked: true,
          lockoutSeconds: 120,
          otpError:
              'Too many incorrect attempts (5/5). Locked for 2 minutes. Please request a new code.',
          verifyStatus: ApiResultStatus.error(error: Exception(e.toString())),
          isSubmitting: false,
        );
      } else {
        changeProps(
          failedAttempts: attempts,
          otpError: 'Invalid verification code ($attempts/5 attempts)',
          verifyStatus: ApiResultStatus.error(error: Exception(e.toString())),
          isSubmitting: false,
        );
      }
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    _lockoutTimer?.cancel();
    return super.close();
  }
}
