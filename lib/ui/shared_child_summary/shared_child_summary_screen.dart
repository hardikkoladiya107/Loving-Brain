import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
import 'package:loving_brain/ui/family_menu/family_menu_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/shared_child_summary_cubit.dart';
import 'bloc/shared_child_summary_state.dart';

/// Screen 52: Shared Child Summary / Handover View.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class SharedChildSummaryScreen extends StatefulWidget {
  const SharedChildSummaryScreen({super.key});

  @override
  State<SharedChildSummaryScreen> createState() =>
      _SharedChildSummaryScreenState();
}

class _SharedChildSummaryScreenState extends State<SharedChildSummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedChildSummaryCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedChildSummaryCubit, SharedChildSummaryState>(
      listener: (BuildContext context, SharedChildSummaryState state) {},
      builder: (BuildContext context, SharedChildSummaryState state) {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FamilyMenuScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: "Manage access".appText(
                                fontSize: 14.sp,
                                color: greyColor9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          "Shared with ${state.partnerName}".appText(
                            fontSize: 32.sp,
                            color: greyColor9,
                            fraunces: true,
                            textAlign: TextAlign.start,
                          ),
                          8.spaceH,
                          "You're both seeing the same picture of ${state.childName}'s week."
                              .appText(
                                fontSize: 14.sp,
                                color: greyColor,
                                textAlign: TextAlign.start,
                              ),
                          24.spaceH,
                          _buildTodaysPlanCard(state),
                          24.spaceH,
                          "RECENT UPDATES".appText(
                            fontSize: 16.sp,
                            color: greyColor11,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.start,
                          ),
                          12.spaceH,
                          _buildUpdatesCard(state),
                          16.spaceH,
                          _buildWhatWereTryingCard(state),
                          16.spaceH,
                          _buildInfoCard(state),
                          140.spaceH,
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
    );
  }

  Widget _buildTodaysPlanCard(SharedChildSummaryState state) {
    return CommonInfoCard(
      chipTitle: 'Today’s plan',
      chipIcon: Icons.stars_rounded,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: state.todaysPlanTitle,
      titleFontSize: 20.sp,
      subtitle: state.todaysPlanSubtitle,
    );
  }

  Widget _buildUpdatesCard(SharedChildSummaryState state) {
    if (state.recentUpdates.isEmpty) {
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
            "No updates yet today".appText(
              fontSize: 22.sp,
              color: greyColor9,
              fraunces: true,
              textAlign: TextAlign.start,
            ),
            8.spaceH,
            "When either parent logs sleep or bedtime, updates will appear here."
                .appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
          ],
        ),
      );
    }

    final int count = state.recentUpdates.length;
    final String updateTitle = count == 1
        ? "One sleep update today"
        : "$count sleep updates today";

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
          updateTitle.appText(
            fontSize: 22.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
          16.spaceH,
          ...state.recentUpdates.map((HandoverLogItem item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildLogItem(
                authorName: item.authorName,
                isPartner: item.isPartner,
                actionDescription: item.actionDescription,
                timeAgo: item.timeAgo,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLogItem({
    required String authorName,
    required bool isPartner,
    required String actionDescription,
    required String timeAgo,
  }) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: isPartner ? const Color(0xFFFDC21A) : primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              isPartner ? Icons.face : Icons.person,
              size: 20.sp,
              color: Colors.white,
            ),
          ),
        ),
        12.spaceW,
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14.sp,
                color: greyColor9,
              ),
              children: [
                TextSpan(
                  text: authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " $actionDescription · "),
                TextSpan(
                  text: timeAgo,
                  style: TextStyle(color: greyColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatWereTryingCard(SharedChildSummaryState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEFF),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: "What you’re trying together",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: Colors.white,
          ),
          16.spaceH,
          state.activeWeeklyFocus.appText(
            fontSize: 18.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(SharedChildSummaryState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: softPeachOrange,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: state.handoverNote.appText(
        fontSize: 14.sp,
        color: greyColor9,
        textAlign: TextAlign.start,
        height: 1.4,
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            top: 32.h,
            bottom: 32.h,
            left: 20.w,
            right: 20.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFEF8F4).withValues(alpha: 0.0),
                const Color(0xFFFEF8F4),
                const Color(0xFFFEF8F4),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: AppButton(
            title: "View child essentials",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChildEssentialsScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
