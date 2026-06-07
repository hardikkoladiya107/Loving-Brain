import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  // Page controller to manage onboarding step changes
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Completes onboarding, saves status offline, and moves to login route
  Future<void> _completeOnboarding() async {
    await preferences.putBool(SharedPreference.hasSeenOnboarding, true);
    if (!mounted) return;
    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ──────────────────────────────────────────────────────────────────
          // Smooth Cross-Fading Backgrounds
          // ──────────────────────────────────────────────────────────────────
          Positioned.fill(
            child: Container(color: const Color(0xFFFAFAFA)),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _currentIndex == 0 ? 1.0 : 0.0,
              child: Image.asset(
                Assets.images.imgOnBoardingBg2.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _currentIndex == 1 ? 1.0 : 0.0,
              child: Image.asset(
                Assets.images.imgOnBoardingBg3.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _currentIndex == 2 ? 1.0 : 0.0,
              child: Image.asset(
                Assets.images.imgOnBoardingBg4.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Subtle shading filter to make text readable
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.12),
            ),
          ),

          // ──────────────────────────────────────────────────────────────────
          // Onboarding Pages Content & Controllers
          // ──────────────────────────────────────────────────────────────────
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    8.h.spaceH,
                    _topBar(),
                    20.h.spaceH,
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (int page) {
                          setState(() {
                            _currentIndex = page;
                          });
                        },
                        children: [
                          _page1(),
                          _page2(),
                          _page3(),
                        ],
                      ),
                    ),
                    _progressDots(),
                    20.h.spaceH,
                    _navigationButtons(),
                    24.h.spaceH,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Shared Control Elements
  // ──────────────────────────────────────────────────────────────────────────

  // Top navigation header row
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Navigation Button
        if (_currentIndex > 0)
          BaseButton(
            onTap: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.r),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          )
        else
          SizedBox(width: 34.r), // spacer to maintain centering

        // Step index visual pill
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: '${_currentIndex + 1}/3'.appText(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.sp,
          ),
        ),

        // Skip / Complete onboarding button
        BaseButton(
          onTap: _completeOnboarding,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8.r),
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  // Step indicator dot timeline widget
  Widget _progressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int index) {
        final bool isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 26.w : 8.w,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(100.r),
          ),
        );
      }),
    );
  }

  // Main Call-To-Action buttons
  Widget _navigationButtons() {
    final bool isLastPage = _currentIndex == 2;
    return BaseButton(
      onTap: () {
        if (isLastPage) {
          _completeOnboarding();
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLastPage
                ? [blueButtonColor, blueButtonColor.withValues(alpha: 0.85)]
                : [const Color(0xFFFFD23F), const Color(0xFFFF9E00)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: (isLastPage ? blueButtonColor : const Color(0xFFFF9E00))
                  .withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (isLastPage ? LocaleKeys.getStarted.tr() : LocaleKeys.next.tr())
                .appText(
                  fontWeight: FontWeight.w900,
                  color: isLastPage ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 16.sp,
                  letterSpacing: 0.5,
                )
                .appPadding(top: 14.h, bottom: 14.h),
            8.spaceW,
            Icon(
              isLastPage
                  ? Icons.check_circle_outline_rounded
                  : Icons.arrow_forward_rounded,
              color: isLastPage ? Colors.white : const Color(0xFF1F2937),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Page Steps
  // ──────────────────────────────────────────────────────────────────────────

  // Slide 1 View
  Widget _page1() {
    return Column(
      children: [
        _glassHeaderCard(
          title: LocaleKeys.youMadeTt.tr(),
          description: LocaleKeys
              .letsTakeCareOfYourMindSoYouCanTakeCareOfTheirs
              .tr(),
        ),
        20.h.spaceH,
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _infoCardStep1(
                  cardColor: cardColor1,
                  header: LocaleKeys.dailyMindfulMoments.tr(),
                  description: LocaleKeys.twoMinExercisesToResetAndRecharge.tr(),
                  assetImage: Assets.icons.icDailyMindfulMomentsIcon,
                ),
                14.h.spaceH,
                _infoCardStep1(
                  cardColor: cardColor2,
                  header: LocaleKeys.parentingInsights.tr(),
                  description: LocaleKeys.expertBackedTipsTailoredForYourNeeds.tr(),
                  assetImage: Assets.icons.icParentingInsightsIcon,
                ),
                14.h.spaceH,
                _infoCardStep1(
                  cardColor: cardColor3,
                  header: LocaleKeys.stressSOS.tr(),
                  description: LocaleKeys.quickToolsForCalmingInToughMoments.tr(),
                  assetImage: Assets.icons.icStressSosIcon,
                ),
                18.h.spaceH,
                _superheroCard(),
                20.h.spaceH,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Slide 2 View
  Widget _page2() {
    return Column(
      children: [
        _glassHeaderCard(
          title: LocaleKeys.personalizedParentSupport.tr(),
          subtitleBadge: LocaleKeys.justTapAway.tr(),
        ),
        20.h.spaceH,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _floatingGlassInfo(
                text: LocaleKeys.weGuideYouThroughParenting.tr(),
              ),
              14.h.spaceH,
              _floatingGlassInfo(
                text: LocaleKeys.takeAFree2weekCoaching.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Slide 3 View
  Widget _page3() {
    return Column(
      children: [
        _glassHeaderCard(
          title: LocaleKeys.intelligent.tr(),
          highlightedTitle: LocaleKeys.chatbot.tr(),
        ),
        20.h.spaceH,
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _infoCardStep3(
                  title: LocaleKeys.dailySchedulePlanner.tr(),
                  description: LocaleKeys.shareResponsibilityFairly.tr(),
                  image: Assets.icons.icDailySchedulePlannerIcon,
                  trackerStartColor: sliderTrackColor1,
                  trackerEndColor: sliderTrackColor1.withValues(alpha: 0.2),
                ),
                12.h.spaceH,
                _infoCardStep3(
                  title: LocaleKeys.coParentingCalendar.tr(),
                  description: LocaleKeys
                      .coordinateChildRoutinesMealsSchoolPlaytimeTherapy
                      .tr(),
                  image: Assets.icons.icCoParentingIcon,
                  trackerStartColor: sliderTrackColor2,
                  trackerEndColor: sliderTrackColor2.withValues(alpha: 0.2),
                ),
                12.h.spaceH,
                _infoCardStep3(
                  title: LocaleKeys.mindfulness.tr(),
                  description: LocaleKeys.overallWellbeing.tr(),
                  image: Assets.icons.icMindfulness,
                  trackerStartColor: sliderTrackColor3,
                  trackerEndColor: sliderTrackColor3.withValues(alpha: 0.2),
                ),
                12.h.spaceH,
                _infoCardStep3(
                  title: LocaleKeys.parentSupport.tr(),
                  description: LocaleKeys.certifiedTrainersCounselors.tr(),
                  image: Assets.icons.icParentSupport,
                  trackerStartColor: sliderTrackColor4,
                  trackerEndColor: sliderTrackColor4.withValues(alpha: 0.2),
                ),
                20.h.spaceH,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Specialized Custom Widgets
  // ──────────────────────────────────────────────────────────────────────────

  // Glassmorphic title header card supporting subtitles, highlighted words, or badges
  Widget _glassHeaderCard({
    required String title,
    String? description,
    String? highlightedTitle,
    String? subtitleBadge,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.16),
                Colors.white.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (highlightedTitle == null)
                title.appText(
                  fontSize: 26.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                )
              else
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: getTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 26.sp,
                        ),
                      ),
                      TextSpan(
                        text: " $highlightedTitle",
                        style: getTextStyle(
                          color: yellowTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 26.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              if (description != null) ...[
                12.spaceH,
                description.appText(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
              ],
              if (subtitleBadge != null) ...[
                14.spaceH,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.4)),
                  ),
                  child: subtitleBadge.appText(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Superhero motivation glass card
  Widget _superheroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
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
                fontSize: 14.sp,
                color: primaryColor,
              )
              .appPadding(all: 16),
        ),
      ),
    );
  }

  // Step 1 colorful info card
  Widget _infoCardStep1({
    required Color cardColor,
    required String header,
    required String description,
    required AssetGenImage assetImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          14.w.spaceW,
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: assetImage.image(height: 28.h, width: 28.w),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header.appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                description.appText(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  height: 1.3,
                ),
              ],
            ),
          ),
          12.w.spaceW,
        ],
      ).appPadding(top: 14.h, bottom: 14.h),
    );
  }

  // Step 2 glass info card
  Widget _floatingGlassInfo({required String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: text.appText(
            fontWeight: FontWeight.w800,
            fontSize: 15.sp,
            textAlign: TextAlign.center,
            color: const Color(0xFF1F2937),
            height: 1.45,
          ),
        ),
      ),
    );
  }

  // Step 3 progress tracker info card
  Widget _infoCardStep3({
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
            color: Colors.white.withValues(alpha: 0.55),
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
}
