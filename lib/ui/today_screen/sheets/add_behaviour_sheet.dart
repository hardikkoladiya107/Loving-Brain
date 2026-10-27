import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/today_screen/widgets/action_grid.dart';

void showAddBehaviourSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: const Color(0xFFF7F7F7),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (BuildContext context) => const AddBehaviourSheet(),
  );
}

class AddBehaviourSheet extends StatelessWidget {
  const AddBehaviourSheet({super.key});

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
                  height: 4.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: greyColor7,
                  ),
                ),
              ],
            ),
            16.spaceH,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "What would you like to update?".appText(
                  fontSize: 28.sp,
                  fraunces: true,
                  textAlign: TextAlign.start,
                ),
                8.spaceH,
                "Takes about twenty seconds.".appText(
                  fontSize: 14.sp,
                  color: greyColor6,
                  height: 1.4,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            16.spaceH,
            const ActionGrid(),
            24.spaceH,
          ],
        ).appPadding(left: 16.w, right: 16.w, top: 12.h, bottom: 16.h),
      ),
    );
  }
}
