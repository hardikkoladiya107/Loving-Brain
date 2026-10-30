import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'enrolled_journey_home_state.dart';

/// Cubit managing Enrolled Sleep Reset Journey (Screen 49).
/// Conforms to AGENTS.md Rule 4.2.
class EnrolledJourneyHomeCubit extends Cubit<EnrolledJourneyHomeState> {
  EnrolledJourneyHomeCubit() : super(const EnrolledJourneyHomeState());

  void reset() {
    emit(const EnrolledJourneyHomeState());
  }

  Future<void> init({String? childId}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    final String resolvedId =
        childId ??
        preferences.getChildModel()?.reference?.id ??
        'default_child';

    final ApiResultStatus<EnrolledProgramModel> res = await MentorshipRepo
        .instance
        .getEnrolledProgram(resolvedId);

    if (res is Data<EnrolledProgramModel>) {
      changeProps(isLoading: false, program: res.data, fetchStatus: res);
    } else {
      changeProps(isLoading: false, fetchStatus: res);
    }
  }

  void changeProps({
    bool? isLoading,
    EnrolledProgramModel? program,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        program: program ?? state.program,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void toggleModuleCompleted() {
    if (state.program == null) return;
    final EnrolledProgramModel updated = state.program!.copyWith(
      isModuleCompleted: !state.program!.isModuleCompleted,
    );
    changeProps(program: updated);
  }
}
