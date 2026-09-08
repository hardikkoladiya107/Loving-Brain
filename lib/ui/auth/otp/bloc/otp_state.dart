import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../model/api_result_status.dart';

part 'otp_state.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    @Default('') String otpCode,
    @Default('') String otpError,
    @Default(ApiResultStatus.initial()) ApiResultStatus verifyStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus resendStatus,
    @Default(false) bool isSubmitting,
    @Default(30) int resendCountdown,
    @Default(false) bool canResend,
    @Default('') String destination,
  }) = _OtpState;
}
