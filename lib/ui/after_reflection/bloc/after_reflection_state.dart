import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'after_reflection_state.freezed.dart';

@freezed
abstract class AfterReflectionState with _$AfterReflectionState {
  const factory AfterReflectionState({
    @Default(false) bool isLoading,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
    @Default('') String beforeEvent,
    @Default('') String durationText,
    @Default(0.0) double intensityValue,
    @Default('') String selectedHelped,
    @Default('') String selectedFeeling,
    @Default(false) bool showErrors,
  }) = _AfterReflectionState;
}
