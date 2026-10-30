import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/consistency_recognition_cubit.dart';
import 'bloc/consistency_recognition_state.dart';

class ConsistencyRecognitionScreen extends StatefulWidget {
  final int? initialDaysCheckedIn;

  const ConsistencyRecognitionScreen({super.key, this.initialDaysCheckedIn});

  @override
  State<ConsistencyRecognitionScreen> createState() =>
      _ConsistencyRecognitionScreenState();
}

class _ConsistencyRecognitionScreenState
    extends State<ConsistencyRecognitionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsistencyRecognitionCubit>().init(
        initialDays: widget.initialDaysCheckedIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ConsistencyRecognitionCubit,
      ConsistencyRecognitionState
    >(
      listener: (BuildContext context, ConsistencyRecognitionState state) {},
      builder: (BuildContext context, ConsistencyRecognitionState state) {
        final String headline = state.consistencyTitle.trim().isNotEmpty
            ? state.consistencyTitle
            : (state.daysCheckedIn == 0
                  ? "Starting your family\njourney"
                  : "You've checked in ${state.daysCheckedIn}\ndays this week");
        final String subtitle = state.consistencySubtitle.trim().isNotEmpty
            ? state.consistencySubtitle
            : 'No streak to lose — we just wanted to notice the effort.';
        final String detail = state.consistencyDetail.trim().isNotEmpty
            ? state.consistencyDetail
            : (state.daysCheckedIn < 4
                  ? 'Small, regular check-ins are what let us spot patterns. After 4 days, weekly reviews appear.'
                  : "Small, regular check-ins are what let us spot patterns. Weeks where you don't manage it are fine too.");

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top glow behind image
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: 400.h,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.0,
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20.r),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: darkBlue,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          Center(
                            child: Image.asset(
                              Assets
                                  .v2
                                  .images
                                  .imgJourneyConsistencyRecognition
                                  .path,
                              width: 250.w,
                              height: 250.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          24.spaceH,
                          headline.appText(
                            fontSize: 28.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.center,
                            height: 1.2,
                          ),
                          16.spaceH,
                          subtitle.appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            textAlign: TextAlign.center,
                          ),
                          32.spaceH,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              color: softPeachOrange,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: detail.appText(
                              fontSize: 14.sp,
                              color: greyColor9,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          120.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            top: 24.h,
            bottom: 24.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                const Color(0xFFFEF8F4),
                const Color(0xFFFEF8F4),
              ],
              stops: const [0.0, 0.35, 1.0],
            ),
          ),
          child: AppButton(
            title: 'Back to Journey',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
