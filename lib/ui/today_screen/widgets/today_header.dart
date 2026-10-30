import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/today_screen/sheets/child_switcher_sheet.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

class TodayHeader extends StatelessWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TodayState state = context.watch<TodayCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  if (state.activeChildId.isEmpty) {
                    final TodayCubit todayCubit = context.read<TodayCubit>();
                    await context.push(
                      RoutePaths.childProfilePath(
                        preferences.getUserModel()?.uid ?? '',
                        fromManageChildren: true,
                      ),
                    );
                    todayCubit.init();
                  } else {
                    await showChildSwitcherSheet(context);
                  }
                },
                child: Container(
                  constraints: BoxConstraints(minHeight: 40.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.r),
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
                            (state.childName.isNotEmpty
                                    ? state.childName
                                    : (state.isLoading ? '' : 'Add child'))
                                .appText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                      ),
                      4.spaceW,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: greyColor,
                      ),
                    ],
                  ).appPadding(left: 6.w, right: 10.w, top: 4.h, bottom: 4.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () async {
                final TodayCubit todayCubit = context.read<TodayCubit>();
                await context.push(RoutePaths.parentProfile);
                todayCubit.init();
              },
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: primaryColor,
                child: Icon(Icons.face, size: 20.sp, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(Icons.mood, color: Colors.orange, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: "${state.timeOfDayGreeting} ${state.parentName}!".appText(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: greyColor,
                letterSpacing: 1.2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
