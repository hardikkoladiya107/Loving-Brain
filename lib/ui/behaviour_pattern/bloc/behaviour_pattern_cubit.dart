import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'behaviour_pattern_state.dart';

class BehaviourPatternCubit extends Cubit<BehaviourPatternState> {
  BehaviourPatternCubit() : super(const BehaviourPatternState());

  void reset() {
    emit(const BehaviourPatternState());
  }

  void init({ChildModel? childModel}) {
    emit(const BehaviourPatternState());
    _loadPatternData(childModel);
  }

  void changeProps({
    bool? isLoading,
    ApiResultStatus? fetchStatus,
    BehaviourPatternSummary? summary,
    int? totalTantrums,
    String? mostCommonTimeWindow,
    List<String>? topTriggers,
    List<String>? topHelpedStrategies,
    double? averageIntensity,
    String? insightText,
    String? childName,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
        summary: summary ?? state.summary,
        totalTantrums: totalTantrums ?? state.totalTantrums,
        mostCommonTimeWindow:
            mostCommonTimeWindow ?? state.mostCommonTimeWindow,
        topTriggers: topTriggers ?? state.topTriggers,
        topHelpedStrategies: topHelpedStrategies ?? state.topHelpedStrategies,
        averageIntensity: averageIntensity ?? state.averageIntensity,
        insightText: insightText ?? state.insightText,
        childName: childName ?? state.childName,
      ),
    );
  }

  Future<void> _loadPatternData(ChildModel? explicitChild) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = explicitChild ?? preferences.getChildModel();
    final String name =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';
    final String childId =
        child?.reference?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    List<TantrumLogModel> logs = <TantrumLogModel>[];
    if (childId.isNotEmpty) {
      try {
        final ApiResultStatus<List<TantrumLogModel>> res = await TodayLogRepo
            .instance
            .getRecentTantrumLogs(childId);
        if (res is Data<List<TantrumLogModel>>) {
          logs = res.data;
        }
      } catch (_) {}
    }

    final BehaviourPatternSummary summary =
        EnergyBridgeBehaviourCalculator.aggregatePattern(
          logs: logs,
          childName: name,
        );

    changeProps(
      isLoading: false,
      fetchStatus: const ApiResultStatus.data(data: null),
      summary: summary,
      totalTantrums: summary.totalTantrums,
      mostCommonTimeWindow: summary.mostCommonTimeWindow,
      topTriggers: summary.topTriggers,
      topHelpedStrategies: summary.topHelpedStrategies,
      averageIntensity: summary.averageIntensity,
      insightText: summary.insightText,
      childName: name,
    );
  }
}
