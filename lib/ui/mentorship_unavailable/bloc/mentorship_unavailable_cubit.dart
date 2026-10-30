import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'mentorship_unavailable_state.dart';

/// Cubit for Screen 71 (Mentor Service Unavailable / Waitlist).
/// Conforms to AGENTS.md §4.2 and §7.
class MentorshipUnavailableCubit extends Cubit<MentorshipUnavailableState> {
  MentorshipUnavailableCubit() : super(const MentorshipUnavailableState());

  void init() {
    emit(const MentorshipUnavailableState());
  }

  void reset() {
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

  Future<void> joinWaitlist({
    String? supportArea,
    String? preferredGuideId,
  }) async {
    changeProps(
      isLoading: true,
      waitlistStatus: const ApiResultStatus.loading(),
    );

    final String userId = preferences.getUserModel()?.uid ?? 'user_local';
    final String childId =
        preferences.getChildModel()?.reference?.id ?? 'child_local';

    final ApiResultStatus<bool> result = await MentorshipRepo.instance
        .joinWaitlist(
          userId: userId,
          childId: childId,
          supportArea: supportArea,
          preferredGuideId: preferredGuideId,
        );

    changeProps(
      isLoading: false,
      isWaitlistJoined: result is Data<bool>,
      waitlistStatus: result,
    );
  }
}
