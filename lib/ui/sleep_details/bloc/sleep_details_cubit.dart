import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'sleep_details_state.dart';

/// Cubit managing Sleep Details (Screen 24).
class SleepDetailsCubit extends Cubit<SleepDetailsState> {
  SleepDetailsCubit() : super(const SleepDetailsState());

  /// Central state emitter adhering to AGENTS.md Rule 4.2.
  void changeProps({
    bool? isLoading,
    String? timeInSleep,
    String? wakeUpTime,
    String? wentToBed,
    String? fellAsleepTime,
    String? sleepQuality,
    String? windowStart,
    String? windowEnd,
    String? bedtimeEstimate,
    String? confidenceLabel,
    int? confidenceDots,
    String? childName,
    String? whyWeExpectIt,
    String? whatCouldChange,
    bool? hasRealLogs,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        timeInSleep: timeInSleep ?? state.timeInSleep,
        wakeUpTime: wakeUpTime ?? state.wakeUpTime,
        wentToBed: wentToBed ?? state.wentToBed,
        fellAsleepTime: fellAsleepTime ?? state.fellAsleepTime,
        sleepQuality: sleepQuality ?? state.sleepQuality,
        windowStart: windowStart ?? state.windowStart,
        windowEnd: windowEnd ?? state.windowEnd,
        bedtimeEstimate: bedtimeEstimate ?? state.bedtimeEstimate,
        confidenceLabel: confidenceLabel ?? state.confidenceLabel,
        confidenceDots: confidenceDots ?? state.confidenceDots,
        childName: childName ?? state.childName,
        whyWeExpectIt: whyWeExpectIt ?? state.whyWeExpectIt,
        whatCouldChange: whatCouldChange ?? state.whatCouldChange,
        hasRealLogs: hasRealLogs ?? state.hasRealLogs,
      ),
    );
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

    String calcTimeInSleep = '6h 52m';
    String calcWakeUpTime = '07:12 AM';
    String calcWentToBed = '08:00 PM';
    String calcFellAsleepTime = 'None';
    String calcQuality = '4/5';
    final bool hasLogs = sleepLogs.isNotEmpty;

    if (hasLogs) {
      final SleepLogModel latest = sleepLogs.first;
      final int diffMins =
          latest.durationMinutes ??
          latest.wakeTime.difference(latest.bedTime).inMinutes.abs();
      final int hours = diffMins ~/ 60;
      final int mins = diffMins % 60;
      calcTimeInSleep = '${hours}h ${mins}m';

      final DateFormat fmt = DateFormat('hh:mm a');
      calcWakeUpTime = latest.wokeUpTime ?? fmt.format(latest.wakeTime);
      calcWentToBed = latest.fellAsleepTime ?? fmt.format(latest.bedTime);
      calcQuality = '${latest.sleepQualityIndex + 1}/5';
      calcFellAsleepTime = latest.isNightWaking ? '1 waking' : 'None';
    }

    changeProps(
      isLoading: false,
      childName: cName,
      windowStart: forecast.windowStart,
      windowEnd: forecast.windowEnd,
      bedtimeEstimate: forecast.bedtimeEstimate,
      confidenceLabel: forecast.confidenceLabel,
      confidenceDots: forecast.confidenceDots,
      whyWeExpectIt: forecast.reason,
      whatCouldChange:
          forecast.healthCaveat ??
          "Illness, travel or a change of setting can make today less predictable.",
      timeInSleep: calcTimeInSleep,
      wakeUpTime: calcWakeUpTime,
      wentToBed: calcWentToBed,
      fellAsleepTime: calcFellAsleepTime,
      sleepQuality: calcQuality,
      hasRealLogs: hasLogs,
    );
  }
}
