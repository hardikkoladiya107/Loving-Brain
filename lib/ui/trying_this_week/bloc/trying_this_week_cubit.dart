import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'trying_this_week_state.dart';

class TryingThisWeekCubit extends Cubit<TryingThisWeekState> {
  TryingThisWeekCubit() : super(const TryingThisWeekState());

  void init() {
    emit(const TryingThisWeekState());
    _loadExperiment();
  }

  void changeProps({
    ActiveExperimentModel? experiment,
    ChildModel? child,
    int? currentDay,
    int? totalDays,
    ApiResultStatus? fetchStatus,
    ApiResultStatus? finishStatus,
  }) {
    emit(
      state.copyWith(
        experiment: experiment ?? state.experiment,
        child: child ?? state.child,
        currentDay: currentDay ?? state.currentDay,
        totalDays: totalDays ?? state.totalDays,
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
      }
    }

    if (active == null) {
      final DateTime now = DateTime.now();
      final DateTime startDate = now.subtract(const Duration(days: 2));
      active = ActiveExperimentModel(
        id: 'default_exp',
        childId: childId,
        changeTitle: 'An earlier, shorter\nafternoon nap',
        observeTarget: 'Evening mood and how easily\nbedtime goes',
        startDate: startDate,
        targetDays: 7,
        reviewDate: startDate.add(const Duration(days: 7)),
        status: 'active',
      );
    }

    final int dayNum = active.currentDayNumber;
    final int total = active.targetDays;

    changeProps(
      experiment: active,
      child: child,
      currentDay: dayNum,
      totalDays: total,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  Future<void> finishEarly(String? reason) async {
    changeProps(finishStatus: const ApiResultStatus.loading());

    final ChildModel? child = state.child ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    final String expId = state.experiment?.id ?? '';

    if (childId.isNotEmpty && expId.isNotEmpty) {
      final ApiResultStatus<bool> res = await ExperimentRepo.instance
          .finishExperimentEarly(
            childId: childId,
            experimentId: expId,
            reason: reason,
          );
      changeProps(finishStatus: res);
      return;
    }

    changeProps(finishStatus: const ApiResultStatus.data(data: true));
  }
}
