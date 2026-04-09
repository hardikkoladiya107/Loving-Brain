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
        color: const Color(0xFFF0F4FF), // fallback color
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg1.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1400),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Column(
              children: [
                Spacer(flex: 3),
                Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: _buildTitleCard(),
                  ),
                ),
                Spacer(flex: 5),
                Transform.translate(
                  offset: Offset(0, 80 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: _buildActionCard(),
                  ),
                ),
                Spacer(),
                _buildTermsText(),
                40.spaceH,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocaleKeys.welcomeTo.tr().appText(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 2.0,
                color: const Color(0xFF6B7280),
              ),
              6.spaceH,
              LocaleKeys.lovingBrain.tr().appText(
                fontWeight: FontWeight.w900,
                fontSize: 36,
                letterSpacing: 1.2,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: Offset(0, 15),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocaleKeys.becauseEveryChildDeservesTheBestVersionOfYou
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    height: 1.4,
                    color: const Color(0xFF4B5563),
                  )
                  .appPadding(left: 12, right: 12),
              24.spaceH,
              _getStartedButton(),
            ],
          ),
        ),
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _getStartedButton() {
    return BaseButton(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFFD700), const Color(0xFFFFB700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB700).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: LocaleKeys.getStarted.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
            color: const Color(0xFF1F2937),
          ),
        ),
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
          color: const Color(0xFF4B5563),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: "By continuing, you agree to our "),
          TextSpan(
            text: "Terms & Conditions",
            style: getTextStyle(
               color: primaryColor,
               fontSize: 12,
               fontWeight: FontWeight.w800,
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
               color: primaryColor,
               fontSize: 12,
               fontWeight: FontWeight.w800,
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
