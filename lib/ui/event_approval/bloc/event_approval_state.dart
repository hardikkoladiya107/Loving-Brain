import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/child_model.dart';
import '../../../model/shared_event_model.dart';
import '../../../model/user_model.dart';

part 'event_approval_state.freezed.dart';

@freezed
abstract class EventApprovalState with _$EventApprovalState {
  const factory EventApprovalState({
    @Default("") String message,
    SharedEventModel? sharedEvent,
    @Default(ApiResultStatus.initial()) ApiResultStatus getAssigneeApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus getChildrenResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus  getCreatedByUserApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus  updatedSharedEventApiResult,
    UserModel? createdByUser,
    UserModel? userModel,
    @Default([]) List<UserModel> assignedUserList,
    @Default([]) List<ChildModel> childrenList,
  }) = _EventApprovalState;
}
