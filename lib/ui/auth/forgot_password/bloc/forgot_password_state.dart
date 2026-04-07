import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../model/api_result_status.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default("") String emailAddress,
    @Default("") String emailAddressError,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _ForgotPasswordState;
}
