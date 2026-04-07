import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';
import 'package:loving_brain/ui/auth/on_boarding/on_boarding_screen2.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg1.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Spacer(flex: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LocaleKeys.welcomeTo.tr().appText(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                      8.spaceH,
                      LocaleKeys.lovingBrain.tr().appText(
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                        letterSpacing: 1.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(flex: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LocaleKeys.becauseEveryChildDeservesTheBestVersionOfYou
                          .tr()
                          .appText(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            height: 1.4,
                          )
                          .appPadding(left: 10, right: 10),
                      40.spaceH,
                      _getStartedButton(),
                      10.spaceH,
                    ],
                  ),
                ),
              ),
            ).appPadding(left: 20, right: 20),
            60.spaceH,
          ],
        ),
      ),
    );
  }

  Widget _getStartedButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: yellowColor2,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: yellowColor2.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.getStarted.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ],
        ).appPadding(top: 16, bottom: 16),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen2()),
        );
      },
    ).appPadding(left: 10, right: 10);
  }

  Widget _loginButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.login.tr().appText(fontWeight: FontWeight.w700),
          ],
        ).appPadding(top: 10, bottom: 10),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
    ).appPadding(left: 30, right: 30);
  }
}
