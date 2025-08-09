import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/login/login_screen.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';

class OnBoardingScreen4 extends StatefulWidget {
  const OnBoardingScreen4({super.key});

  @override
  State<OnBoardingScreen4> createState() => _OnBoardingScreen4State();
}

class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
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
            20.spaceH,
            _nextButton(),
          ],
        ),
      ),
    );
  }

  Widget _topCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: LocaleKeys.intelligent.tr(),
              style: getTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            TextSpan(
              text: LocaleKeys.chatbot.tr(),
              style: getTextStyle(
                color: yellowTextColor2,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ).appPadding(all: 10),
    ).appPadding(left: 30, right: 30);
  }

  Widget _card1({
    required String title,
    required String description,
    required AssetGenImage image,
    required Color trackerStartColor,
    required Color trackerEndColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          12.spaceW,
          image.image(height: 55.h, width: 55.w),
          12.spaceW,
          Expanded(
            child: Column(
              children: [
                10.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: title.appText(
                        color: blackTextColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      child: description.appText(
                        color: blackTextColor,
                        fontSize: 14,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                8.spaceH,
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: SliderComponentShape.noThumb,
                    trackShape: const RoundedRectSliderTrackShape(),
                    activeTrackColor: trackerStartColor,
                    inactiveTrackColor: trackerEndColor,
                  ),
                  child: Slider(value: 1, onChanged: (value) {}, max: 10),
                ),
                16.spaceH,
              ],
            ),
          ),
          8.spaceW,
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _nextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseButton(
          child: Container(
            decoration: BoxDecoration(
              color: blueButtonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocaleKeys.next
                    .tr()
                    .appText(fontWeight: FontWeight.w700, color: Colors.white)
                    .appPadding(left: 80, right: 80, top: 8, bottom: 8),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}
