import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/brainy_saved_guidance/brainy_saved_guidance_screen.dart';
import 'package:loving_brain/ui/enrolled_journey_home/enrolled_journey_home_screen.dart';
import 'package:loving_brain/ui/family_timeline/family_timeline_screen.dart';
import 'package:loving_brain/ui/harder_week/harder_week_screen.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/programme_detail/programme_detail_screen.dart';
import 'package:loving_brain/ui/trying_this_week/trying_this_week_screen.dart';
import 'package:loving_brain/ui/weekly_family_review/weekly_family_review_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/journey_cubit.dart';
import 'bloc/journey_state.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JourneyCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JourneyCubit, JourneyState>(
      listener: (BuildContext context, JourneyState state) {},
      builder: (BuildContext context, JourneyState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150,
                top: -150,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 140.h),
                    children: [
                      16.spaceH,
                      'Journey'.appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      'How things have been changing for your family.'.appText(
                        fontSize: 16.sp,
                        color: greyColor9,
                        textAlign: TextAlign.start,
                      ),
                      12.spaceH,
                      _buildWeeklyReviewCard(context, state),
                      32.spaceH,
                      'ALSO HERE'.appText(
                        fontSize: 12.sp,
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                      16.spaceH,
                      _buildSleepJourneyCard(context, state),
                      12.spaceH,
                      _buildFamilyTimelineCard(context),
                      12.spaceH,
                      _buildSavedGuidanceCard(context, state),
                      12.spaceH,
                      _buildConsistencyCard(context, state),
                      12.spaceH,
                      _buildGuidedMentorshipCard(context),
                      40.spaceH,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyReviewCard(BuildContext context, JourneyState state) {
    String chipTitle = 'Weekly review';
    String titleText = "This week's review is ready";
    String subtitleText =
        "One positive change, one thing that's still hard, and one focus for next week.";
    String buttonText = 'Open review';
    String imagePath = Assets.v2.images.imgJournyWeeklyReview.path;
    Widget targetScreen = const WeeklyFamilyReviewScreen();

    if (state.mode == JourneyMode.harder) {
      chipTitle = 'Disrupted week';
      titleText = 'This week was harder';
      subtitleText =
          state.weeklyInsights?.harderExplanation ??
          "Travel or illness disrupted the routine. That's expected, and routines take a few days to settle again.";
      imagePath = Assets.v2.images.imgJourneyThisWeek.path;
      targetScreen = const HarderWeekScreen();
    } else if (state.mode == JourneyMode.trying) {
      chipTitle = 'Active recommendation';
      titleText = "What we're trying this week";
      subtitleText =
          state.activeExperiment?.changeTitle ??
          'An earlier, shorter afternoon nap.';
      buttonText = 'View progress';
      imagePath = Assets.v2.images.imgSprout.path;
      targetScreen = const TryingThisWeekScreen();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
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
              ).then((_) {
                if (context.mounted) {
                  context.read<JourneyCubit>().init();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepJourneyCard(BuildContext context, JourneyState state) {
    final bool isEnrolled = state.isSleepJourneyEnrolled;
    final int currentWeek = state.sleepJourneyWeek;
    final int totalWeeks = state.sleepJourneyTotalWeeks;
    final double fraction = (currentWeek / totalWeeks).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        if (isEnrolled) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EnrolledJourneyHomeScreen(),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<JourneyCubit>().init();
            }
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgrammeDetailScreen()),
          ).then((_) {
            if (context.mounted) {
              context.read<JourneyCubit>().init();
            }
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEFF),
                borderRadius: BorderRadius.circular(12.r),
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
                  '6-Week Sleep Journey'.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  if (isEnrolled) ...[
                    'Week $currentWeek of $totalWeeks'.appText(
                      fontSize: 14.sp,
                      color: greyColor11,
                      textAlign: TextAlign.start,
                    ),
                    8.spaceH,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: fraction,
                        backgroundColor: const Color(0xFFF1EEFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          secondaryColor,
                        ),
                        minHeight: 4.h,
                      ),
                    ),
                  ] else ...[
                    'Reset bedtime and nighttime wakings'.appText(
                      fontSize: 13.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
                    4.spaceH,
                    'Learn more'.appText(
                      fontSize: 12.sp,
                      color: secondaryColor,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedGuidanceCard(BuildContext context, JourneyState state) {
    final String countLabel = state.savedGuidanceCount == 1
        ? '1 saved answer'
        : '${state.savedGuidanceCount} saved answers';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BrainySavedGuidanceScreen()),
        ).then((_) {
          if (context.mounted) {
            context.read<JourneyCubit>().init();
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FAFF),
                borderRadius: BorderRadius.circular(12.r),
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
                  'Saved guidance'.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  countLabel.appText(
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
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF0E8),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  Icons.show_chart_rounded,
                  color: primaryColor,
                  size: 24.sp,
                ),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Family timeline'.appText(
                    fontSize: 16.sp,
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

  Widget _buildConsistencyCard(BuildContext context, JourneyState state) {
    final int days = state.weeklyInsights?.daysCheckedIn ?? 0;
    return GestureDetector(
      onTap: () {
        context.push('${RoutePaths.consistencyRecognition}?days=$days');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Image.asset(
                  Assets.v2.images.imgJourneyConsistencyRecognition.path,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Consistency recognition'.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  (days > 0
                          ? "Checked in $days ${days == 1 ? 'day' : 'days'} this week"
                          : "Showing up for your family")
                      .appText(
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

  Widget _buildGuidedMentorshipCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext routeCtx) => const MentorshipLandingScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEFF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Image.asset(
                  Assets.v2.icons.icMentorshipBooking.path,
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
                  'Guided mentorship'.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  '1:1 guidance for sleep & routines'.appText(
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
}
