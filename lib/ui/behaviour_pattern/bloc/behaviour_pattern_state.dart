import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'behaviour_pattern_state.freezed.dart';

@freezed
abstract class BehaviourPatternState with _$BehaviourPatternState {
  const factory BehaviourPatternState({
    @Default(false) bool isLoading,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    BehaviourPatternSummary? summary,
    @Default(0) int totalTantrums,
    @Default('5:00 PM – 7:00 PM') String mostCommonTimeWindow,
    @Default(<String>['Tiredness', 'Transitions']) List<String> topTriggers,
    @Default(<String>['Lowering stimulation', 'Quiet connection'])
    List<String> topHelpedStrategies,
    @Default(0.5) double averageIntensity,
    @Default('Harder moments most often follow tiredness and transition load.')
    String insightText,
    @Default('your child') String childName,
  }) = _BehaviourPatternState;
}
