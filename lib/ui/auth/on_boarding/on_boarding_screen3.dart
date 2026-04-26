import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/auth/login/login_screen.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';
import '../../widget/base_button.dart';

class OnBoardingScreen3 extends StatefulWidget {
  const OnBoardingScreen3({super.key});

  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgOnBoardingBg4.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              40.spaceH,
              _topCard(),
              20.spaceH,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _card1(
                        title: LocaleKeys.dailySchedulePlanner.tr(),
                        description: LocaleKeys.shareResponsibilityFairly.tr(),
                        image: Assets.icons.icDailySchedulePlannerIcon,
                        trackerStartColor: sliderTrackColor1,
                        trackerEndColor: sliderTrackColor1.withValues(alpha: 0.2),
                      ),
                      16.spaceH,
                      _card1(
                        title: LocaleKeys.coParentingCalendar.tr(),
                        description: LocaleKeys.coordinateChildRoutinesMealsSchoolPlaytimeTherapy.tr(),
                        image: Assets.icons.icCoParentingIcon,
                        trackerStartColor: sliderTrackColor2,
                        trackerEndColor: sliderTrackColor2.withValues(alpha: 0.2),
                      ),
                      16.spaceH,
                      _card1(
                        title: LocaleKeys.mindfulness.tr(),
                        description: LocaleKeys.overallWellbeing.tr(),
                        image: Assets.icons.icMindfulness,
                        trackerStartColor: sliderTrackColor3,
                        trackerEndColor: sliderTrackColor3.withValues(alpha: 0.2),
                      ),
                      16.spaceH,
                      _card1(
                        title: LocaleKeys.parentSupport.tr(),
                        description: LocaleKeys.certifiedTrainersCounselors.tr(),
                        image: Assets.icons.icParentSupport,
                        trackerStartColor: sliderTrackColor4,
                        trackerEndColor: sliderTrackColor4.withValues(alpha: 0.2),
                      ),
                      40.spaceH,
                    ],
                  ),
                ),
              ),
              _nextButton(),
              30.spaceH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _topCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.intelligent.tr(),
                  style: getTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: " ${LocaleKeys.chatbot.tr()}",
                  style: getTextStyle(
                    color: yellowTextColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ).appPadding(left: 24, right: 24, top: 16, bottom: 16),
        ),
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _card1({
    required String title,
    required String description,
    required AssetGenImage image,
    required Color trackerStartColor,
    required Color trackerEndColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              16.spaceW,
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: trackerStartColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: image.image(height: 32.h, width: 32.w),
              ),
              16.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.spaceH,
                    title.appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                    6.spaceH,
                    description.appText(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                      height: 1.3,
                    ),
                    12.spaceH,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: trackerEndColor,
                        valueColor: AlwaysStoppedAnimation<Color>(trackerStartColor),
                        minHeight: 8,
                      ),
                    ),
                    16.spaceH,
                  ],
                ),
              ),
              16.spaceW,
            ],
          ),
        ),
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _nextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseButton(
          child: Container(
            width: 240.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [blueButtonColor, blueButtonColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: blueButtonColor.withValues(alpha: 0.5),
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
                    .appPadding(top: 16, bottom: 16),
              ],
            ),
          ),
          onTap: () async {
            await preferences.putBool(SharedPreference.hasSeenOnboarding, true);
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
