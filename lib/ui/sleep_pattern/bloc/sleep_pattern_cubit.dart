import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'sleep_pattern_state.dart';

/// Cubit managing Sleep Pattern (Screen 26).
class SleepPatternCubit extends Cubit<SleepPatternState> {
  SleepPatternCubit() : super(const SleepPatternState());

  /// Central state emitter adhering to AGENTS.md Rule 4.2.
  void changeProps({
    bool? isLoading,
    int? selectedToggleIndex,
    String? childName,
    double? averageSleepHours,
    int? consistencyScore,
    String? patternInsight,
    String? patternDetail,
    List<double>? dailySleepHours,
    bool? hasData,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        selectedToggleIndex: selectedToggleIndex ?? state.selectedToggleIndex,
        childName: childName ?? state.childName,
        averageSleepHours: averageSleepHours ?? state.averageSleepHours,
        consistencyScore: consistencyScore ?? state.consistencyScore,
        patternInsight: patternInsight ?? state.patternInsight,
        patternDetail: patternDetail ?? state.patternDetail,
        dailySleepHours: dailySleepHours ?? state.dailySleepHours,
        hasData: hasData ?? state.hasData,
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

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> result = await TodayLogRepo
          .instance
          .getRecentSleepLogs(childId, limit: 14);
      if (result is Data<List<SleepLogModel>>) {
        sleepLogs = result.data;
      }
    }

    if (sleepLogs.isNotEmpty) {
      final List<double> dailyHours = <double>[];
      double totalHours = 0.0;
      int shortNapCount = 0;

      for (int i = 0; i < sleepLogs.length && i < 7; i++) {
        final SleepLogModel log = sleepLogs[i];
        final int mins =
            log.durationMinutes ??
            log.wakeTime.difference(log.bedTime).inMinutes.abs();
        final double hours = (mins / 60.0).clamp(0.0, 16.0);
        dailyHours.add(double.parse(hours.toStringAsFixed(1)));
        totalHours += hours;

        if (mins < 45) {
          shortNapCount++;
        }
      }

      while (dailyHours.length < 6) {
        dailyHours.add(5.0);
      }

      final double avg = dailyHours.isNotEmpty
          ? double.parse(
              (totalHours / (dailyHours.length.clamp(1, 7))).toStringAsFixed(1),
            )
          : 10.5;

      final bool hasShorterNaps = shortNapCount >= 1;
      final String insight = hasShorterNaps
          ? "Naps have been shorter this week."
          : "Sleep rhythm has been consistent.";
      final String detail = hasShorterNaps
          ? "Shorter naps tend to show up as harder evenings with earlier tiredness."
          : "Bedtime and wake rhythms are staying within predictable windows.";

      changeProps(
        isLoading: false,
        childName: cName,
        averageSleepHours: avg,
        consistencyScore: (85 + (sleepLogs.length * 2)).clamp(70, 95),
        patternInsight: insight,
        patternDetail: detail,
        dailySleepHours: dailyHours,
        hasData: true,
      );
    } else {
      changeProps(
        isLoading: false,
        childName: cName,
        averageSleepHours: 10.5,
        consistencyScore: 85,
        patternInsight: "Still learning $cName's sleep pattern.",
        patternDetail:
            "Add sleep updates to see personalized weekly rest rhythms.",
        dailySleepHours: <double>[5.0, 5.0, 3.0, 5.0, 2.0, 6.0],
        hasData: false,
      );
    }
  }

  void setToggleIndex(int index) => changeProps(selectedToggleIndex: index);
}
