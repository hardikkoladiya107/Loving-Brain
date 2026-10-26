import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'calm_plan_state.freezed.dart';

@freezed
abstract class CalmPlanState with _$CalmPlanState {
  const factory CalmPlanState({
    @Default(false) bool isLoading,
    @Default(false) bool isAudioPlaying,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    BehaviourForecastResult? forecast,
    @Default(<CalmPlanAction>[
      CalmPlanAction(
        stepNumber: '1',
        title: 'Lower stimulation now',
        description:
            'Dim the room, turn off background noise, and pause high-energy play.',
      ),
      CalmPlanAction(
        stepNumber: '2',
        title: 'Offer a quiet, familiar activity',
        description: 'Choose something familiar without demands.',
      ),
      CalmPlanAction(
        stepNumber: '3',
        title: 'Stay close and steady',
        description:
            'Your calm physical presence is the clearest safety signal.',
      ),
    ])
    List<CalmPlanAction> actions,
    @Default("Don't introduce a new demand right now")
    String avoidInstructionTitle,
    @Default(
      'Requests, transitions, and boundary debates can wait until your child has settled.',
    )
    String avoidInstructionSubtitle,
    @Default('your child') String childName,
    @Default(0) int audioPositionSeconds,
    @Default(180) int audioDurationSeconds,
  }) = _CalmPlanState;
}
