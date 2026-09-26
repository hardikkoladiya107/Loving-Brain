import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/programme_detail_cubit.dart';
import 'bloc/programme_detail_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/parent_success_guide/parent_success_guide_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

class ProgrammeDetailScreen extends StatelessWidget {
  const ProgrammeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgrammeDetailCubit(),
      child: BlocBuilder<ProgrammeDetailCubit, ProgrammeDetailState>(
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
                            "6-Week Sleep Journey".appText(
                              fontSize: 28.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            8.spaceH,
                            "Structured support with a real person, over a few weeks."
                                .appText(
                                  fontSize: 16.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                ),
                            24.spaceH,

                            24.spaceH,
                            CommonInfoCard(
                              chipTitle: "Who it's for",
                              title:
                                  "Parents facing two or more weeks of inconsistent sleep",
                              subtitle:
                                  "If things have only been off for a few nights, the app alone is usually enough.",
                            ),
                            16.spaceH,
                            CommonInfoCard(
                              chipTitle: "Expected outcome",
                              title:
                                  "Designed to support a more predictable bedtime routine over six weeks",
                              subtitle:
                                  "Every family is different, so we can't promise a specific result.",
                            ),
                            16.spaceH,
                            CommonInfoCard(
                              chipTitle: "Duration & sessions",
                              title:
                                  "6 weeks of guidance with up to 3 video sessions",
                              subtitle:
                                  "Weekly check-ins and direct messaging included.",
                            ),
                            120.spaceH,
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
              title: "View available guides",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentSuccessGuideScreen(),
                  ),
                );
              },
            ),
            16.spaceH,
            BaseButton(
              child: "Ask Brainy whether this fits".appText(
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
