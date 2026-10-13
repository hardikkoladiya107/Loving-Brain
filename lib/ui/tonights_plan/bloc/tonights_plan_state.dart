import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';

part 'tonights_plan_state.freezed.dart';

@freezed
abstract class TonightsPlanState with _$TonightsPlanState {
  const factory TonightsPlanState({
    @Default(false) bool isLoading,
    @Default(false) bool isPlanStarted,
    @Default(false) bool isAudioPlaying,
    @Default('your child') String childName,
    @Default('08:10 PM') String bedtimeEstimate,
    @Default('07:45 PM') String windowStart,
    @Default('08:15 PM') String windowEnd,
    @Default('Moderate') String confidenceLabel,
    @Default([]) List<TonightPlanStep> planSteps,
    @Default("Today's rest indicates normal wake pressure.") String reason,
  }) = _TonightsPlanState;
}
