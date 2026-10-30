import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'trying_this_week_state.dart';

class TryingThisWeekCubit extends Cubit<TryingThisWeekState> {
  TryingThisWeekCubit() : super(const TryingThisWeekState());

  void init() {
    emit(const TryingThisWeekState());
    _loadExperiment();
  }

  void reset() {
    emit(const TryingThisWeekState());
  }

  void changeProps({
    ActiveExperimentModel? experiment,
    ChildModel? child,
    int? currentDay,
    int? totalDays,
    bool? hasExperiment,
    bool clearExperiment = false,
    ApiResultStatus? fetchStatus,
    ApiResultStatus? finishStatus,
  }) {
    emit(
      state.copyWith(
        experiment: clearExperiment ? null : (experiment ?? state.experiment),
        child: child ?? state.child,
        currentDay: currentDay ?? state.currentDay,
        totalDays: totalDays ?? state.totalDays,
        hasExperiment: hasExperiment ?? state.hasExperiment,
        fetchStatus: fetchStatus ?? const ApiResultStatus.initial(),
        finishStatus: finishStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _loadExperiment() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    ActiveExperimentModel? active;
    if (childId.isNotEmpty) {
      final ApiResultStatus<ActiveExperimentModel?> res = await ExperimentRepo
          .instance
          .getActiveExperiment(childId: childId);
      if (res is Data<ActiveExperimentModel?>) {
        active = res.data;
      } else if (res is Error<ActiveExperimentModel?>) {
        changeProps(child: child, hasExperiment: false, fetchStatus: res);
        return;
      }
    }

    if (active == null) {
      changeProps(
        child: child,
        hasExperiment: false,
        clearExperiment: true,
        currentDay: 0,
        totalDays: 7,
        fetchStatus: const ApiResultStatus.data(data: null),
      );
      return;
    }

    if (active.isDueForReview && childId.isNotEmpty) {
      await _completeDueExperiment(childId: childId, experiment: active);
      changeProps(
        child: child,
        hasExperiment: false,
        clearExperiment: true,
        currentDay: 0,
        totalDays: 7,
        fetchStatus: const ApiResultStatus.data(data: null),
      );
      return;
    }

    changeProps(
      experiment: active,
      child: child,
      currentDay: active.currentDayNumber,
      totalDays: active.targetDays,
      hasExperiment: true,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  Future<void> _completeDueExperiment({
    required String childId,
    required ActiveExperimentModel experiment,
  }) async {
    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];

    final ApiResultStatus<List<SleepLogModel>> sleepRes = await SleepLogRepo
        .instance
        .getSleepLogsForChild(childId);
    if (sleepRes is Data<List<SleepLogModel>>) {
      sleepLogs = sleepRes.data;
    }

    final ApiResultStatus<List<TantrumLogModel>> tantrumRes = await TodayLogRepo
        .instance
        .getRecentTantrumLogs(childId, limit: 40);
    if (tantrumRes is Data<List<TantrumLogModel>>) {
      tantrumLogs = tantrumRes.data;
    }

    final String resultNote = JourneyInsightsEngine.compareExperimentOutcome(
      experiment: experiment,
      sleepLogs: sleepLogs,
      tantrumLogs: tantrumLogs,
    );

    await ExperimentRepo.instance.completeExperiment(
      childId: childId,
      experimentId: experiment.id,
      resultNote: resultNote,
    );
  }

  Future<void> finishEarly(String? reason) async {
    changeProps(finishStatus: const ApiResultStatus.loading());

    final ChildModel? child = state.child ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    final String expId = state.experiment?.id ?? '';

    if (childId.isEmpty || expId.isEmpty || expId == 'default_exp') {
      changeProps(
        finishStatus: ApiResultStatus.error(
          error: Exception('No active experiment to finish.'),
        ),
      );
      return;
    }

    final ApiResultStatus<bool> res = await ExperimentRepo.instance
        .finishExperimentEarly(
          childId: childId,
          experimentId: expId,
          reason: reason,
        );
    changeProps(finishStatus: res);
  }
}
