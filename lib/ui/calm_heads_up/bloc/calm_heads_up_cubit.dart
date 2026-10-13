import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'calm_heads_up_state.dart';

class CalmHeadsUpCubit extends Cubit<CalmHeadsUpState> {
  CalmHeadsUpCubit() : super(const CalmHeadsUpState());

  void init({ChildModel? childModel}) {
    emit(const CalmHeadsUpState());
    _loadBehaviourForecast(childModel);
  }

  void changeProps({
    bool? isLoading,
    ApiResultStatus? fetchStatus,
    BehaviourForecastResult? forecast,
    String? childName,
    String? headline,
    String? reason,
    String? windowStart,
    String? windowEnd,
    int? confidenceDots,
    String? confidenceLabel,
    List<String>? contributingSignals,
    String? healthCaveat,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
        forecast: forecast ?? state.forecast,
        childName: childName ?? state.childName,
        headline: headline ?? state.headline,
        reason: reason ?? state.reason,
        windowStart: windowStart ?? state.windowStart,
        windowEnd: windowEnd ?? state.windowEnd,
        confidenceDots: confidenceDots ?? state.confidenceDots,
        confidenceLabel: confidenceLabel ?? state.confidenceLabel,
        contributingSignals: contributingSignals ?? state.contributingSignals,
        healthCaveat: healthCaveat ?? state.healthCaveat,
      ),
    );
  }

  Future<void> _loadBehaviourForecast(ChildModel? explicitChild) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    ChildModel? child = explicitChild ?? preferences.getChildModel();
    final String childId =
        child?.reference?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];
    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<MoodLogModel> moodLogs = <MoodLogModel>[];
    List<HealthLogModel> healthLogs = <HealthLogModel>[];

    if (childId.isNotEmpty) {
      try {
        final ApiResultStatus<List<TantrumLogModel>> tantrumRes =
            await TodayLogRepo.instance.getRecentTantrumLogs(childId);
        if (tantrumRes is Data<List<TantrumLogModel>>) {
          tantrumLogs = tantrumRes.data;
        }

        final ApiResultStatus<List<SleepLogModel>> sleepRes = await TodayLogRepo
            .instance
            .getRecentSleepLogs(childId);
        if (sleepRes is Data<List<SleepLogModel>>) {
          sleepLogs = sleepRes.data;
        }

        final ApiResultStatus<List<MoodLogModel>> moodRes = await TodayLogRepo
            .instance
            .getRecentMoodLogs(childId);
        if (moodRes is Data<List<MoodLogModel>>) {
          moodLogs = moodRes.data;
        }

        final ApiResultStatus<List<HealthLogModel>> healthRes =
            await TodayLogRepo.instance.getRecentHealthLogs(childId);
        if (healthRes is Data<List<HealthLogModel>>) {
          healthLogs = healthRes.data;
        }
      } catch (_) {}
    }

    final BehaviourForecastResult forecast =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child,
          tantrumLogs: tantrumLogs,
          sleepLogs: sleepLogs,
          moodLogs: moodLogs,
          healthLogs: healthLogs,
        );

    changeProps(
      isLoading: false,
      fetchStatus: const ApiResultStatus.data(data: null),
      forecast: forecast,
      childName: forecast.childName,
      headline: forecast.headline,
      reason: forecast.reason,
      windowStart: forecast.windowStart,
      windowEnd: forecast.windowEnd,
      confidenceDots: forecast.confidenceDots,
      confidenceLabel: forecast.confidenceLabel,
      contributingSignals: forecast.contributingSignals,
      healthCaveat: forecast.healthCaveat,
    );
  }
}
