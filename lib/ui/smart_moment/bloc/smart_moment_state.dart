import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/user_model.dart';

part 'smart_moment_state.freezed.dart';

@freezed
abstract class SmartMomentState with _$SmartMomentState {
  const factory SmartMomentState({
    UserModel? userModel,
    ChildModel? childModel,
    ChildState? stateAtTime,
    @Default('') String activityTitle,
    @Default('') String subtitle,
    @Default('') String message,
    @Default(<String>[]) List<String> steps,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveApiResultStatus,
  }) = _SmartMomentState;
}
