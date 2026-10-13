import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'calm_heads_up_state.freezed.dart';

@freezed
abstract class CalmHeadsUpState with _$CalmHeadsUpState {
  const factory CalmHeadsUpState({
    @Default(false) bool isLoading,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    BehaviourForecastResult? forecast,
    @Default('your child') String childName,
    @Default('A harder window may be more likely') String headline,
    @Default('Between 5:30 and 7:00 PM — sensory load and transition today.')
    String reason,
    @Default('5:30 PM') String windowStart,
    @Default('7:00 PM') String windowEnd,
    @Default(2) int confidenceDots,
    @Default('Confidence: moderate') String confidenceLabel,
    @Default(<String>[]) List<String> contributingSignals,
    String? healthCaveat,
  }) = _CalmHeadsUpState;
}
