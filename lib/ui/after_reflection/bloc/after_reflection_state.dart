import 'package:freezed_annotation/freezed_annotation.dart';

part 'after_reflection_state.freezed.dart';

@freezed
abstract class AfterReflectionState with _$AfterReflectionState {
  const factory AfterReflectionState({
    @Default(false) bool isLoading,
    @Default(0.5) double intensityValue,
    @Default('Holding close') String selectedHelped,
    @Default('Tired') String selectedFeeling,
  }) = _AfterReflectionState;
}
