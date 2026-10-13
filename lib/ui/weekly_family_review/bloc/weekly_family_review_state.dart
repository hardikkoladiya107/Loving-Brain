import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'weekly_family_review_state.freezed.dart';

@freezed
abstract class WeeklyFamilyReviewState with _$WeeklyFamilyReviewState {
  const factory WeeklyFamilyReviewState({
    ChildModel? child,
    WeeklyInsightsResult? insights,
    ActiveExperimentModel? activeExperiment,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _WeeklyFamilyReviewState;
}
