import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'harder_week_state.freezed.dart';

@freezed
abstract class HarderWeekState with _$HarderWeekState {
  const factory HarderWeekState({
    ChildModel? child,
    WeeklyInsightsResult? insights,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _HarderWeekState;
}
