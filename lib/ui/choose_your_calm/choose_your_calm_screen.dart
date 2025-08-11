import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';

class ChooseYourCalmScreen extends StatefulWidget {
  const ChooseYourCalmScreen({super.key});

  @override
  State<ChooseYourCalmScreen> createState() => _ChooseYourCalmScreenState();
}

class _ChooseYourCalmScreenState extends State<ChooseYourCalmScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgChooseYourCalmBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            60.spaceH,
            _header(),
            10.spaceH,
            _headerDescription(),
            _topCards(),
            _bottomCards(),
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
        _cardItem(
          image: Assets.images.imgChooseCalmCardBg1,
          icon: Assets.icons.icDiaperChangeBreath,
          title: LocaleKeys.diaperChangeBreath.tr(),
          description: LocaleKeys.aQuickCalmingBreathFindSerenityBusyMoments
              .tr(),
          textColor: Colors.white,
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
        ),
        20.spaceW,
        _cardItem(
          title: LocaleKeys.sleepDeprivationRest.tr(),
          image: Assets.images.imgChooseCalmCardBg4,
          icon: Assets.icons.icSleepDeprivationRest,
          description: LocaleKeys.aQuickMentalRefreshForTiredParents.tr(),
          textColor: Colors.white,
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
  }) {
    return Container(
      height: 200.h,
      width: 160.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(image.path),
        ),
      ),
      child: Column(
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
            fontSize: 10,
          ),
        ],
      ).appPadding(left: 10.w, right: 10.w),
    );
  }
}
