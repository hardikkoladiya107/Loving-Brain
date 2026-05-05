import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../model/api_result_status.dart';

part 'login_state.freezed.dart';

enum LoginSubmitAction { idle, email, google, apple }

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default("") String emailAddress,
    @Default("") String password,
    @Default("") String emailAddressError,
    @Default("") String passwordError,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    @Default(true) bool obscureTextPassword,
    @Default(LoginSubmitAction.idle) LoginSubmitAction submittingAction,
  }) = _LoginState;
}
