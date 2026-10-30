import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/add_child/add_child_screen.dart';
import 'package:loving_brain/ui/after_reflection/after_reflection_screen.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';
import 'package:loving_brain/ui/auth/otp/otp_screen.dart';
import 'package:loving_brain/ui/auth/register/register_screen.dart';
import 'package:loving_brain/ui/auth/welcome/welcome_screen.dart';
import 'package:loving_brain/ui/base_screen/base_screen.dart';
import 'package:loving_brain/ui/behaviour_pattern/behaviour_pattern_screen.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/brainy_history/brainy_history_screen.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/brainy_saved_guidance_screen.dart';
import 'package:loving_brain/ui/calm_heads_up/calm_heads_up_screen.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/child_essentials/allergies_screen.dart';
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
import 'package:loving_brain/ui/child_essentials/medications_screen.dart';
import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';
import 'package:loving_brain/ui/choose_support_area/choose_support_area_screen.dart';
import 'package:loving_brain/ui/consistency_recognition/consistency_recognition_screen.dart';
import 'package:loving_brain/ui/enrolled_journey_home/enrolled_journey_home_screen.dart';
import 'package:loving_brain/ui/family_menu/family_menu_screen.dart';
import 'package:loving_brain/ui/family_sharing_consent/family_sharing_consent_screen.dart';
import 'package:loving_brain/ui/family_snapsshot/family_snapshot_screen.dart';
import 'package:loving_brain/ui/family_timeline/family_timeline_screen.dart';
import 'package:loving_brain/ui/faq/faq_screen.dart';
import 'package:loving_brain/ui/guide_list/guide_list_screen.dart';
import 'package:loving_brain/ui/guide_profile/guide_profile_screen.dart';
import 'package:loving_brain/ui/harder_week/harder_week_screen.dart';
import 'package:loving_brain/ui/help_flow/help_guidance_screen.dart';
import 'package:loving_brain/ui/help_flow/help_problem_selection_screen.dart';
import 'package:loving_brain/ui/help_safety/help_safety_screen.dart';
import 'package:loving_brain/ui/invite_accepted/invite_accepted_screen.dart';
import 'package:loving_brain/ui/invite_caregiver/invite_caregiver_screen.dart';
import 'package:loving_brain/ui/invite_pending/invite_pending_screen.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
import 'package:loving_brain/ui/microphone_permission/microphone_permission_screen.dart';
import 'package:loving_brain/ui/notifications/notifications_screen.dart';
import 'package:loving_brain/ui/notifications_permission/notifications_permission_screen.dart';
import 'package:loving_brain/ui/onboarding/onboarding_screen.dart';
import 'package:loving_brain/ui/parent_profile_v2/parent_profile_screen.dart';
import 'package:loving_brain/ui/parent_success_guide/parent_success_guide_screen.dart';
import 'package:loving_brain/ui/permissions/permissions_screen.dart';
import 'package:loving_brain/ui/post_session_plan/post_session_plan_screen.dart';
import 'package:loving_brain/ui/privacy_data/privacy_data_screen.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/program_recommendation/program_recommendation_screen.dart';
import 'package:loving_brain/ui/programme_detail/programme_detail_screen.dart';
import 'package:loving_brain/ui/request_session/request_session_screen.dart';
import 'package:loving_brain/ui/session_request_confirmation/session_request_confirmation_screen.dart';
import 'package:loving_brain/ui/shared_child_summary/shared_child_summary_screen.dart';
import 'package:loving_brain/ui/sleep_details/sleep_details_screen.dart';
import 'package:loving_brain/ui/sleep_forecast/sleep_forecast_screen.dart';
import 'package:loving_brain/ui/sleep_low_confidence/sleep_low_confidence_screen.dart';
import 'package:loving_brain/ui/sleep_no_data/sleep_no_data_screen.dart';
import 'package:loving_brain/ui/sleep_pattern/sleep_pattern_screen.dart';
import 'package:loving_brain/ui/splash/splash_screen.dart';
import 'package:loving_brain/ui/states_gallery/states_gallery_screen.dart';
import 'package:loving_brain/ui/subscription/subscription_screen.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_behaviour_sheet.dart';
import 'package:loving_brain/ui/tonights_plan/tonights_plan_screen.dart';
import 'package:loving_brain/ui/trying_this_week/trying_this_week_screen.dart';
import 'package:loving_brain/ui/weekly_family_review/weekly_family_review_screen.dart';

