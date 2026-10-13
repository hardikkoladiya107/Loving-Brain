import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'parent_success_guide_state.dart';

/// Cubit managing Parent Success Guide (Screen 51).
/// Conforms to AGENTS.md Rule 4.2.
class ParentSuccessGuideCubit extends Cubit<ParentSuccessGuideState> {
  ParentSuccessGuideCubit() : super(const ParentSuccessGuideState());

  Future<void> init({String? guideId}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    final GuideProfileModel matched = guideId != null && guideId.isNotEmpty
        ? MentorshipRepo.instance.getGuideById(guideId)
        : MentorshipRepo.defaultGuides.first;

    final String userId = preferences.getUserModel()?.uid ?? 'user_local';
    final ApiResultStatus<List<MentorshipRequestModel>> reqResult =
        await MentorshipRepo.instance.getMentorshipRequests(userId);

    List<MentorshipRequestModel> requests = <MentorshipRequestModel>[];
    if (reqResult is Data<List<MentorshipRequestModel>>) {
      requests = reqResult.data;
    }

    changeProps(
      isLoading: false,
      guide: matched,
      pendingRequests: requests,
      fetchStatus: ApiResultStatus.data(data: matched),
    );
  }

  void changeProps({
    bool? isLoading,
    GuideProfileModel? guide,
    List<String>? activeGoals,
    List<MentorshipRequestModel>? pendingRequests,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        guide: guide ?? state.guide,
        activeGoals: activeGoals ?? state.activeGoals,
        pendingRequests: pendingRequests ?? state.pendingRequests,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> cancelRequest(String requestId) async {
    await MentorshipRepo.instance.cancelMentorshipRequest(requestId);
    final List<MentorshipRequestModel> updated = state.pendingRequests.map((
      MentorshipRequestModel r,
    ) {
      if (r.id == requestId) {
        return r.copyWith(status: MentorshipRequestStatus.cancelled);
      }
      return r;
    }).toList();
    changeProps(pendingRequests: updated);
  }
}
