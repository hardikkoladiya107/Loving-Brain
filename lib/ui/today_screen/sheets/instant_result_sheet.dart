import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void showInstantResultSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (context) => const InstantResultSheet(),
  );
}

class InstantResultSheet extends StatelessWidget {
  const InstantResultSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: greyColor7,
              ),
            ),
          ],
        ),
        12.spaceH,
        "Bedtime may shift a little earlier".appText(
          fontSize: 28.sp,
          fraunces: true,
          textAlign: TextAlign.start,
        ),
        12.spaceH,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF767676).withAlpha(16),
                spreadRadius: 16,
                blurRadius: 12,
              ),
            ],
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoChip(iconData: Icons.info, chipTitle: "Reason"),
              10.h.spaceH,
              SizedBox(width: 12.h),
              "Today’s nap ran 25 minutes short, which usually brings the settling window forward."
                  .appText(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    color: greyColor6,
                  ),
              6.h.spaceH,
            ],
          ),
        ),
        12.spaceH,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF767676).withAlpha(16),
                spreadRadius: 16,
                blurRadius: 12,
              ),
            ],
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoChip(
                iconData: Icons.stars_rounded,
                chipTitle: "Action",
              ),
              10.h.spaceH,
              SizedBox(width: 12.h),
              "Start wind-down at 7:30 PM".appText(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              "About 15 minutes earlier than usual tonight.".appText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: greyColor6,
              ),
              6.h.spaceH,
            ],
          ),
        ),
        20.spaceH,
        AppButton(title: "Save Note", onTap: () {}),
        12.spaceH,
      ],
    ).appPadding(left: 16, right: 16, top: 16);
  }
}
