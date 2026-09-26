import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

class OfflineBanner extends StatelessWidget {
  final bool isVisible;

  const OfflineBanner({super.key, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), // Light red/pink
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You're offline now",
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFFD32F2F), // Red text
              fontFamily: 'Fraunces',
            ),
          ),
          12.spaceH,
          Text(
            "Showing your last saved plan - we'll sync when you're back.",
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFFD32F2F),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
