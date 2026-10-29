import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';

class HeadsUpCard extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const HeadsUpCard({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final TodayState state = context.watch<TodayCubit>().state;
    final int nowHour = DateTime.now().hour;

    final bool canViewHealth = TodayLogRepo.instance
        .canCurrentCaregiverViewHealth();
    final bool isHealthNote =
        canViewHealth &&
        (state.forecastSubtitle.toLowerCase().contains('fever') ||
            state.forecastSubtitle.toLowerCase().contains('health'));

    final String resolvedTitle =
        title ??
        (isHealthNote
            ? "Health check-in noted"
            : "A harder evening may be more likely");

    final String resolvedSubtitle =
        subtitle ??
        (isHealthNote
            ? "Symptoms logged today. Rest and comfort matter most right now."
            : (nowHour >= 20
                  ? "Wind-down and rest time tonight."
                  : (state.hasSleepLogs
                        ? "Predicted settling window ${state.sleepForecastStart}–${state.sleepForecastEnd}."
                        : "Still learning your child's unique rhythm.")));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(chipTitle: "Calm heads-up"),
          Row(
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
          16.spaceH,
          AppButton(
            title: "See calm plan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalmPlanScreen()),
              );
            },
          ),
        ],
      ).appPadding(all: 16),
    );
  }
}
