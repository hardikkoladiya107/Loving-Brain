import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/sleep_forecast/sleep_forecast_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodayCubit>().state;
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
                  SizedBox(height: 16.h),
                  "${state.sleepForecastStart} - ${state.sleepForecastEnd}"
                      .appText(fontSize: 28.sp, fraunces: true),
                  SizedBox(height: 8.h),
                  "Bedtime estimate ${state.bedtimeEstimate}. ${state.forecastSubtitle}"
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
            ).appPadding(top: 20),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(Icons.circle, color: secondaryColor, size: 8.sp),
            4.spaceW,
            Icon(Icons.circle, color: secondaryColor, size: 8.sp),
            4.spaceW,
            Icon(Icons.circle, color: secondaryColor.withAlpha(50), size: 8.sp),
            8.spaceW,
            "Confidence: ${state.confidenceLevel}".appText(
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
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: secondaryColor.withAlpha(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryColor,
              ),
              child: Center(
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
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
            final todayCubit = context.read<TodayCubit>();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => BlocProvider.value(
                value: todayCubit,
                child: const SleepForecastScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
