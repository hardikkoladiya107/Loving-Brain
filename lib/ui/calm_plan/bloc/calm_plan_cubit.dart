import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/repo/child_repo.dart';

import 'calm_plan_state.dart';

class CalmPlanCubit extends Cubit<CalmPlanState> {
  CalmPlanCubit() : super(const CalmPlanState());

  void init({BehaviourForecastResult? forecast}) {
    emit(const CalmPlanState());
    if (forecast != null) {
      changeProps(
        forecast: forecast,
        actions: forecast.actions,
        avoidInstructionTitle: forecast.avoidInstructionTitle,
        avoidInstructionSubtitle: forecast.avoidInstructionSubtitle,
        childName: forecast.childName,
      );
    } else {
      _loadDefaultPlan();
    }
  }

  void changeProps({
    bool? isLoading,
    bool? isAudioPlaying,
    ApiResultStatus? fetchStatus,
    BehaviourForecastResult? forecast,
    List<CalmPlanAction>? actions,
    String? avoidInstructionTitle,
    String? avoidInstructionSubtitle,
    String? childName,
  }) {
    emit(state.copyWith(
      isLoading: isLoading ?? state.isLoading,
      isAudioPlaying: isAudioPlaying ?? state.isAudioPlaying,
      fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      forecast: forecast ?? state.forecast,
      actions: actions ?? state.actions,
      avoidInstructionTitle:
          avoidInstructionTitle ?? state.avoidInstructionTitle,
      avoidInstructionSubtitle:
          avoidInstructionSubtitle ?? state.avoidInstructionSubtitle,
      childName: childName ?? state.childName,
    ));
  }

  void toggleAudio() {
    changeProps(isAudioPlaying: !state.isAudioPlaying);
  }

  void _loadDefaultPlan() {
    final ChildModel? child = ChildRepo.instance.selectedChildModel;
    final String name = (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    final BehaviourForecastResult forecast = EnergyBridgeBehaviourCalculator.calculate(
      childModel: child,
      tantrumLogs: <dynamic>[],
      sleepLogs: <dynamic>[],
      moodLogs: <dynamic>[],
      healthLogs: <dynamic>[],
    );

    changeProps(
      forecast: forecast,
      actions: forecast.actions,
      avoidInstructionTitle: forecast.avoidInstructionTitle,
      avoidInstructionSubtitle: forecast.avoidInstructionSubtitle,
      childName: name,
    );
  }
}
