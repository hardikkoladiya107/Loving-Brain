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
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
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
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';

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
                location == RoutePaths.privacy) {
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
          if (location == RoutePaths.base ||
              location == RoutePaths.onboarding ||
              location == RoutePaths.familySnapshot) {
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
            final String? destination = state.extra as String?;
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
          path: RoutePaths.familySnapshot,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilySnapshotScreen(),
        ),
      ],
    );
  }
}
