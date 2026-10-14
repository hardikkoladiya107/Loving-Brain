import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'mentorship_unavailable_state.freezed.dart';

/// State for Screen 71 (Mentor Service Unavailable / Waitlist).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class MentorshipUnavailableState with _$MentorshipUnavailableState {
  const factory MentorshipUnavailableState({
    @Default(false) bool isWaitlistJoined,
    @Default(false) bool isLoading,
    @Default(ApiResultStatus.initial()) ApiResultStatus waitlistStatus,
  }) = _MentorshipUnavailableState;
}
