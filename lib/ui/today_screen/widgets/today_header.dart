import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/child_profile_v2/child_profile_screen.dart';
import 'package:loving_brain/ui/parent_profile_v2/parent_profile_screen.dart';

import '../bloc/today_cubit.dart';

class TodayHeader extends StatelessWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodayCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  final todayCubit = context.read<TodayCubit>();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChildProfileScreen(),
                    ),
                  );
                  todayCubit.init();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
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
                      SizedBox(width: 8.w),
                      Flexible(
                        child: state.childName.appText(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ).appPadding(left: 6, right: 12, top: 6, bottom: 6),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () async {
                final todayCubit = context.read<TodayCubit>();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentProfileScreen(),
                  ),
                );
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
        InkWell(
          onTap: () => context.read<TodayCubit>().toggleMode(),
          child: Row(
            children: [
              Icon(Icons.mood, color: Colors.orange, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: "${state.timeOfDayGreeting} ${state.parentName}!"
                    .appText(
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
        ),
      ],
    );
  }
}
