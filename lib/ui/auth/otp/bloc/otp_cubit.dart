import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/api_result_status.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState());

  Timer? _resendTimer;

  void init({String? destination}) {
    emit(const OtpState());
    if (destination != null && destination.isNotEmpty) {
      changeProps(destination: destination);
    }
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

  void changeProps({
    String? otpCode,
    String? otpError,
    ApiResultStatus? verifyStatus,
    ApiResultStatus? resendStatus,
    bool? isSubmitting,
    int? resendCountdown,
    bool? canResend,
    String? destination,
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
      ),
    );
  }

  void onOtpChanged(String value) {
    changeProps(otpCode: value, otpError: '');
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    changeProps(resendStatus: ApiResultStatus.loading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      changeProps(resendStatus: ApiResultStatus.data(data: true));
      startResendTimer();
    } catch (e) {
      changeProps(
        resendStatus: ApiResultStatus.error(error: Exception(e.toString())),
      );
    }
  }

  Future<void> verifyOtp({VoidCallback? onSuccess}) async {
    final String code = state.otpCode.trim();
    if (code.isEmpty) {
      changeProps(otpError: 'Please enter verification code');
      return;
    }
    if (code.length < 4) {
      changeProps(otpError: 'Please enter 4-digit verification code');
      return;
    }

    changeProps(
      verifyStatus: ApiResultStatus.loading(),
      isSubmitting: true,
      otpError: '',
    );
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      changeProps(
        verifyStatus: ApiResultStatus.data(data: true),
        isSubmitting: false,
      );
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      changeProps(
        verifyStatus: ApiResultStatus.error(error: Exception(e.toString())),
        isSubmitting: false,
        otpError: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
