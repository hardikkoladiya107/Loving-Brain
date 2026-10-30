import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';

import 'package:loving_brain/manager/deep_link/deep_link_manager.dart';
import 'package:loving_brain/other/notification_util.dart';
import '../../other/preferances.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(seconds: 2), _continueFromSplash);
    });
    super.initState();
  }

  void _continueFromSplash() {
    if (!mounted) {
      return;
    }
    // An invitation route was pushed on top of splash. Replacing the stack
    // here disposes that screen while its loading barrier is still up, and
    // the barrier keeps eating taps on Today.
    final GoRouter router = GoRouter.of(context);
    if (router.canPop()) {
      return;
    }
    if (router.state.uri.path != RoutePaths.splash) {
      return;
    }
    if (DeepLinkManager.instance.isHandlingInvitation) {
      Future<void>.delayed(
        const Duration(milliseconds: 300),
        _continueFromSplash,
      );
      return;
    }
    final UserModel? userModel = preferences.getUserModel();
    final bool isLogin =
        (preferences.getBool(SharedPreference.isLogin) ?? false) &&
        (userModel?.uid?.trim().isNotEmpty ?? false);

    if (isLogin) {
      if (userModel?.isOnboardingCompleted != true) {
        context.go(RoutePaths.onboarding);
        return;
      }
      final String? pendingRoute =
          NotificationUtil.consumePendingNotificationRoute();
      if (pendingRoute != null) {
        context.go(pendingRoute);
        return;
      }
      context.go(RoutePaths.base);
    } else {
      context.go(RoutePaths.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF8F4),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.v2.images.imgBg.path),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Assets.v2.icons.icAppIconSvg.svg(
                height: 110.h,
                width: 110.w,
              ),
            ),
            14.spaceH,
            Assets.v2.icons.icLovingBrainText.svg(),
          ],
        ),
      ),
    );
  }
}
