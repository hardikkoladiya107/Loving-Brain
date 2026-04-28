import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              _buildHeaderCard(),
              Spacer(flex: 2),
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
                  24.spaceH,
                  _superheroCard(),
                  60.spaceH,
                  _nextButton(),
                  30.spaceH,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
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
                fontSize: 28,
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
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    height: 1.4,
                  ),
            ],
          ),
        ),
      ),
    ).appPadding(left: 24, right: 24);
  }

  Widget _superheroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
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
                fontSize: 14,
                color: primaryColor,
              )
              .appPadding(all: 16),
        ),
      ),
    ).appPadding(left: 30, right: 30);
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
                  fontSize: 16,
                )
                .appPadding(top: 14, bottom: 14),
          ],
        ),
      ),
      onTap: () {
        context.push(RoutePaths.onboarding2);
      },
    );
  }
}
