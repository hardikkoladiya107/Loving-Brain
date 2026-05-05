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

import 'package:loving_brain/ui/subscription/subscription_screen.dart';
import 'package:loving_brain/ui/daily_mood_check_in/daily_mood_check_in_screen.dart';
import 'package:loving_brain/ui/daily_mood_log/daily_mood_log.dart';
import 'package:loving_brain/ui/schedule/schedule_screen.dart';
import 'package:loving_brain/ui/chat_list/chat_list_screen.dart';
import 'package:loving_brain/ui/write_your_thought/write_your_thought_screen.dart';
import 'package:loving_brain/ui/manage_children/manage_children_screen.dart';
import 'package:loving_brain/ui/event_detail/event_detail_screen.dart';
import 'package:loving_brain/ui/event_approval/event_approval_screen.dart';
import 'package:loving_brain/ui/ai_chat/ai_chat_screen.dart';
import 'package:loving_brain/ui/your_streak/your_streak_screen.dart';
import 'package:loving_brain/ui/essentials/essentials_screen.dart';
import 'package:loving_brain/ui/energy_bridge/energy_bridge_screen.dart';
import 'package:loving_brain/ui/sleep_summary/sleep_summary_screen.dart';
import 'package:loving_brain/ui/new_behavior/new_behavior_screen.dart';
import 'package:loving_brain/ui/reflect_your_emotions/reflect_your_emotions.dart';
import 'package:loving_brain/ui/family_meter/family_meter_state_detail_screen.dart';
import 'package:loving_brain/ui/family_meter/family_meter_state_picker_screen.dart';
import 'package:loving_brain/ui/smart_moment/smart_moment_screen.dart';
import 'package:loving_brain/ui/help_flow/help_guidance_screen.dart';
import 'package:loving_brain/ui/help_flow/help_problem_selection_screen.dart';
import 'package:loving_brain/ui/propose_change/propose_change_screen.dart';
import 'package:loving_brain/ui/thought_list/thought_list_scren.dart';
import 'package:loving_brain/ui/chat_detail/chat_detail_screen.dart';
import 'package:loving_brain/ui/add_shared_event/add_shared_event_screen.dart';
import 'package:loving_brain/ui/link_co_parent/link_co_parent_screen.dart';
import 'package:loving_brain/model/shared_event_model.dart';

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

        // Auth / onboarding only: logged-in users are sent to the app shell.
        // Terms and privacy stay reachable from profile (do not list them here).
        const Set<String> authFlowRoutes = <String>{
          RoutePaths.splash,
          RoutePaths.welcome,
          RoutePaths.onboarding1,
          RoutePaths.onboarding2,
          RoutePaths.onboarding3,
          RoutePaths.login,
          RoutePaths.register,
          RoutePaths.forgotPassword,
        };

        if (isLoggedIn && authFlowRoutes.contains(location)) {
          return RoutePaths.base;
        }

        if (!isLoggedIn && location == RoutePaths.base) {
          return RoutePaths.welcome;
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
          path: RoutePaths.dailyMoodCheckIn,
          builder: (BuildContext context, GoRouterState state) =>
              const DailyMoodCheckInScreen(),
        ),
        GoRoute(
          path: RoutePaths.dailyMoodLog,
          builder: (BuildContext context, GoRouterState state) =>
              const DailyMoodLog(),
        ),
        GoRoute(
          path: RoutePaths.schedule,
          builder: (BuildContext context, GoRouterState state) =>
              const ScheduleScreen(),
        ),
        GoRoute(
          path: RoutePaths.chatList,
          builder: (BuildContext context, GoRouterState state) =>
              const ChatListScreen(),
        ),
        GoRoute(
          path: RoutePaths.writeYourThought,
          builder: (BuildContext context, GoRouterState state) =>
              const WriteYourThoughtScreen(),
        ),
        GoRoute(
          path: RoutePaths.manageChildren,
          builder: (BuildContext context, GoRouterState state) =>
              const ManageChildrenScreen(),
        ),
        GoRoute(
          path: RoutePaths.eventDetail,
          builder: (BuildContext context, GoRouterState state) {
            final sharedEvent = state.extra as SharedEventModel?;
            if (sharedEvent == null) return const SizedBox();
            return EventDetailScreen(sharedEvent: sharedEvent);
          },
        ),
        GoRoute(
          path: RoutePaths.eventApproval,
          builder: (BuildContext context, GoRouterState state) {
            final sharedEvent = state.extra as SharedEventModel?;
            if (sharedEvent == null) return const SizedBox();
            return EventApprovalScreen(sharedEvent: sharedEvent);
          },
        ),
        GoRoute(
          path: RoutePaths.aiChat,
          builder: (BuildContext context, GoRouterState state) =>
              const AiChatScreen(),
        ),
        GoRoute(
          path: RoutePaths.yourStreak,
          builder: (BuildContext context, GoRouterState state) =>
              const YourStreakScreen(),
        ),
        GoRoute(
          path: RoutePaths.essentials,
          builder: (BuildContext context, GoRouterState state) =>
              const EssentialsScreen(),
        ),
        GoRoute(
          path: RoutePaths.energyBridge,
          builder: (BuildContext context, GoRouterState state) =>
              const EnergyBridgeScreen(),
        ),
        GoRoute(
          path: RoutePaths.sleepSummary,
          builder: (BuildContext context, GoRouterState state) =>
              const SleepSummaryScreen(),
        ),
        GoRoute(
          path: RoutePaths.newBehavior,
          builder: (BuildContext context, GoRouterState state) =>
              const NewBehaviorScreen(),
        ),
        GoRoute(
          path: RoutePaths.reflectYourEmotions,
          builder: (BuildContext context, GoRouterState state) =>
              const ReflectYourEmotions(),
        ),
        GoRoute(
          path: RoutePaths.familyMeterStateDetail,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilyMeterStateDetailScreen(),
        ),
        GoRoute(
          path: RoutePaths.familyMeterStatePicker,
          builder: (BuildContext context, GoRouterState state) =>
              const FamilyMeterStatePickerScreen(),
        ),
        GoRoute(
          path: RoutePaths.smartMoment,
          builder: (BuildContext context, GoRouterState state) =>
              const SmartMomentScreen(),
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
          path: RoutePaths.proposeChange,
          builder: (BuildContext context, GoRouterState state) {
            final sharedEvent = state.extra as SharedEventModel?;
            return ProposeChangeScreen(sharedEvent: sharedEvent!);
          },
        ),
        GoRoute(
          path: RoutePaths.thoughtList,
          builder: (BuildContext context, GoRouterState state) =>
              const ThoughtListScreen(),
        ),
        GoRoute(
          path: RoutePaths.chatDetail,
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return ChatDetailScreen(
              initialChat: extra['initialChat'] as String?,
              conversationId: extra['conversationId'] as String?,
            );
          },
        ),
        GoRoute(
          path: RoutePaths.addSharedEvent,
          builder: (BuildContext context, GoRouterState state) =>
              const AddSharedEventScreen(),
        ),
        GoRoute(
          path: RoutePaths.linkCoParent,
          builder: (BuildContext context, GoRouterState state) =>
              const LinkCoParentScreen(),
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
