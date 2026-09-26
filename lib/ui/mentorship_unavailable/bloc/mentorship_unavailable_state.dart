import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentorship_unavailable_state.freezed.dart';

@freezed
abstract class MentorshipUnavailableState with _$MentorshipUnavailableState {
  const factory MentorshipUnavailableState() = _MentorshipUnavailableState;
}
