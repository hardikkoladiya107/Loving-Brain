import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';

class SleepHeader extends StatelessWidget {
  final Widget titleWidget;
  final String chipText;
  final String timeText;
  final String estimateText;
  final String cloudImagePath;

  const SleepHeader({
    super.key,
    required this.titleWidget,
    required this.chipText,
    required this.timeText,
    required this.estimateText,
    required this.cloudImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.person,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        8.spaceW,
                        Flexible(
                          child:
                              (preferences.getChildModel()?.childName ??
                                      'Child')
                                  .appText(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                        ),
                      ],
                    ).appPadding(left: 6, right: 12, top: 8, bottom: 8),
                  ),
                ),
                12.spaceW,
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.face, size: 20.sp, color: Colors.white),
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
        ).appPadding(all: 16),
      ],
    );
  }
}
