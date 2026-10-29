import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/guide_profile/guide_profile_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/parent_success_guide_cubit.dart';
import 'bloc/parent_success_guide_state.dart';

/// Screen 51: Parent Success Guide.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class ParentSuccessGuideScreen extends StatefulWidget {
  final String? guideId;

  const ParentSuccessGuideScreen({super.key, this.guideId});

  @override
  State<ParentSuccessGuideScreen> createState() =>
      _ParentSuccessGuideScreenState();
}

class _ParentSuccessGuideScreenState extends State<ParentSuccessGuideScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentSuccessGuideCubit>().init(guideId: widget.guideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentSuccessGuideCubit, ParentSuccessGuideState>(
      listener: (BuildContext context, ParentSuccessGuideState state) {},
      builder: (BuildContext context, ParentSuccessGuideState state) {
        final GuideProfileModel? guide = state.guide;
        if (guide == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: "This guide is no longer available.".appText(
                        fontSize: 16.sp,
                        color: greyColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
                          "Your Parent Success Guide".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Image.asset(
                                  Assets.v2.images.imgSuccessGuide.path,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              16.spaceW,
                              Expanded(
                                flex: 6,
                                child:
                                    "${guide.name} is your dedicated guide who stays with you across everything here so you never have to explain your family from scratch."
                                        .appText(
                                          fontSize: 14.sp,
                                          color: greyColor,
                                          textAlign: TextAlign.start,
                                          height: 1.4,
                                        ),
                              ),
                            ],
                          ),
                          32.spaceH,
                          if (state.pendingRequests.any(
                            (MentorshipRequestModel r) =>
                                r.status == MentorshipRequestStatus.pending,
                          )) ...[
                            _buildPendingRequestCard(
                              state.pendingRequests.firstWhere(
                                (MentorshipRequestModel r) =>
                                    r.status == MentorshipRequestStatus.pending,
                              ),
                              guide,
                            ),
                            16.spaceH,
                          ],
                          if (state.activeGoals.isNotEmpty) ...[
                            _buildActiveGoalsCard(state.activeGoals, guide),
                            16.spaceH,
                          ] else if (!state.pendingRequests.any(
                            (MentorshipRequestModel r) =>
                                r.status == MentorshipRequestStatus.pending,
                          )) ...[
                            _buildNoGoalsCard(guide),
                            16.spaceH,
                          ],
                          if (state.recommendedNextStep != null &&
                              state.recommendedNextStep!.isNotEmpty) ...[
                            CommonInfoCard(
                              chipTitle: "Recommended next step",
                              title: state.recommendedNextStep!,
                              subtitle: state.recommendedNextStepSubtitle ?? "",
                            ),
                            16.spaceH,
                          ],
                          160.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomActions(context, state, guide),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingRequestCard(
    MentorshipRequestModel request,
    GuideProfileModel guide,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: secondaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "Request pending",
            iconData: Icons.schedule,
            color: secondaryColor,
            bgColor: const Color(0xFFF1EEFF),
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          ),
          12.spaceH,
          "Session with ${guide.name}".appText(
            fontSize: 18.sp,
            color: darkBlue,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          6.spaceH,
          "Concern: ${request.mainConcern}\nPreferred: ${request.preferredDays}"
              .appText(
                fontSize: 13.sp,
                color: greyColor,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
          12.spaceH,
          "We'll notify you as soon as ${guide.name} confirms your time."
              .appText(
                fontSize: 12.sp,
                color: greyColor6,
                textAlign: TextAlign.start,
              ),
        ],
      ),
    );
  }

  Widget _buildNoGoalsCard(GuideProfileModel guide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "Get started",
            iconData: Icons.emoji_objects_outlined,
            color: primaryColor,
            bgColor: const Color(0xFFFEF0E8),
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          ),
          12.spaceH,
          "Connect with ${guide.name}".appText(
            fontSize: 18.sp,
            color: darkBlue,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          6.spaceH,
          "Once you schedule a 1-on-1 check-in, your personalized goals, agreed routine shifts, and recommended journey steps will appear here."
              .appText(
                fontSize: 13.sp,
                color: greyColor,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
        ],
      ),
    );
  }

  Widget _buildActiveGoalsCard(
    List<String> activeGoals,
    GuideProfileModel guide,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "Active goals",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: const Color(0xFFF1EEFF),
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          ),
          16.spaceH,
          ...activeGoals.map((String goal) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildGoalRow(goal),
            );
          }),
          8.spaceH,
          "Agreed with ${guide.name}. You can change these any time.".appText(
            fontSize: 14.sp,
            color: greyColor6,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalRow(String goalText) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.r),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 16.sp),
        ),
        12.spaceW,
        Expanded(
          child: goalText.appText(
            fontSize: 16.sp,
            color: greyColor9,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    ParentSuccessGuideState state,
    GuideProfileModel guide,
  ) {
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
              title: "Request a check-in",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuideProfileScreen(guideId: guide.id),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "Cancel active request".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (state.pendingRequests.isNotEmpty) {
                  final String reqId = state.pendingRequests.first.id;
                  context.read<ParentSuccessGuideCubit>().cancelRequest(reqId);
                  showSnackBar(
                    message: "Mentorship request cancelled",
                    type: SnackBarType.SUCCESS,
                  );
                } else {
                  showSnackBar(
                    message: "No active mentorship request to cancel",
                    type: SnackBarType.None,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
