import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class ConsistencyRecognitionScreen extends StatelessWidget {
  const ConsistencyRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top glow behind image
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 400.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      40.spaceH,
                      Center(
                        child: Image.asset(
                          Assets
                              .v2
                              .images
                              .imgJourneyConsistencyRecognition
                              .path,
                          width: 250.w,
                          height: 250.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      24.spaceH,
                      "You've shown up five\ndays this week".appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.center,
                        height: 1.2,
                      ),
                      16.spaceH,
                      "No streak to lose we just wanted to notice the effort."
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            textAlign: TextAlign.center,
                          ),
                      32.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: softPeachOrange, // soft peach/orange
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            "Small, regular check-ins are what let us spot patterns. Weeks where you don't manage it are fine too."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                ),
                      ),
                      120.spaceH, // Spacing for bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 40.h,
          bottom: 40.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: AppButton(
          title: "Back to Journey",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
