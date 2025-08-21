import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            10.spaceH,
            _topCard(),
            10.spaceH,
            _secondCard(),
            10.spaceH,
            _thirdCard(),
            Spacer(),
            _reminder(),
          ],
        ),
      ),
    );
  }

  Widget _topCard() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          10.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.spaceW,
              Assets.icons.icProfileIcon2.image(
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
              10.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Hello, Sarah!".appText(fontWeight: FontWeight.w600),
                    "Ready to nurture Rohan's journey?\n(Child: Rohan, 2.5 years old)"
                        .appText(fontSize: 12, textAlign: TextAlign.start),
                  ],
                ),
              ),
              10.spaceW,
              Icon(CupertinoIcons.bell),
              10.spaceW,
            ],
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    "Next Schedule".appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    "3:00PM".appText(fontSize: 12),
                    "Rohan's Nap Time".appText(fontSize: 12),
                    Row(
                      children: [
                        "View Schedule".appText(
                          fontWeight: FontWeight.w700,
                          color: sliderTrackColor2,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              10.spaceW,
              Column(
                children: [
                  Row(
                    children: [
                      Assets.icons.icStreakIcon.image(),
                      5.spaceW,
                      "5".appText(fontSize: 20, fontWeight: FontWeight.w700),
                    ],
                  ),
                  "Streak!".appText(fontWeight: FontWeight.w600),
                  12.spaceH,
                  Assets.icons.icCalenderIcon.image(height: 50, width: 50),
                ],
              ),
              20.spaceW,
            ],
          ),
          10.spaceH,
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _secondCard() {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgHomeCardBg.path),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.calmCorner.tr(),
              asset: Assets.icons.icCalmCorner,
              onTap: () {},
            ),
          ),
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.challenges.tr(),
              asset: Assets.icons.icChallengesIcon,
              onTap: () {},
            ),
          ),
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.trackKidBehaviour.tr(),
              asset: Assets.icons.icTrackKidBehaviour,
              onTap: () {},
            ),
          ),
          8.spaceW,
        ],
      ).appPadding(bottom: 20),
    ).appPadding(left: 20, right: 20);
  }

  Widget _secondCardItem({
    required String title,
    required AssetGenImage asset,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title.appText(fontSize: 12, fontWeight: FontWeight.w600),
            8.spaceH,
            asset.image(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _thirdCard() {
    return Row(
      children: [
        20.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.learnPlay.tr(),
            asset: Assets.images.imgLearnAndPlay,
            onTap: () {},
          ),
        ),
        10.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.sleep.tr(),
            asset: Assets.images.imgSleep,
            onTap: () {},
          ),
        ),
        10.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.howAreWeFeeling.tr(),
            asset: Assets.images.imgHowAreWeFeeling,
            onTap: () {},
          ),
        ),
        20.spaceW,
      ],
    );
  }

  Widget _thirdCardItem({
    required String title,
    required AssetGenImage asset,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(asset.path),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [title.appText(fontWeight: FontWeight.w700, fontSize: 14)],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _reminder() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 150.h,
            decoration: BoxDecoration(
              color: yellowColor4,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
          ),
        ),

        Container(height: 190.h),

        Positioned(
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.h,
                width: 270.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.images.imgReminderBg.path),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Remember to re-evaluate".appText(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                        "Tantrum strategies in 3 days".appText(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          children: [
                            "Take action".appText(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            10.spaceW,
                            Assets.icons.icForwardArrow.image(
                              height: 22.h,
                              width: 22.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    10.spaceW,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.icReminderIcon.image(
                          height: 25.h,
                          width: 25.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
