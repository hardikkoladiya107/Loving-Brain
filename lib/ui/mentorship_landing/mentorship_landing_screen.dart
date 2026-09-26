import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/choose_support_area/choose_support_area_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/enrolled_journey_home/enrolled_journey_home_screen.dart';

import 'bloc/mentorship_landing_cubit.dart';
import 'bloc/mentorship_landing_state.dart';

class MentorshipLandingScreen extends StatelessWidget {
  const MentorshipLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MentorshipLandingCubit(),
      child: BlocBuilder<MentorshipLandingCubit, MentorshipLandingState>(
        builder: (context, state) {
          if (!state.isAvailable) {
            return _buildUnavailableScaffold(context);
          }
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
                  bottom: 0,
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
                SafeArea(
                  bottom: false,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      16.spaceH,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: darkBlue,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      24.spaceH,
                      GestureDetector(
                        onTap: () {
                          context
                              .read<MentorshipLandingCubit>()
                              .toggleAvailability();
                        },
                        child: "Guided mentorship".appText(
                          fontSize: 28.sp,
                          color: greyColor9,
                          fraunces: true,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      8.spaceH,
                      "Talk to our expert mentors who are deeply trained on LovingBrain methodologies and child psychology."
                          .appText(
                            fontSize: 16.sp,
                            color: greyColor9,
                            textAlign: TextAlign.start,
                            height: 1.4,
                          ),
                      24.spaceH,
                      _buildMainMentorshipCard(context),
                      24.spaceH,
                      "MORE GUIDANCE OPTIONS".appText(
                        fontSize: 12.sp,
                        color: secondaryColor,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                      16.spaceH,

                      SizedBox(
                        height:
                            210.h - (MediaQuery.of(context).size.width * 0.1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildGridCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const EnrolledJourneyHomeScreen(),
                                    ),
                                  );
                                },
                                iconPath: Assets
                                    .v2
                                    .images
                                    .imgGuidedMentorshipSleepReset
                                    .path,
                                title: "Sleep Reset",
                                subtitle: "For returning back to better sleep",
                                isSelected: false,
                              ),
                            ),
                            16.spaceW,
                            Expanded(
                              child: _buildGridCard(
                                iconPath: Assets
                                    .v2
                                    .images
                                    .imgGuidedMentorshipTantrumUnderstanding
                                    .path,
                                title: "Tantrum Understanding",
                                subtitle:
                                    "For big feelings that keep repeating",
                                isSelected: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.spaceH,
                      SizedBox(
                        height:
                            220.h - (MediaQuery.of(context).size.width * 0.1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildGridCard(
                                iconPath: Assets
                                    .v2
                                    .images
                                    .imgGuidedMentorshipParentCalm
                                    .path,
                                title: "Parent Calm & Confidence",
                                subtitle:
                                    "Support for you, not just your child",
                                isSelected: false,
                              ),
                            ),
                            16.spaceW,
                            Expanded(
                              child: _buildGridCard(
                                iconPath: Assets
                                    .v2
                                    .images
                                    .imgGuidedMentorshipParentingSupport
                                    .path,
                                title: "Co-parenting Support",
                                subtitle: "Getting on the same page together",
                                isSelected: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      120.spaceH,
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

  Widget _buildMainMentorshipCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChooseSupportAreaScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoChip(
                        chipTitle: "Popular",
                        iconData: Icons.star,
                        color: Color(0xFFF5A623),
                        bgColor: Color(0xFFFFF7EB),
                      ),
                      12.spaceH,
                      "Parenting Support & Troubleshooting".appText(
                        fontSize: 22.sp,
                        color: darkBlue,
                        fraunces: true,
                        textAlign: TextAlign.start,
                        height: 1.2,
                      ),
                      8.spaceH,
                      "A single session or short series to tackle a specific challenge like nap transitions, ongoing tantrums, or adjusting to childcare."
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            textAlign: TextAlign.start,
                            height: 1.4,
                          ),
                    ],
                  ),
                ),
                16.spaceW,
                Image.asset(
                  Assets.v2.images.imgGuidedMentorshipHumanSupport.path,
                  width: 90.w,
                  height: 90.w,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard({
    VoidCallback? onTap,
    required String iconPath,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            16.spaceH,
            title.appText(
              fontSize: 16.sp,
              color: greyColor9,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
            8.spaceH,
            Expanded(
              child: subtitle.appText(
                fontSize: 12.sp,
                color: greyColor,
                textAlign: TextAlign.start,

                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wraps MentorshipUnavailableScreen into a scaffold with a toggle back button for testing
  Widget _buildUnavailableScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          const MentorshipUnavailableScreen(),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  context.read<MentorshipLandingCubit>().toggleAvailability();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.transparent,
                  child: "Tap here to toggle available".appText(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
