import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/model/user_model.dart';

part 'journal_state.freezed.dart';

@freezed
abstract class JournalState with _$JournalState {
  const factory JournalState({
    UserModel? userModel,
    ChildModel? childModel,
    @Default(<TimelineEventModel>[]) List<TimelineEventModel> todayEvents,
    @Default(0) int readinessScore,
    @Default(false) bool readyNow,
    @Default(false) bool moodLoggedToday,
    @Default(0.0) double sleepHoursLastNight,
    @Default(<MilestoneModel>[]) List<MilestoneModel> milestones,
    @Default(<int>{}) Set<int> unlockedChapters,
    @Default(false) bool exportUnlocked,
    @Default(ApiResultStatus.initial()) ApiResultStatus loadStatus,
  }) = _JournalState;
}
