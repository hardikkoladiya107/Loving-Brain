import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/readiness_score.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/repo/milestone_repo.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/timeline_repo.dart';
import 'package:loving_brain/ui/journal/bloc/journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit() : super(const JournalState());

  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;

  void init() {
    final UserModel? userModel = preferences.getUserModel();
    emit(JournalState(userModel: userModel));
    _listenToChild(userModel?.defaultChild);
    _checkMoodLoggedToday(userModel?.uid);
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    List<TimelineEventModel>? todayEvents,
    int? readinessScore,
    bool? readyNow,
    bool? moodLoggedToday,
    double? sleepHoursLastNight,
    List<MilestoneModel>? milestones,
    Set<int>? unlockedChapters,
    bool? exportUnlocked,
    ApiResultStatus? loadStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        todayEvents: todayEvents ?? state.todayEvents,
        readinessScore: readinessScore ?? state.readinessScore,
        readyNow: readyNow ?? state.readyNow,
        moodLoggedToday: moodLoggedToday ?? state.moodLoggedToday,
        sleepHoursLastNight: sleepHoursLastNight ?? state.sleepHoursLastNight,
        milestones: milestones ?? state.milestones,
        unlockedChapters: unlockedChapters ?? state.unlockedChapters,
        exportUnlocked: exportUnlocked ?? state.exportUnlocked,
        loadStatus: loadStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void _listenToChild(DocumentReference<Object?>? defaultChildRef) {
    _childSubscription?.cancel();
    _childSubscription = defaultChildRef?.snapshots().listen((
      DocumentSnapshot<Object?> event,
    ) async {
      if (event.data() != null) {
        final ChildModel childModel = ChildModel.fromJson(
          event.data() as Map<String, dynamic>,
          event.reference,
        );
        changeProps(childModel: childModel);
        await reload();
      }
    });
  }

  void _checkMoodLoggedToday(String? uid) {
    if ((uid ?? '').isEmpty) {
      return;
    }
    AuthRepo.instance.userCollection
        .doc(uid)
        .collection('mood')
        .doc(getStringDate(DateTime.now()))
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snap) {
          changeProps(moodLoggedToday: snap.exists);
        });
  }

  Future<void> reload() async {
    final String childId = state.childModel?.reference?.id ?? '';
    if (childId.isEmpty) {
      return;
    }
    changeProps(loadStatus: ApiResultStatus.loading());
    final ApiResultStatus<List<TimelineEventModel>> eventsResult =
        await TimelineRepo.instance.fetchTodayEvents(childId: childId);
    final ApiResultStatus<List<MilestoneModel>> milestonesResult =
        await MilestoneRepo.instance.fetchMilestonesForChild(childId: childId);
    final double sleepHours = await _lastNightSleepHours(childId);
    List<MilestoneModel> milestones = <MilestoneModel>[];
    milestonesResult.whenOrNull(
      data: (List<MilestoneModel> data) => milestones = data,
    );
    final Set<int> unlockedChapters =
        MilestoneRepo.unlockedChaptersFrom(milestones);
    final bool exportUnlocked =
        MilestoneRepo.isExportUnlocked(unlockedChapters);
    final ChildState? childState = state.childModel?.childState;
    final int score = ReadinessScore.calculate(
      moodLoggedToday: state.moodLoggedToday,
      sleepHoursLastNight: sleepHours,
      childState: childState,
    );
    final bool readyNow = ReadinessScore.isReadyNow(
      score: score,
      childState: childState,
      sleepHoursLastNight: sleepHours,
    );
    eventsResult.whenOrNull(
      data: (List<TimelineEventModel> events) {
        changeProps(
          todayEvents: events,
          milestones: milestones,
          unlockedChapters: unlockedChapters,
          exportUnlocked: exportUnlocked,
          sleepHoursLastNight: sleepHours,
          readinessScore: score,
          readyNow: readyNow,
          loadStatus: ApiResultStatus.data(data: events),
        );
      },
      error: (Exception error) {
        changeProps(loadStatus: ApiResultStatus.error(error: error));
      },
    );
  }

  Future<double> _lastNightSleepHours(String childId) async {
    final DateTime today = DateTime.now();
    final ApiResultStatus<List<SleepLogModel>> result =
        await SleepLogRepo.instance.getSleepLogsForChild(
          childId,
          fromInclusive: today.subtract(const Duration(days: 2)),
          toInclusive: today,
        );
    double hours = 0;
    result.whenOrNull(
      data: (List<SleepLogModel> logs) {
        for (final SleepLogModel log in logs.reversed) {
          final DateTime wake = log.wakeTime;
          if (wake.year == today.year &&
              wake.month == today.month &&
              wake.day == today.day) {
            hours = wake.difference(log.bedTime).inMinutes / 60.0;
            break;
          }
        }
      },
    );
    return hours;
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    return super.close();
  }
}
