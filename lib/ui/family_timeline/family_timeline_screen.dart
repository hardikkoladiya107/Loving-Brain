import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/family_timeline_cubit.dart';
import 'bloc/family_timeline_state.dart';

class FamilyTimelineScreen extends StatefulWidget {
  const FamilyTimelineScreen({super.key});

  @override
  State<FamilyTimelineScreen> createState() => _FamilyTimelineScreenState();
}

class _FamilyTimelineScreenState extends State<FamilyTimelineScreen> {
  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FamilyTimelineCubit()..init(),
      child: BlocBuilder<FamilyTimelineCubit, FamilyTimelineState>(
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
                      "Family timeline".appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip("All"),
                            8.spaceW,
                            _buildFilterChip("Sleep"),
                            8.spaceW,
                            _buildFilterChip("Behaviour"),
                            8.spaceW,
                            _buildFilterChip("Mentorship"),
                          ],
                        ),
                      ),
                      24.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 32.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ...state.events.asMap().entries.map((entry) {
                              int idx = entry.key;
                              var event = entry.value;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: _buildTimelineItem(
                                    title: event.title,
                                    subtitle: event.subtitle ?? '',
                                    isFirst: idx == 0,
                                    isLast: idx == state.events.length - 1,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      24.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: orangeLightColor, // soft peach/orange
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            "Five weeks with LovingBrain. Bedtime has moved 22 minutes earlier on average since you started."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                  height: 1.4,
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

  Widget _buildFilterChip(String title) {
    bool isSelected = title == _selectedFilter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: title.appText(
          fontSize: 16.sp,
          color: isSelected ? secondaryColor : greyColor9,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line & dot
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 16.h,
                  color: isFirst ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          16.spaceW,
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.spaceH, // slight offset to align with dot
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 12.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
                32.spaceH, // spacing before next item
              ],
            ),
          ),
        ],
      ),
    );
  }
}
