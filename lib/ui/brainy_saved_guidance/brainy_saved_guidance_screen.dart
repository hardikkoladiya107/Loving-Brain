import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/brainy_saved_guidance_cubit.dart';
import 'bloc/brainy_saved_guidance_state.dart';

class BrainySavedGuidanceScreen extends StatefulWidget {
  const BrainySavedGuidanceScreen({super.key});

  @override
  State<BrainySavedGuidanceScreen> createState() =>
      _BrainySavedGuidanceScreenState();
}

class _BrainySavedGuidanceScreenState extends State<BrainySavedGuidanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrainySavedGuidanceCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrainySavedGuidanceCubit, BrainySavedGuidanceState>(
      listener: (BuildContext context, BrainySavedGuidanceState state) {},
      builder: (BuildContext context, BrainySavedGuidanceState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -150.w,
                top: -150.h,
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
                            onTap: () => Navigator.pop(context),
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
                    32.spaceH,
                    "Saved Guidance".appText(
                      fontSize: 28.sp,
                      color: darkBlue,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    if (state.hasLoadError) ...[
                      32.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          children: [
                            'Could not load saved guidance'.appText(
                              fontSize: 16.sp,
                              color: darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                            12.spaceH,
                            AppButton(
                              title: 'Try again',
                              onTap: () {
                                context
                                    .read<BrainySavedGuidanceCubit>()
                                    .retry();
                              },
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              height: 44,
                            ),
                          ],
                        ),
                      ),
                    ] else if (state.sleepItems.isEmpty &&
                        state.behaviourItems.isEmpty &&
                        state.parentWellbeingItems.isEmpty) ...[
                      32.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(28.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bookmark_border_rounded,
                              size: 48.sp,
                              color: primaryColor,
                            ),
                            16.spaceH,
                            "No saved guidance yet".appText(
                              fontSize: 18.sp,
                              color: darkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            8.spaceH,
                            "Tap the bookmark icon on any Brainy answer to save it here for quick reference."
                                .appText(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                  textAlign: TextAlign.center,
                                  height: 1.4,
                                ),
                          ],
                        ),
                      ),
                    ],
                    if (state.sleepItems.isNotEmpty) ...[
                      32.spaceH,
                      _buildSectionTitle("SLEEP"),
                      12.spaceH,
                      ...state.sleepItems.map((BrainySavedItem item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                    ],
                    if (state.behaviourItems.isNotEmpty) ...[
                      32.spaceH,
                      _buildSectionTitle("BEHAVIOUR", color: greyColor11),
                      12.spaceH,
                      ...state.behaviourItems.map((BrainySavedItem item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                    ],
                    if (state.parentWellbeingItems.isNotEmpty) ...[
                      32.spaceH,
                      _buildSectionTitle("PARENT WELLBEING"),
                      12.spaceH,
                      ...state.parentWellbeingItems.map((BrainySavedItem item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildGuidanceItem(context, item: item),
                        );
                      }),
                    ],
                    32.spaceH,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, {Color color = secondaryColor}) {
    return title.appText(
      fontSize: 12.sp,
      color: color,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.start,
    );
  }

  Widget _buildGuidanceItem(
    BuildContext context, {
    required BrainySavedItem item,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {
            if (item.conversationId != null &&
                item.conversationId!.trim().isNotEmpty) {
              context.push(
                RoutePaths.brainyConversation,
                extra: <String, dynamic>{
                  'conversationId': item.conversationId,
                  'initialChat': item.title,
                  'topic': item.topic,
                },
              );
              return;
            }
            if (item.hasStoredAnswerParts) {
              _showStoredAnswerSheet(context, item);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: Color(item.imageBgColorValue),
                    borderRadius: BorderRadius.circular(16.r),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(item.imagePath),
                    ),
                  ),
                ),
                16.spaceW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.title.appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                      4.spaceH,
                      item.subtitle.appText(
                        fontSize: 12.sp,
                        color: greyColor4,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: greyColor4, size: 20.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStoredAnswerSheet(BuildContext context, BrainySavedItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Saved answer'.appText(
                    fontSize: 20.sp,
                    fraunces: true,
                    color: darkBlue,
                  ),
                  16.spaceH,
                  if ((item.whatMayBeHappeningHeadline ?? '').isNotEmpty) ...[
                    'What may be happening'.appText(
                      fontSize: 12.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    6.spaceH,
                    item.whatMayBeHappeningHeadline!.appText(
                      fontSize: 16.sp,
                      color: darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    if ((item.whatMayBeHappeningSubtext ?? '').isNotEmpty) ...[
                      6.spaceH,
                      item.whatMayBeHappeningSubtext!.appText(
                        fontSize: 13.sp,
                        color: greyColor,
                      ),
                    ],
                    16.spaceH,
                  ],
                  if ((item.whatToTryNowHeadline ?? '').isNotEmpty) ...[
                    'What to try now'.appText(
                      fontSize: 12.sp,
                      color: secondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    6.spaceH,
                    item.whatToTryNowHeadline!.appText(
                      fontSize: 16.sp,
                      color: darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    if ((item.whatToTryNowSubtext ?? '').isNotEmpty) ...[
                      6.spaceH,
                      item.whatToTryNowSubtext!.appText(
                        fontSize: 13.sp,
                        color: greyColor,
                      ),
                    ],
                    16.spaceH,
                  ],
                  if ((item.whenToGetHelpHeadline ?? '').isNotEmpty) ...[
                    'When to get help'.appText(
                      fontSize: 12.sp,
                      color: secondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    6.spaceH,
                    item.whenToGetHelpHeadline!.appText(
                      fontSize: 16.sp,
                      color: darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    if ((item.whenToGetHelpSubtext ?? '').isNotEmpty) ...[
                      6.spaceH,
                      item.whenToGetHelpSubtext!.appText(
                        fontSize: 13.sp,
                        color: greyColor,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
