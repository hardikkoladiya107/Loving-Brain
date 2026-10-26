import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.chipTitle,
    required this.title,
    this.subtitle,
  });

  final String chipTitle;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(chipTitle: chipTitle),
          12.spaceH,
          title.appText(
            fontSize: 20,
            color: greyColor9,
            textAlign: TextAlign.start,
            fraunces: true,
          ),
          if (subtitle != null &&
              subtitle!.isNotEmpty &&
              subtitle != title) ...[
            8.spaceH,
            subtitle!.appText(
              fontSize: 14,
              color: greyColor6,
              textAlign: TextAlign.start,
            ),
          ],
        ],
      ),
    );
  }
}
