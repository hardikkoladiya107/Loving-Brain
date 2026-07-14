import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/model/user_model.dart';

part 'timeline_state.freezed.dart';

@freezed
abstract class TimelineState with _$TimelineState {
  const factory TimelineState({
    UserModel? userModel,
    ChildModel? childModel,
    @Default(<TimelineEventModel>[]) List<TimelineEventModel> events,
    @Default(ApiResultStatus.initial()) ApiResultStatus loadStatus,
  }) = _TimelineState;
}
