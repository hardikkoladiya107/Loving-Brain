import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/brainy_history_cubit.dart';
import 'bloc/brainy_history_state.dart';

class BrainyHistoryScreen extends StatefulWidget {
  const BrainyHistoryScreen({super.key});

  @override
  State<BrainyHistoryScreen> createState() => _BrainyHistoryScreenState();
}

class _BrainyHistoryScreenState extends State<BrainyHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrainyHistoryCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrainyHistoryCubit, BrainyHistoryState>(
      listener: (BuildContext context, BrainyHistoryState state) {},
      builder: (BuildContext context, BrainyHistoryState state) {
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
                    "History".appText(
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
                            'Could not load history'.appText(
                              fontSize: 16.sp,
                              color: darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                            12.spaceH,
                            AppButton(
                              title: 'Try again',
                              onTap: () {
                                context.read<BrainyHistoryCubit>().retry();
                              },
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              height: 44,
                            ),
                          ],
                        ),
                      ),
                    ] else if (state.thisWeekHistory.isEmpty &&
                        state.earlierHistory.isEmpty) ...[
                      32.spaceH,
                      _buildEmptyState(context),
                    ],
                    if (state.thisWeekHistory.isNotEmpty) ...[
                      32.spaceH,
                      _buildSectionTitle("THIS WEEK"),
                      12.spaceH,
                      ...state.thisWeekHistory.map((BrainyHistoryItem item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildHistoryItem(context, item: item),
                        );
                      }),
                    ],
                    if (state.earlierHistory.isNotEmpty) ...[
                      32.spaceH,
                      _buildSectionTitle("EARLIER", color: greyColor11),
                      12.spaceH,
                      ...state.earlierHistory.map((BrainyHistoryItem item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: _buildHistoryItem(context, item: item),
                        );
                      }),
                    ],
                    32.spaceH,
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: greyColor,
                            size: 20.sp,
                          ),
                          12.spaceW,
                          Expanded(
                            child:
                                "History is kept for 30 days to help provide better insights."
                                    .appText(
                                      fontSize: 12.sp,
                                      color: greyColor,
                                      textAlign: TextAlign.start,
                                      height: 1.4,
                                    ),
                          ),
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

  Widget _buildEmptyState(BuildContext context) {
    final List<Map<String, String>> starters = <Map<String, String>>[
      <String, String>{
        'title': 'Why is bedtime harder lately?',
        'topic': 'Sleep',
      },
      <String, String>{
        'title': 'Is this normal for her age?',
        'topic': 'Behaviour',
      },
      <String, String>{'title': 'What can I try for naps?', 'topic': 'Sleep'},
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: primaryColor,
                  size: 22.sp,
                ),
              ),
              12.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "No conversations yet".appText(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: darkBlue,
                      textAlign: TextAlign.start,
                    ),
                    2.spaceH,
                    "Start a chat with Brainy to see your history here".appText(
                      fontSize: 12.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.spaceH,
          "SUGGESTED QUESTIONS".appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: secondaryColor,
            letterSpacing: 1.2,
            textAlign: TextAlign.start,
          ),
          10.spaceH,
          ...starters.map((Map<String, String> s) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Material(
                color: const Color(0xFFFEF8F4),
                borderRadius: BorderRadius.circular(14.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () {
                    context.push(
                      RoutePaths.brainyConversation,
                      extra: <String, dynamic>{
                        'initialChat': s['title'],
                        'topic': s['topic'],
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: (s['title'] ?? '').appText(
                            fontSize: 13.sp,
                            color: greyColor9,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: primaryColor,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
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

  Widget _buildHistoryItem(
    BuildContext context, {
    required BrainyHistoryItem item,
  }) {
    final String convId = item.conversationId ?? item.title;
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
            context.push(
              RoutePaths.brainyConversation,
              extra: <String, dynamic>{
                'conversationId': convId.startsWith('sample_') ? null : convId,
                'initialChat': item.title,
                'topic': item.topic,
              },
            );
          },
          onLongPress: () => _showDeleteDialog(context, convId),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
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
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showDeleteDialog(context, convId),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: greyColor4,
                    size: 18.sp,
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

  void _showDeleteDialog(BuildContext context, String conversationId) {
    final BrainyHistoryCubit cubit = context.read<BrainyHistoryCubit>();
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFD84315),
                      size: 28.sp,
                    ),
                  ),
                  18.spaceH,
                  "Delete conversation?".appText(
                    fontSize: 22.sp,
                    color: greyColor9,
                    fraunces: true,
                  ),
                  10.spaceH,
                  "Are you sure you want to delete this conversation? This action cannot be undone."
                      .appText(fontSize: 14.sp, color: greyColor, height: 1.4),
                  24.spaceH,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 48.h,
                          padding: EdgeInsets.zero,
                          title: 'Cancel',
                          backgroundColor: const Color(0xFFF8F5F2),
                          borderColor: const Color(0xFFE9E2DC),
                          textColor: greyColor9,
                          onTap: () => Navigator.pop(dialogContext),
                        ),
                      ),
                      12.spaceW,
                      Expanded(
                        child: AppButton(
                          height: 48.h,
                          padding: EdgeInsets.zero,
                          title: 'Delete',
                          backgroundColor: const Color(0xFFD84315),
                          borderColor: const Color(0xFFD84315),
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.pop(dialogContext);
                            cubit.deleteConversation(conversationId);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
