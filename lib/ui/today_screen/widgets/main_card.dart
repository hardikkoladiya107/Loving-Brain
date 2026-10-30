import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key});

  double _fractionForTime(String? timeStr, {double fallback = 0.5}) {
    if (timeStr == null || timeStr.trim().isEmpty) return fallback;
    try {
      final DateFormat format12 = DateFormat('h:mm a');
      final DateFormat format12NoPad = DateFormat('hh:mm a');
      DateTime dt;
      try {
        dt = format12.parse(timeStr.trim());
      } catch (_) {
        dt = format12NoPad.parse(timeStr.trim());
      }
      final int totalMinutes = dt.hour * 60 + dt.minute;
      const int scaleStartMinutes = 18 * 60; // 6:00 PM
      const int scaleEndMinutes = 21 * 60; // 9:00 PM
      const int scaleDuration = scaleEndMinutes - scaleStartMinutes; // 180 mins

      final double fraction =
          (totalMinutes - scaleStartMinutes) / scaleDuration;
      return fraction.clamp(0.05, 0.95);
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TodayState state = context.watch<TodayCubit>().state;
    final String confidenceText = state.confidenceLevel.isNotEmpty
        ? state.confidenceLevel[0].toUpperCase() +
              state.confidenceLevel.substring(1)
        : 'Learning';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoChip(chipTitle: "Sleep Forecast"),
                  16.spaceH,
                  "${state.sleepForecastStart} - ${state.sleepForecastEnd}"
                      .appText(fontSize: 28.sp, fraunces: true),
                  8.spaceH,
                  (state.forecastSubtitle.startsWith("Bedtime estimate")
                          ? state.forecastSubtitle
                          : "Bedtime estimate ${state.bedtimeEstimate}. ${state.forecastSubtitle}")
                      .appText(
                        fontSize: 12.sp,
                        color: greyColor6,
                        height: 1.4,
                        textAlign: TextAlign.start,
                      ),
                ],
              ),
            ),
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(Assets.v2.images.imgCuteCloud.path),
                ),
              ),
            ).appPadding(top: 20.h),
          ],
        ),
        16.spaceH,
        Row(
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
            "Confidence: $confidenceText".appText(
              fontSize: 12.sp,
              color: greyColor6,
            ),
          ],
        ),
        24.spaceH,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double trackWidth = constraints.maxWidth;
            final double startFrac = _fractionForTime(
              state.sleepForecastStart,
              fallback: 0.35,
            );
            final double endFrac = _fractionForTime(
              state.sleepForecastEnd,
              fallback: 0.65,
            );
            final double bedtimeFrac = _fractionForTime(
              state.bedtimeEstimate,
              fallback: 0.5,
            );

            final double windowLeft = (startFrac * trackWidth).clamp(
              0.0,
              trackWidth,
            );
            final double windowRight = (endFrac * trackWidth).clamp(
              windowLeft,
              trackWidth,
            );
            final double windowWidth = (windowRight - windowLeft).clamp(
              24.w,
              trackWidth,
            );

            final double thumbLeft = ((bedtimeFrac * trackWidth) - 20.w).clamp(
              0.0,
              trackWidth - 40.w,
            );

            return SizedBox(
              height: 40.h,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Full background track
                  Container(
                    height: 12.h,
                    width: trackWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: secondaryColor.withValues(alpha: 0.18),
                    ),
                  ),
                  // Active predicted window range
                  Positioned(
                    left: windowLeft,
                    width: windowWidth,
                    child: Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: secondaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  // Bedtime Estimate Thumb Indicator
                  Positioned(
                    left: thumbLeft,
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x33665FCE),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          height: 28.w,
                          width: 28.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            4.spaceW,
            "6 PM".appText(color: greyColor4, fontSize: 14.sp),
            4.spaceW,
            "7 PM".appText(color: greyColor4, fontSize: 14.sp),
            4.spaceW,
            "8 PM".appText(color: greyColor4, fontSize: 14.sp),
            4.spaceW,
            "9 PM".appText(color: greyColor4, fontSize: 14.sp),
            4.spaceW,
          ],
        ),
        16.spaceH,
        AppButton(
          title: "View details",
          onTap: () {
            context.push(RoutePaths.sleepForecast);
          },
        ),
      ],
    );
  }
}
