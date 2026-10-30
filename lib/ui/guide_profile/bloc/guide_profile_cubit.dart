import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'guide_profile_state.dart';

/// Cubit managing Guide Profile (Screen 46).
/// Conforms to AGENTS.md Rule 4.2.
class GuideProfileCubit extends Cubit<GuideProfileState> {
  GuideProfileCubit() : super(const GuideProfileState());

  void reset() {
    emit(const GuideProfileState());
  }

  Future<void> init({String? guideId, String? supportArea}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    if (guideId != null && guideId.trim().isNotEmpty) {
      final ApiResultStatus<GuideProfileModel> result = await MentorshipRepo
          .instance
          .getGuideById(guideId);
      if (result is Data<GuideProfileModel>) {
        changeProps(
          isLoading: false,
          guide: result.data,
          updateGuide: true,
          fetchStatus: result,
        );
      } else {
        changeProps(
          isLoading: false,
          guide: null,
          updateGuide: true,
          fetchStatus: result,
        );
      }
      return;
    }

    final ApiResultStatus<List<GuideProfileModel>> profiles =
        await MentorshipRepo.instance.getGuideProfiles(
          supportArea: supportArea,
        );
    if (profiles is Data<List<GuideProfileModel>> && profiles.data.isNotEmpty) {
      final GuideProfileModel matched = profiles.data.first;
      changeProps(
        isLoading: false,
        guide: matched,
        updateGuide: true,
        fetchStatus: ApiResultStatus.data(data: matched),
      );
    } else if (profiles is Error<List<GuideProfileModel>>) {
      changeProps(
        isLoading: false,
        guide: null,
        updateGuide: true,
        fetchStatus: profiles,
      );
    } else {
      changeProps(
        isLoading: false,
        guide: null,
        updateGuide: true,
        fetchStatus: ApiResultStatus.error(
          error: Exception('Guide is no longer available'),
        ),
      );
    }
  }

  void changeProps({
    bool? isLoading,
    GuideProfileModel? guide,
    bool updateGuide = false,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        guide: updateGuide ? guide : state.guide,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
