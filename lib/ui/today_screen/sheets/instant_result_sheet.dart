import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

void showInstantResultSheet(
  BuildContext context, {
  required String title,
  required String reason,
  required String action,
  required String actionSubtitle,
  VoidCallback? onActionTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (BuildContext context) => InstantResultSheet(
      title: title,
      reason: reason,
      action: action,
      actionSubtitle: actionSubtitle,
      onActionTap: onActionTap,
    ),
  );
}

class InstantResultSheet extends StatelessWidget {
  final String title;
  final String reason;
  final String action;
  final String actionSubtitle;
  final VoidCallback? onActionTap;

  const InstantResultSheet({
    super.key,
    required this.title,
    required this.reason,
    required this.action,
    required this.actionSubtitle,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
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
            title.appText(
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
                  const InfoChip(iconData: Icons.info, chipTitle: 'Reason'),
                  10.spaceH,
                  SizedBox(width: 12.h),
                  reason.appText(
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
            InkWell(
              onTap: onActionTap != null
                  ? () {
                      Navigator.pop(context);
                      onActionTap!();
                    }
                  : null,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const InfoChip(
                          iconData: Icons.stars_rounded,
                          chipTitle: 'Action',
                        ),
                        if (onActionTap != null)
                          Icon(
                            Icons.chevron_right_rounded,
                            color: primaryColor,
                            size: 24.sp,
                          ),
                      ],
                    ),
                    10.spaceH,
                    action.appText(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                    6.spaceH,
                    actionSubtitle.appText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      color: greyColor6,
                    ),
                    6.spaceH,
                  ],
                ),
              ),
            ),
            20.spaceH,
            AppButton(
              title: 'Done',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            12.spaceH,
          ],
        ).appPadding(left: 16.w, right: 16.w, top: 16.h, bottom: 20.h),
      ),
    );
  }
}
