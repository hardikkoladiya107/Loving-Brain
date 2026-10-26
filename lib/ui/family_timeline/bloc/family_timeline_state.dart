import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';

part 'family_timeline_state.freezed.dart';

@freezed
abstract class FamilyTimelineState with _$FamilyTimelineState {
  const factory FamilyTimelineState({
    @Default([]) List<TimelineEventModel> allEvents,
    @Default([]) List<TimelineEventModel> filteredEvents,
    @Default('All') String selectedFilter,
    ChildModel? child,
    @Default(0) int weeksWithLovingBrain,
    @Default(0) int averageBedtimeShiftMinutes,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _FamilyTimelineState;
}
