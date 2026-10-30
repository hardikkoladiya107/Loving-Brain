import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/calm_plan/bloc/calm_plan_cubit.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class HeadsUpCard extends StatelessWidget {
  final bool isHealthNote;

  const HeadsUpCard({super.key, this.isHealthNote = false});

  @override
  Widget build(BuildContext context) {
    final TodayState state = context.watch<TodayCubit>().state;

    final String resolvedTitle = isHealthNote
        ? (state.healthHeadsUpTitle.isNotEmpty
              ? state.healthHeadsUpTitle
              : 'Health check-in noted')
        : (state.headsUpHeadline.isNotEmpty
              ? state.headsUpHeadline
              : 'A harder window may be more likely');

    final String resolvedSubtitle = isHealthNote
        ? (state.healthHeadsUpSubtitle.isNotEmpty
              ? state.healthHeadsUpSubtitle
              : 'Symptoms logged today. Rest and comfort matter most right now.')
        : (state.headsUpReason.isNotEmpty
              ? state.headsUpReason
              : (state.headsUpWindowStart.isNotEmpty
                    ? 'Between ${state.headsUpWindowStart} and ${state.headsUpWindowEnd}.'
                    : 'A harder window may be more likely based on recent patterns.'));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(chipTitle: isHealthNote ? 'Health note' : 'Calm heads-up'),
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: isHealthNote
                ? null
                : () {
                    context.push(RoutePaths.calmHeadsUp);
                  },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      resolvedTitle.appText(
                        fontSize: 24.sp,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.h),
                      resolvedSubtitle.appText(
                        fontSize: 12.sp,
                        color: greyColor6,
                        height: 1.4,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 150.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Assets.v2.images.imgHumi.path),
                    ),
                  ),
                ).appPadding(top: 20),
              ],
            ),
          ),
          if (!isHealthNote) ...[
            16.spaceH,
            AppButton(
              title: 'See calm plan',
              onTap: () {
                context.push(RoutePaths.calmPlan);
              },
            ),
            12.spaceH,
            AppButton(
              title: 'Play audio',
              backgroundColor: Colors.white,
              textColor: greyColor9,
              onTap: () {
                context.read<CalmPlanCubit>().playAudio();
              },
            ),
          ],
        ],
      ).appPadding(all: 16),
    );
  }
}
