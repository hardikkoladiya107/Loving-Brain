import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/calm_heads_up_cubit.dart';
import 'bloc/calm_heads_up_state.dart';

class CalmHeadsUpScreen extends StatefulWidget {
  const CalmHeadsUpScreen({super.key});

  @override
  State<CalmHeadsUpScreen> createState() => _CalmHeadsUpScreenState();
}

class _CalmHeadsUpScreenState extends State<CalmHeadsUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalmHeadsUpCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalmHeadsUpCubit, CalmHeadsUpState>(
      listener: (BuildContext context, CalmHeadsUpState state) {},
      builder: (BuildContext context, CalmHeadsUpState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              // Bottom Right Glow
              Positioned(
                right: -150.w,
                bottom: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.6),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.spaceH,
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24.r),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Icon(
                                Icons.arrow_back,
                                color: darkBlue,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      24.spaceH,
                      "Calm Heads-Up".appText(
                        fontSize: 32.sp,
                        color: darkBlue,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      16.spaceH,
                      _buildConfidencePill(state),
                      24.spaceH,
                      _buildMainCard(context, state),
                      24.spaceH,
                      _buildBottomNotice(state),
                      if (state.healthCaveat != null) ...[
                        12.spaceH,
                        _buildHealthCaveat(state.healthCaveat!),
                      ],
                      32.spaceH,
                      AppButton(
                        title: "Add update",
                        onTap: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.white,
                        textColor: greyColor9,
                      ),
                      32.spaceH,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfidencePill(CalmHeadsUpState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildDot(
                state.confidenceDots >= 1
                    ? const Color(0xFF6A5AE0)
                    : const Color(0xFF6A5AE0).withValues(alpha: 0.2),
              ),
              4.spaceW,
              _buildDot(
                state.confidenceDots >= 2
                    ? const Color(0xFF6A5AE0)
                    : const Color(0xFF6A5AE0).withValues(alpha: 0.2),
              ),
              4.spaceW,
              _buildDot(
                state.confidenceDots >= 3
                    ? const Color(0xFF6A5AE0)
                    : const Color(0xFF6A5AE0).withValues(alpha: 0.2),
              ),
            ],
          ),
          8.spaceW,
          state.confidenceLabel.appText(
            color: greyColor4,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildMainCard(BuildContext context, CalmHeadsUpState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoChip(
            chipTitle: "Heads-up",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.spaceH,
                    state.headline.appText(
                      fontSize: 28.sp,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    12.spaceH,
                    state.reason.appText(
                      fontSize: 14.sp,
                      color: greyColor6,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Container(
                width: 100.w,
                height: 120.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(Assets.v2.images.imgHumi.path),
                  ),
                ),
              ),
            ],
          ),
          24.spaceH,
          AppButton(
            title: "See calm plan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalmPlanScreen(forecast: state.forecast),
                ),
              );
            },
            backgroundColor: primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNotice(CalmHeadsUpState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info, color: primaryColor, size: 16.sp),
        8.spaceW,
        Expanded(
          child: state.reason.appText(
            color: primaryColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCaveat(String caveat) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: const Color(0xFF856404),
            size: 16.sp,
          ),
          8.spaceW,
          Expanded(
            child: caveat.appText(
              fontSize: 12.sp,
              color: const Color(0xFF856404),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
