import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
// ignore: depend_on_referenced_packages
import 'package:nested/nested.dart';

final List<SingleChildWidget> blocProvider = <SingleChildWidget>[
  BlocProvider<AddChildCubit>(
    create: (BuildContext context) => AddChildCubit(),
  ),
  BlocProvider<AfterReflectionCubit>(
    create: (BuildContext context) => AfterReflectionCubit(),
  ),
  BlocProvider<BaseCubit>(create: (BuildContext context) => BaseCubit()),
  BlocProvider<BehaviourPatternCubit>(
    create: (BuildContext context) => BehaviourPatternCubit(),
  ),
  BlocProvider<BrainyConversationCubit>(
    create: (BuildContext context) => BrainyConversationCubit(),
  ),
  BlocProvider<BrainyHistoryCubit>(
    create: (BuildContext context) => BrainyHistoryCubit(),
  ),
  BlocProvider<BrainyHomeCubit>(
    create: (BuildContext context) => BrainyHomeCubit(),
  ),
  BlocProvider<BrainySavedGuidanceCubit>(
    create: (BuildContext context) => BrainySavedGuidanceCubit(),
  ),
  BlocProvider<BrainyVoiceCubit>(
    create: (BuildContext context) => BrainyVoiceCubit(),
  ),
  BlocProvider<CalmHeadsUpCubit>(
    create: (BuildContext context) => CalmHeadsUpCubit(),
  ),
  BlocProvider<CalmPlanCubit>(
    create: (BuildContext context) => CalmPlanCubit(),
  ),
  BlocProvider<ChildEssentialsCubit>(
    create: (BuildContext context) => ChildEssentialsCubit(),
  ),
  BlocProvider<ChildProfileV2Cubit>(
    create: (BuildContext context) => ChildProfileV2Cubit(),
  ),
  BlocProvider<ChooseSupportAreaCubit>(
    create: (BuildContext context) => ChooseSupportAreaCubit(),
  ),
  BlocProvider<ConsistencyRecognitionCubit>(
    create: (BuildContext context) => ConsistencyRecognitionCubit(),
  ),
  BlocProvider<EnrolledJourneyHomeCubit>(
    create: (BuildContext context) => EnrolledJourneyHomeCubit(),
  ),
  BlocProvider<FamilyMenuCubit>(
    create: (BuildContext context) => FamilyMenuCubit(),
  ),
  BlocProvider<FamilySharingConsentCubit>(
    create: (BuildContext context) => FamilySharingConsentCubit(),
  ),
  BlocProvider<FamilySnapshotCubit>(
    create: (BuildContext context) => FamilySnapshotCubit(),
  ),
  BlocProvider<FamilyTimelineCubit>(
    create: (BuildContext context) => FamilyTimelineCubit(),
  ),
  BlocProvider<GuideListCubit>(
    create: (BuildContext context) => GuideListCubit(),
  ),
  BlocProvider<GuideProfileCubit>(
    create: (BuildContext context) => GuideProfileCubit(),
  ),
  BlocProvider<HarderWeekCubit>(
    create: (BuildContext context) => HarderWeekCubit(),
  ),
  BlocProvider<HelpFlowCubit>(
    create: (BuildContext context) => HelpFlowCubit(),
  ),
  BlocProvider<HelpSafetyCubit>(
    create: (BuildContext context) => HelpSafetyCubit(),
  ),
  BlocProvider<InviteAcceptedCubit>(
    create: (BuildContext context) => InviteAcceptedCubit(),
  ),
  BlocProvider<InviteCaregiverCubit>(
    create: (BuildContext context) => InviteCaregiverCubit(),
  ),
  BlocProvider<InvitePendingCubit>(
    create: (BuildContext context) => InvitePendingCubit(),
  ),
  BlocProvider<JourneyCubit>(create: (BuildContext context) => JourneyCubit()),
  BlocProvider<LoginCubit>(create: (BuildContext context) => LoginCubit()),
  BlocProvider<MentorshipLandingCubit>(
    create: (BuildContext context) => MentorshipLandingCubit(),
  ),
  BlocProvider<MentorshipUnavailableCubit>(
    create: (BuildContext context) => MentorshipUnavailableCubit(),
  ),
  BlocProvider<MicrophonePermissionCubit>(
    create: (BuildContext context) => MicrophonePermissionCubit(),
  ),
  BlocProvider<NotificationsCubit>(
    create: (BuildContext context) => NotificationsCubit(),
  ),
  BlocProvider<NotificationsPermissionCubit>(
    create: (BuildContext context) => NotificationsPermissionCubit(),
  ),
  BlocProvider<OnboardingCubit>(
    create: (BuildContext context) => OnboardingCubit(),
  ),
  BlocProvider<OtpCubit>(create: (BuildContext context) => OtpCubit()),
  BlocProvider<ParentProfileV2Cubit>(
    create: (BuildContext context) => ParentProfileV2Cubit(),
  ),
  BlocProvider<ParentSuccessGuideCubit>(
    create: (BuildContext context) => ParentSuccessGuideCubit(),
  ),
  BlocProvider<PermissionsCubit>(
    create: (BuildContext context) => PermissionsCubit(),
  ),
  BlocProvider<PostSessionPlanCubit>(
    create: (BuildContext context) => PostSessionPlanCubit(),
  ),
  BlocProvider<PrivacyDataCubit>(
    create: (BuildContext context) => PrivacyDataCubit(),
  ),
  BlocProvider<ProfileCubit>(create: (BuildContext context) => ProfileCubit()),
  BlocProvider<ProgrammeDetailCubit>(
    create: (BuildContext context) => ProgrammeDetailCubit(),
  ),
  BlocProvider<RegisterCubit>(
    create: (BuildContext context) => RegisterCubit(),
  ),
  BlocProvider<RequestSessionCubit>(
    create: (BuildContext context) => RequestSessionCubit(),
  ),
  BlocProvider<SessionRequestConfirmationCubit>(
    create: (BuildContext context) => SessionRequestConfirmationCubit(),
  ),
  BlocProvider<SharedChildSummaryCubit>(
    create: (BuildContext context) => SharedChildSummaryCubit(),
  ),
  BlocProvider<SleepDetailsCubit>(
    create: (BuildContext context) => SleepDetailsCubit(),
  ),
  BlocProvider<SleepForecastCubit>(
    create: (BuildContext context) => SleepForecastCubit(),
  ),
  BlocProvider<SleepLowConfidenceCubit>(
    create: (BuildContext context) => SleepLowConfidenceCubit(),
  ),
  BlocProvider<SleepNoDataCubit>(
    create: (BuildContext context) => SleepNoDataCubit(),
  ),
  BlocProvider<SleepPatternCubit>(
    create: (BuildContext context) => SleepPatternCubit(),
  ),
  BlocProvider<SubscriptionCubit>(
    create: (BuildContext context) => SubscriptionCubit(),
  ),
  BlocProvider<TodayCubit>(create: (BuildContext context) => TodayCubit()),
  BlocProvider<TonightsPlanCubit>(
    create: (BuildContext context) => TonightsPlanCubit(),
  ),
  BlocProvider<TryingThisWeekCubit>(
    create: (BuildContext context) => TryingThisWeekCubit(),
  ),
  BlocProvider<WeeklyFamilyReviewCubit>(
    create: (BuildContext context) => WeeklyFamilyReviewCubit(),
  ),
];
