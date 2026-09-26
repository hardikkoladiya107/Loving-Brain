import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class WarningBox extends StatelessWidget {
  final String label;
  final String body;
  final String? title;

  const WarningBox({
    super.key,
    required this.label,
    required this.body,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE9E7), // Light red/pink
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars,
                  color: const Color(0xFFD84315), // Red
                  size: 14.sp,
                ),
                6.spaceW,
                label.appText(
                  fontSize: 14.sp,
                  color: const Color(0xFFD84315),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          if (title != null) 12.spaceH,
          if (title != null)
            title!.appText(
              fontSize: 22.sp,
              color: primaryColor,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
          12.spaceH,
          body.appText(
            fontSize: 14.sp,
            color: Color(0xFFD54B36),
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
