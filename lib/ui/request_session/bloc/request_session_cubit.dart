import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'request_session_state.dart';

/// Cubit managing Request a Session (Screen 47).
/// Conforms to AGENTS.md Rule 4.2.
class RequestSessionCubit extends Cubit<RequestSessionState> {
  RequestSessionCubit() : super(const RequestSessionState());

  void init({GuideProfileModel? guide, String? initialConcern}) {
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';
    final String? childAge = child?.childAge?.trim();
    final String cAge = (childAge != null && childAge.isNotEmpty)
        ? childAge
        : '18 months';

    changeProps(
      guide: guide ?? MentorshipRepo.defaultGuides.first,
      childName: cName,
      childAge: cAge,
      mainConcern: (initialConcern != null && initialConcern.trim().isNotEmpty)
          ? initialConcern.trim()
          : '',
      saveStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    GuideProfileModel? guide,
    String? childName,
    String? mainConcern,
    String? childAge,
    String? preferredDays,
    String? preferredLanguage,
    bool? shareSummary,
    bool? isSubmitting,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        guide: guide ?? state.guide,
        childName: childName ?? state.childName,
        mainConcern: mainConcern ?? state.mainConcern,
        childAge: childAge ?? state.childAge,
        preferredDays: preferredDays ?? state.preferredDays,
        preferredLanguage: preferredLanguage ?? state.preferredLanguage,
        shareSummary: shareSummary ?? state.shareSummary,
        isSubmitting: isSubmitting ?? state.isSubmitting,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void updateMainConcern(String val) => changeProps(mainConcern: val);
  void updateChildAge(String val) => changeProps(childAge: val);
  void updatePreferredDays(String val) => changeProps(preferredDays: val);
  void updatePreferredLanguage(String val) =>
      changeProps(preferredLanguage: val);
  void toggleShareSummary(bool share) => changeProps(shareSummary: share);

  Future<bool> submitRequest() async {
    final String concern = state.mainConcern.trim();
    if (concern.isEmpty) {
      changeProps(
        isSubmitting: false,
        saveStatus: ApiResultStatus.error(
          error: Exception('Please describe your main concern'),
        ),
      );
      return false;
    }

    changeProps(
      isSubmitting: true,
      saveStatus: const ApiResultStatus.loading(),
    );

    final String userId = preferences.getUserModel()?.uid ?? 'user_local';
    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? 'child_local';

    final MentorshipRequestModel request = MentorshipRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      childId: childId,
      childName: state.childName,
      childAge: state.childAge,
      mainConcern: state.mainConcern,
      preferredDays: state.preferredDays,
      preferredLanguage: state.preferredLanguage,
      guideId: state.guide?.id,
      guideName: state.guide?.name,
      shareRecentSummary: state.shareSummary,
      status: MentorshipRequestStatus.pending,
      createdAt: DateTime.now(),
    );

    final ApiResultStatus<MentorshipRequestModel> res = await MentorshipRepo
        .instance
        .createMentorshipRequest(request);

    if (res is Data<MentorshipRequestModel>) {
      // Schedule 24h & 1h session reminders per V2 notification types 5 & 7
      final DateTime estimatedSessionTime = DateTime.now().add(
        const Duration(days: 2),
      );
      V2NotificationScheduler.scheduleMentorshipReminders(
        sessionId: request.id,
        sessionTime: estimatedSessionTime,
        mentorName: state.guide?.name ?? 'Your mentor',
      );

      changeProps(isSubmitting: false, saveStatus: res);
      return true;
    } else {
      changeProps(isSubmitting: false, saveStatus: res);
      return false;
    }
  }
}
