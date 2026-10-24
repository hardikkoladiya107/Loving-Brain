import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void showInstantResultSheet(
  BuildContext context, {
  String? title,
  String? reason,
  String? action,
  String? actionSubtitle,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (BuildContext context) => InstantResultSheet(
      title: title,
      reason: reason,
      action: action,
      actionSubtitle: actionSubtitle,
    ),
  );
}

class InstantResultSheet extends StatelessWidget {
  final String? title;
  final String? reason;
  final String? action;
  final String? actionSubtitle;

  const InstantResultSheet({
    super.key,
    this.title,
    this.reason,
    this.action,
    this.actionSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedTitle = title ?? "Bedtime may shift a little earlier";
    final String resolvedReason =
        reason ??
        "Today’s nap ran 25 minutes short, which usually brings the settling window forward.";
    final String resolvedAction = action ?? "Start wind-down at 7:30 PM";
    final String resolvedActionSubtitle =
        actionSubtitle ?? "About 15 minutes earlier than usual tonight.";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2.h,
              width: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: greyColor7,
              ),
            ),
          ],
        ),
        12.spaceH,
        resolvedTitle.appText(
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
              10.spaceH,
              SizedBox(width: 12.h),
              resolvedReason.appText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: greyColor6,
              ),
              6.spaceH,
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
              10.spaceH,
              SizedBox(width: 12.h),
              resolvedAction.appText(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              resolvedActionSubtitle.appText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                color: greyColor6,
              ),
              6.spaceH,
            ],
          ),
        ),
        20.spaceH,
        AppButton(
          title: "Done",
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.spaceH,
      ],
    ).appPadding(left: 16.r, right: 16.r, top: 16.r);
  }
}
