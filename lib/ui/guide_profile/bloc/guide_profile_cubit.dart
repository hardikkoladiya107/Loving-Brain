import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'guide_profile_state.dart';

/// Cubit managing Guide Profile (Screen 46).
/// Conforms to AGENTS.md Rule 4.2.
class GuideProfileCubit extends Cubit<GuideProfileState> {
  GuideProfileCubit() : super(const GuideProfileState());

  void init({String? guideId, String? supportArea}) {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    GuideProfileModel matched;
    if (guideId != null && guideId.isNotEmpty) {
      matched = MentorshipRepo.instance.getGuideById(guideId);
    } else {
      matched = MentorshipRepo.defaultGuides.first;
      if (supportArea != null && supportArea.isNotEmpty) {
        final String cleanArea = supportArea.toLowerCase().trim();
        for (final GuideProfileModel g in MentorshipRepo.defaultGuides) {
          if (g.supportAreas.any(
            (String a) => a.toLowerCase().contains(cleanArea),
          )) {
            matched = g;
            break;
          }
        }
      }
    }

    changeProps(
      isLoading: false,
      guide: matched,
      fetchStatus: ApiResultStatus.data(data: matched),
    );
  }

  void changeProps({
    bool? isLoading,
    GuideProfileModel? guide,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        guide: guide ?? state.guide,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }
}
