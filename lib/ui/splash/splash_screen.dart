import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/preferances.dart';
import '../base_screen/base_screen.dart';
import '../on_boarding/on_boarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        Future.delayed(Duration(seconds: 2), () {
          if (preferences.getBool(SharedPreference.isLogin) ?? false) {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => const BaseScreen()),
            );
          } else {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnBoardingScreen1(),
              ),
            );
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgSplashBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            240.spaceH,
            LocaleKeys.appName.tr().appText(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 30,
            ),
            10.spaceH,
            LocaleKeys.yourPersonalParentingCoPilot.tr().appText(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
