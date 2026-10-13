import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';

part 'parent_success_guide_state.freezed.dart';

@freezed
abstract class ParentSuccessGuideState with _$ParentSuccessGuideState {
  const factory ParentSuccessGuideState({
    @Default(false) bool isLoading,
    GuideProfileModel? guide,
    @Default(<String>[
      'Shift bedtime by 15 minutes',
      'Consistent evening wind-down routine',
    ])
    List<String> activeGoals,
    @Default(<MentorshipRequestModel>[])
    List<MentorshipRequestModel> pendingRequests,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _ParentSuccessGuideState;
}
