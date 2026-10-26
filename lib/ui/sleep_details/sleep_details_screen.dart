import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_sleep_update_sheet.dart';
import 'package:loving_brain/ui/tonights_plan/tonights_plan_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/sleep_header.dart';

import 'bloc/sleep_details_cubit.dart';
import 'bloc/sleep_details_state.dart';

/// Screen 24 — Sleep Details screen.
class SleepDetailsScreen extends StatefulWidget {
  const SleepDetailsScreen({super.key});

  @override
  State<SleepDetailsScreen> createState() => _SleepDetailsScreenState();
}

class _SleepDetailsScreenState extends State<SleepDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepDetailsCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepDetailsCubit, SleepDetailsState>(
      listener: (BuildContext context, SleepDetailsState state) {},
      builder: (BuildContext context, SleepDetailsState state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(statusBarColor: darkBlue),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: const Color(0xFFFEF8F4),
            body: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SleepHeader(
                        titleWidget: "Sleep details".appText(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fraunces: true,
                          textAlign: TextAlign.start,
                        ),
                        chipText: "Tonight",
                        timeText: "${state.windowStart} - ${state.windowEnd}",
                        estimateText:
                            "Bedtime estimate ${state.bedtimeEstimate}",
                        cloudImagePath:
                            Assets.v2.images.imgNoriSleepDetails.path,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.spaceH,
                            _buildConfidenceRow(state),
                            24.spaceH,
                            _buildInfoCardsRow(state),
                            24.spaceH,
                            _buildLastSleepInfoCard(state),
                            32.spaceH,
                            AppButton(
                              title: "Update sleep",
                              onTap: () async {
                                await showAddSleepUpdateSheet(context);
                                if (context.mounted) {
                                  context.read<SleepDetailsCubit>().init();
                                }
                              },
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            ),
                            12.spaceH,
                            AppButton(
                              title: "View tonight's plan",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext routeCtx) =>
                                        const TonightsPlanScreen(),
                                  ),
                                );
                              },
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                            ),
                            SafeArea(top: false, child: 40.spaceH),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildConfidenceRow(SleepDetailsState state) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++) ...[
          Icon(
            Icons.circle,
            color: i < state.confidenceDots
                ? secondaryColor
                : secondaryColor.withValues(alpha: 0.2),
            size: 8.sp,
          ),
          if (i < 2) 4.spaceW,
        ],
        8.spaceW,
        "${state.confidenceLabel} confidence".appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildInfoCardsRow(SleepDetailsState state) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallInfoCard(
            "WOKE",
            state.wakeUpTime,
            state.hasRealLogs ? "Logged wake" : "Expected",
            false,
          ),
        ),
        8.spaceW,
        Expanded(
          child: _buildSmallInfoCard(
            "BEDTIME",
            state.wentToBed,
            state.hasRealLogs ? "Last logged" : "Target",
            true,
          ),
        ),
        8.spaceW,
        Expanded(
          child: _buildSmallInfoCard(
            "QUALITY",
            state.sleepQuality,
            state.hasRealLogs ? "Rest rating" : "Baseline",
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard(
    String title,
    String time,
    String subtitle,
    bool isHighlighted,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isHighlighted
            ? Border.all(color: secondaryColor, width: 1.w)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title.appText(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: greyColor4,
            letterSpacing: 1.0,
          ),
          8.spaceH,
          time.appText(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          4.spaceH,
          subtitle.appText(fontSize: 11.sp, color: greyColor4),
        ],
      ),
    );
  }

  Widget _buildLastSleepInfoCard(SleepDetailsState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Last sleep information".appText(
            fontSize: 20.sp,
            color: Colors.white,
            fraunces: true,
          ),
          24.spaceH,
          Row(
            children: [
              Expanded(
                child: _buildSleepInfoItem(
                  Assets.v2.icons.icTimeInSleep.path,
                  state.timeInSleep,
                  "Time in sleep",
                ),
              ),
              Expanded(
                child: _buildSleepInfoItem(
                  Assets.v2.icons.icWakeUpTime.path,
                  state.wakeUpTime,
                  "Wake up time",
                ),
              ),
            ],
          ),
          24.spaceH,
          Row(
            children: [
              Expanded(
                child: _buildSleepInfoItem(
                  Assets.v2.icons.icWentToBed.path,
                  state.wentToBed,
                  "Went to bed",
                ),
              ),
              Expanded(
                child: _buildSleepInfoItem(
                  Assets.v2.icons.icFellAsleep.path,
                  state.fellAsleepTime,
                  "Night wakings",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepInfoItem(String svgAsset, String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(svgAsset, width: 24.sp, height: 24.sp),
        8.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              value.appText(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              4.spaceH,
              label.appText(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
