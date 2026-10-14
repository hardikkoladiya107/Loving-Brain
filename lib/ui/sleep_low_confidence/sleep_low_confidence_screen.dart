import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

import 'bloc/sleep_low_confidence_cubit.dart';
import 'bloc/sleep_low_confidence_state.dart';

/// Screen 69: Low Confidence Sleep Window.
/// Conforms to AGENTS.md §5.1, §6.1, and §6.3.
class SleepLowConfidenceScreen extends StatefulWidget {
  const SleepLowConfidenceScreen({super.key});

  @override
  State<SleepLowConfidenceScreen> createState() =>
      _SleepLowConfidenceScreenState();
}

class _SleepLowConfidenceScreenState extends State<SleepLowConfidenceScreen> {
  late final SleepLowConfidenceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SleepLowConfidenceCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<SleepLowConfidenceCubit, SleepLowConfidenceState>(
        bloc: _cubit,
        listener: (BuildContext context, SleepLowConfidenceState state) {},
        builder: (BuildContext context, SleepLowConfidenceState state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: darkBlue,
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFFEF8F4),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const BackButton(color: Color(0xFF1E293B)),
                title: "Sleep".appText(
                  color: const Color(0xFF1E293B),
                  fontSize: 28.sp,
                  fraunces: true,
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        16.spaceH,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8.sp,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                                  4.spaceW,
                                  Icon(
                                    Icons.circle,
                                    size: 8.sp,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                                  4.spaceW,
                                  Icon(
                                    Icons.circle,
                                    size: 8.sp,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ],
                              ),
                              8.spaceW,
                              "Confidence: ${state.confidence}".appText(
                                fontSize: 14.sp,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        24.spaceH,
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InfoBox(
                                body: Assets.v2.icons.icFaqs.path,
                                title: "Next window",
                                backgroundColor: const Color(0xFFF1F5F9),
                                textColor: const Color(0xFF64748B),
                                iconColor: const Color(0xFF64748B),
                              ),
                              16.spaceH,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    Assets.v2.images.imgSprout.path,
                                    width: 120.w,
                                    height: 120.w,
                                    fit: BoxFit.contain,
                                  ),
                                  16.spaceW,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        state.windowTimeRange.appText(
                                          fontSize: 24.sp,
                                          color: const Color(0xFF1E293B),
                                          fraunces: true,
                                          height: 1.2,
                                        ),
                                        8.spaceH,
                                        state.explanation.appText(
                                          fontSize: 14.sp,
                                          color: const Color(0xFF64748B),
                                          height: 1.4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.spaceH,
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const InfoBox(
                                title: "Still learning this pattern",
                                body:
                                    "A few more updates will sharpen this estimate. Around ten nights is usually enough.",
                                backgroundColor: Color(0xFFF1F5F9),
                                textColor: Color(0xFF64748B),
                                iconColor: Color(0xFF64748B),
                              ),
                              24.spaceH,
                              "Based on ${state.nightsCount} nights so far"
                                  .appText(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF1E293B),
                                    fraunces: true,
                                  ),
                              8.spaceH,
                              "A few more updates will sharpen this estimate. Around ten nights is usually enough."
                                  .appText(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                            ],
                          ),
                        ),
                        16.spaceH,
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child:
                              "We'd rather show a wide window honestly than a precise time we can't stand behind."
                                  .appText(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF1E293B),
                                    height: 1.4,
                                  ),
                        ),
                        120.spaceH,
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFFFEF8F4),
                            const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      child: AppButton(
                        title: "Add tonight's update",
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
