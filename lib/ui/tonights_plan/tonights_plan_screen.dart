import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/tonights_plan_cubit.dart';
import 'bloc/tonights_plan_state.dart';

/// Screen 25 — Tonight's Plan view.
class TonightsPlanScreen extends StatefulWidget {
  const TonightsPlanScreen({super.key});

  @override
  State<TonightsPlanScreen> createState() => _TonightsPlanScreenState();
}

class _TonightsPlanScreenState extends State<TonightsPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TonightsPlanCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TonightsPlanCubit, TonightsPlanState>(
      listener: (BuildContext context, TonightsPlanState state) {},
      builder: (BuildContext context, TonightsPlanState state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: const Color(0xFFFEF8F4),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildHeader(context),
                      16.spaceH,
                      _buildTimelineCard(state),
                      16.spaceH,
                      _buildInfoCard(state),
                      16.spaceH,
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: state.isPlanStarted ? "Stop plan" : "Start plan",
                        onTap: () =>
                            context.read<TonightsPlanCubit>().startPlan(),
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        padding: EdgeInsetsGeometry.zero,
                      ),
                    ),
                    12.spaceW,
                    Expanded(
                      child: AppButton(
                        title: state.isAudioPlaying
                            ? "Pause audio"
                            : "Play audio",
                        onTap: () =>
                            context.read<TonightsPlanCubit>().toggleAudio(),
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        padding: EdgeInsetsGeometry.zero,
                      ),
                    ),
                  ],
                ).appPadding(all: 16.w),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 350.h,
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
          bottom: 16.h,
          right: 16.w,
          child: Container(
            height: 150.h,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(Assets.v2.images.imgNoriTonightsPlan.path),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top > 0
              ? MediaQuery.of(context).padding.top + 6.h
              : 20.h,
          left: 20.w,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: darkBlue, size: 24.sp),
            ),
          ),
        ),
        Positioned(
          bottom: 20.h,
          left: 20.w,
          child: "Tonight's plan".appText(
            fontSize: 28.sp,
            color: Colors.white,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
        ),
        SafeArea(bottom: false, child: 160.spaceH),
      ],
    );
  }

  Widget _buildTimelineCard(TonightsPlanState state) {
    final List<TonightPlanStep> steps = state.planSteps;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(
            chipTitle: "About 50 minutes",
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          24.spaceH,
          if (steps.isNotEmpty)
            for (int i = 0; i < steps.length; i++)
              _buildTimelineItem(
                time: steps[i].timeLabel,
                title: steps[i].title,
                subtitle: steps[i].subtitle,
                isFirst: i == 0,
                isLast: i == steps.length - 1,
              )
          else ...[
            _buildTimelineItem(
              time: "07:20 PM",
              title: "Wind-down starts",
              subtitle: "Lights lower, no screens",
              isFirst: true,
            ),
            _buildTimelineItem(
              time: "07:30 PM",
              title: "Bath",
              subtitle: "Keep it short tonight",
            ),
            _buildTimelineItem(
              time: "07:50 PM",
              title: "Book in the bedroom",
              subtitle: "The same two books is fine",
            ),
            _buildTimelineItem(
              time: "${state.windowStart} - ${state.windowEnd}",
              title: "Sleep window",
              subtitle: "Lights out inside this range",
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: const Color(0xFFFFF0E5)),
                ),
            ],
          ),
          16.spaceW,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      "$time — ".appText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: title.appText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  4.spaceH,
                  subtitle
                      .replaceAll('$time - ', '')
                      .appText(
                        fontSize: 12.sp,
                        color: greyColor4,
                        textAlign: TextAlign.start,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(TonightsPlanState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "If ${state.childName} resists",
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          "Wait five minutes before responding".appText(
            fontSize: 20.sp,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
          12.spaceH,
          "Keep the room dark and your voice low. Resistance at the start of a schedule is normal."
              .appText(
                fontSize: 14.sp,
                color: greyColor,
                textAlign: TextAlign.start,
              ),
        ],
      ),
    );
  }
}
