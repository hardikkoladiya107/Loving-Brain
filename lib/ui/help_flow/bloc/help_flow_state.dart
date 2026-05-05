import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/user_model.dart';

part 'help_flow_state.freezed.dart';

@freezed
abstract class HelpFlowState with _$HelpFlowState {
  const factory HelpFlowState({
    UserModel? userModel,
    ChildModel? childModel,
    ChildState? childState,
    @Default('') String selectedProblemType,
    @Default('') String contextLine,
    @Default('') String primaryAction,
    @Default(<String>[]) List<String> steps,
    @Default('') String fallbackText,
    @Default(0) int solutionIndex,
    @Default(0) int failedAttempts,
    @Default(false) bool showEscalationHint,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveApiResultStatus,
  }) = _HelpFlowState;
}
