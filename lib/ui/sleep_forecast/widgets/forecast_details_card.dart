import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class ForecastDetailsCard extends StatelessWidget {
  const ForecastDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reason Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoChip(
                  chipTitle: "Reason",
                  iconData: Icons.info_outline,
                  color: primaryColor,
                  bgColor: orangeLightColor,
                ),
                16.spaceH,
                "Why this window".appText(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                  fraunces: true,
                ),
                12.spaceH,
                "Ira woke at 6:45 and today's nap ran about 25 minutes short, so tiredness is building a little earlier than usual."
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
              ],
            ),
          ),
          24.spaceH,
          "TONIGHT’S PLAN".appText(
            color: secondaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            letterSpacing: 1.0,
          ),
          16.spaceH,
          _buildPlanItem("Wind-down starts", "7:20 PM - 25 min"),
          12.spaceH,
          _buildPlanItem("Book in the bedroom", "7:20 PM - 25 min"),
          12.spaceH,
          _buildPlanItem("Lights out", "7:20 PM - 25 min"),
        ],
      ),
    );
  }

  Widget _buildPlanItem(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,

            decoration: BoxDecoration(
              color: const Color(0xFFEEEEFC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.v2.images.imgTonightsPlan.path),
                  fit: BoxFit.contain,
                ),
              ),
            ).appPadding(all: 4),
          ),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                4.spaceH,
                subtitle.appText(fontSize: 12.sp, color: Colors.grey),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey, size: 24.sp),
        ],
      ),
    );
  }
}
