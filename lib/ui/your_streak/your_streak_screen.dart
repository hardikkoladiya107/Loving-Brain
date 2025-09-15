import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';

class YourStreakScreen extends StatefulWidget {
  const YourStreakScreen({super.key});

  @override
  State<YourStreakScreen> createState() => _YourStreakScreenState();
}

class _YourStreakScreenState extends State<YourStreakScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgYourStreakBg.image(
                  height: context.height,
                  width: context.width,
                ),
                Container(height: context.height),
              ],
            ),
            Column(
              children: [
                45.h.spaceH,
                _appBar(),
                140.h.spaceH,
                _youAreOnRole(),
                40.h.spaceH,
                _currentStreakCard(),
                40.h.spaceH,
                _logMood(text: 'Log Mood', onTap: () {}),
              ],
            ).appPadding(left: 20.w, right: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(
            height: 36,
            width: 36,
            color: Colors.black.withValues(alpha: 0.8),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        "Your Streak !".appText(fontWeight: FontWeight.w700),
      ],
    );
  }

  Widget _youAreOnRole() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "You're on a roll, Sarah!".appText(fontWeight: FontWeight.w900),
        ],
      ).appPadding(top: 6.h, bottom: 6.h),
    );
  }

  Widget _currentStreakCard() {
    return Container(
      height: 350.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgCurrentStreakCard.path),
        ),
      ),
      child: Column(
        children: [
          18.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Current Streak".appText(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ],
          ),
          10.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "5".appText(fontWeight: FontWeight.w900, fontSize: 32),
              Assets.icons.icStreakIcon.image(height: 35, width: 35),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Best streak: 12 days".appText(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ],
          ),
          20.h.spaceH,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Assets.icons.icFlagIcon.image(height: 24, width: 24),
                    10.w.spaceW,
                    "Next Milestone".appText(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                12.h.spaceH,
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: SliderComponentShape.noThumb,
                    trackShape: const RoundedRectSliderTrackShape(),
                    activeTrackColor: cardColor2,
                    inactiveTrackColor: greyColor3,
                  ),
                  child: Slider(value: 8, onChanged: (value) {}, max: 10),
                ),
              ],
            ).appPadding(all: 12),
          ).appPadding(left: 16.w, right: 16.w),
          20.h.spaceH,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    "Your Mood History".appText(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ).appPadding(all: 12),
          ).appPadding(left: 16.w, right: 16.w),
          20.h.spaceH,
          "Don't miss your daily mood check-in to keep the streak going!"
              .appText(fontWeight: FontWeight.w700, fontSize: 10)
              .appPadding(left: 20, right: 20),
        ],
      ),
    );
  }

  Widget _logMood({required String text, required GestureTapCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
