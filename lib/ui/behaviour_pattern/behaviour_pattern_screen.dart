import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/calm_plan/calm_plan_screen.dart';
import 'package:loving_brain/ui/mentorship_landing/mentorship_landing_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/behaviour_pattern_cubit.dart';
import 'bloc/behaviour_pattern_state.dart';

class BehaviourPatternScreen extends StatefulWidget {
  const BehaviourPatternScreen({super.key});

  @override
  State<BehaviourPatternScreen> createState() => _BehaviourPatternScreenState();
}

class _BehaviourPatternScreenState extends State<BehaviourPatternScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BehaviourPatternCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BehaviourPatternCubit, BehaviourPatternState>(
      listener: (BuildContext context, BehaviourPatternState state) {},
      builder: (BuildContext context, BehaviourPatternState state) {
        final String triggersText = state.topTriggers.isNotEmpty
            ? state.topTriggers.join(', ')
            : 'Still learning triggers';
        final String helpedText = state.topHelpedStrategies.isNotEmpty
            ? state.topHelpedStrategies.join(', ')
            : 'Still learning what helps';

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
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    16.spaceH,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
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
                    24.spaceH,
                    "Behaviour pattern".appText(
                      fontSize: 32.sp,
                      color: darkBlue,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    24.spaceH,
                    _buildCommonTimesCard(state),
                    16.spaceH,
                    _buildInfoCard(
                      "Possible triggers",
                      Icons.info,
                      triggersText,
                      "Often two of these together rather than one alone.",
                    ),
                    16.spaceH,
                    _buildInfoCard(
                      "What has helped",
                      Icons.stars_rounded,
                      helpedText,
                      state.insightText,
                    ),
                    200.spaceH,
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 12.h,
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  color: const Color(0xFFFEF2EA),
                  child: Column(
                    children: [
                      AppButton(
                        title: "Try this plan",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalmPlanScreen(),
                            ),
                          );
                        },
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                      ),
                      16.spaceH,
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MentorshipLandingScreen(),
                            ),
                          );
                        },
                        child: "View mentorship".appText(
                          fontSize: 16.sp,
                          color: greyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _buildCommonTimesCard(BehaviourPatternState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.w,
            height: 140.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(Assets.v2.images.imgHumi.path),
              ),
            ),
          ),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoChip(
                  chipTitle: "Common times",
                  iconData: Icons.info,
                  color: primaryColor,
                  bgColor: orangeLightColor,
                ),
                16.spaceH,
                "Most often around ${state.mostCommonTimeWindow}".appText(
                  fontSize: 22.sp,
                  fraunces: true,
                  textAlign: TextAlign.start,
                  color: greyColor9,
                ),
                12.spaceH,
                "${state.totalTantrums} logged moments analyzed for ${state.childName}."
                    .appText(
                      fontSize: 12.sp,
                      color: greyColor6,
                      textAlign: TextAlign.start,
                      height: 1.4,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String chipTitle,
    IconData icon,
    String title,
    String subtitle,
  ) {
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
          InfoChip(
            chipTitle: chipTitle,
            iconData: icon,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          title.appText(
            fontSize: 22.sp,
            fraunces: true,
            textAlign: TextAlign.start,
            color: greyColor9,
          ),
          8.spaceH,
          subtitle.appText(
            fontSize: 14.sp,
            color: greyColor6,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
