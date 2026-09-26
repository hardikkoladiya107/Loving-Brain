import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/widget/sleep_header.dart';

class ForecastHeader extends StatelessWidget {
  const ForecastHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SleepHeader(
      titleWidget: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(Assets.v2.images.imgMoodGood.path),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            children: [
              "GOOD EVENING ".appText(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: Colors.white,
                textAlign: TextAlign.start,
              ),
              "${(preferences.getUserModel()?.parentName ?? 'Parent').toUpperCase()}!".appText(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.white,
                letterSpacing: 1.2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
      chipText: "Next window",
      timeText: "07:45 - 8:15 PM",
      estimateText: "Bedtime estimate 8:10 PM. High\nconfidence.",
      cloudImagePath: Assets.v2.images.imgNoriSleepForecaste.path,
    );
  }
}
