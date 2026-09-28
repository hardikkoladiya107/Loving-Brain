import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';

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
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        final bool isLogin =
            preferences.getBool(SharedPreference.isLogin) ?? false;

        if (isLogin) {
          final userModel = preferences.getUserModel();
          if (userModel == null || !userModel.isOnboardingCompleted) {
            context.go(RoutePaths.onboarding);
            return;
          }
          context.go(RoutePaths.base);
        } else {
          context.go(RoutePaths.welcome);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.v2.images.imgBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Assets.v2.icons.icAppIcon.svg()),
            14.spaceH,
            Assets.v2.icons.icLovingBrainText.svg(),
          ],
        ),
      ),
    );
  }
}
