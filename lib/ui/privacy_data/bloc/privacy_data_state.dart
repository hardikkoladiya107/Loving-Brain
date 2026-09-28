import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_data_state.freezed.dart';

@freezed
abstract class PrivacyDataState with _$PrivacyDataState {
  const factory PrivacyDataState({
    @Default('your child') String childName,
    @Default(false) bool isDeletingAccount,
    @Default(false) bool isAccountDeleted,
    @Default('') String errorMessage,
  }) = _PrivacyDataState;
}
