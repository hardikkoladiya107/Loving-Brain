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
      guide: guide,
      updateGuide: true,
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
    bool updateGuide = false,
    String? childName,
    String? mainConcern,
    String? mainConcernError,
    String? childAge,
    String? preferredDays,
    String? preferredLanguage,
    bool? shareSummary,
    bool? isSubmitting,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        guide: updateGuide ? guide : state.guide,
        childName: childName ?? state.childName,
        mainConcern: mainConcern ?? state.mainConcern,
        mainConcernError: mainConcernError ?? state.mainConcernError,
        childAge: childAge ?? state.childAge,
        preferredDays: preferredDays ?? state.preferredDays,
        preferredLanguage: preferredLanguage ?? state.preferredLanguage,
        shareSummary: shareSummary ?? state.shareSummary,
        isSubmitting: isSubmitting ?? state.isSubmitting,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void updateMainConcern(String val) =>
      changeProps(mainConcern: val, mainConcernError: '');
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
        mainConcernError: 'Please describe your main concern',
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
      // Immediate booking status event notification (Doc 03 §2 Type 6)
      V2NotificationScheduler.notifyMentorshipBookingEvent(
        sessionId: request.id,
        mentorName: state.guide?.name ?? 'Your mentor',
        statusText: 'requested',
      );

      changeProps(isSubmitting: false, saveStatus: res);
      return true;
    } else {
      changeProps(isSubmitting: false, saveStatus: res);
      return false;
    }
  }
}
