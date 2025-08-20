import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(true) bool obscureTextPassword,
    @Default(true) bool obscureTextConfirmPassword,
    @Default("") String emailAddress,
    @Default("") String password,
    @Default("") String confirmPassword,
    @Default("") String emailAddressError,
    @Default("") String passwordError,
    @Default("") String confirmPasswordError,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
  }) = _RegisterState;
}
