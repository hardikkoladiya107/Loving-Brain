import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';

part 'manage_children_state.freezed.dart';

@freezed
abstract class ManageChildrenState with _$ManageChildrenState {
  const factory ManageChildrenState({
    UserModel? userModel,
    @Default([]) List<ChildModel> children,
    @Default(ApiResultStatus.initial()) ApiResultStatus loadStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus setDefaultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus deleteChildStatus,
  }) = _ManageChildrenState;
}
