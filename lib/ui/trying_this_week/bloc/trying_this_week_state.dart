import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'trying_this_week_state.freezed.dart';

@freezed
abstract class TryingThisWeekState with _$TryingThisWeekState {
  const factory TryingThisWeekState({
    ActiveExperimentModel? experiment,
    ChildModel? child,
    @Default(3) int currentDay,
    @Default(7) int totalDays,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus finishStatus,
  }) = _TryingThisWeekState;
}
