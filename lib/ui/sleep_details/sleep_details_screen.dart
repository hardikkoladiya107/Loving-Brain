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

class SleepDetailsScreen extends StatelessWidget {
  const SleepDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SleepDetailsCubit()..init(),
      child: BlocBuilder<SleepDetailsCubit, SleepDetailsState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: darkBlue,
            ),
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: const Color(0xFFFEF8F4),
              body: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SleepHeader(
                          titleWidget: "Sleep details".appText(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          chipText: "Tonight",
                          timeText: "07:45 - 8:15 PM",
                          estimateText: "Bedtime estimate 8:10 PM",
                          cloudImagePath:
                              Assets.v2.images.imgNoriSleepDetails.path,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.spaceH,
                              _buildConfidenceRow(),
                              24.spaceH,
                              _buildInfoCardsRow(),
                              24.spaceH,
                              _buildLastSleepInfoCard(state),
                              32.spaceH,
                              AppButton(
                                title: "Update sleep",
                                onTap: () {
                                  showAddSleepUpdateSheet(context);
                                },
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                              ),
                              12.spaceH,
                              AppButton(
                                title: "View tonight's plan",
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  ); // close the bottom sheet
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TonightsPlanScreen(),
                                    ),
                                  );
                                },
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                              ),
                              100.spaceH,
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfidenceRow() {
    return Row(
      children: [
        Icon(Icons.more_horiz, color: secondaryColor, size: 24.sp),
        8.spaceW,
        "High confidence".appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildInfoCardsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSmallInfoCard("WOKE", "06:45 AM", "15 min early", false),
        _buildSmallInfoCard("NAP", "11:40 AM", "15 min early", true),
        _buildSmallInfoCard("LAST NIGHT", "10:34 PM", "15 min early", false),
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
      width: 110.w,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: secondaryColor, width: 1)
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          4.spaceH,
          subtitle.appText(fontSize: 12.sp, color: greyColor4),
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
        borderRadius: BorderRadius.circular(24),
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
                  "Fell asleep",
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
        Column(
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
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ],
    );
  }
}
