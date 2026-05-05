import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';

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
  Future<void> _completeOnboarding() async {
    await preferences.putBool(SharedPreference.hasSeenOnboarding, true);
    if (!mounted) return;
    context.go(RoutePaths.login);
  }

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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                8.h.spaceH,
                _topBar(),
                18.h.spaceH,
                _topCard(),
                16.h.spaceH,
                _progressDots(currentIndex: 2),
                18.h.spaceH,
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        _card1(
                          title: LocaleKeys.dailySchedulePlanner.tr(),
                          description: LocaleKeys.shareResponsibilityFairly
                              .tr(),
                          image: Assets.icons.icDailySchedulePlannerIcon,
                          trackerStartColor: sliderTrackColor1,
                          trackerEndColor: sliderTrackColor1.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        12.h.spaceH,
                        _card1(
                          title: LocaleKeys.coParentingCalendar.tr(),
                          description: LocaleKeys
                              .coordinateChildRoutinesMealsSchoolPlaytimeTherapy
                              .tr(),
                          image: Assets.icons.icCoParentingIcon,
                          trackerStartColor: sliderTrackColor2,
                          trackerEndColor: sliderTrackColor2.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        12.h.spaceH,
                        _card1(
                          title: LocaleKeys.mindfulness.tr(),
                          description: LocaleKeys.overallWellbeing.tr(),
                          image: Assets.icons.icMindfulness,
                          trackerStartColor: sliderTrackColor3,
                          trackerEndColor: sliderTrackColor3.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        12.h.spaceH,
                        _card1(
                          title: LocaleKeys.parentSupport.tr(),
                          description: LocaleKeys.certifiedTrainersCounselors
                              .tr(),
                          image: Assets.icons.icParentSupport,
                          trackerStartColor: sliderTrackColor4,
                          trackerEndColor: sliderTrackColor4.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        18.h.spaceH,
                      ],
                    ),
                  ),
                ),
                _navigationButtons(),
                24.h.spaceH,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () {
            context.pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 18.r,
            ),
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: '3/3'.appText(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _progressDots({required int currentIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 26.w : 8.w,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(100.r),
          ),
        );
      }),
    );
  }

  Widget _topCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.intelligent.tr(),
                  style: getTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24.sp,
                  ),
                ),
                TextSpan(
                  text: " ${LocaleKeys.chatbot.tr()}",
                  style: getTextStyle(
                    color: yellowTextColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
          ).appPadding(left: 24.w, right: 24.w, top: 16.h, bottom: 16.h),
        ),
      ),
    );
  }

  Widget _card1({
    required String title,
    required String description,
    required AssetGenImage image,
    required Color trackerStartColor,
    required Color trackerEndColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              16.w.spaceW,
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: trackerStartColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: image.image(height: 32.h, width: 32.w),
              ),
              16.w.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.spaceH,
                    title.appText(
                      color: const Color(0xFF1F2937),
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                    ),
                    4.spaceH,
                    description.appText(
                      color: const Color(0xFF4B5563),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      height: 1.3,
                    ),
                    12.spaceH,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: trackerEndColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          trackerStartColor,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    16.spaceH,
                  ],
                ),
              ),
              16.w.spaceW,
            ],
          ),
        ),
      ),
    );
  }

  Widget _navigationButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: BaseButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: const Color(0xFF1F2937),
                size: 20.r,
              ).appPadding(top: 14.h, bottom: 14.h),
            ),
          ),
        ),
        12.w.spaceW,
        Expanded(
          flex: 3,
          child: BaseButton(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    blueButtonColor,
                    blueButtonColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: blueButtonColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: LocaleKeys.getStarted
                  .tr()
                  .appText(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 17.sp,
                    letterSpacing: 1.0,
                  )
                  .appPadding(top: 14.h, bottom: 14.h),
            ),
            onTap: _completeOnboarding,
          ),
        ),
      ],
    );
  }
}
