import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentorship_landing_state.freezed.dart';

@freezed
abstract class MentorshipLandingState with _$MentorshipLandingState {
  const factory MentorshipLandingState({@Default(true) bool isAvailable}) =
      _MentorshipLandingState;
}
