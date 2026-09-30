import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_conversation/brainy_conversation_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/brainy_history_cubit.dart';
import 'bloc/brainy_history_state.dart';

class BrainyHistoryScreen extends StatelessWidget {
  const BrainyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrainyHistoryCubit()..init(),
      child: BlocBuilder<BrainyHistoryCubit, BrainyHistoryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
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
                              onTap: () => Navigator.pop(context),
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
                      32.spaceH,
                      "History".appText(
                        fontSize: 28.sp,
                        color: darkBlue,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      if (state.thisWeekHistory.isNotEmpty) ...[
                        32.spaceH,
                        _buildSectionTitle("THIS WEEK"),
                        12.spaceH,
                        ...state.thisWeekHistory.map((item) {
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
                        ...state.earlierHistory.map((item) {
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
                          borderRadius: BorderRadius.circular(24),
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
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BrainyConversationScreen(
                  conversationId: item.conversationId,
                  initialChat: item.title,
                  topic: item.topic,
                ),
              ),
            );
          },
          onLongPress: item.conversationId != null
              ? () => _showDeleteDialog(context, item.conversationId!)
              : null,
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
                if (item.conversationId != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () =>
                        _showDeleteDialog(context, item.conversationId!),
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
    final cubit = context.read<BrainyHistoryCubit>();
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
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      height: 1.4,
                    ),
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
        );
      },
    );
  }
}
