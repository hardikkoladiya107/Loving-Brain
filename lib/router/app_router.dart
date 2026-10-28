import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/auth/co_parent_register/co_parent_register_screen.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';
import 'package:loving_brain/ui/auth/otp/otp_screen.dart';
import 'package:loving_brain/ui/auth/register/register_screen.dart';
import 'package:loving_brain/ui/auth/welcome/welcome_screen.dart';
import 'package:loving_brain/ui/base_screen/base_screen.dart';
import 'package:loving_brain/ui/child_essentials/allergies_screen.dart';
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
import 'package:loving_brain/ui/child_essentials/medications_screen.dart';
import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';
import 'package:loving_brain/ui/family_snapsshot/family_snapshot_screen.dart';
import 'package:loving_brain/ui/help_flow/help_guidance_screen.dart';
import 'package:loving_brain/ui/help_flow/help_problem_selection_screen.dart';
import 'package:loving_brain/ui/onboarding/onboarding_screen.dart';
import 'package:loving_brain/ui/parent_profile_v2/parent_profile_screen.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/splash/splash_screen.dart';
import 'package:loving_brain/ui/subscription/subscription_screen.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:loving_brain/ui/faq/faq_screen.dart';
import 'package:loving_brain/ui/microphone_permission/microphone_permission_screen.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/notifications_permission/notifications_permission_screen.dart';
import 'package:loving_brain/ui/session_request_confirmation/session_request_confirmation_screen.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_behaviour_sheet.dart';
import 'package:loving_brain/ui/tonights_plan/tonights_plan_screen.dart';
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
                location == RoutePaths.coParentRegister ||
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
            RoutePaths.coParentRegister,
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
          path: RoutePaths.coParentRegister,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>? ?? {};
            return CoParentRegisterScreen(
              email: (extra['email'] as String?) ?? '',
              invitationId: (extra['invitationId'] as String?) ?? '',
            );
          },
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
          builder: (BuildContext context, GoRouterState state) =>
              const SessionRequestConfirmationScreen(),
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
