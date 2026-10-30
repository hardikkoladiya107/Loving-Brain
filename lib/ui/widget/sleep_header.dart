import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class SleepHeader extends StatelessWidget {
  final Widget titleWidget;
  final String chipText;
  final String timeText;
  final String estimateText;
  final String cloudImagePath;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final VoidCallback? onChildSwitched;
  final VoidCallback? onParentProfileReturned;
  final String? childName;

  const SleepHeader({
    super.key,
    required this.titleWidget,
    required this.chipText,
    required this.timeText,
    required this.estimateText,
    required this.cloudImagePath,
    this.showBackButton = true,
    this.onBackTap,
    this.onChildSwitched,
    this.onParentProfileReturned,
    this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.v2.images.imgSleepBackground.path),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12.h,
          right: 12.w,
          child: SizedBox(
            height: 120.h,
            width: 105.w,
            child: Image.asset(cloudImagePath, fit: BoxFit.contain),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: () {
                    if (onBackTap != null) {
                      onBackTap!();
                    } else if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      context.pop();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_back, color: darkBlue, size: 22.sp),
                  ),
                ),
              16.spaceH,
              titleWidget,
              16.spaceH,
              InfoChip(
                chipTitle: chipText,
                iconData: Icons.info,
                color: secondaryColor,
                bgColor: Colors.white,
              ),
              16.spaceH,
              Padding(
                padding: EdgeInsets.only(right: 110.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    timeText.appText(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    4.spaceH,
                    estimateText.appText(
                      fontSize: 13.sp,
                      color: greyColor2,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ).appPadding(left: 16.w, right: 16.w, top: 8.h, bottom: 16.h),
        ),
      ],
    );
  }
}
