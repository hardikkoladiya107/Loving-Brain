import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/daily_mood_log/daily_mood_log.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/snack_bar.dart';
import 'bloc/daily_mood_check_in_cubit.dart';
import 'bloc/daily_mood_check_in_state.dart';

class DailyMoodCheckInScreen extends StatefulWidget {
  const DailyMoodCheckInScreen({super.key});

  @override
  State<DailyMoodCheckInScreen> createState() => _DailyMoodCheckInScreenState();
}

class _DailyMoodCheckInScreenState extends State<DailyMoodCheckInScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DailyMoodCheckInCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyMoodCheckInCubit, DailyMoodCheckInState>(
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (data) {
            showSnackBar(
              message: LocaleKeys.greatJobCheckingIn.tr(),
              type: SnackBarType.SUCCESS,
            );
            UserRepo.instance.updateUserStreak();
            EasyLoading.dismiss();
            Navigator.of(context).pop();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA), // Soft beautiful off-white/grey
          body: Stack(
            children: [
              // Beautiful Header Banner Graphic
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Assets.images.imgDailyMoodCheckInBg.image(
                  fit: BoxFit.fitWidth,
                  width: context.width,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    16.h.spaceH,
                    _buildHeader(context),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                        child: Column(
                          children: [
                            _childFeelingCard(state),
                            24.h.spaceH,
                            _parentFeelingCard(state),
                            40.h.spaceH,
                            _logMoodsButton(context),
                            40.h.spaceH,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseButton(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24.sp),
            ),
          ),
          "Daily Mood Check-in".appText(
            color: blackTextColor,
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
          ),
          BaseButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DailyMoodLog()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.history_rounded, color: primaryColor, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _childFeelingCard(DailyMoodCheckInState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.child_care_rounded, color: primaryColor, size: 24.sp),
              ),
              12.w.spaceW,
              Flexible(
                child: "How is ${state.userModel?.childName ?? 'your child'} feeling?".appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          24.h.spaceH,
          _moodGridContainer(
            selectedMood: state.childMood,
            onMoodSelected: (mood) => context.read<DailyMoodCheckInCubit>().changeProps(childMood: mood),
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _parentFeelingCard(DailyMoodCheckInState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: blueColor1.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: blueColor1, size: 24.sp),
              ),
              12.w.spaceW,
              Flexible(
                child: "How are you feeling?".appText(
                  color: blueColor1,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          24.h.spaceH,
          _moodGridContainer(
            selectedMood: state.parentMood,
            onMoodSelected: (mood) => context.read<DailyMoodCheckInCubit>().changeProps(parentMood: mood),
            activeColor: blueColor1,
          ),
        ],
      ),
    );
  }

  Widget _moodGridContainer({
    required String selectedMood,
    required Function(String) onMoodSelected,
    required Color activeColor,
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.w,
      runSpacing: 16.h,
      children: [
        _moodSquare(
          title: LocaleKeys.happy.tr(),
          image: Assets.icons.icHappyIcon,
          isSelected: selectedMood == "HAPPY",
          onTap: () => onMoodSelected("HAPPY"),
          activeColor: activeColor,
        ),
        _moodSquare(
          title: LocaleKeys.sad.tr(),
          image: Assets.icons.icSadIcon,
          isSelected: selectedMood == "SAD",
          onTap: () => onMoodSelected("SAD"),
          activeColor: activeColor,
        ),
        _moodSquare(
          title: LocaleKeys.calm.tr(),
          image: Assets.icons.icCalmIcon,
          isSelected: selectedMood == "CALM",
          onTap: () => onMoodSelected("CALM"),
          activeColor: activeColor,
        ),
        _moodSquare(
          title: LocaleKeys.mad.tr(),
          image: Assets.icons.icMadIcon,
          isSelected: selectedMood == "MAD",
          onTap: () => onMoodSelected("MAD"),
          activeColor: activeColor,
        ),
        _moodSquare(
          title: LocaleKeys.worried.tr(),
          image: Assets.icons.icWorriedIcon,
          isSelected: selectedMood == "WORRIED",
          onTap: () => onMoodSelected("WORRIED"),
          activeColor: activeColor,
        ),
      ],
    );
  }

  Widget _moodSquare({
    required String title,
    required AssetGenImage image,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return BaseButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 85.w,
        height: 98.h,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isSelected ? 1.1 : 1.0,
              curve: Curves.easeOutBack,
              child: image.image(height: 38.h, width: 38.w),
            ),
            10.h.spaceH,
            title.appText(
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? activeColor : greyColor1,
              fontSize: 13.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logMoodsButton(BuildContext context) {
    return BaseButton(
      onTap: () => context.read<DailyMoodCheckInCubit>().logMoods(),
      child: Container(
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryColor, blueColor2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: LocaleKeys.logMoodsLabel.tr().appText(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
