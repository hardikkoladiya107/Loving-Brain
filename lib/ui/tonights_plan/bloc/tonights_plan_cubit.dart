import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'tonights_plan_state.dart';

/// Cubit managing Tonight's Plan (Screen 25).
class TonightsPlanCubit extends Cubit<TonightsPlanState> {
  TonightsPlanCubit() : super(const TonightsPlanState());

  /// Central state emitter adhering to AGENTS.md Rule 4.2.
  void changeProps({
    bool? isLoading,
    bool? isPlanStarted,
    bool? isAudioPlaying,
    String? childName,
    String? bedtimeEstimate,
    String? windowStart,
    String? windowEnd,
    String? confidenceLabel,
    List<TonightPlanStep>? planSteps,
    String? reason,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        isPlanStarted: isPlanStarted ?? state.isPlanStarted,
        isAudioPlaying: isAudioPlaying ?? state.isAudioPlaying,
        childName: childName ?? state.childName,
        bedtimeEstimate: bedtimeEstimate ?? state.bedtimeEstimate,
        windowStart: windowStart ?? state.windowStart,
        windowEnd: windowEnd ?? state.windowEnd,
        confidenceLabel: confidenceLabel ?? state.confidenceLabel,
        planSteps: planSteps ?? state.planSteps,
        reason: reason ?? state.reason,
      ),
    );
  }

  void reset() {
    emit(const TonightsPlanState());
  }

  Future<void> init() async {
    changeProps(isLoading: true);

    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    final String childId =
        child?.reference?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    HealthLogModel? todayHealthLog;

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 14);
      if (sleepResult is Data<List<SleepLogModel>>) {
        sleepLogs = sleepResult.data;
      }

      final ApiResultStatus<List<HealthLogModel>> healthResult =
          await TodayLogRepo.instance.getRecentHealthLogs(childId, limit: 5);
      if (healthResult is Data<List<HealthLogModel>>) {
        final DateTime now = DateTime.now();
        final List<HealthLogModel> recentHealth = healthResult.data;
        for (final HealthLogModel h in recentHealth) {
          if (h.timestamp.year == now.year &&
              h.timestamp.month == now.month &&
              h.timestamp.day == now.day) {
            todayHealthLog = h;
            break;
          }
        }
      }
    }

    final SleepForecastResult forecast = EnergyBridgeSleepCalculator.calculate(
      child: child,
      sleepLogs: sleepLogs,
      todayHealthLog: todayHealthLog,
    );

    changeProps(
      isLoading: false,
      childName: cName,
      bedtimeEstimate: forecast.bedtimeEstimate,
      windowStart: forecast.windowStart,
      windowEnd: forecast.windowEnd,
      confidenceLabel: forecast.confidenceLabel,
      planSteps: forecast.planSteps,
      reason: forecast.reason,
    );
  }

  void startPlan() {
    changeProps(isPlanStarted: !state.isPlanStarted);
  }

  void toggleAudio() {
    changeProps(isAudioPlaying: !state.isAudioPlaying);
  }
}
