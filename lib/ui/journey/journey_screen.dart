import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:easy_localization/easy_localization.dart';

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
      listener: (BuildContext context, JourneyState state) {
        final ApiResultStatus status = state.fetchStatus;
        if (status is Loging) {
          EasyLoading.show();
        } else if (status is Data) {
          EasyLoading.dismiss();
        } else if (status is Error) {
          EasyLoading.dismiss();
          showSnackBar(
            message: status.error.toString().replaceAll('Exception: ', ''),
            type: SnackBarType.ERROR,
          );
        }
      },
      builder: (BuildContext context, JourneyState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150,
                top: -150,
                child: IgnorePointer(
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
    final bool insightsReady = state.weeklyInsights != null;
    String chipTitle = LocaleKeys.journeyWeeklyReviewChip.tr();
    String titleText = insightsReady
        ? LocaleKeys.journeyWeeklyReviewReadyTitle.tr()
        : LocaleKeys.journeyWeeklyReviewLoadingTitle.tr();
    String subtitleText = insightsReady
        ? LocaleKeys.journeyWeeklyReviewReadySubtitle.tr()
        : LocaleKeys.journeyWeeklyReviewLoadingSubtitle.tr();
    String buttonText = LocaleKeys.journeyOpenReview.tr();
    String imagePath = Assets.v2.images.imgJournyWeeklyReview.path;
    String targetRoute = RoutePaths.weeklyReview;

    if (state.mode == JourneyMode.learning) {
      chipTitle = LocaleKeys.journeyPatternsInProgressChip.tr();
      titleText = LocaleKeys.journeyPatternsInProgressTitle.tr();
      subtitleText = LocaleKeys.journeyPatternsInProgressSubtitle.tr();
      buttonText = LocaleKeys.journeySeeProgress.tr();
      targetRoute = RoutePaths.weeklyReview;
    } else if (state.mode == JourneyMode.harder) {
      chipTitle = LocaleKeys.journeyDisruptedWeekChip.tr();
      titleText = LocaleKeys.journeyHarderWeekTitle.tr();
      subtitleText =
          state.weeklyInsights?.harderExplanation ??
          LocaleKeys.journeyHarderWeekFallback.tr();
      imagePath = Assets.v2.images.imgJourneyThisWeek.path;
      targetRoute = RoutePaths.harderWeek;
    } else if (state.mode == JourneyMode.trying) {
      chipTitle = LocaleKeys.journeyActiveRecommendationChip.tr();
      titleText = LocaleKeys.journeyTryingThisWeekTitle.tr();
      final String experimentTitle =
          state.activeExperiment?.changeTitle.trim() ?? '';
      final String disruptionLine = state.weeklyInsights?.isHarderWeek == true
          ? ' ${LocaleKeys.journeyAlsoDisruptedNote.tr()}'
          : '';
      subtitleText =
          (experimentTitle.isNotEmpty
              ? experimentTitle
              : LocaleKeys.journeyTryingThisWeekFallback.tr()) +
          disruptionLine;
      buttonText = LocaleKeys.journeyViewProgress.tr();
      imagePath = Assets.v2.images.imgSprout.path;
      targetRoute = RoutePaths.tryingThisWeek;
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
            onTap: () async {
              await context.push(targetRoute);
              if (context.mounted) {
                context.read<JourneyCubit>().init();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepJourneyCard(BuildContext context, JourneyState state) {
    final bool isEnrolled = state.isSleepJourneyEnrolled;
    final int currentWeek = state.sleepJourneyWeek;
    final int totalWeeks = state.sleepJourneyTotalWeeks <= 0
        ? 6
        : state.sleepJourneyTotalWeeks;
    final double fraction = (currentWeek / totalWeeks).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () async {
        if (isEnrolled) {
          await context.push(RoutePaths.enrolledJourney);
        } else {
          await context.push(RoutePaths.programmeDetail);
        }
        if (context.mounted) {
          context.read<JourneyCubit>().init();
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
      onTap: () async {
        await context.push(RoutePaths.brainySaved);
        if (context.mounted) {
          context.read<JourneyCubit>().init();
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
        context.push(RoutePaths.familyTimeline);
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
        context.push(RoutePaths.mentorshipLanding);
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
