import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../widget/base_button.dart';
import 'on_boarding_screen3.dart';

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
        body: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Stack(
              children: [
                Positioned(
                  top: 80 + (20 * (1 - value)),
                  left: 24,
                  right: 24,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: _personalizedCard(),
                  ),
                ),
                Positioned(
                  bottom: 350 + (30 * (1 - value)),
                  left: 30,
                  right: 30,
                  child: Opacity(
                    opacity: (value - 0.3).clamp(0.0, 1.0),
                    child: _floatingGlassInfo(
                      text: LocaleKeys.weGuideYouThroughParenting.tr(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 190.h + (30 * (1 - value)),
                  left: 30,
                  right: 30,
                  child: Opacity(
                    opacity: (value - 0.6).clamp(0.0, 1.0),
                    child: _floatingGlassInfo(
                      text: LocaleKeys.takeAFree2weekCoaching.tr(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: (value - 0.8).clamp(0.0, 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_nextButton()],
                    ),
                  ),
                ),
              ],
            );
          },
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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: text.appText(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            textAlign: TextAlign.center,
            color: Colors.white,
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
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
              )
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
                color: Colors.white,
              ),
              12.spaceH,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: yellowTextColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LocaleKeys.justTapAway.tr().appText(
                  color: yellowTextColor,
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
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen3()),
        );
      },
    );
  }
}
