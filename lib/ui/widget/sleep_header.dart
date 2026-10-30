import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/today_screen/sheets/child_switcher_sheet.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

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
    final String effectiveChildName =
        childName ?? preferences.getChildModel()?.childName ?? 'Child';

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
              Row(
                children: [
                  if (showBackButton) ...[
                    BaseButton(
                      onTap: () {
                        if (onBackTap != null) {
                          onBackTap!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Assets.v2.icons.icBack.svg(
                          width: 20.w,
                          height: 20.w,
                          colorFilter: const ColorFilter.mode(
                            darkBlue,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    10.spaceW,
                  ],
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        final ChildModel? currentChild = preferences
                            .getChildModel();
                        if (currentChild == null) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext _) =>
                                  const ChildProfileScreen(
                                    fromManageChildren: true,
                                  ),
                            ),
                          );
                        } else {
                          await showChildSwitcherSheet(context);
                        }
                        onChildSwitched?.call();
                      },
                      child: Container(
                        constraints: BoxConstraints(minHeight: 38.h),
                        decoration: BoxDecoration(
                          color: darkBlue,
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child:
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: Colors.amber,
                                  child: Icon(
                                    Icons.person,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                8.spaceW,
                                Flexible(
                                  child:
                                      (effectiveChildName.isNotEmpty
                                              ? effectiveChildName
                                              : 'Child')
                                          .appText(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                          ),
                                ),
                                4.spaceW,
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18.sp,
                                  color: Colors.white70,
                                ),
                              ],
                            ).appPadding(
                              left: 6.w,
                              right: 10.w,
                              top: 4.h,
                              bottom: 4.h,
                            ),
                      ),
                    ),
                  ),
                  12.spaceW,
                  GestureDetector(
                    onTap: () async {
                      await context.push(RoutePaths.parentProfile);
                      onParentProfileReturned?.call();
                    },
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: primaryColor,
                      child: Icon(Icons.face, size: 20.sp, color: Colors.white),
                    ),
                  ),
                ],
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
