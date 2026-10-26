import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

/// Displayed when the family does not yet have 3+ days of logged data (Rule 6).
/// Replaces fabricated multi-day comparative insights with honest learning guidance.
class StillLearningPatternsCard extends StatelessWidget {
  const StillLearningPatternsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(
            iconData: Icons.auto_awesome_rounded,
            chipTitle: "Learning patterns",
          ),
          12.spaceH,
          "Still learning your child's rhythm".appText(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          6.spaceH,
          "Keep adding sleep and behaviour updates. Multi-day patterns and bedtime consistency insights will unlock after 3 logged days."
              .appText(
                fontSize: 13.sp,
                color: greyColor6,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
        ],
      ),
    );
  }
}
