import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/after_reflection/after_reflection_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/calm_plan_cubit.dart';
import 'bloc/calm_plan_state.dart';

class CalmPlanScreen extends StatelessWidget {
  const CalmPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalmPlanCubit()..init(),
      child: BlocBuilder<CalmPlanCubit, CalmPlanState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400,
                    height: 400,
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
                  right: -150,
                  bottom: -150,
                  child: Container(
                    width: 400,
                    height: 400,
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
                      24.spaceH,
                      "Calm Heads-Up".appText(
                        fontSize: 32.sp,
                        color: darkBlue,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      _buildRightNowCard(),
                      16.spaceH,
                      _buildAvoidCard(),
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
                          onPressed: () {},
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
      ),
    );
  }

  Widget _buildRightNowCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          _buildStepItem(
            "1",
            "Lower stimulation now",
            "Dim the room, turn off background noise",
          ),
          16.spaceH,
          _buildStepItem(
            "2",
            "Offer a quiet, familiar activity",
            "Something she already knows well",
          ),
          16.spaceH,
          _buildStepItem(
            "3",
            "Stay close and steady",
            "Your calm is the strongest signal",
          ),
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

  Widget _buildAvoidCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          "Don't introduce a new demand right now".appText(
            fontSize: 24.sp,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          "Requests, transitions and choices can wait until she has settled."
              .appText(
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
        borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(24),
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
                "3 min Â· a voice to follow along with".appText(
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
