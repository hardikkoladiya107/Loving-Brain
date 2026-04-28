import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../widget/base_button.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg3.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              _personalizedCard().appPadding(left: 24, right: 24),
              Spacer(flex: 2),
              _floatingGlassInfo(
                text: LocaleKeys.weGuideYouThroughParenting.tr(),
              ).appPadding(left: 30, right: 30),
              24.spaceH,
              _floatingGlassInfo(
                text: LocaleKeys.takeAFree2weekCoaching.tr(),
              ).appPadding(left: 30, right: 30),
              Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_nextButton()],
              ),
              30.spaceH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingGlassInfo({required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: text.appText(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            textAlign: TextAlign.center,
            color: const Color(0xFF1F2937),
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _personalizedCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              LocaleKeys.personalizedParentSupport.tr().appText(
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
                fontSize: 26,
                letterSpacing: 1.2,
                color: const Color(0xFF1F2937),
              ),
              12.spaceH,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LocaleKeys.justTapAway.tr().appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ).appPadding(all: 24),
        ),
      ),
    );
  }

  Widget _nextButton() {
    return BaseButton(
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor2, cardColor2.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cardColor2.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.next
                .tr()
                .appText(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.0,
                )
                .appPadding(left: 40, right: 40, top: 16, bottom: 16),
          ],
        ),
      ),
      onTap: () {
        context.push(RoutePaths.onboarding3);
      },
    );
  }
}
