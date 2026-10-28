import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'sleep_forecast_state.dart';

/// Cubit managing Sleep Forecast (Screen 23) powered by EnergyBridge.
class SleepForecastCubit extends Cubit<SleepForecastState> {
  SleepForecastCubit() : super(const SleepForecastState());

  /// Central state emitter adhering to AGENTS.md Rule 4.2.
  void changeProps({
    bool? isLoading,
    int? selectedDayIndex,
    String? parentName,
    String? childName,
    String? timeOfDayGreeting,
    String? windowStart,
    String? windowEnd,
    String? bedtimeEstimate,
    String? reason,
    String? subtitle,
    String? confidenceLevel,
    int? confidenceDots,
    List<TonightPlanStep>? planSteps,
    bool? hasRealLogs,
    List<int>? loggedDays,
    String? healthCaveat,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        selectedDayIndex: selectedDayIndex ?? state.selectedDayIndex,
        parentName: parentName ?? state.parentName,
        childName: childName ?? state.childName,
        timeOfDayGreeting: timeOfDayGreeting ?? state.timeOfDayGreeting,
        windowStart: windowStart ?? state.windowStart,
        windowEnd: windowEnd ?? state.windowEnd,
        bedtimeEstimate: bedtimeEstimate ?? state.bedtimeEstimate,
        reason: reason ?? state.reason,
        subtitle: subtitle ?? state.subtitle,
        confidenceLevel: confidenceLevel ?? state.confidenceLevel,
        confidenceDots: confidenceDots ?? state.confidenceDots,
        planSteps: planSteps ?? state.planSteps,
        hasRealLogs: hasRealLogs ?? state.hasRealLogs,
        loggedDays: loggedDays ?? state.loggedDays,
        healthCaveat: healthCaveat ?? state.healthCaveat,
      ),
    );
  }

  Future<void> init() async {
    changeProps(isLoading: true);

    final int hour = DateTime.now().hour;
    String greeting = 'GOOD MORNING';
    if (hour >= 12 && hour < 17) {
      greeting = 'GOOD AFTERNOON';
    } else if (hour >= 17) {
      greeting = 'GOOD EVENING';
    }

    final String pName = (preferences.getUserModel()?.parentName ?? 'Parent')
        .toUpperCase();
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
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

    final DateTime now = DateTime.now();
    final int todayWeekdayIndex = (now.weekday - 1) % 7;
    final DateTime monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: todayWeekdayIndex));
    final List<int> loggedWeekdays = <int>[];
    for (final SleepLogModel log in sleepLogs) {
      final DateTime logDay = DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      );
      final int diff = logDay.difference(monday).inDays;
      if (diff >= 0 && diff < 7 && !loggedWeekdays.contains(diff)) {
        loggedWeekdays.add(diff);
      }
    }

    changeProps(
      isLoading: false,
      selectedDayIndex: todayWeekdayIndex,
      parentName: pName,
      childName: cName,
      timeOfDayGreeting: greeting,
      windowStart: forecast.windowStart,
      windowEnd: forecast.windowEnd,
      bedtimeEstimate: forecast.bedtimeEstimate,
      reason: forecast.reason,
      subtitle: forecast.subtitle,
      confidenceLevel: forecast.confidenceLabel,
      confidenceDots: forecast.confidenceDots,
      planSteps: forecast.planSteps,
      hasRealLogs: forecast.hasPersonalLogs,
      loggedDays: loggedWeekdays,
      healthCaveat: forecast.healthCaveat,
    );
  }

  void selectDay(int index) => changeProps(selectedDayIndex: index);
}
