import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';
import 'on_boarding_screen4.dart';

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
          image: AssetImage(Assets.images.imgOnBoardingBg3.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 60, left: 20, child: _personalizedCard()),
            Positioned(
              bottom: 350,
              left: 45,
              child: Container(
                child: LocaleKeys.weGuideYouThroughParenting.tr().appText(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.5,
                ),
              ),
            ),
            Positioned(
              bottom: 190.h,
              left: 60,
              child: Container(
                child: LocaleKeys.takeAFree2weekCoaching.tr().appText(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.5,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_nextButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalizedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          LocaleKeys.personalizedParentSupport.tr().appText(
            fontWeight: FontWeight.w900,
            textAlign: TextAlign.start,
            fontSize: 18,
          ),
          LocaleKeys.justTapAway.tr().appText(
            color: yellowTextColor,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ],
      ).appPadding(left: 30, right: 30, top: 12, bottom: 12),
    );
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
            LocaleKeys.next
                .tr()
                .appText(fontWeight: FontWeight.w700, color: Colors.white)
                .appPadding(left: 40, right: 40, top: 8, bottom: 8),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen4()),
        );
      },
    );
  }
}
