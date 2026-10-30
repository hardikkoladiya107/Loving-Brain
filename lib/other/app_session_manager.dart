import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/ui/add_child/bloc/add_child_cubit.dart';
import 'package:loving_brain/ui/after_reflection/bloc/after_reflection_cubit.dart';
import 'package:loving_brain/ui/auth/login/bloc/login_cubit.dart';
import 'package:loving_brain/ui/auth/otp/bloc/otp_cubit.dart';
import 'package:loving_brain/ui/auth/register/bloc/register_cubit.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/behaviour_pattern/bloc/behaviour_pattern_cubit.dart';
import 'package:loving_brain/ui/brainy_ai/bloc/brainy_voice_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/brainy_history/bloc/brainy_history_cubit.dart';
import 'package:loving_brain/ui/brainy_home/bloc/brainy_home_cubit.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/bloc/brainy_saved_guidance_cubit.dart';
import 'package:loving_brain/ui/calm_heads_up/bloc/calm_heads_up_cubit.dart';
import 'package:loving_brain/ui/calm_plan/bloc/calm_plan_cubit.dart';
import 'package:loving_brain/ui/child_essentials/bloc/child_essentials_cubit.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart';
import 'package:loving_brain/ui/choose_support_area/bloc/choose_support_area_cubit.dart';
import 'package:loving_brain/ui/consistency_recognition/bloc/consistency_recognition_cubit.dart';
import 'package:loving_brain/ui/enrolled_journey_home/bloc/enrolled_journey_home_cubit.dart';
import 'package:loving_brain/ui/family_menu/bloc/family_menu_cubit.dart';
import 'package:loving_brain/ui/family_sharing_consent/bloc/family_sharing_consent_cubit.dart';
import 'package:loving_brain/ui/family_snapsshot/bloc/family_snapshot_cubit.dart';
import 'package:loving_brain/ui/family_timeline/bloc/family_timeline_cubit.dart';
import 'package:loving_brain/ui/guide_list/bloc/guide_list_cubit.dart';
import 'package:loving_brain/ui/guide_profile/bloc/guide_profile_cubit.dart';
import 'package:loving_brain/ui/harder_week/bloc/harder_week_cubit.dart';
import 'package:loving_brain/ui/help_flow/bloc/help_flow_cubit.dart';
import 'package:loving_brain/ui/help_safety/bloc/help_safety_cubit.dart';
import 'package:loving_brain/ui/invite_accepted/bloc/invite_accepted_cubit.dart';
import 'package:loving_brain/ui/invite_caregiver/bloc/invite_caregiver_cubit.dart';
import 'package:loving_brain/ui/invite_pending/bloc/invite_pending_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_cubit.dart';
import 'package:loving_brain/ui/mentorship_landing/bloc/mentorship_landing_cubit.dart';
import 'package:loving_brain/ui/mentorship_unavailable/bloc/mentorship_unavailable_cubit.dart';
import 'package:loving_brain/ui/microphone_permission/bloc/microphone_permission_cubit.dart';
import 'package:loving_brain/ui/notifications/bloc/notifications_cubit.dart';
import 'package:loving_brain/ui/notifications_permission/bloc/notifications_permission_cubit.dart';
import 'package:loving_brain/ui/onboarding/bloc/onboarding_cubit.dart';
import 'package:loving_brain/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart';
import 'package:loving_brain/ui/parent_success_guide/bloc/parent_success_guide_cubit.dart';
import 'package:loving_brain/ui/permissions/bloc/permissions_cubit.dart';
import 'package:loving_brain/ui/post_session_plan/bloc/post_session_plan_cubit.dart';
import 'package:loving_brain/ui/privacy_data/bloc/privacy_data_cubit.dart';
import 'package:loving_brain/ui/profile/bloc/profile_cubit.dart';
import 'package:loving_brain/ui/programme_detail/bloc/programme_detail_cubit.dart';
import 'package:loving_brain/ui/request_session/bloc/request_session_cubit.dart';
import 'package:loving_brain/ui/session_request_confirmation/bloc/session_request_confirmation_cubit.dart';
import 'package:loving_brain/ui/shared_child_summary/bloc/shared_child_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_details/bloc/sleep_details_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_low_confidence/bloc/sleep_low_confidence_cubit.dart';
import 'package:loving_brain/ui/sleep_no_data/bloc/sleep_no_data_cubit.dart';
import 'package:loving_brain/ui/sleep_pattern/bloc/sleep_pattern_cubit.dart';
import 'package:loving_brain/ui/subscription/bloc/subscription_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/tonights_plan/bloc/tonights_plan_cubit.dart';
import 'package:loving_brain/ui/trying_this_week/bloc/trying_this_week_cubit.dart';
import 'package:loving_brain/ui/weekly_family_review/bloc/weekly_family_review_cubit.dart';

/// Centralized manager responsible for completely purging all user-scoped in-memory
/// states across every Cubit and local cache upon logout or account deletion.
class AppSessionManager {
  AppSessionManager._();
  static final AppSessionManager instance = AppSessionManager._();

  /// Completely clears all in-memory Cubit states and cleans user preferences.
  Future<void> clearAllSessionStates({BuildContext? context}) async {
    // 1. Reset all in-memory Cubits to their clean initial states synchronously before any async gap
    final BuildContext? targetContext = context ?? navigatorKey.currentContext;
    if (targetContext != null) {
      _resetAllCubits(targetContext);
    }

    // 2. Wipe SharedPreferences and draft caches
    try {
      await preferences.clearOnboardingDraft();
      await preferences.clearUser();
      await preferences.clearChild();
      await preferences.putBool(SharedPreference.isLogin, false);
      await OfflineSyncRepo.instance.clearQueue();
    } catch (_) {}
  }

