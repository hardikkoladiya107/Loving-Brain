import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_state.dart';
import 'package:loving_brain/ui/tonights_plan/tonights_plan_screen.dart';

class ForecastDetailsCard extends StatelessWidget {
  const ForecastDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SleepForecastState state = context.watch<SleepForecastCubit>().state;
    final List<TonightPlanStep> steps = state.planSteps;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reason Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoChip(
                  chipTitle: "Reason",
                  iconData: Icons.info_outline,
                  color: primaryColor,
                  bgColor: orangeLightColor,
                ),
                16.spaceH,
                "Why this window".appText(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                  fraunces: true,
                ),
                12.spaceH,
                state.reason.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
                if (state.healthCaveat != null &&
                    state.healthCaveat!.isNotEmpty) ...[
                  () {
                    final String caveat = state.healthCaveat!;
                    return Container(
                      margin: EdgeInsets.only(top: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: orangeLightColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.health_and_safety_outlined,
                            size: 16.sp,
                            color: primaryColor,
                          ),
                          8.spaceW,
                          Expanded(
                            child: caveat.appText(
                              fontSize: 12.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    );
                  }(),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TonightsPlanScreen()),
              );
            },
            child: "TONIGHT’S PLAN".appText(
              color: secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              letterSpacing: 1.0,
            ),
          ),
          16.spaceH,
          if (steps.isNotEmpty)
            for (int i = 0; i < steps.length; i++) ...[
              _buildPlanItem(context, steps[i].title, steps[i].subtitle),
              if (i < steps.length - 1) 12.spaceH,
            ]
          else ...[
            _buildPlanItem(
              context,
              "Wind-down starts",
              "About 20 minutes",
            ),
            12.spaceH,
            _buildPlanItem(
              context,
              "Book in the bedroom",
              "About 20 minutes",
            ),
            12.spaceH,
            _buildPlanItem(
              context,
              "Lights out",
              "Inside recommended window",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanItem(BuildContext context, String title, String subtitle) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TonightsPlanScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEFC),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.v2.images.imgTonightsPlan.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ).appPadding(all: 4.r),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.appText(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                  4.spaceH,
                  subtitle.appText(fontSize: 12.sp, color: Colors.grey),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
