import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
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
          image: AssetImage(Assets.images.imgOnBoardingBg2.path),
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
                _buildHeaderCard(),
                24.h.spaceH,
                _progressDots(currentIndex: 0),
                28.h.spaceH,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        _infoCard(
                          cardColor: cardColor1,
                          header: LocaleKeys.dailyMindfulMoments.tr(),
                          description: LocaleKeys
                              .twoMinExercisesToResetAndRecharge
                              .tr(),
                          assetImage: Assets.icons.icDailyMindfulMomentsIcon,
                        ),
                        14.h.spaceH,
                        _infoCard(
                          cardColor: cardColor2,
                          header: LocaleKeys.parentingInsights.tr(),
                          description: LocaleKeys
                              .expertBackedTipsTailoredForYourNeeds
                              .tr(),
                          assetImage: Assets.icons.icParentingInsightsIcon,
                        ),
                        14.h.spaceH,
                        _infoCard(
                          cardColor: cardColor3,
                          header: LocaleKeys.stressSOS.tr(),
                          description: LocaleKeys
                              .quickToolsForCalmingInToughMoments
                              .tr(),
                          assetImage: Assets.icons.icStressSosIcon,
                        ),
                        18.h.spaceH,
                        _superheroCard(),
                        20.h.spaceH,
                      ],
                    ),
                  ),
                ),
                _nextButton(),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: '1/3'.appText(
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

  Widget _buildHeaderCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              LocaleKeys.youMadeTt.tr().appText(
                fontSize: 28.sp,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
              12.spaceH,
              LocaleKeys.letsTakeCareOfYourMindSoYouCanTakeCareOfTheirs
                  .tr()
                  .appText(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                    height: 1.4,
                  ),
            ],
          ),
        ),
      ),
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

  Widget _superheroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: LocaleKeys.evenSuperheroesRequireSupport
              .tr()
              .appText(
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
                color: primaryColor,
              )
              .appPadding(all: 16),
        ),
      ),
    );
  }

  Widget _infoCard({
    required Color cardColor,
    required String header,
    required String description,
    required AssetGenImage assetImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          12.w.spaceW,
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: assetImage.image(height: 28.h, width: 28.w),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header.appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                ),
                4.spaceH,
                description.appText(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  height: 1.3,
                ),
              ],
            ),
          ),
          12.w.spaceW,
        ],
      ).appPadding(top: 14.h, bottom: 14.h),
    );
  }

  Widget _nextButton() {
    return BaseButton(
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cardColor2.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.startYourDay
                .tr()
                .appText(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 16.sp,
                )
                .appPadding(top: 14.h, bottom: 14.h),
          ],
        ),
      ),
      onTap: () {
        context.push(RoutePaths.onboarding2);
      },
    );
  }
}
