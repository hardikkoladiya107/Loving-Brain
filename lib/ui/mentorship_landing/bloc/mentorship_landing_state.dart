import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'mentorship_landing_state.freezed.dart';

@freezed
abstract class MentorshipLandingState with _$MentorshipLandingState {
  const factory MentorshipLandingState({
    @Default(false) bool isLoading,
    @Default(true) bool isAvailable,
    @Default(<String>[
      'Sleep',
      'Behaviour',
      'Parent Calm & Confidence',
      'Co-parenting Support',
    ])
    List<String> supportAreas,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _MentorshipLandingState;
}
