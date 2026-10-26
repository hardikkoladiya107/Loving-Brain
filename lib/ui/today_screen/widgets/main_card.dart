import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/sleep_forecast/sleep_forecast_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key});

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
        Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Container(
              height: 12.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: secondaryColor.withValues(alpha: 0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 12.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor,
              ),
              child: Center(
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (BuildContext sheetContext) =>
                  const SleepForecastScreen(),
            );
          },
        ),
      ],
    );
  }
}
