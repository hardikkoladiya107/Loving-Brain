import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import 'mentorship_unavailable_state.dart';

/// Cubit for Screen 71 (Mentor Service Unavailable / Waitlist).
/// Conforms to AGENTS.md §4.2.
class MentorshipUnavailableCubit extends Cubit<MentorshipUnavailableState> {
  MentorshipUnavailableCubit() : super(const MentorshipUnavailableState());

  void init() {
    emit(const MentorshipUnavailableState());
  }

  void changeProps({
    bool? isWaitlistJoined,
    bool? isLoading,
    ApiResultStatus? waitlistStatus,
  }) {
    emit(
      state.copyWith(
        isWaitlistJoined: isWaitlistJoined ?? state.isWaitlistJoined,
        isLoading: isLoading ?? state.isLoading,
        waitlistStatus: waitlistStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void joinWaitlist() {
    changeProps(
      isWaitlistJoined: true,
      waitlistStatus: const ApiResultStatus.data(data: null),
    );
  }
}
