import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'parent_success_guide_state.dart';

/// Cubit managing Parent Success Guide (Screen 51).
/// Conforms to AGENTS.md Rule 4.2.
class ParentSuccessGuideCubit extends Cubit<ParentSuccessGuideState> {
  ParentSuccessGuideCubit() : super(const ParentSuccessGuideState());

  Future<void> init({String? guideId}) async {
    changeProps(isLoading: true, fetchStatus: const ApiResultStatus.loading());

    GuideProfileModel? matched;
    if (guideId != null && guideId.isNotEmpty) {
      final ApiResultStatus<GuideProfileModel> guideResult =
          await MentorshipRepo.instance.getGuideById(guideId);
      if (guideResult is Data<GuideProfileModel>) {
        matched = guideResult.data;
      }
    } else {
      final ApiResultStatus<List<GuideProfileModel>> profiles =
          await MentorshipRepo.instance.getGuideProfiles();
      if (profiles is Data<List<GuideProfileModel>> &&
          profiles.data.isNotEmpty) {
        matched = profiles.data.first;
      }
    }

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
      updateGuide: true,
      pendingRequests: requests,
      fetchStatus: matched != null
          ? ApiResultStatus.data(data: matched)
          : ApiResultStatus.error(
              error: Exception('Guide is no longer available'),
            ),
    );
  }

  void changeProps({
    bool? isLoading,
    GuideProfileModel? guide,
    bool updateGuide = false,
    List<String>? activeGoals,
    List<MentorshipRequestModel>? pendingRequests,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        guide: updateGuide ? guide : state.guide,
        activeGoals: activeGoals ?? state.activeGoals,
        pendingRequests: pendingRequests ?? state.pendingRequests,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> cancelRequest(String requestId) async {
    await MentorshipRepo.instance.cancelMentorshipRequest(requestId);
    V2NotificationScheduler.cancelMentorshipReminders(requestId);
    V2NotificationScheduler.notifyMentorshipBookingEvent(
      sessionId: requestId,
      mentorName: state.guide?.name ?? 'Your mentor',
      statusText: 'cancelled',
    );

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
