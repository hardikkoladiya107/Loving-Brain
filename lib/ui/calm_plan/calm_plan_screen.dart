import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/after_reflection/after_reflection_screen.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/calm_plan_cubit.dart';
import 'bloc/calm_plan_state.dart';

class CalmPlanScreen extends StatefulWidget {
  final BehaviourForecastResult? forecast;

  const CalmPlanScreen({
    super.key,
    this.forecast,
  });

  @override
  State<CalmPlanScreen> createState() => _CalmPlanScreenState();
}

class _CalmPlanScreenState extends State<CalmPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalmPlanCubit>(
      create: (BuildContext context) => CalmPlanCubit()..init(forecast: widget.forecast),
      child: _CalmPlanView(forecast: widget.forecast),
    );
  }
}

class _CalmPlanView extends StatefulWidget {
  final BehaviourForecastResult? forecast;

  const _CalmPlanView({this.forecast});

  @override
  State<_CalmPlanView> createState() => _CalmPlanViewState();
}

class _CalmPlanViewState extends State<_CalmPlanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalmPlanCubit>().init(forecast: widget.forecast);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalmPlanCubit, CalmPlanState>(
      listener: (BuildContext context, CalmPlanState state) {},
      builder: (BuildContext context, CalmPlanState state) {
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
                    "Calm Heads-Up".appText(
                      fontSize: 32.sp,
                      color: darkBlue,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    24.spaceH,
                    _buildRightNowCard(state),
                    16.spaceH,
                    _buildAvoidCard(state),
                    16.spaceH,
                    _buildAudioCard(context, state),
                    24.spaceH,
                    AppButton(
                      title: "Tell us what happened",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AfterReflectionScreen(),
                          ),
                        );
                      },
                      backgroundColor: primaryColor,
                      textColor: Colors.white,
                    ),
                    16.spaceH,
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BrainyConversationScreen(
                                topic: 'Calm Plan',
                                initialChat:
                                    'Can you help me with a calming plan for my child during a hard moment?',
                              ),
                            ),
                          );
                        },
                        child: "Ask Brainy".appText(
                          fontSize: 16.sp,
                          color: greyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    100.spaceH,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightNowCard(CalmPlanState state) {
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
            chipTitle: "Right now",
            iconData: Icons.info,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          24.spaceH,
          for (int i = 0; i < state.actions.length; i++) ...[
            _buildStepItem(
              state.actions[i].stepNumber,
              state.actions[i].title,
              state.actions[i].description,
            ),
            if (i < state.actions.length - 1) 16.spaceH,
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: const BoxDecoration(
            color: indigoLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: number.appText(
            color: secondaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        12.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.appText(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: greyColor9,
              ),
              4.spaceH,
              subtitle.appText(
                fontSize: 13.sp,
                color: greyColor10,
                textAlign: TextAlign.start,
                height: 1.3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvoidCard(CalmPlanState state) {
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
            chipTitle: "One thing to avoid",
            iconData: Icons.cancel,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          state.avoidInstructionTitle.appText(
            fontSize: 24.sp,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          state.avoidInstructionSubtitle.appText(
            fontSize: 14.sp,
            color: greyColor,
            height: 1.5,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard(BuildContext context, CalmPlanState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24.r),
                onTap: () => context.read<CalmPlanCubit>().toggleAudio(),
                child: SizedBox(
                  width: 48.w,
                  height: 48.w,
                  child: Icon(
                    state.isAudioPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Calm audio guide".appText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                4.spaceH,
                "3 min · a voice to follow along with".appText(
                  fontSize: 13.sp,
                  color: greyColor4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
