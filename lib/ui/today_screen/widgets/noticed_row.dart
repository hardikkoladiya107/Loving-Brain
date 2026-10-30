import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';

class NoticedRow extends StatelessWidget {
  const NoticedRow({super.key});

  @override
  Widget build(BuildContext context) {
    final TodayState state = context.watch<TodayCubit>().state;
    final bool showHeadsUp = state.showBehaviourHeadsUp;
    final bool showNoticed = state.showNoticed;

    if (!showHeadsUp && !showNoticed) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 330.h,
      child: Row(
        spacing: 12,
        children: [
          if (showHeadsUp)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: () {
                      context.push(RoutePaths.calmHeadsUp);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 160.h,
                            width: 160.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  Assets.v2.images.imgHeadsUp.path,
                                ),
                              ),
                            ),
                          ),
                          20.spaceH,
                          const InfoChip(chipTitle: 'Heads-up'),
                          20.spaceH,
                          (state.headsUpHeadline.isNotEmpty
                                  ? state.headsUpHeadline
                                  : 'A harder window may be more likely')
                              .appText(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (showNoticed)
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: () {
                      if (state.noticedDestination ==
                          TodayNoticedDestination.behaviourPattern) {
                        context.push(RoutePaths.behaviourPattern);
                      } else {
                        context.push(RoutePaths.sleepPattern);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const InfoChip(chipTitle: 'Noticed'),
                          10.spaceH,
                          SizedBox(width: 12.h),
                          state.noticedTitle.appText(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                          6.spaceH,
                          Container(
                            height: 150.w,
                            width: 150.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  Assets.v2.images.imgNoticed.path,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
