import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';

import '../../../model/api_result_status.dart';
import '../../../model/shared_event_model.dart';

part 'event_detail_state.freezed.dart';

@freezed
abstract class EventDetailState with _$EventDetailState {
  const factory EventDetailState({
    @Default("") String message,
    @Default(ApiResultStatus.initial()) ApiResultStatus getAssigneeApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus getChildrenResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus  getCreatedByUserApiResult,
    UserModel? createdByUser,
    @Default([]) List<UserModel> assignedUserList,
    @Default([]) List<ChildModel> childrenList,
    SharedEventModel? sharedEvent,
  }) = _EventDetailState;
}