  void _resetAllCubits(BuildContext context) {
    try {
      context.read<AddChildCubit>().reset();
    } catch (_) {}
    try {
      context.read<TodayCubit>().reset();
    } catch (_) {}
    try {
      context.read<BrainyConversationCubit>().reset();
    } catch (_) {}
    try {
      context.read<BrainyHistoryCubit>().reset();
    } catch (_) {}
    try {
      context.read<BrainyHomeCubit>().reset();
    } catch (_) {}
    try {
      context.read<BrainySavedGuidanceCubit>().reset();
    } catch (_) {}
    try {
      context.read<BrainyVoiceCubit>().reset();
    } catch (_) {}
    try {
      context.read<JourneyCubit>().reset();
    } catch (_) {}
    try {
      context.read<SleepForecastCubit>().reset();
    } catch (_) {}
    try {
      context.read<SleepDetailsCubit>().reset();
    } catch (_) {}
    try {
      context.read<SleepPatternCubit>().reset();
    } catch (_) {}
    try {
      context.read<SleepLowConfidenceCubit>().reset();
    } catch (_) {}
    try {
      context.read<SleepNoDataCubit>().reset();
    } catch (_) {}
    try {
      context.read<FamilyMenuCubit>().reset();
    } catch (_) {}
    try {
      context.read<PermissionsCubit>().reset();
    } catch (_) {}
    try {
      context.read<ChildProfileV2Cubit>().reset();
    } catch (_) {}
    try {
      context.read<ParentProfileV2Cubit>().reset();
    } catch (_) {}
    try {
      context.read<ChildEssentialsCubit>().reset();
    } catch (_) {}
    try {
      context.read<SharedChildSummaryCubit>().reset();
    } catch (_) {}
    try {
      context.read<OnboardingCubit>().reset();
    } catch (_) {}
    try {
      context.read<CalmHeadsUpCubit>().reset();
    } catch (_) {}
    try {
      context.read<CalmPlanCubit>().reset();
    } catch (_) {}
    try {
      context.read<BehaviourPatternCubit>().reset();
    } catch (_) {}
    try {
      context.read<AfterReflectionCubit>().reset();
    } catch (_) {}
    try {
      context.read<WeeklyFamilyReviewCubit>().reset();
    } catch (_) {}
    try {
      context.read<MentorshipLandingCubit>().reset();
    } catch (_) {}
    try {
      context.read<ChooseSupportAreaCubit>().reset();
    } catch (_) {}
    try {
      context.read<PostSessionPlanCubit>().reset();
    } catch (_) {}
    try {
      context.read<TonightsPlanCubit>().reset();
    } catch (_) {}
    try {
      context.read<TryingThisWeekCubit>().reset();
    } catch (_) {}
    try {
      context.read<HarderWeekCubit>().reset();
    } catch (_) {}
    try {
      context.read<HelpFlowCubit>().reset();
    } catch (_) {}
    try {
      context.read<BaseCubit>().reset();
    } catch (_) {}
    try {
      context.read<ProfileCubit>().reset();
    } catch (_) {}
    try {
      context.read<PrivacyDataCubit>().reset();
    } catch (_) {}
    try {
      context.read<SubscriptionCubit>().reset();
    } catch (_) {}
    try {
      context.read<FamilySnapshotCubit>().reset();
    } catch (_) {}
    try {
      context.read<FamilyTimelineCubit>().reset();
    } catch (_) {}
    try {
      context.read<EnrolledJourneyHomeCubit>().reset();
    } catch (_) {}
    try {
      context.read<NotificationsCubit>().reset();
    } catch (_) {}
    try {
      context.read<InvitePendingCubit>().reset();
    } catch (_) {}
    try {
      context.read<InviteCaregiverCubit>().reset();
    } catch (_) {}
    try {
      context.read<InviteAcceptedCubit>().reset();
    } catch (_) {}
    try {
      context.read<GuideListCubit>().reset();
    } catch (_) {}
    try {
      context.read<GuideProfileCubit>().reset();
    } catch (_) {}
    try {
      context.read<RequestSessionCubit>().reset();
    } catch (_) {}
    try {
      context.read<SessionRequestConfirmationCubit>().reset();
    } catch (_) {}
    try {
      context.read<ProgrammeDetailCubit>().reset();
    } catch (_) {}
    try {
      context.read<ParentSuccessGuideCubit>().reset();
    } catch (_) {}
    try {
      context.read<ConsistencyRecognitionCubit>().reset();
    } catch (_) {}
    try {
      context.read<FamilySharingConsentCubit>().reset();
    } catch (_) {}
    try {
      context.read<HelpSafetyCubit>().reset();
    } catch (_) {}
    try {
      context.read<MentorshipUnavailableCubit>().reset();
    } catch (_) {}
    try {
      context.read<MicrophonePermissionCubit>().reset();
    } catch (_) {}
    try {
      context.read<NotificationsPermissionCubit>().reset();
    } catch (_) {}
    try {
      context.read<LoginCubit>().reset();
    } catch (_) {}
    try {
      context.read<RegisterCubit>().reset();
    } catch (_) {}
    try {
      context.read<OtpCubit>().reset();
    } catch (_) {}
  }
}
