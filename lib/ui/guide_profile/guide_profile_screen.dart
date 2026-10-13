import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';
import 'package:loving_brain/ui/programme_detail/programme_detail_screen.dart';
import 'package:loving_brain/ui/request_session/request_session_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/guide_profile_cubit.dart';
import 'bloc/guide_profile_state.dart';

/// Screen 46: Guide Profile.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class GuideProfileScreen extends StatefulWidget {
  final String? guideId;
  final String? supportArea;

  const GuideProfileScreen({
    super.key,
    this.guideId,
    this.supportArea,
  });

  @override
  State<GuideProfileScreen> createState() => _GuideProfileScreenState();
}

class _GuideProfileScreenState extends State<GuideProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuideProfileCubit>().init(
            guideId: widget.guideId,
            supportArea: widget.supportArea,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuideProfileCubit, GuideProfileState>(
      listener: (BuildContext context, GuideProfileState state) {},
      builder: (BuildContext context, GuideProfileState state) {
        final GuideProfileModel guide =
            state.guide ?? MentorshipRepo.defaultGuides.first;

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top glow
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
              // Bottom Right Glow
              Positioned(
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.h,
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
                          onTap: () => Navigator.pop(context),
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
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          "Guide profile".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.center,
                          ),
                          32.spaceH,
                          Center(
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4DD0E1), // Teal
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 80.sp,
                                  color: Colors.white,
                                Perp: null,
                                ),
                              ),
                            ),
                          ),
                          16.spaceH,
                          guide.name.appText(
                            fontSize: 24.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.center,
                          ),
                          8.spaceH,
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: const Color(0xFF43A047),
                                    size: 16.sp,
                                  ),
                                  6.spaceW,
                                  "Verified guide".appText(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF43A047),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          24.spaceH,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            alignment: WrapAlignment.center,
                            children: [
                              ...guide.languages.map((String lang) => _buildTag(lang)),
                              ...guide.supportAreas.map((String area) => _buildTag(area)),
                            ],
                          ),
                          32.spaceH,
                          _buildHowWorksCard(guide),
                          16.spaceH,
                          _buildEstimateCard(guide),
                          140.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context, guide),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: greyColor.withValues(alpha: 0.2)),
      ),
      child: text.appText(fontSize: 14.sp, color: greyColor9),
    );
  }

  Widget _buildHowWorksCard(GuideProfileModel guide) {
    return CommonInfoCard(
      chipTitle: "How ${guide.name.split(' ').first} works",
      subtitle: guide.bio,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
    );
  }

  Widget _buildEstimateCard(GuideProfileModel guide) {
    return CommonInfoCard(
      chipTitle: "Estimate — confirmed at booking",
      title: "Sessions run about ${guide.sessionDurationMinutes} minutes",
      chipColor: const Color(0xFF9E9E9E),
      chipBgColor: const Color(0xFFF5F5F5),
    );
  }

  Widget _buildBottomActions(BuildContext context, GuideProfileModel guide) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 24.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: const BoxDecoration(color: Color(0xFFFEF2EA)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Request a session",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RequestSessionScreen(guide: guide),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "View the Sleep Reset programme".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProgrammeDetailScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
