import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class HeadsUpCard extends StatelessWidget {
  const HeadsUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(chipTitle: "Calm heads-up"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    "A harder evening may be more likely".appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    "Overtiredness and a skipped nap Â· window 6â€“8 PM."
                        .appText(
                          fontSize: 12.sp,
                          color: greyColor6,
                          height: 1.4,
                          textAlign: TextAlign.start,
                        ),
                  ],
                ),
              ),
              Container(
                width: 150.w,
                height: 180.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(Assets.v2.images.imgHumi.path),
                  ),
                ),
              ).appPadding(top: 20),
            ],
          ),
          16.spaceH,
          AppButton(
            title: "See calm plan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalmPlanScreen()),
              );
            },
          ),
        ],
      ).appPadding(all: 16),
    );
  }
}
