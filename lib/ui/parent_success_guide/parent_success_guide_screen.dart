import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/parent_success_guide_cubit.dart';
import 'bloc/parent_success_guide_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/guide_profile/guide_profile_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

class ParentSuccessGuideScreen extends StatelessWidget {
  const ParentSuccessGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParentSuccessGuideCubit(),
      child: BlocBuilder<ParentSuccessGuideCubit, ParentSuccessGuideState>(
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
                                      "Your success guide is one real person who stays with you across everything here so you never have to explain your family from scratch."
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
                            _buildActiveGoalsCard(),
                            16.spaceH,
                            _buildRecommendedNextStepCard(),
                            150.spaceH,
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
      ),
    );
  }

  Widget _buildActiveGoalsCard() {
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
          InfoChip(
            chipTitle: "Active goals",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: const Color(0xFFF1EEFF), // Light purple
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          16.spaceH,
          _buildGoalRow("A consistent bedtime"),
          12.spaceH,
          _buildGoalRow("A shorter wind-down"),
          16.spaceH,
          "Set with you three weeks ago. You can change these any time."
              .appText(
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
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
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

  Widget _buildRecommendedNextStepCard() {
    return CommonInfoCard(
      chipTitle: "Recommended next step",
      title: "Finish week 2 of the Sleep Reset journey",
      subtitle: "Two tasks left the earlier nap and logging three nights.",
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
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
        decoration: BoxDecoration(color: Color(0xffFEF2EA)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: "Request a check-in",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuideProfileScreen()),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "Cancel this request".appText(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
