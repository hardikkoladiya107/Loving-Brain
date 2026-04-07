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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            80.spaceH,
            Row(),
            _topCard(),
            20.spaceH,
            _card1(
              title: LocaleKeys.dailySchedulePlanner.tr(),
              description: LocaleKeys.shareResponsibilityFairly.tr(),
              image: Assets.icons.icDailySchedulePlannerIcon,
              trackerStartColor: sliderTrackColor1,
              trackerEndColor: sliderTrackColor1.withValues(alpha: 0.3),
            ),
            20.spaceH,
            _card1(
              title: LocaleKeys.coParentingCalendar.tr(),
              description: LocaleKeys
                  .coordinateChildRoutinesMealsSchoolPlaytimeTherapy
                  .tr(),
              image: Assets.icons.icCoParentingIcon,
              trackerStartColor: sliderTrackColor2,
              trackerEndColor: sliderTrackColor2.withValues(alpha: 0.3),
            ),
            20.spaceH,
            _card1(
              title: LocaleKeys.mindfulness.tr(),
              description: LocaleKeys.overallWellbeing.tr(),
              image: Assets.icons.icMindfulness,
              trackerStartColor: sliderTrackColor3,
              trackerEndColor: sliderTrackColor3.withValues(alpha: 0.3),
            ),
            20.spaceH,
            _card1(
              title: LocaleKeys.parentSupport.tr(),
              description: LocaleKeys.certifiedTrainersCounselors.tr(),
              image: Assets.icons.icParentSupport,
              trackerStartColor: sliderTrackColor4,
              trackerEndColor: sliderTrackColor4.withValues(alpha: 0.3),
            ),
            Spacer(),
            _nextButton(),
            30.spaceH,
          ],
        ),
      ),
    );
  }

  Widget _topCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.intelligent.tr(),
                  style: getTextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                TextSpan(
                  text: " " + LocaleKeys.chatbot.tr(),
                  style: getTextStyle(
                    color: yellowTextColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ).appPadding(left: 20, right: 20, top: 12, bottom: 12),
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
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              16.spaceW,
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: image.image(height: 40.h, width: 40.w),
              ),
              16.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    12.spaceH,
                    title.appText(
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      textAlign: TextAlign.start,
                    ),
                    4.spaceH,
                    description.appText(
                      color: Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    8.spaceH,
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 6,
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: SliderComponentShape.noThumb,
                        trackShape: const RoundedRectSliderTrackShape(),
                        activeTrackColor: trackerStartColor,
                        inactiveTrackColor: trackerEndColor,
                      ),
                      child: Slider(value: 1, onChanged: (value) {}, max: 10),
                    ),
                    12.spaceH,
                  ],
                ),
              ),
              12.spaceW,
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
            width: 220.w,
            decoration: BoxDecoration(
              color: blueButtonColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: blueButtonColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: Offset(0, 5),
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
                      fontWeight: FontWeight.w800, 
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    )
                    .appPadding(top: 14, bottom: 14),
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
