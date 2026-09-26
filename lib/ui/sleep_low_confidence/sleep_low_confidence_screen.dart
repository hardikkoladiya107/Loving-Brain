import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sleep_low_confidence_cubit.dart';
import 'bloc/sleep_low_confidence_state.dart';

class SleepLowConfidenceScreen extends StatelessWidget {
  const SleepLowConfidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: darkBlue),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF8F4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Color(0xFF1E293B)),
          title: Text(
            "Sleep",
            style: TextStyle(
              color: const Color(0xFF1E293B),
              fontSize: 28.sp,
              fontFamily: 'Fraunces',
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  16.spaceH,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.sp,
                              color: const Color(0xFF5C6BC0),
                            ),
                            4.spaceW,
                            Icon(
                              Icons.circle,
                              size: 8.sp,
                              color: const Color(0xFF5C6BC0),
                            ),
                            4.spaceW,
                            Icon(
                              Icons.circle,
                              size: 8.sp,
                              color: const Color(0xFFE2E8F0),
                            ),
                          ],
                        ),
                        8.spaceW,
                        Text(
                          "Confidence: low",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoBox(
                          body: Assets.v2.icons.icFaqs.path, // Info icon
                          title: "Next window",
                          backgroundColor: const Color(0xFFF1F5F9),
                          textColor: const Color(0xFF64748B),
                          iconColor: const Color(0xFF64748B),
                        ),
                        16.spaceH,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              Assets.v2.images.imgSprout.path,
                              width: 120.w,
                              height: 120.w,
                              fit: BoxFit.contain,
                            ),
                            16.spaceW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "7:15 ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“ 8:30 PM",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: const Color(0xFF1E293B),
                                      fontFamily: 'Fraunces',
                                      height: 1.2,
                                    ),
                                  ),
                                  8.spaceH,
                                  Text(
                                    "A wider window than usual the last few days have been unsettled, so we're less sure tonight.",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color(0xFF64748B),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  16.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoBox(
                          title: "Still learning this pattern",
                          body:
                              "A few more updates will sharpen this estimate. Around ten nights is usually enough.v",
                          backgroundColor: const Color(0xFFF1F5F9),
                          textColor: const Color(0xFF64748B),
                          iconColor: const Color(0xFF64748B),
                        ),
                        24.spaceH,
                        Text(
                          "Based on 4 nights so far",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: const Color(0xFF1E293B),
                            fontFamily: 'Fraunces',
                          ),
                        ),
                        8.spaceH,
                        Text(
                          "A few more updates will sharpen this estimate. Around ten nights is usually enough.",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.spaceH,
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF), // Light purple
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "We'd rather show a wide window honestly than a precise time we can't stand behind.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF1E293B),
                        height: 1.4,
                      ),
                    ),
                  ),
                  120.spaceH, // Bottom spacing for fixed button
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFFFEF8F4),
                      const Color(0xFFFEF8F4).withOpacity(0.0),
                    ],
                  ),
                ),
                child: AppButton(title: "Add tonight's update", onTap: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
