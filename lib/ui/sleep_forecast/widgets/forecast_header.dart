import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_state.dart';
import 'package:loving_brain/ui/widget/sleep_header.dart';

class ForecastHeader extends StatelessWidget {
  const ForecastHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final SleepForecastCubit cubit = context.read<SleepForecastCubit>();
    final SleepForecastState state = context.watch<SleepForecastCubit>().state;

    return SleepHeader(
      showBackButton: true,
      onChildSwitched: () => cubit.init(),
      onParentProfileReturned: () => cubit.init(),
      childName: state.childName.isNotEmpty ? state.childName : null,
      titleWidget: Row(
        children: [
          Container(
            height: 30.w,
            width: 30.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(Assets.v2.images.imgMoodGood.path),
              ),
            ),
          ),
          8.spaceW,
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${state.timeOfDayGreeting} ",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "${state.parentName}!",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      chipText: "Next window",
      timeText: "${state.windowStart} - ${state.windowEnd}",
      estimateText:
          "Bedtime estimate ${state.bedtimeEstimate}. ${state.confidenceLevel}\nconfidence.",
      cloudImagePath: Assets.v2.images.imgNoriSleepForecaste.path,
    );
  }
}
