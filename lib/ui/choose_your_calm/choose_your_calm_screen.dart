import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../postpartum_calm/postpartum_calm_screen.dart';

class ChooseYourCalmScreen extends StatefulWidget {
  const ChooseYourCalmScreen({super.key});

  @override
  State<ChooseYourCalmScreen> createState() => _ChooseYourCalmScreenState();
}

class _ChooseYourCalmScreenState extends State<ChooseYourCalmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: calmCornerBgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgChooseYourCalmBg.image(
                  height: context.height,
                  width: context.width,
                ),
                SizedBox(height: context.height / 2, width: context.width),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(),
                60.spaceH,
                _header(),
                10.spaceH,
                _headerDescription(),
                16.spaceH,
                _topCards(),
                10.spaceH,
                _middleCard(),
                10.spaceH,
                _bottomCards(),
                10.spaceH,
                LocaleKeys.moreExercisesAvailableInFutureChallenges
                    .tr()
                    .appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LocaleKeys.chooseYourCalm
          .tr()
          .appText(fontSize: 16, fontWeight: FontWeight.w800)
          .appPadding(all: 5),
    );
  }

  Widget _headerDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: "${LocaleKeys.selectExerciseFindMomentOfPeaceForYouAnd.tr()} Rohan"
          .appText(fontSize: 10, fontWeight: FontWeight.w800)
          .appPadding(all: 5),
    ).appPadding(left: 30, right: 30);
  }

  Widget _topCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        20.spaceW,
        //PostpartumCalmScreen
        _cardItem(
          image: Assets.images.imgChooseCalmCardBg1,
          icon: Assets.icons.icDiaperChangeBreath,
          title: LocaleKeys.diaperChangeBreath.tr(),
          description: LocaleKeys.aQuickCalmingBreathFindSerenityBusyMoments
              .tr(),
          textColor: Colors.white,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PostpartumCalmScreen(),
              ),
            );
          },
        ),
        20.spaceW,
        _cardItem(
          image: Assets.images.imgChooseCalmCardBg2,
          icon: Assets.icons.icMindfulFeedingAnchor,
          title: LocaleKeys.mindfulFeedingAnchor.tr(),
          description: LocaleKeys
              .focusOnSensationsDuringFeedingConnectWithYourBaby
              .tr(),
          textColor: Colors.black,
          onTap: () {},
        ),
        20.spaceW,
      ],
    );
  }

  Widget _bottomCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        20.spaceW,
        _cardItem(
          image: Assets.images.imgChooseCalmCardBg3,
          icon: Assets.icons.icSunnyBreathForKids,
          title: LocaleKeys.sunnyBreathForKids.tr(),
          description: LocaleKeys.feelTheSunshineEnveloping.tr(),
          textColor: Colors.black,
          onTap: () {},
        ),
        20.spaceW,
        _cardItem(
          title: LocaleKeys.sleepDeprivationRest.tr(),
          image: Assets.images.imgChooseCalmCardBg4,
          icon: Assets.icons.icSleepDeprivationRest,
          description: LocaleKeys.aQuickMentalRefreshForTiredParents.tr(),
          textColor: Colors.white,
          onTap: () {},
        ),
        20.spaceW,
      ],
    );
  }

  Widget _cardItem({
    required AssetGenImage image,
    required AssetGenImage icon,
    required String title,
    required String description,
    required Color textColor,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 180.h,
        width: 155.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image.path),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon.image(height: 80, width: 80),
                10.spaceH,
                title.appText(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
                description.appText(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 8,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned(bottom: 10, right: 0, child: _playIcon()),
          ],
        ).appPadding(left: 10.w, right: 10.w),
      ),
    );
  }

  Widget _middleCard() {
    return Container(
      height: 135.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgChooseCalmCardBg5.path),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.icons.icPostpartumCalmMeditation.image(
            height: 90.h,
            width: 90.w,
          ),
          10.spaceH,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocaleKeys.postpartumCalmMeditation.tr().appText(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
                8.spaceH,
                LocaleKeys
                    .aSoothingMeditationForMothersToAlleviateAnxietyAndOverwhelm
                    .tr()
                    .appText(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
              ],
            ),
          ),
        ],
      ).appPadding(left: 10.w, right: 10.w),
    ).appPadding(left: 30.w, right: 30.w);
  }

  Widget _playIcon() {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(color: greyColor1, shape: BoxShape.circle),
      child: Icon(Icons.play_arrow, color: Colors.white, size: 15),
    );
  }
}
