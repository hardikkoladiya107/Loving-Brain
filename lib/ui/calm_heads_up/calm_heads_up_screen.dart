import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/calm_heads_up_cubit.dart';
import 'bloc/calm_heads_up_state.dart';

class CalmHeadsUpScreen extends StatelessWidget {
  const CalmHeadsUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFFFD4C8,
                    ).withValues(alpha: 0.8), // Inner peach glow
                    const Color(
                      0xFFFFD4C8,
                    ).withValues(alpha: 0.0), // Fade to transparent
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          // Bottom Right Glow
          Positioned(
            right: -150,
            bottom: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFFFD4C8,
                    ).withValues(alpha: 0.6), // Inner peach glow
                    const Color(
                      0xFFFFD4C8,
                    ).withValues(alpha: 0.0), // Fade to transparent
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.spaceH,
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back,
                            color: darkBlue,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  24.spaceH,
                  "Calm Heads-Up".appText(
                    fontSize: 32.sp,
                    color: darkBlue,
                    fraunces: true,
                    textAlign: TextAlign.start,
                  ),
                  16.spaceH,
                  _buildConfidencePill(),
                  24.spaceH,
                  _buildMainCard(context),
                  24.spaceH,
                  _buildBottomNotice(),
                  const Spacer(),
                  AppButton(
                    title: "Add update",
                    onTap: () {},
                    backgroundColor: Colors.white,
                    textColor: greyColor9,
                  ),
                  16.spaceH,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidencePill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildDot(const Color(0xFF6A5AE0)),
              4.spaceW,
              _buildDot(const Color(0xFF6A5AE0)),
              4.spaceW,
              _buildDot(const Color(0xFF6A5AE0).withValues(alpha: 0.3)),
            ],
          ),
          8.spaceW,
          "Confidence: moderate".appText(
            color: greyColor4,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(
            chipTitle: "Heads-up",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.spaceH,
                    "A harder window may be more likely".appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    12.spaceH,
                    "Between 5:30 and 7:00 PM - a skipped nap and a new environment today."
                        .appText(
                          fontSize: 14.sp,
                          color: greyColor6,
                          textAlign: TextAlign.start,
                        ),
                  ],
                ),
              ),
              Container(
                width: 100.w,
                height: 120.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(Assets.v2.images.imgHumi.path),
                  ),
                ),
              ),
            ],
          ),
          24.spaceH,
          AppButton(
            title: "See calm plan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalmPlanScreen()),
              );
            },
            backgroundColor: primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNotice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info, color: primaryColor, size: 16.sp),
        8.spaceW,
        Expanded(
          child:
              "Between 5:30 and 7:00 PM - a skipped nap and a new environment today."
                  .appText(
                    color: primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                    height: 1.4,
                  ),
        ),
      ],
    );
  }
}
