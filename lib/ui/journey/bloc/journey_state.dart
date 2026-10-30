import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'journey_state.freezed.dart';

enum JourneyMode { normal, learning, harder, trying }

@freezed
abstract class JourneyState with _$JourneyState {
  const factory JourneyState({
    @Default(JourneyMode.normal) JourneyMode mode,
    ChildModel? child,
    WeeklyInsightsResult? weeklyInsights,
    ActiveExperimentModel? activeExperiment,
    @Default(0) int savedGuidanceCount,
    @Default(0) int timelineEventCount,
    @Default(false) bool isSleepJourneyEnrolled,
    @Default(1) int sleepJourneyWeek,
    @Default(6) int sleepJourneyTotalWeeks,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _JourneyState;
}
