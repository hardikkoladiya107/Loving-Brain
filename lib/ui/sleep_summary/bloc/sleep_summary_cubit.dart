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

class SleepSummaryCubit extends Cubit<SleepSummaryState> {
  SleepSummaryCubit() : super(SleepSummaryState());

  void init() async {
    emit(SleepSummaryState(userModel: preferences.getUserModel()));
    await loadChildren();
    await fetchChildFromFirestore();
    await loadSleepLogs();
    await _selectInitialWeek();
  }

  Future<void> reload() async {
    await loadSleepLogs();
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
    DateTime? date,
    DateTime? bedTime,
    DateTime? wakeTime,
    String? notes,
    String? msg,
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
        date: date ?? state.date,
        bedTime: bedTime ?? state.bedTime,
        wakeTime: wakeTime ?? state.wakeTime,
        notes: notes ?? state.notes,
        sleepLogs: sleepLogs ?? state.sleepLogs,
        selectedWeek: selectedWeek ?? state.selectedWeek,
        weeks: weeks ?? state.weeks,
        msg: msg,
      ),
    );
  }

  Future<void> fetchChildFromFirestore({DocumentReference? refVal}) async {
    try {
      DocumentReference ref = refVal ?? state.userModel!.defaultChild!;
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

  bool isValidate({required String title, required String description}) {
    if (title.isEmpty) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.initial(),
        titleError: "Please provide title",
      );
      return false;
    }
    if (description.isEmpty) {
      changeProps(
        addEssentialsApiResult: ApiResultStatus.initial(),
        descriptionError: "Please provide description",
      );
      return false;
    }
    return true;
  }

  Future<void> loadChildren() async {
    changeProps(childrenListApiResult: ApiResultStatus.loading(), children: []);
    if (state.userModel != null) {
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

  void clearSleepLogForm() {
    emit(state.copyWith(date: null, bedTime: null, wakeTime: null, notes: ""));
  }

  Future<void> addSleepLog() async {
    changeProps(msg: "");
    if (state.childModel == null) {
      changeProps(msg: "No child selected");

      return;
    }
    if (state.date == null) {
      changeProps(msg: "Please Select Date");

      return;
    }
    if (state.bedTime == null) {
      changeProps(msg: "Please Select Bed Time");
      return;
    }
    if (state.wakeTime == null) {
      changeProps(msg: "Please Select Wake-up Time");
      return;
    }
    changeProps(addSleepLogApiResult: ApiResultStatus.loading());
    try {
      ApiResultStatus apiResultStatus = await SleepLogRepo.instance.addSleepLog(
        state.childModel!,
        SleepLogModel(
          id: "",
          ref: null,
          date: state.date!,
          bedTime: state.bedTime!,
          wakeTime: state.wakeTime!,
          notes: state.notes,
        ),
      );
      changeProps(addSleepLogApiResult: apiResultStatus);
    } catch (e) {
      changeProps(addSleepLogApiResult: ApiResultStatus.initial());
    }
  }

  Future<void> loadSleepLogs() async {
    changeProps(getSleepLogsApiResult: ApiResultStatus.loading());
    ApiResultStatus apiResultStatus = await SleepLogRepo.instance
        .getSleepLogsForChild(state.childModel!);

    changeProps(getSleepLogsApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        changeProps(sleepLogs: data);
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
