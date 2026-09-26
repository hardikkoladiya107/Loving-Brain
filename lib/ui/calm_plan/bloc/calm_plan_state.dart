import 'package:freezed_annotation/freezed_annotation.dart';

part 'calm_plan_state.freezed.dart';

@freezed
abstract class CalmPlanState with _$CalmPlanState {
  const factory CalmPlanState({
    @Default(false) bool isLoading,
    @Default(false) bool isAudioPlaying,
  }) = _CalmPlanState;
}
