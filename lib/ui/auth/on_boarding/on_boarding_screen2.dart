import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
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
            Spacer(flex: 2),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      LocaleKeys.youMadeTt
                          .tr()
                          .appText(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                      12.spaceH,
                      LocaleKeys.letsTakeCareOfYourMindSoYouCanTakeCareOfTheirs
                          .tr()
                          .appText(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                    ],
                  ),
                ),
              ),
            ).appPadding(left: 24, right: 24),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: LocaleKeys.evenSuperheroesRequireSupport
                          .tr()
                          .appText(
                            fontWeight: FontWeight.w800,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            color: primaryColor,
                          )
                          .appPadding(all: 16),
                    ),
                  ),
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
        color: cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
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
          12.spaceW,
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: assetImage.image(height: 28, width: 28),
          ),
          12.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header.appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                4.spaceH,
                description.appText(
                  color: Colors.white.withValues(alpha: 0.9), 
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  height: 1.3,
                ),
              ],
            ),
          ),
          12.spaceW,
        ],
      ).appPadding(top: 16, bottom: 16),
    ).appPadding(left: 30, right: 30);
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
                .appText(
                  fontWeight: FontWeight.w800, 
                  color: Colors.white,
                  fontSize: 16,
                )
                .appPadding(top: 14, bottom: 14),
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
