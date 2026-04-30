import 'package:go_router/go_router.dart';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/daily_mood_log/bloc/daily_mood_log_cubit.dart';
import 'package:loving_brain/ui/daily_mood_log/bloc/daily_mood_log_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class DailyMoodLog extends StatefulWidget {
  const DailyMoodLog({super.key});

  @override
  State<DailyMoodLog> createState() => _DailyMoodLogState();
}

class _DailyMoodLogState extends State<DailyMoodLog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyMoodLogCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyMoodLogCubit, DailyMoodLogState>(
      listener: (BuildContext context, DailyMoodLogState state) {
        state.logsApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) => EasyLoading.dismiss(),
          error: (dynamic error) => EasyLoading.dismiss(),
          initial: () => EasyLoading.dismiss(),
        );
      },
      builder: (BuildContext context, DailyMoodLogState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: <Widget>[
              _buildAuroraBackground(),
              _buildGlassOverlay(),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      sliver: SliverToBoxAdapter(child: _topBar()),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[_heroCard(), 18.h.spaceH],
                        ),
                      ),
                    ),
                    if (state.logs.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _emptyState(),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        sliver: SliverList.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return _logTile(state.logs[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              10.h.spaceH,
                          itemCount: state.logs.length,
                        ),
                      ),
                    SliverToBoxAdapter(child: 40.h.spaceH),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuroraBackground() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -90.h,
          left: -70.w,
          child: Container(
            width: 320.w,
            height: 320.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF894BCD).withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: 180.h,
          right: -100.w,
          child: Container(
            width: 280.w,
            height: 280.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5271FF).withValues(alpha: 0.12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(color: Colors.white.withValues(alpha: 0.35)),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22.sp,
              color: primaryColor,
            ),
          ),
        ),
        12.w.spaceW,
        Expanded(
          child: LocaleKeys.yourMoodHistory.tr().appText(
            fontWeight: FontWeight.w900,
            fontSize: 19.sp,
            color: Colors.black87,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF894BCD), Color(0xFFB185DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF894BCD).withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: Colors.white,
              size: 21.sp,
            ),
          ),
          12.w.spaceW,
          Expanded(
            child:
                "Review mood trends and stay connected with your emotional journey."
                    .appText(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.history_toggle_off_rounded,
                size: 34.sp,
                color: primaryColor,
              ),
              10.h.spaceH,
              LocaleKeys.noChatAvailable.tr().appText(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logTile(MoodLogModel log) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: yellowColor3.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.mood_rounded,
              size: 22.sp,
              color: greenPlayButtonColor,
            ),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                "Parent: ${log.parentMood.toLowerCase()}".appText(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Colors.black87,
                ),
                4.h.spaceH,
                "Child: ${log.childMood.toLowerCase()}".appText(
                  fontSize: 12.sp,
                  color: Colors.grey.shade700,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          8.w.spaceW,
          log.logTime.timeAgo().appText(
            fontSize: 10.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
