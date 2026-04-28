import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/auth/forgot_password/forgot_password_screen.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';
import 'package:loving_brain/ui/auth/on_boarding/on_boarding_screen1.dart';
import 'package:loving_brain/ui/auth/on_boarding/on_boarding_screen2.dart';
import 'package:loving_brain/ui/auth/on_boarding/on_boarding_screen3.dart';
import 'package:loving_brain/ui/auth/on_boarding/welcome_screen.dart';
import 'package:loving_brain/ui/auth/register/register_screen.dart';
import 'package:loving_brain/ui/base_screen/base_screen.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/parent_profile/parent_profile_screen.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/splash/splash_screen.dart';
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';

import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RoutePaths.splash,
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn =
            preferences.getBool(SharedPreference.isLogin) ?? false;
        final String location = state.uri.path;

        const Set<String> guestRoutes = <String>{
          RoutePaths.splash,
          RoutePaths.welcome,
          RoutePaths.onboarding1,
          RoutePaths.onboarding2,
          RoutePaths.onboarding3,
          RoutePaths.login,
          RoutePaths.register,
          RoutePaths.forgotPassword,
          RoutePaths.terms,
          RoutePaths.privacy,
        };

        if (isLoggedIn && guestRoutes.contains(location)) {
          return RoutePaths.base;
        }

        if (!isLoggedIn && location == RoutePaths.base) {
          return RoutePaths.welcome;
        }
        return null;
      },
      routes: <RouteBase>[
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
          path: RoutePaths.onboarding1,
          builder: (BuildContext context, GoRouterState state) =>
              const OnBoardingScreen1(),
        ),
        GoRoute(
          path: RoutePaths.onboarding2,
          builder: (BuildContext context, GoRouterState state) =>
              const OnBoardingScreen2(),
        ),
        GoRoute(
          path: RoutePaths.onboarding3,
          builder: (BuildContext context, GoRouterState state) =>
              const OnBoardingScreen3(),
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
          path: RoutePaths.forgotPassword,
          builder: (BuildContext context, GoRouterState state) =>
              const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: RoutePaths.terms,
          builder: (BuildContext context, GoRouterState state) =>
              const TermsAndConditionsScreen(),
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
      ],
    );
  }
}
