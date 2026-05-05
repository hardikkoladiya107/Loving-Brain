import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
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
  Future<void> _completeOnboarding() async {
    await preferences.putBool(SharedPreference.hasSeenOnboarding, true);
    if (!mounted) return;
    context.go(RoutePaths.login);
  }

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: <Widget>[
                8.h.spaceH,
                _topBar(),
                20.h.spaceH,
                _personalizedCard(),
                20.h.spaceH,
                _progressDots(currentIndex: 1),
                24.h.spaceH,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _floatingGlassInfo(
                        text: LocaleKeys.weGuideYouThroughParenting.tr(),
                      ),
                      14.h.spaceH,
                      _floatingGlassInfo(
                        text: LocaleKeys.takeAFree2weekCoaching.tr(),
                      ),
                    ],
                  ),
                ),
                _navigationButtons(),
                24.h.spaceH,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () {
            context.pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 18.r,
            ),
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: '2/3'.appText(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.sp,
          ),
        ),
        const Spacer(),
        BaseButton(
          onTap: _completeOnboarding,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Icon(Icons.close_rounded, color: Colors.white, size: 18.r),
          ),
        ),
      ],
    );
  }

  Widget _progressDots({required int currentIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 26.w : 8.w,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(100.r),
          ),
        );
      }),
    );
  }

  Widget _floatingGlassInfo({required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: text.appText(
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
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
      borderRadius: BorderRadius.circular(30.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(30.r),
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
                fontSize: 26.sp,
                letterSpacing: 1.2,
                color: const Color(0xFF1F2937),
              ),
              12.spaceH,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: LocaleKeys.justTapAway.tr().appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                ),
              ),
            ],
          ).appPadding(all: 24.w),
        ),
      ),
    );
  }

  Widget _navigationButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: BaseButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: const Color(0xFF1F2937),
                size: 20.r,
              ).appPadding(top: 14.h, bottom: 14.h),
            ),
          ),
        ),
        12.w.spaceW,
        Expanded(
          flex: 3,
          child: BaseButton(
            onTap: () {
              context.push(RoutePaths.onboarding3);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    cardColor2,
                    cardColor2.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: cardColor2.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: LocaleKeys.next
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 17.sp,
                    letterSpacing: 1,
                  )
                  .appPadding(top: 14.h, bottom: 14.h),
            ),
          ),
        ),
      ],
    );
  }
}
