import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/child_repo.dart';
import '../../../repo/energy_bridge_repo.dart';

class SleepSummaryCubit extends Cubit<SleepSummaryState> {
  SleepSummaryCubit() : super(SleepSummaryState());

  void init() async {
    emit(SleepSummaryState(userModel: preferences.getUserModel()));
    await _loadChildren();
    await _fetchChildFromFirestore();
    await _loadSleepLogs();
    await _selectInitialWeek();
  }

  Future<void> reload() async {
    await _loadSleepLogs();
    await _selectInitialWeek();
  }

  void changeProps({
    ChildModel? childModel,
    WeekRange? selectedWeek,
    List<WeekRange>? weeks,
    List<ChildModel>? children,
    List<SleepLogModel>? sleepLogs,
    UserModel? userModel,
    ApiResultStatus? addEssentialsApiResult,
    ApiResultStatus? uploadDocumentApiResultStatus,
    ApiResultStatus? addSleepLogApiResult,
    ApiResultStatus? childrenListApiResult,
    ApiResultStatus? getSleepLogsApiResult,
    String? titleError,
    String? descriptionError,
    List<String>? documentsList,
    DateTime? selectedDate,
    DateTime? selectedBedTime,
    DateTime? selectedWakeTime,
    String? notes,
    String? bedTimeError,
    String? selectedDateError,
    String? wakeUpTimeError,
    String? notesError,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        childrenListApiResult:
            childrenListApiResult ?? ApiResultStatus.initial(),
        addSleepLogApiResult: addSleepLogApiResult ?? ApiResultStatus.initial(),
        getSleepLogsApiResult:
            getSleepLogsApiResult ?? ApiResultStatus.initial(),
        childList: children ?? state.childList,
        sleepLogs: sleepLogs ?? state.sleepLogs,
        selectedWeek: selectedWeek ?? state.selectedWeek,
        weeks: weeks ?? state.weeks,
        selectedDate: selectedDate ?? state.selectedDate,
        selectedBedTime: selectedBedTime ?? state.selectedBedTime,
        selectedWakeTime: selectedWakeTime ?? state.selectedWakeTime,
        notes: notes ?? state.notes,
        bedTimeError: bedTimeError ?? state.bedTimeError,
        selectedDateError: selectedDateError ?? state.selectedDateError,
        wakeUpTimeError: wakeUpTimeError ?? state.wakeUpTimeError,
        notesError: notesError ?? state.notesError,
      ),
    );
  }

  Future<void> _fetchChildFromFirestore({DocumentReference? refVal}) async {
    try {
      final DocumentReference? ref = refVal ?? state.userModel?.defaultChild;
      if (ref == null) return;
      final snapshot = await ref.get();
      final data = snapshot.data();
      if (data != null) {
        changeProps(
          childModel: ChildModel.fromJson(data as Map<String, dynamic>, ref),
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch child: $e');
    }
  }

  Future<void> _loadChildren() async {
    if (state.userModel != null) {
      changeProps(
        childrenListApiResult: ApiResultStatus.loading(),
        children: [],
      );
      ApiResultStatus childrenListApiResult = await ChildRepo.instance
          .getAllChildren(state.userModel!);
      childrenListApiResult.whenOrNull(
        data: (data) {
          changeProps(
            childrenListApiResult: ApiResultStatus.data(data: data),
            children: data,
            childModel: data.isNotEmpty ? data.first : null,
          );
        },
        error: (error) {
          changeProps(
            childrenListApiResult: ApiResultStatus.error(
              error: Exception("Failed to load children"),
            ),
          );
        },
      );
    }
  }

  bool _validateSleepLog() {
    bool isValid = true;

    if (state.selectedDate == null) {
      changeProps(selectedDateError: "Please select Date");
      isValid = false;
    } else {
      changeProps(selectedDateError: "");
    }

    if (state.selectedBedTime == null) {
      changeProps(bedTimeError: "Please select bed time");
      isValid = false;
    } else {
      changeProps(bedTimeError: "");
    }

    if (state.selectedWakeTime == null) {
      changeProps(wakeUpTimeError: "Please select wake up time");
      isValid = false;
    } else {
      changeProps(wakeUpTimeError: "");
    }

    if ((state.notes ?? "").isEmpty) {
      changeProps(notesError: "Please enter notes");
      isValid = false;
    } else {
      changeProps(notesError: "");
    }

    if (isValid &&
        state.selectedBedTime != null &&
        state.selectedWakeTime != null) {
      if (!state.selectedWakeTime!.isAfter(state.selectedBedTime!)) {
        changeProps(wakeUpTimeError: "Wake time must be after bed time");
        isValid = false;
      } else {
        final duration = state.selectedWakeTime!.difference(
          state.selectedBedTime!,
        );
        if (duration.inHours > 24) {
          changeProps(wakeUpTimeError: "Sleep duration cannot exceed 24 hours");
          isValid = false;
        }
      }
    }

    return isValid;
  }

  Future<void> addSleepLog() async {
    if (state.childModel?.reference?.id == null) {
      changeProps(
        addSleepLogApiResult: ApiResultStatus.error(
          error: Exception("Child not found"),
        ),
      );
      return;
    }
    if (_validateSleepLog()) {
      changeProps(addSleepLogApiResult: ApiResultStatus.loading());
      try {
        ApiResultStatus apiResultStatus = await SleepLogRepo.instance
            .addSleepLog(
              state.childModel!.reference!.id,
              SleepLogModel(
                id: "",
                ref: null,
                date: state.selectedDate!,
                bedTime: state.selectedBedTime!,
                wakeTime: state.selectedWakeTime!,
                notes: state.notes,
              ),
            );
        changeProps(addSleepLogApiResult: apiResultStatus);
        await _syncEnergyBridgeOnSleep(apiResultStatus);
      } catch (e) {
        changeProps(addSleepLogApiResult: ApiResultStatus.initial());
      }
    }
  }

  Future<void> _syncEnergyBridgeOnSleep(ApiResultStatus apiResultStatus) async {
    final String? childId = state.childModel?.reference?.id;
    final String uid = state.userModel?.uid ?? '';
    if ((childId ?? '').isEmpty || uid.isEmpty) return;

    bool isSuccess = false;
    apiResultStatus.whenOrNull(data: (_) => isSuccess = true);
    if (!isSuccess) return;

    await EnergyBridgeRepo.instance.resetTimer(
      childId: childId!,
      actorUid: uid,
      reason: 'sleep',
    );
  }

  Future<void> _loadSleepLogs() async {
    if (state.childModel?.reference?.id == null) {
      return;
    }

    changeProps(getSleepLogsApiResult: ApiResultStatus.loading());
    ApiResultStatus apiResultStatus = await SleepLogRepo.instance
        .getSleepLogsForChild(state.childModel!.reference!.id);
    changeProps(getSleepLogsApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        changeProps(sleepLogs: data);
      },
    );
  }

  Future<void> deleteSleepLog(String logId) async {
    if (state.childModel == null) return;

    // Add loading indicator here if needed, but we can do it optimistically or wait for reload.
    ApiResultStatus result = await SleepLogRepo.instance.deleteSleepLog(
      child: state.childModel!,
      sleepLogId: logId,
    );

    result.whenOrNull(
      data: (_) {
        reload(); // Reload sleep logs after successful deletion
      },
    );
  }

  Future<void> _selectInitialWeek() async {
    List<WeekRange> weeks = SleepLogRepo.instance.getWeeksWithLogsOffline(
      state.sleepLogs,
    );
    changeProps(weeks: weeks);

    if (weeks.isEmpty) return;

    final now = DateTime.now();

    // 1. If current date is inside any week → return that
    for (final w in weeks) {
      if (now.isAfter(w.start) &&
          now.isBefore(w.end.add(const Duration(days: 1)))) {
        changeProps(selectedWeek: w);
      }
    }
    changeProps(selectedWeek: weeks.last);
  }

  String getTotalSleepStringForWeek() {
    final selectedWeek = state.selectedWeek; // store locally

    if (selectedWeek == null) return "0 hr 0 min";

    double totalMinutes = 0;

    for (final log in state.sleepLogs) {
      // Normalize dates to compare
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);

      final weekStart = DateTime(
        selectedWeek.start.year,
        selectedWeek.start.month,
        selectedWeek.start.day,
      );

      final weekEnd = DateTime(
        selectedWeek.end.year,
        selectedWeek.end.month,
        selectedWeek.end.day,
      );

      if (logDate.isBefore(weekStart) || logDate.isAfter(weekEnd)) continue;

      DateTime bt = log.bedTime;
      DateTime wt = log.wakeTime;

      // If wake is same or before bedtime → assume next day wake
      if (!wt.isAfter(bt)) {
        wt = wt.add(const Duration(days: 1));
      }

      final duration = wt.difference(bt);
      totalMinutes += duration.inMinutes;
    }

    final hours = totalMinutes ~/ 60;
    final minutes = (totalMinutes % 60).toInt();

    return "$hours hr $minutes min";
  }

  String getAverageBedTimeString() {
    final selectedWeek = state.selectedWeek;
    if (selectedWeek == null) return "--";

    int total = 0;
    int count = 0;

    final weekStart = DateTime(
      selectedWeek.start.year,
      selectedWeek.start.month,
      selectedWeek.start.day,
    );

    final weekEnd = DateTime(
      selectedWeek.end.year,
      selectedWeek.end.month,
      selectedWeek.end.day,
    );

    for (final log in state.sleepLogs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);

      if (logDate.isBefore(weekStart) || logDate.isAfter(weekEnd)) continue;

      total += log.bedTime.hour * 60 + log.bedTime.minute;
      count++;
    }

    if (count == 0) return "--";

    int avg = total ~/ count;
    return _formatMinutesToTimeString(avg);
  }

  String getAverageWakeTimeString() {
    final selectedWeek = state.selectedWeek;
    if (selectedWeek == null) return "--";

    int total = 0;
    int count = 0;

    final weekStart = DateTime(
      selectedWeek.start.year,
      selectedWeek.start.month,
      selectedWeek.start.day,
    );

    final weekEnd = DateTime(
      selectedWeek.end.year,
      selectedWeek.end.month,
      selectedWeek.end.day,
    );

    for (final log in state.sleepLogs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);

      if (logDate.isBefore(weekStart) || logDate.isAfter(weekEnd)) continue;

      total += log.wakeTime.hour * 60 + log.wakeTime.minute;
      count++;
    }

    if (count == 0) return "--";

    int avg = total ~/ count;
    return _formatMinutesToTimeString(avg);
  }

  String _formatMinutesToTimeString(int minutes) {
    int hour = minutes ~/ 60;
    int minute = minutes % 60;

    bool isPM = hour >= 12;
    int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    String minStr = minute.toString().padLeft(2, '0');

    return "$hour12:$minStr ${isPM ? 'pm' : 'am'}";
  }
}
