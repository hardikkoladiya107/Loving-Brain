import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/mood_repo.dart';
import 'package:loving_brain/ui/reflect_your_emotions/bloc/reflect_emotion_state.dart';

import '../../../model/api_result_status.dart';

class ReflectEmotionCubit extends Cubit<ReflectEmotionState> {
  ReflectEmotionCubit() : super(ReflectEmotionState());

  void init() async {
    emit(ReflectEmotionState(userModel: preferences.getUserModel()));
    await loadChildren();
    await fetchChildFromFirestore();
    await _loadEmotionLogs();
    await _selectInitialWeek();
  }

  void changeProps({
    ApiResultStatus? emotionsLogApiResult,
    ApiResultStatus? childrenListApiResult,
    UserModel? userModel,
    List<MoodLogModel>? logs,
    WeekRange? selectedWeek,
    ApiResultStatus? apiResultStatus,
    ChildModel? childModel,
    List<ChildModel>? children,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        emotionsLogApiResult:
            emotionsLogApiResult ?? state.emotionsLogApiResult,
        logs: logs ?? state.logs,
        apiResultStatus: apiResultStatus ?? ApiResultStatus.initial(),
        childrenListApiResult:
            childrenListApiResult ?? state.childrenListApiResult,
        selectedWeek: selectedWeek ?? state.selectedWeek,
        childModel: childModel ?? state.childModel,
        children: children ?? state.children,
      ),
    );
  }

  Future<void> _loadEmotionLogs() async {
    changeProps(emotionsLogApiResult: ApiResultStatus.loading());
    var apiResultStatus = await MoodRepo.instance.fetchAllMoodLogs();
    changeProps(emotionsLogApiResult: apiResultStatus);
    apiResultStatus.whenOrNull(
      data: (data) {
        if (data is List<MoodLogModel>) {
          changeProps(logs: data);
        }
      },
    );
  }

  List<WeekRange> getAllWeeks() {
    List<MoodLogModel> logs = [];
    logs.addAll(state.logs);
    if (logs.isEmpty) return [];

    logs.sort((a, b) => a.logTime.compareTo(b.logTime));

    final firstDate = logs.first.logTime;
    final lastDate = logs.last.logTime;

    DateTime startOfWeek = _startOfWeek(firstDate);

    List<WeekRange> weeks = [];

    while (startOfWeek.isBefore(lastDate)) {
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      weeks.add(WeekRange(startOfWeek, endOfWeek));
      startOfWeek = startOfWeek.add(const Duration(days: 7));
    }

    return weeks;
  }

  WeekRange? getCurrentWeekFromList(List<WeekRange> allWeeks) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    for (final w in allWeeks) {
      final start = DateTime(w.start.year, w.start.month, w.start.day);
      final end = DateTime(w.end.year, w.end.month, w.end.day);

      if (!todayDate.isBefore(start) && !todayDate.isAfter(end)) {
        return w;
      }
    }

    return null;
  }

  void nextWeek() {
    final allWeeks = getAllWeeks();
    if (allWeeks.isEmpty) return;

    final selected = state.selectedWeek;

    // If no week is selected → select CURRENT WEEK
    if (selected == null) {
      final current = getCurrentWeekFromList(allWeeks);
      changeProps(selectedWeek: current ?? allWeeks.first);
    }

    final index = allWeeks.indexWhere(
      (w) =>
          w.start.year == selected!.start.year &&
          w.start.month == selected.start.month &&
          w.start.day == selected.start.day,
    );

    if (index == -1) changeProps(selectedWeek: allWeeks.first);

    if (index >= allWeeks.length - 1) {
      changeProps(selectedWeek: allWeeks[index]);
      return;
    }
    changeProps(selectedWeek: allWeeks[index + 1]);
  }

  void previousWeek() {
    final allWeeks = getAllWeeks();
    if (allWeeks.isEmpty) return;

    final selected = state.selectedWeek;

    // If no week is selected → select CURRENT WEEK
    if (selected == null) {
      final current = getCurrentWeekFromList(allWeeks);
      changeProps(selectedWeek: current ?? allWeeks.last);
      return;
    }

    // Find index of selected
    final index = allWeeks.indexWhere(
      (w) =>
          w.start.year == selected.start.year &&
          w.start.month == selected.start.month &&
          w.start.day == selected.start.day,
    );

    if (index == -1) {
      changeProps(selectedWeek: allWeeks.last);
      return;
    }

    // If already first → stay same
    if (index <= 0) {
      changeProps(selectedWeek: allWeeks[index]);
      return;
    }

    // Move to previous week
    changeProps(selectedWeek: allWeeks[index - 1]);
  }

  DateTime _startOfWeek(DateTime date) {
    // In Dart: weekday: Mon=1 ... Sun=7
    int diff = date.weekday % 7; // Sunday = 0
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: diff));
  }

  List<MoodLogModel> getLogsForWeek() {
    if (state.selectedWeek == null) return [];
    return state.logs.where((log) {
      final t = log.logTime;
      return t.isAfter(
            state.selectedWeek!.start.subtract(const Duration(seconds: 1)),
          ) &&
          t.isBefore(state.selectedWeek!.end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<void> _selectInitialWeek() async {
    List<WeekRange> weeks = getAllWeeks();

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

  /// Returns a list of 7 integers representing counts for each day of the week:
  /// [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday].
  List<double> countMoodLogsByDay() {
    if (state.selectedWeek == null) {
      return [0, 0, 0, 0, 0, 0, 0];
    }
    // Initialize counts to zero for 7 days
    final counts = List<double>.filled(7, 0);

    // Truncate start and end to date-only (midnight) to avoid time-of-day issues
    final weekStart = DateTime(
      state.selectedWeek!.start.year,
      state.selectedWeek!.start.month,
      state.selectedWeek!.start.day,
    );
    final weekEnd = DateTime(
      state.selectedWeek!.end.year,
      state.selectedWeek!.end.month,
      state.selectedWeek!.end.day,
    );

    for (final log in state.logs) {
      // Convert each log time to date-only in the same local/UTC basis as range
      final logDate = DateTime(
        log.logTime.year,
        log.logTime.month,
        log.logTime.day,
      );

      // check inclusive range
      if (!logDate.isBefore(weekStart) && !logDate.isAfter(weekEnd)) {
        final index = logDate.difference(weekStart).inDays;
        if (index >= 0 && index < 7) {
          counts[index] += 1;
        }
      }
    }

    return counts;
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
}
