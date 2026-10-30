import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/choose_support_area/choose_support_area_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/programme_detail/programme_detail_screen.dart';

import 'bloc/mentorship_landing_cubit.dart';
import 'bloc/mentorship_landing_state.dart';

/// Screen 43: Guided Mentorship Landing.
/// Conforms to AGENTS.md §5 (StatefulWidget + BlocConsumer wrapping Scaffold).
class MentorshipLandingScreen extends StatefulWidget {
  const MentorshipLandingScreen({super.key});

  @override
  State<MentorshipLandingScreen> createState() =>
      _MentorshipLandingScreenState();
}

class _MentorshipLandingScreenState extends State<MentorshipLandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentorshipLandingCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MentorshipLandingCubit, MentorshipLandingState>(
      listener: (BuildContext context, MentorshipLandingState state) {},
      builder: (BuildContext context, MentorshipLandingState state) {
        if (!state.isAvailable) {
          return _buildUnavailableScaffold(context);
        }
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Color(0xFFFEF8F4),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150.r,
                  top: -150.r,
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
                  right: -150.r,
                  bottom: 0,
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
                              borderRadius: BorderRadius.circular(24.r),
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
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
                      ),
                      24.spaceH,
                      "Guided mentorship".appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "Talk to our expert mentors who are deeply trained on Loving Brain methodologies and child psychology."
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
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildGridCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ProgrammeDetailScreen(),
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ChooseSupportAreaScreen(
                                            initialArea: 'Behaviour',
                                          ),
                                    ),
                                  );
                                },
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
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildGridCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ChooseSupportAreaScreen(
                                            initialArea: 'Parent Wellbeing',
                                          ),
                                    ),
                                  );
                                },
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ChooseSupportAreaScreen(
                                            initialArea: 'Co-parenting',
                                          ),
                                    ),
                                  );
                                },
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
          ),
        );
      },
    );
  }

  Widget _buildMainMentorshipCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const ChooseSupportAreaScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoChip(
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
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1.5.w,
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
                borderRadius: BorderRadius.circular(12.r),
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
              fontSize: 15.sp,
              color: greyColor9,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            8.spaceH,
            subtitle.appText(
              fontSize: 12.sp,
              color: greyColor,
              textAlign: TextAlign.start,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableScaffold(BuildContext context) {
    return Stack(
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
                padding: EdgeInsets.all(8.r),
                color: Colors.transparent,
                child: "Tap here to toggle available".appText(
                  color: Colors.grey,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
