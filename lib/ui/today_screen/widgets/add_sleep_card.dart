import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_sleep_update_sheet.dart';

class AddSleepCard extends StatelessWidget {
  const AddSleepCard({super.key});

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
          const InfoChip(chipTitle: "Getting started"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    "Still learning your child".appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    "Add one update and we’ll start noticing patterns.".appText(
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
                    image: AssetImage(Assets.v2.images.imgSprout.path),
                  ),
                ),
              ).appPadding(top: 20),
            ],
          ),
          16.spaceH,
          AppButton(
            title: "Add sleep update",
            onTap: () {
              showAddSleepUpdateSheet(context);
            },
          ),
        ],
      ).appPadding(all: 16),
    );
  }
}
