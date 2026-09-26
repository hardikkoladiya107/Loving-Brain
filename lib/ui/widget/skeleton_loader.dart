import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

class SkeletonBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBlock({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate 100
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class LoadingSkeletonScreen extends StatelessWidget {
  const LoadingSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
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
                  SkeletonBlock(height: 24.h, width: 120.w, borderRadius: 16),
                  24.spaceH,
                  SkeletonBlock(height: 48.h, width: double.infinity),
                  12.spaceH,
                  SkeletonBlock(height: 20.h, width: 200.w),
                  24.spaceH,
                  SkeletonBlock(height: 40.h, width: 40.w, borderRadius: 20),
                  24.spaceH,
                  SkeletonBlock(
                    height: 56.h,
                    width: double.infinity,
                    borderRadius: 28,
                  ),
                ],
              ),
            ),
            16.spaceH,
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBlock(height: 24.h, width: 100.w, borderRadius: 16),
                  16.spaceH,
                  SkeletonBlock(height: 20.h, width: double.infinity),
                  12.spaceH,
                  SkeletonBlock(height: 20.h, width: 180.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
