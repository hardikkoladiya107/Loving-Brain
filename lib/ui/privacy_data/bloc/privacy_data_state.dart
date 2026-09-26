import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_data_state.freezed.dart';

@freezed
abstract class PrivacyDataState with _$PrivacyDataState {
  const factory PrivacyDataState() = _PrivacyDataState;
}
