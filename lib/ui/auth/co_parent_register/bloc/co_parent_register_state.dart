import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'co_parent_register_state.freezed.dart';

@freezed
abstract class CoParentRegisterState with _$CoParentRegisterState {
  const factory CoParentRegisterState({
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String passwordError,
    @Default('') String confirmPasswordError,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    @Default(false) bool isTermsAccepted,
    @Default(ApiResultStatus.initial()) ApiResultStatus apiResultStatus,
    @Default(false) bool isSubmitting,
  }) = _CoParentRegisterState;
}
