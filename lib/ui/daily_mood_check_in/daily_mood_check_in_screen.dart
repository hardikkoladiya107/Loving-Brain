import 'dart:ui';
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
          backgroundColor: const Color(0xFFF9FAFC),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        24.h.spaceH,
                        // Custom rounded drag handle aesthetic
                        Center(
                          child: Container(
                            width: 60.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: greyColor2,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        32.h.spaceH,
                        _childFeelingSection(state),
                        40.h.spaceH,
                        _parentFeelingSection(state),
                        60.h.spaceH,
                        _logMoodsButton(context),
                        60.h.spaceH,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      title: "Daily Mood".appText(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 20.sp,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      leading: BaseButton(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22.sp),
        ),
      ),
      actions: [
        BaseButton(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DailyMoodLog()),
            );
          },
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, color: Colors.white, size: 22.sp),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Assets.images.imgDailyMoodCheckInBg.image(
              fit: BoxFit.cover,
            ),
            // Subtle gradient at bottom to blend into the curving surface
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _childFeelingSection(DailyMoodCheckInState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.child_care_rounded, color: primaryColor, size: 26.sp),
              ),
              12.w.spaceW,
              Flexible(
                child: "How is ${state.userModel?.childName ?? 'your child'} feeling?".appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                  height: 1.2,
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

  Widget _parentFeelingSection(DailyMoodCheckInState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: blueColor1.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: blueColor1, size: 26.sp),
              ),
              12.w.spaceW,
              Flexible(
                child: "And how are you feeling?".appText(
                  color: blueColor1,
                  fontWeight: FontWeight.w900,
                  fontSize: 22.sp,
                  height: 1.2,
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
    // Beautiful grid layout for emotions
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.w,
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
        curve: Curves.easeOutBack,
        width: 100.w,
        height: 108.h,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.15 : 1.0,
              child: image.image(height: 48.h, width: 48.w),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: BaseButton(
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
      ),
    );
  }
}
