import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'mentorship_landing_state.dart';

/// Cubit managing Mentorship Landing (Screen 43).
/// Conforms to AGENTS.md Rule 4.2.
class MentorshipLandingCubit extends Cubit<MentorshipLandingState> {
  MentorshipLandingCubit() : super(const MentorshipLandingState());

  void init() {
    changeProps(
      isLoading: false,
      isAvailable: true,
      fetchStatus: const ApiResultStatus.data(data: null),
    );

    final String userId = preferences.getUserModel()?.uid ?? 'user_local';
    MentorshipRepo.instance.checkWaitlistSlotAvailability(userId);
  }

  void changeProps({
    bool? isLoading,
    bool? isAvailable,
    List<String>? supportAreas,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        isAvailable: isAvailable ?? state.isAvailable,
        supportAreas: supportAreas ?? state.supportAreas,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void toggleAvailability() {
    final bool nextAvailable = !state.isAvailable;
    changeProps(isAvailable: nextAvailable);
    if (nextAvailable) {
      final String userId = preferences.getUserModel()?.uid ?? 'user_local';
      MentorshipRepo.instance.checkWaitlistSlotAvailability(userId);
    }
  }
}