import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RoutePaths.splash,
      redirect: (BuildContext context, GoRouterState state) {
        final UserModel? userModel = preferences.getUserModel();
        final bool isLoggedIn =
            (preferences.getBool(SharedPreference.isLogin) ?? false) &&
            (userModel?.uid?.trim().isNotEmpty ?? false);
        final bool isOnboarded = userModel?.isOnboardingCompleted ?? false;

        final String location = state.uri.path;

        if (location == RoutePaths.splash) {
          return null;
        }

        const Set<String> unauthenticatedOnlyRoutes = <String>{
          RoutePaths.welcome,
          RoutePaths.login,
          RoutePaths.register,
          RoutePaths.otp,
        };

        if (isLoggedIn) {
          if (!isOnboarded) {
            if (location == RoutePaths.onboarding ||
                location == RoutePaths.familySnapshot ||
                location == RoutePaths.terms ||
                location == RoutePaths.privacy ||
                location == RoutePaths.faq) {
              return null;
            }
            if (unauthenticatedOnlyRoutes.contains(location) ||
                location == RoutePaths.base) {
              return RoutePaths.onboarding;
            }
          } else {
            if (unauthenticatedOnlyRoutes.contains(location) ||
                location == RoutePaths.onboarding) {
              return RoutePaths.base;
            }
          }
        } else {
          const Set<String> publicRoutes = <String>{
            RoutePaths.welcome,
            RoutePaths.login,
            RoutePaths.register,
            RoutePaths.otp,
            RoutePaths.terms,
            RoutePaths.privacy,
            RoutePaths.faq,
          };
          if (!publicRoutes.contains(location)) {
            return RoutePaths.welcome;
          }
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.subscription,
          builder: (BuildContext context, GoRouterState state) =>
              const SubscriptionScreen(),
        ),
        GoRoute(
          path: RoutePaths.essentials,
          builder: (BuildContext context, GoRouterState state) =>
              const ChildEssentialsScreen(),
        ),
        GoRoute(
          path: RoutePaths.allergies,
          builder: (BuildContext context, GoRouterState state) =>
              const AllergiesScreen(),
        ),
        GoRoute(
          path: RoutePaths.medications,
          builder: (BuildContext context, GoRouterState state) =>
              const MedicationsScreen(),
        ),
        GoRoute(
          path: RoutePaths.helpProblemSelection,
          builder: (BuildContext context, GoRouterState state) =>
              const HelpProblemSelectionScreen(),
        ),
        GoRoute(
          path: RoutePaths.helpGuidance,
          builder: (BuildContext context, GoRouterState state) =>
              const HelpGuidanceScreen(),
        ),
        GoRoute(
          path: RoutePaths.splash,
          builder: (BuildContext context, GoRouterState state) =>
              const SplashScreen(),
        ),
        GoRoute(
          path: RoutePaths.welcome,
          builder: (BuildContext context, GoRouterState state) =>
              const WelcomeScreen(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.register,
          builder: (BuildContext context, GoRouterState state) =>
              const RegisterScreen(),
        ),
        GoRoute(
          path: RoutePaths.onboarding,
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingScreen(),
        ),
        GoRoute(
          path: RoutePaths.otp,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            if (extra is Map<String, dynamic>) {
              return OtpScreen(
                destination: extra['destination'] as String?,
                verificationId: extra['verificationId'] as String?,
                resendToken: extra['resendToken'] as int?,
                isPhoneAuth: extra['isPhoneAuth'] as bool? ?? false,
                linkedEmail: extra['linkedEmail'] as String?,
                linkedPhone: extra['linkedPhone'] as String?,
              );
            }
            final String? destination = extra as String?;
            return OtpScreen(destination: destination);
          },
        ),
        GoRoute(
          path: RoutePaths.terms,
          builder: (BuildContext context, GoRouterState state) =>
              const TermsAndConditionsScreen(),
        ),
        GoRoute(
          path: RoutePaths.successScreen,
          builder: (BuildContext context, GoRouterState state) {
            final String text = state.extra as String? ?? '';
            return SucessScreen(successText: text);
          },
        ),
        GoRoute(
          path: RoutePaths.privacy,
          builder: (BuildContext context, GoRouterState state) =>
              const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: RoutePaths.parentProfile,
          builder: (BuildContext context, GoRouterState state) =>
              const ParentProfileScreen(),
        ),
        GoRoute(
          path: RoutePaths.childProfile,
          builder: (BuildContext context, GoRouterState state) {
            final String userId = state.pathParameters['userId'] ?? '';
            final bool fromManageChildren =
                state.uri.queryParameters['fromManageChildren'] == 'true';
            return ChildProfileScreen(
              userId: userId,
              fromManageChildren: fromManageChildren,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.addChild,
          builder: (BuildContext context, GoRouterState state) =>
              const AddChildScreen(),
        ),
        GoRoute(
          path: RoutePaths.base,
          builder: (BuildContext context, GoRouterState state) =>
              const BaseScreen(),
        ),
        GoRoute(
          path: RoutePaths.faq,
          builder: (BuildContext context, GoRouterState state) =>
              const FaqScreen(),
        ),
        GoRoute(
          path: RoutePaths.familySnapshot,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilySnapshotScreen(),
        ),
        GoRoute(
          path: RoutePaths.notificationsPermission,
          builder: (BuildContext context, GoRouterState state) =>
              const NotificationsPermissionScreen(),
        ),
        GoRoute(
          path: RoutePaths.microphonePermission,
          builder: (BuildContext context, GoRouterState state) =>
              const MicrophonePermissionScreen(),
        ),
        GoRoute(
          path: RoutePaths.tonightsPlan,
          builder: (BuildContext context, GoRouterState state) =>
              const TonightsPlanScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepForecast,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepForecastScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepDetails,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepDetailsScreen(),
        ),
        GoRoute(
          path: RoutePaths.calmPlan,
          builder: (BuildContext context, GoRouterState state) =>
              const CalmPlanScreen(),
        ),
        GoRoute(
          path: RoutePaths.weeklyReview,
          builder: (BuildContext context, GoRouterState state) =>
              const WeeklyFamilyReviewScreen(),
        ),
        GoRoute(
          path: RoutePaths.sessionConfirmation,
          builder: (BuildContext context, GoRouterState state) {
            final String? guideName = state.uri.queryParameters['guideName'] ??
                (state.extra is String ? state.extra as String : null);
            return SessionRequestConfirmationScreen(guideName: guideName);
          },
        ),
        GoRoute(
          path: RoutePaths.quickUpdate,
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(
                backgroundColor: Color(0xFFF7F7F7),
                body: SafeArea(child: AddBehaviourSheet()),
              ),
        ),
        GoRoute(
          path: RoutePaths.mentorshipLanding,
          builder: (BuildContext context, GoRouterState state) =>
              const MentorshipLandingScreen(),
        ),
        GoRoute(
          path: RoutePaths.consistencyRecognition,
          builder: (BuildContext context, GoRouterState state) {
            final int? days = int.tryParse(
              state.uri.queryParameters['days'] ?? '',
            );
            return ConsistencyRecognitionScreen(initialDaysCheckedIn: days);
          },
        ),
        GoRoute(
          path: RoutePaths.brainyConversation,
          builder: (BuildContext context, GoRouterState state) {
            String? conversationId =
                state.uri.queryParameters['conversationId'];
            String? initialChat = state.uri.queryParameters['initialChat'];
            String? topic = state.uri.queryParameters['topic'];
            File? initialAudioFile;
            List<String>? initialImagePaths;

            final dynamic extra = state.extra;
            if (extra is Map<String, dynamic>) {
              conversationId =
                  extra['conversationId'] as String? ?? conversationId;
              initialChat = extra['initialChat'] as String? ?? initialChat;
              topic = extra['topic'] as String? ?? topic;
              initialAudioFile = extra['initialAudioFile'] as File?;
              initialImagePaths = extra['initialImagePaths'] as List<String>?;
            } else if (extra is String) {
              initialChat = extra;
            }

            return BrainyConversationScreen(
              conversationId: conversationId,
              initialChat: initialChat,
              initialAudioFile: initialAudioFile,
              initialImagePaths: initialImagePaths,
              topic: topic,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.brainyHistory,
          builder: (BuildContext context, GoRouterState state) =>
              const BrainyHistoryScreen(),
        ),
        GoRoute(
          path: RoutePaths.brainySaved,
          builder: (BuildContext context, GoRouterState state) =>
              const BrainySavedGuidanceScreen(),
        ),
        GoRoute(
          path: RoutePaths.helpSafety,
          builder: (BuildContext context, GoRouterState state) =>
              const HelpSafetyScreen(),
        ),
        GoRoute(
          path: RoutePaths.behaviourPattern,
          builder: (BuildContext context, GoRouterState state) =>
              const BehaviourPatternScreen(),
        ),
        GoRoute(
          path: RoutePaths.calmHeadsUp,
          builder: (BuildContext context, GoRouterState state) =>
              const CalmHeadsUpScreen(),
        ),
        GoRoute(
          path: RoutePaths.afterReflection,
          builder: (BuildContext context, GoRouterState state) =>
              const AfterReflectionScreen(),
        ),
        GoRoute(
          path: RoutePaths.chooseSupportArea,
          builder: (BuildContext context, GoRouterState state) {
            final String? initialArea =
                state.uri.queryParameters['initialArea'] ??
                (state.extra is String ? state.extra as String : null);
            return ChooseSupportAreaScreen(initialArea: initialArea);
          },
        ),
        GoRoute(
          path: RoutePaths.guideList,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            String supportArea = state.uri.queryParameters['supportArea'] ?? '';
            List<GuideProfileModel>? guides;
            if (extra is Map<String, dynamic>) {
              supportArea = extra['supportArea'] as String? ?? supportArea;
              guides = extra['guides'] as List<GuideProfileModel>?;
            } else if (extra is List<GuideProfileModel>) {
              guides = extra;
            } else if (extra is String) {
              supportArea = extra;
            }
            return GuideListScreen(supportArea: supportArea, guides: guides);
          },
        ),
        GoRoute(
          path: RoutePaths.guideProfile,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            String? guideId = state.uri.queryParameters['guideId'];
            String? supportArea = state.uri.queryParameters['supportArea'];
            if (extra is Map<String, dynamic>) {
              guideId = extra['guideId'] as String? ?? guideId;
              supportArea = extra['supportArea'] as String? ?? supportArea;
            } else if (extra is String) {
              guideId = extra;
            }
            return GuideProfileScreen(
              guideId: guideId,
              supportArea: supportArea,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.requestSession,
          builder: (BuildContext context, GoRouterState state) {
            final GuideProfileModel? guide = state.extra as GuideProfileModel?;
            return RequestSessionScreen(guide: guide);
          },
        ),
        GoRoute(
          path: RoutePaths.parentSuccessGuide,
          builder: (BuildContext context, GoRouterState state) {
            final String? guideId =
                state.uri.queryParameters['guideId'] ??
                (state.extra is String ? state.extra as String : null);
            return ParentSuccessGuideScreen(guideId: guideId);
          },
        ),
        GoRoute(
          path: RoutePaths.postSessionPlan,
          builder: (BuildContext context, GoRouterState state) =>
              const PostSessionPlanScreen(),
        ),
        GoRoute(
          path: RoutePaths.programmeDetail,
          builder: (BuildContext context, GoRouterState state) =>
              const ProgrammeDetailScreen(),
        ),
        GoRoute(
          path: RoutePaths.enrolledJourney,
          builder: (BuildContext context, GoRouterState state) =>
              const EnrolledJourneyHomeScreen(),
        ),
        GoRoute(
          path: RoutePaths.programRecommendation,
          builder: (BuildContext context, GoRouterState state) =>
              const ProgramRecommendationScreen(),
        ),
        GoRoute(
          path: RoutePaths.mentorshipUnavailable,
          builder: (BuildContext context, GoRouterState state) {
            final String? detail =
                state.uri.queryParameters['detail'] ??
                (state.extra is String ? state.extra as String : null);
            return MentorshipUnavailableScreen(detail: detail);
          },
        ),
        GoRoute(
          path: RoutePaths.familyTimeline,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilyTimelineScreen(),
        ),
        GoRoute(
          path: RoutePaths.familyMenu,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilyMenuScreen(),
        ),
        GoRoute(
          path: RoutePaths.permissions,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            String? caregiverName = state.uri.queryParameters['caregiverName'];
            String? caregiverRole = state.uri.queryParameters['caregiverRole'];
            String? caregiverId = state.uri.queryParameters['caregiverId'];
            String? caregiverEmail =
                state.uri.queryParameters['caregiverEmail'];
            if (extra is Map<String, dynamic>) {
              caregiverName =
                  extra['caregiverName'] as String? ?? caregiverName;
              caregiverRole =
                  extra['caregiverRole'] as String? ?? caregiverRole;
              caregiverId = extra['caregiverId'] as String? ?? caregiverId;
              caregiverEmail =
                  extra['caregiverEmail'] as String? ?? caregiverEmail;
            }
            return PermissionsScreen(
              caregiverName: caregiverName,
              caregiverRole: caregiverRole,
              caregiverId: caregiverId,
              caregiverEmail: caregiverEmail,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.inviteCaregiver,
          builder: (BuildContext context, GoRouterState state) =>
              const InviteCaregiverScreen(),
        ),
        GoRoute(
          path: RoutePaths.invitePending,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            String? invitationId = state.uri.queryParameters['invitationId'];
            String? recipientEmail =
                state.uri.queryParameters['recipientEmail'];
            String? role = state.uri.queryParameters['role'];
            String? childName = state.uri.queryParameters['childName'];
            if (extra is Map<String, dynamic>) {
              invitationId = extra['invitationId'] as String? ?? invitationId;
              recipientEmail =
                  extra['recipientEmail'] as String? ?? recipientEmail;
              role = extra['role'] as String? ?? role;
              childName = extra['childName'] as String? ?? childName;
            }
            return InvitePendingScreen(
              invitationId: invitationId,
              recipientEmail: recipientEmail,
              role: role,
              childName: childName,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.inviteAccepted,
          builder: (BuildContext context, GoRouterState state) {
            final dynamic extra = state.extra;
            String? caregiverName = state.uri.queryParameters['caregiverName'];
            String? caregiverRole = state.uri.queryParameters['caregiverRole'];
            if (extra is Map<String, dynamic>) {
              caregiverName =
                  extra['caregiverName'] as String? ?? caregiverName;
              caregiverRole =
                  extra['caregiverRole'] as String? ?? caregiverRole;
            }
            return InviteAcceptedScreen(
              caregiverName: caregiverName,
              caregiverRole: caregiverRole,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.familySharingConsent,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilySharingConsentScreen(),
        ),
        GoRoute(
          path: RoutePaths.sharedChildSummary,
          builder: (BuildContext context, GoRouterState state) =>
              const SharedChildSummaryScreen(),
        ),
        GoRoute(
          path: RoutePaths.harderWeek,
          builder: (BuildContext context, GoRouterState state) =>
              const HarderWeekScreen(),
        ),
        GoRoute(
          path: RoutePaths.tryingThisWeek,
          builder: (BuildContext context, GoRouterState state) =>
              const TryingThisWeekScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepPattern,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepPatternScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepNoData,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepNoDataScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepLowConfidence,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepLowConfidenceScreen(),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          builder: (BuildContext context, GoRouterState state) =>
              const NotificationsScreen(),
        ),
        GoRoute(
          path: RoutePaths.privacyData,
          builder: (BuildContext context, GoRouterState state) =>
              const PrivacyDataScreen(),
        ),
        GoRoute(
          path: RoutePaths.statesGallery,
          builder: (BuildContext context, GoRouterState state) =>
              const StatesGalleryScreen(),
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) {
        if (state.uri.path == '/faq' || state.uri.toString().contains('faq')) {
          return const FaqScreen();
        }
        final UserModel? userModel = preferences.getUserModel();
        final bool isLoggedIn =
            (preferences.getBool(SharedPreference.isLogin) ?? false) &&
            (userModel?.uid?.trim().isNotEmpty ?? false);
        if (!isLoggedIn) {
          return const WelcomeScreen();
        }
        return const BaseScreen();
      },
    );
  }
}
