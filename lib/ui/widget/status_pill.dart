import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class StatusPill extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Widget? leading;

  const StatusPill({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.leading,
  });

  factory StatusPill.linked() {
    return StatusPill(
      text: "Linked",
      textColor: greenColor,
      backgroundColor: lightGreenColor,
      leading: Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: greenColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  factory StatusPill.awaitingResponse() {
    return StatusPill(
      text: "Awaiting response",
      textColor: yellowColor1,
      backgroundColor: lightYellowColor,
      leading: Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: yellowColor1,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  factory StatusPill.pending() {
    return StatusPill(
      text: "Pending",
      textColor: yellowColor1,
      backgroundColor: lightYellowColor,
      leading: Icon(Icons.stars, color: yellowColor1, size: 14.sp),
    );
  }

  factory StatusPill.accepted() {
    return StatusPill(
      text: "Accepted",
      textColor: const Color(0xFF2E7D32),
      backgroundColor: const Color(0xFFE8F5E9),
      leading: Icon(
        Icons.check_circle,
        color: const Color(0xFF2E7D32),
        size: 14.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, 6.spaceW],
          text.appText(
            fontSize: 12.sp,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
