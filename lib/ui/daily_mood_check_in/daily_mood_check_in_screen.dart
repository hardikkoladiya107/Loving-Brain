import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/daily_mood_log/daily_mood_log.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/daily_mood_check_in_cubit.dart';
import 'bloc/daily_mood_check_in_state.dart';

class DailyMoodCheckInScreen extends StatefulWidget {
  const DailyMoodCheckInScreen({super.key});

  @override
  State<DailyMoodCheckInScreen> createState() => _DailyMoodCheckInScreenState();
}

class _DailyMoodCheckInScreenState extends State<DailyMoodCheckInScreen> {
  static final List<_MoodOption> _moods = <_MoodOption>[
    _MoodOption(
      key: LocaleKeys.happy,
      value: "HAPPY",
      icon: Assets.icons.icHappyIcon,
    ),
    _MoodOption(
      key: LocaleKeys.sad,
      value: "SAD",
      icon: Assets.icons.icSadIcon,
    ),
    _MoodOption(
      key: LocaleKeys.calm,
      value: "CALM",
      icon: Assets.icons.icCalmIcon,
    ),
    _MoodOption(
      key: LocaleKeys.mad,
      value: "MAD",
      icon: Assets.icons.icMadIcon,
    ),
    _MoodOption(
      key: LocaleKeys.worried,
      value: "WORRIED",
      icon: Assets.icons.icWorriedIcon,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyMoodCheckInCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyMoodCheckInCubit, DailyMoodCheckInState>(
      listener: (BuildContext context, DailyMoodCheckInState state) {
        state.apiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic data) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.greatJobCheckingIn.tr(),
              type: SnackBarType.SUCCESS,
            );
            UserRepo.instance.updateUserStreak();
            context.pop();
          },
          error: (dynamic error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, DailyMoodCheckInState state) {
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
                      sliver: SliverToBoxAdapter(child: _buildTopBar(context)),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildHero(state),
                            18.h.spaceH,
                            _buildMoodCard(
                              title:
                                  "How is ${state.userModel?.childName ?? LocaleKeys.child.tr()} feeling?",
                              subtitle:
                                  "Select your child’s current emotional state.",
                              selectedMood: state.childMood,
                              icon: Icons.child_friendly_rounded,
                              activeColor: primaryColor,
                              onMoodTap: (String mood) {
                                context
                                    .read<DailyMoodCheckInCubit>()
                                    .changeProps(childMood: mood);
                              },
                            ),
                            16.h.spaceH,
                            _buildMoodCard(
                              title: LocaleKeys.howAreYouFeeling.tr(),
                              subtitle:
                                  "Check in with yourself before you continue.",
                              selectedMood: state.parentMood,
                              icon: Icons.self_improvement_rounded,
                              activeColor: blueColor1,
                              onMoodTap: (String mood) {
                                context
                                    .read<DailyMoodCheckInCubit>()
                                    .changeProps(parentMood: mood);
                              },
                            ),
                            28.h.spaceH,
                            _buildLogButton(context),
                            80.h.spaceH,
                          ],
                        ),
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

  Widget _buildAuroraBackground() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -110.h,
          left: -80.w,
          child: Container(
            width: 360.w,
            height: 360.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF894BCD).withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: 130.h,
          right: -90.w,
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

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              color: primaryColor,
              size: 22.sp,
            ),
          ),
        ),
        LocaleKeys.logMood.tr().appText(
          color: Colors.black87,
          fontWeight: FontWeight.w900,
          fontSize: 19.sp,
        ),
        BaseButton(
          onTap: () {
            context.push(RoutePaths.dailyMoodLog);
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Icon(
              Icons.history_rounded,
              color: primaryColor,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(DailyMoodCheckInState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF894BCD), Color(0xFFB185DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
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
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LocaleKeys.howAreWeFeeling.tr().appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.sp,
                ),
                4.h.spaceH,
                "Track both moods in one place to understand your daily emotional rhythm."
                    .appText(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard({
    required String title,
    required String subtitle,
    required String selectedMood,
    required IconData icon,
    required Color activeColor,
    required ValueChanged<String> onMoodTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(icon, color: activeColor, size: 20.sp),
                  ),
                  10.w.spaceW,
                  Expanded(
                    child: title.appText(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              6.h.spaceH,
              subtitle.appText(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
                textAlign: TextAlign.start,
              ),
              14.h.spaceH,
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10.w,
                runSpacing: 10.h,
                children: _moods.map((_MoodOption option) {
                  final bool isSelected = selectedMood == option.value;
                  return BaseButton(
                    onTap: () => onMoodTap(option.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: 85.w,
                      height: 94.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? activeColor.withValues(alpha: 0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: isSelected
                              ? activeColor
                              : Colors.grey.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedScale(
                            duration: const Duration(milliseconds: 220),
                            scale: isSelected ? 1.08 : 1,
                            child: option.icon.image(height: 36.h, width: 36.w),
                          ),
                          8.h.spaceH,
                          option.key.tr().appText(
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSelected ? activeColor : greyColor1,
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogButton(BuildContext context) {
    return BaseButton(
      onTap: () => context.read<DailyMoodCheckInCubit>().logMoods(),
      child: Container(
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[primaryColor, blueColor2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.38),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: LocaleKeys.logMoodsLabel.tr().appText(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MoodOption {
  const _MoodOption({
    required this.key,
    required this.value,
    required this.icon,
  });

  final String key;
  final String value;
  final AssetGenImage icon;
}
