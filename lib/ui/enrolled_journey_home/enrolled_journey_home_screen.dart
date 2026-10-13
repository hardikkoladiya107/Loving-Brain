import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/post_session_plan/post_session_plan_screen.dart';
import 'package:loving_brain/ui/request_session/request_session_screen.dart';

import 'bloc/enrolled_journey_home_cubit.dart';
import 'bloc/enrolled_journey_home_state.dart';

/// Screen 49: Enrolled Sleep Reset Journey.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class EnrolledJourneyHomeScreen extends StatefulWidget {
  const EnrolledJourneyHomeScreen({super.key});

  @override
  State<EnrolledJourneyHomeScreen> createState() =>
      _EnrolledJourneyHomeScreenState();
}

class _EnrolledJourneyHomeScreenState extends State<EnrolledJourneyHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnrolledJourneyHomeCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnrolledJourneyHomeCubit, EnrolledJourneyHomeState>(
      listener: (BuildContext context, EnrolledJourneyHomeState state) {},
      builder: (BuildContext context, EnrolledJourneyHomeState state) {
        final EnrolledProgramModel program =
            state.program ??
            const EnrolledProgramModel(
              id: 'prog_default',
              title: 'Sleep Reset journey',
              guideName: 'Priya S.',
              currentWeek: 2,
              totalWeeks: 6,
              currentFocus: 'Try the earlier nap, and log three nights',
              recentQuote:
                  "Great first week keep the nap timing steady and don't worry about the odd late night.",
              quoteAuthorAndTime: 'Priya S. · 2 days ago',
              recordedModuleTitle: 'Understanding over tiredness',
              recordedModuleDuration: '12 min',
            );

        final double progress = (program.totalWeeks > 0)
            ? (program.currentWeek / program.totalWeeks).clamp(0.0, 1.0)
            : 0.33;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
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
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          program.title.appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          24.spaceH,
                          _buildProgressCard(program, progress),
                          16.spaceH,
                          _buildActionRow(
                            iconPath: Assets.v2.icons.icNextSession.path,
                            iconBgColor: orangeLightColor,
                            iconColor: primaryColor,
                            title: "Next session",
                            subtitle:
                                "Confirmed with ${program.guideName}. Details sent by email.",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RequestSessionScreen(),
                                ),
                              );
                            },
                          ),
                          16.spaceH,
                          _buildActionRow(
                            iconData: Icons.check_circle_outline,
                            iconBgColor: const Color(0xFFF1EEFF),
                            iconColor: secondaryColor,
                            title: "Post-session plan",
                            subtitle:
                                "Action items agreed with ${program.guideName}",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PostSessionPlanScreen(),
                                ),
                              );
                            },
                          ),
                          16.spaceH,
                          _buildActionRow(
                            iconData: Icons.play_arrow_rounded,
                            iconBgColor: const Color(0xFFFCE4EC),
                            iconColor: const Color(0xFFE91E63),
                            title: program.recordedModuleTitle,
                            subtitle:
                                "Recorded module · ${program.recordedModuleDuration}",
                            onTap: () {
                              context
                                  .read<EnrolledJourneyHomeCubit>()
                                  .toggleModuleCompleted();
                            },
                          ),
                          16.spaceH,
                          _buildQuoteCard(program),
                          140.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(EnrolledProgramModel program, double progress) {
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
            chipTitle: "One small thing to try",
            iconData: Icons.stars,
            color: primaryColor,
            bgColor: orangeLightColor,
          ),
          16.spaceH,
          program.currentFocus.appText(
            fontSize: 20.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          24.spaceH,
          LinearProgressIndicator(
            value: progress,
            backgroundColor: greyColor.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(secondaryColor),
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          8.spaceH,
          "Week ${program.currentWeek} of ${program.totalWeeks}".appText(
            fontSize: 12.sp,
            color: greyColor,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    IconData? iconData,
    String? iconPath,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: primaryColor.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: iconPath != null
                    ? Image.asset(
                        iconPath,
                        width: 30.sp,
                        height: 30.sp,
                        fit: BoxFit.contain,
                      )
                    : Icon(iconData, color: iconColor, size: 30.sp),
              ),
            ),
            16.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.appText(
                    fontSize: 16.sp,
                    color: greyColor9,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  subtitle.appText(
                    fontSize: 14.sp,
                    color: greyColor11,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            8.spaceW,
            Icon(Icons.chevron_right, color: greyColor, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(EnrolledProgramModel program) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: indigoLight,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "\"${program.recentQuote}\"".appText(
            fontSize: 18.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
          16.spaceH,
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCC80),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.person, size: 16.sp, color: Colors.white),
                ),
              ),
              8.spaceW,
              program.quoteAuthorAndTime.appText(
                fontSize: 14.sp,
                color: greyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
