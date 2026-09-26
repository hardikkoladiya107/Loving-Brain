import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/brainy_saved_guidance_screen.dart';
import 'package:loving_brain/ui/consistency_recognition/consistency_recognition_screen.dart';
import 'package:loving_brain/ui/family_timeline/family_timeline_screen.dart';
import 'package:loving_brain/ui/harder_week/harder_week_screen.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/trying_this_week/trying_this_week_screen.dart';
import 'package:loving_brain/ui/weekly_family_review/weekly_family_review_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/journey_cubit.dart';
import 'bloc/journey_state.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JourneyCubit(),
      child: BlocBuilder<JourneyCubit, JourneyState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                          const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      16.spaceH,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: darkBlue,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      24.spaceH,
                      GestureDetector(
                        onTap: () {
                          context.read<JourneyCubit>().cycleMode();
                          // Show consistency screen as a surprise when mode cycles to normal
                          if (context.read<JourneyCubit>().state.mode ==
                              JourneyMode.normal) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ConsistencyRecognitionScreen(),
                              ),
                            );
                          }
                        },
                        child: "Journey".appText(
                          fontSize: 28.sp,
                          color: greyColor9,
                          fraunces: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      8.spaceH,
                      "How things have been changing for your family.".appText(
                        fontSize: 16.sp,
                        color: greyColor9,
                        textAlign: TextAlign.start,
                      ),
                      12.spaceH,
                      _buildWeeklyReviewCard(context, state),
                      32.spaceH,
                      "ALSO HERE".appText(
                        fontSize: 12.sp,
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                      16.spaceH,
                      _buildSleepJourneyCard(),
                      12.spaceH,
                      _buildFamilyTimelineCard(context),
                      12.spaceH,
                      _buildSavedGuidanceCard(context),
                      24.spaceH,
                      _buildMentorshipTestLink(
                        context,
                        "Guided Mentorship (Test)",
                        const MentorshipLandingScreen(),
                      ),
                      128.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyReviewCard(BuildContext context, JourneyState state) {
    String chipTitle = "Weekly review";
    String titleText = "This week's review is ready";
    String subtitleText =
        "One positive change, one thing that's still hard, and one focus for next week.";
    String buttonText = "Open review";
    String imagePath = Assets.v2.images.imgJournyWeeklyReview.path;
    Widget targetScreen = const WeeklyFamilyReviewScreen();

    if (state.mode == JourneyMode.harder) {
      targetScreen = const HarderWeekScreen();
    } else if (state.mode == JourneyMode.trying) {
      chipTitle = "Active recommendation";
      titleText = "What we're trying this week";
      subtitleText = "An earlier, shorter afternoon nap.";
      buttonText = "View progress";
      imagePath = Assets
          .v2
          .images
          .imgSprout
          .path; // Just using a placeholder image for active
      targetScreen = const TryingThisWeekScreen();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoChip(
                      chipTitle: chipTitle,
                      iconData: Icons.stars,
                      bgColor: const Color(0xFFFEF0E8),
                      color: primaryColor,
                    ),
                    12.spaceH,
                    titleText.appText(
                      fontSize: 18.sp,
                      color: darkBlue,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    8.spaceH,
                    subtitleText.appText(
                      fontSize: 12.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                      height: 1.4,
                    ),
                  ],
                ),
              ),
              16.spaceW,
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(imagePath),
                  ),
                ),
              ),
            ],
          ),
          16.spaceH,
          AppButton(
            title: buttonText,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => targetScreen),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepJourneyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EEFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                Assets.v2.images.imgSleep.path,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "6-Week Sleep Journey".appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                "Week 2 of 6".appText(
                  fontSize: 14.sp,
                  color: greyColor11,
                  textAlign: TextAlign.start,
                ),
                8.spaceH,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 2 / 6,
                    backgroundColor: const Color(0xFFF1EEFF),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      secondaryColor,
                    ),
                    minHeight: 4.h,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildSavedGuidanceCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BrainySavedGuidanceScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FAFF), // light blue
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  Assets.v2.images.imgNotes.path,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Saved guidance".appText(
                    fontSize: 14.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  "3 saved answers".appText(
                    fontSize: 12.sp,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTimelineCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FamilyTimelineScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF0E8), // light orange
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.timeline,
                  color: Colors.orangeAccent,
                  size: 24.sp,
                ),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Family timeline".appText(
                    fontSize: 14.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  "View your family's journey".appText(
                    fontSize: 12.sp,
                    color: greyColor,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorshipTestLink(
    BuildContext context,
    String title,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title.appText(
              fontSize: 16.sp,
              color: greyColor9,
              fontWeight: FontWeight.w600,
            ),
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
