import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/child_model.dart';
import '../../../model/user_model.dart';

part 'link_co_parent_state.freezed.dart';

@freezed
abstract class LinkCoParentState with _$LinkCoParentState {
  const factory LinkCoParentState({
    @Default("EMAIL") String selectedTab,
    @Default("") String? coParentEmail,
    @Default("") String? coParentEmailError,
    @Default(false) bool calenderAndEvent,
    @Default(false) bool childEssentials,
    @Default("") String selectedChild,
    @Default(ApiResultStatus.initial()) ApiResultStatus getApiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus createInvitation,
    UserModel? userModel,
    @Default([]) List<ChildModel> children,
    @Default([]) List<ChildModel> selectedChildren,
  }) = _LinkCoParentState;
}
