import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class NiceWorkCard extends StatelessWidget {
  const NiceWorkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(iconData: Icons.stars_rounded, chipTitle: "Nice work"),
          10.spaceH,
          "Three nights of easier bedtime in a row".appText(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          6.spaceH,
          "Nice work — this is a pattern worth noticing.".appText(
            fontSize: 12.sp,
            color: greyColor6,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
