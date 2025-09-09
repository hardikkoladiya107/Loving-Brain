import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
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
          image: AssetImage(Assets.images.imgOnBoardingBg2.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: []),
            60.spaceH,
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: LocaleKeys.youMadeTt
                  .tr()
                  .appText(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  )
                  .appPadding(all: 8),
            ),
            10.spaceH,
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: LocaleKeys.letsTakeCareOfYourMindSoYouCanTakeCareOfTheirs
                  .tr()
                  .appText(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  )
                  .appPadding(all: 4),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _infoCard(
                  cardColor: cardColor1,
                  header: LocaleKeys.dailyMindfulMoments.tr(),
                  description: LocaleKeys.twoMinExercisesToResetAndRecharge
                      .tr(),
                  assetImage: Assets.icons.icDailyMindfulMomentsIcon,
                ),
                18.spaceH,
                _infoCard(
                  cardColor: cardColor2,
                  header: LocaleKeys.parentingInsights.tr(),
                  description: LocaleKeys.expertBackedTipsTailoredForYourNeeds
                      .tr(),
                  assetImage: Assets.icons.icParentingInsightsIcon,
                ),
                18.spaceH,
                _infoCard(
                  cardColor: cardColor3,
                  header: LocaleKeys.stressSOS.tr(),
                  description: LocaleKeys.quickToolsForCalmingInToughMoments
                      .tr(),
                  assetImage: Assets.icons.icStressSosIcon,
                ),
                10.spaceH,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: LocaleKeys.evenSuperheroesRequireSupport
                      .tr()
                      .appText(
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                        fontSize: 14,
                      )
                      .appPadding(all: 12),
                ).appPadding(left: 30, right: 30),
                130.spaceH,
                _nextButton(),
                30.spaceH,
              ],
            ),
          ],
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
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          8.spaceW,
          assetImage.image(height: 30, width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header.appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                description.appText(color: Colors.white, fontSize: 10),
              ],
            ),
          ),
        ],
      ).appPadding(all: 8),
    ).appPadding(left: 35, right: 35);
  }

  Widget _nextButton() {
    return BaseButton(
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.startYourDay
                .tr()
                .appText(fontWeight: FontWeight.w700, color: Colors.white)
                .appPadding(top: 8, bottom: 8),
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
