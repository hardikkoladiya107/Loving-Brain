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

  int _minutesForTime(String? timeStr, {int fallback = 19 * 60 + 30}) {
    if (timeStr == null || timeStr.trim().isEmpty) {
      return fallback;
    }
    try {
      final DateFormat format12 = DateFormat('h:mm a');
      final DateFormat format12NoPad = DateFormat('hh:mm a');
      DateTime dt;
      try {
        dt = format12.parse(timeStr.trim());
      } catch (_) {
        dt = format12NoPad.parse(timeStr.trim());
      }
      return dt.hour * 60 + dt.minute;
    } catch (_) {
      return fallback;
    }
  }

  ({int start, int end}) _scaleRange(TodayState state) {
    final int startMins = _minutesForTime(
      state.sleepForecastStart,
      fallback: 18 * 60,
    );
    final int endMins = _minutesForTime(
      state.sleepForecastEnd,
      fallback: 21 * 60,
    );
    int scaleStart = ((startMins ~/ 60) * 60) - 60;
    int scaleEnd = (((endMins + 59) ~/ 60) * 60) + 60;
    if (scaleEnd - scaleStart < 180) {
      final int mid = (startMins + endMins) ~/ 2;
      scaleStart = mid - 90;
      scaleEnd = mid + 90;
    }
    scaleStart = scaleStart.clamp(12 * 60, 22 * 60);
    scaleEnd = scaleEnd.clamp(scaleStart + 120, 24 * 60);
    return (start: scaleStart, end: scaleEnd);
  }

  double _fractionForMinutes(
    int totalMinutes, {
    required int scaleStart,
    required int scaleEnd,
    double fallback = 0.5,
  }) {
    final int scaleDuration = scaleEnd - scaleStart;
    if (scaleDuration <= 0) {
      return fallback;
    }
    final double fraction = (totalMinutes - scaleStart) / scaleDuration;
    return fraction.clamp(0.05, 0.95);
  }

  String _labelForMinutes(int totalMinutes) {
    final int hour24 = (totalMinutes ~/ 60) % 24;
    final int hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final String suffix = hour24 >= 12 ? 'PM' : 'AM';
    return '$hour12 $suffix';
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
            final ({int start, int end}) scale = _scaleRange(state);
            final double startFrac = _fractionForMinutes(
              _minutesForTime(state.sleepForecastStart, fallback: scale.start),
              scaleStart: scale.start,
              scaleEnd: scale.end,
              fallback: 0.35,
            );
            final double endFrac = _fractionForMinutes(
              _minutesForTime(state.sleepForecastEnd, fallback: scale.end),
              scaleStart: scale.start,
              scaleEnd: scale.end,
              fallback: 0.65,
            );
            final double bedtimeFrac = _fractionForMinutes(
              _minutesForTime(
                state.bedtimeEstimate,
                fallback: (scale.start + scale.end) ~/ 2,
              ),
              scaleStart: scale.start,
              scaleEnd: scale.end,
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
                  Container(
                    height: 12.h,
                    width: trackWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: secondaryColor.withValues(alpha: 0.18),
                    ),
                  ),
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
        Builder(
          builder: (BuildContext context) {
            final ({int start, int end}) scale = _scaleRange(state);
            final int step = ((scale.end - scale.start) / 3).round();
            final List<int> labels = <int>[
              scale.start,
              scale.start + step,
              scale.start + (step * 2),
              scale.end,
            ];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final int mins in labels) ...[
                  4.spaceW,
                  _labelForMinutes(
                    mins,
                  ).appText(color: greyColor4, fontSize: 14.sp),
                  4.spaceW,
                ],
              ],
            );
          },
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
