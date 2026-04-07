import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';
import 'package:loving_brain/ui/auth/on_boarding/on_boarding_screen1.dart';
import 'package:loving_brain/ui/privacy_policy/privacy_policy_screen.dart';
import 'package:loving_brain/ui/terms_and_conditions/terms_and_conditions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:flutter/gestures.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
            Spacer(),
            _buildTermsText(),
            40.spaceH,
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
        bool hasSeen = preferences.getBool(SharedPreference.hasSeenOnboarding, defValue: false) ?? false;
        if (hasSeen) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OnBoardingScreen1()),
          );
        }
      },
    ).appPadding(left: 10, right: 10);
  }



  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: getTextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: "By continuing, you agree to our "),
          TextSpan(
            text: "Terms & Conditions",
            style: getTextStyle(
               color: blueTextColor,
               fontSize: 12,
               fontWeight: FontWeight.bold,
               textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen(),
                ));
              },
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy",
            style: getTextStyle(
               color: blueTextColor,
               fontSize: 12,
               fontWeight: FontWeight.bold,
               textDecoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ));
              },
          ),
          TextSpan(text: "."),
        ],
      ),
    ).appPadding(left: 24, right: 24);
  }
}
