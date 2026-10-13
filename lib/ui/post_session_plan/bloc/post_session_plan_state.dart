import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'post_session_plan_state.freezed.dart';

@freezed
abstract class PostSessionPlanState with _$PostSessionPlanState {
  const factory PostSessionPlanState({
    @Default(false) bool isLoading,
    PostSessionPlanModel? plan,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _PostSessionPlanState;
}
