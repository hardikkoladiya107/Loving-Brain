import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/child_essentials/child_essentials_screen.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/common_info_card.dart';

import 'bloc/shared_child_summary_cubit.dart';
import 'bloc/shared_child_summary_state.dart';

class SharedChildSummaryScreen extends StatelessWidget {
  const SharedChildSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SharedChildSummaryCubit()..init(),
      child: BlocBuilder<SharedChildSummaryCubit, SharedChildSummaryState>(
        builder: (context, state) {
          final childName = context.read<SharedChildSummaryCubit>().childName;
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChildEssentialsScreen(),
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
                                  borderRadius: BorderRadius.circular(20),
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
                            "Shared with Ravi".appText(
                              fontSize: 32.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            8.spaceH,
                            "You're both seeing the same picture of $childName's week."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                  textAlign: TextAlign.start,
                                ),
                            24.spaceH,
                            _buildTodaysPlanCard(),
                            24.spaceH,
                            "RECENT UPDATES".appText(
                              fontSize: 16.sp,
                              color: greyColor11,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.start,
                            ),
                            12.spaceH,
                            _buildUpdatesCard(),
                            16.spaceH,
                            _buildWhatWereTryingCard(),
                            16.spaceH,
                            _buildInfoCard(),
                            120.spaceH,
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
      ),
    );
  }

  Widget _buildTodaysPlanCard() {
    return CommonInfoCard(
      chipTitle: 'Today’s plan',
      chipIcon: Icons.stars_rounded,
      chipColor: primaryColor,
      chipBgColor: orangeLightColor,
      title: 'Wind-down at 7:30 PM',
      titleFontSize: 20.sp,
      subtitle: 'Sleep window 7:45 – 8:15 PM.',
    );
  }

  Widget _buildUpdatesCard() {
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
          "Two sleep updates today".appText(
            fontSize: 22.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
          ),
          16.spaceH,
          _buildLogItem(
            isRavi: true,
            text: "Ravi",
            subText: " logged a nap · 3h ago",
          ),
          12.spaceH,
          _buildLogItem(
            isRavi: false,
            text: "You",
            subText: " logged bedtime · yesterday",
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem({
    required bool isRavi,
    required String text,
    required String subText,
  }) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: isRavi ? greyColor9 : const Color(0xFFA0A0A0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.person, size: 16.sp, color: Colors.white),
          ),
        ),
        8.spaceW,
        RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 14.sp,
              color: greyColor9,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
            children: [
              TextSpan(
                text: subText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFA0A0A0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatWereTryingCard() {
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
            chipTitle: "What we're trying",
            iconData: Icons.stars,
            color: secondaryColor,
            bgColor: Color(0xFFF1EEFF),
          ),
          16.spaceH,
          "An earlier, shorter afternoon nap".appText(
            fontSize: 24.sp,
            color: greyColor9,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          12.spaceH,
          "Day 3 of 7 · started by you on Tuesday.".appText(
            fontSize: 14.sp,
            color: greyColor6,
            textAlign: TextAlign.start,
          ),
          16.spaceH,
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: greyColor.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(secondaryColor),
            minHeight: 6.h,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: softPeachOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: greyColor9, size: 20.sp),
              8.spaceW,
              "What Ravi can see".appText(
                fontSize: 14.sp,
                color: greyColor9,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          8.spaceH,
          "Sleep, behaviour and plans. Health notes and mentorship summaries stay private unless you share them."
              .appText(
                fontSize: 14.sp,
                color: greyColor9,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
        ],
      ),
    );
  }
}
