import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';

import 'request_session_state.dart';

/// Cubit managing Request a Session (Screen 47).
/// Conforms to AGENTS.md Rule 4.2.
class RequestSessionCubit extends Cubit<RequestSessionState> {
  RequestSessionCubit() : super(const RequestSessionState());

  void init({GuideProfileModel? guide, String? initialConcern}) {
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';
    final String cAge =
        (child?.childAge != null && child!.childAge!.trim().isNotEmpty)
        ? child.childAge!.trim()
        : '18 months';

    changeProps(
      guide: guide ?? MentorshipRepo.defaultGuides.first,
      childName: cName,
      childAge: cAge,
      mainConcern: (initialConcern != null && initialConcern.trim().isNotEmpty)
          ? initialConcern.trim()
          : 'Bedtime has been unsettled for two weeks',
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
      changeProps(isSubmitting: false, saveStatus: res);
      return true;
    } else {
      changeProps(isSubmitting: false, saveStatus: res);
      return false;
    }
  }
}
