import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
      builder: (context, state) {
        return Scaffold(
          backgroundColor: yellowTextColor,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgDailyMoodCheckInBg.image(
                      height: context.height,
                      width: context.width,
                    ),
                    Container(height: context.height / 4),
                  ],
                ),
                Column(
                  children: [
                    50.spaceH,
                    _header(),
                    180.spaceH,
                    _childFeeling(state),
                    50.spaceH,
                    _parentFeeling(state),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            showSnackBar(
              message: LocaleKeys.greatJobCheckingIn.tr(),
              type: SnackBarType.SUCCESS,
            );
            EasyLoading.dismiss();
            Navigator.of(context).pop();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: "Daily Mood Check-in"
              .appText(
                color: orangeColor2,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              )
              .appPadding(all: 8),
        ),
      ],
    );
  }

  Widget _moodItem({
    required String title,
    required AssetGenImage image,
    required bool isSelected,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              offset: Offset(1, 1),
              spreadRadius: 5,
              blurRadius: 5,
            ),
          ],
          border: isSelected
              ? Border.all(color: primaryColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            4.spaceW,
            image.image(height: 24.h, width: 24.w),
            10.spaceW,
            title.appText(fontWeight: FontWeight.w500),
            4.spaceW,
          ],
        ).appPadding(all: 5),
      ),
    );
  }

  Widget _childFeeling(DailyMoodCheckInState state) {
    return Column(
      children: [
        "How is ${state.userModel?.childName ?? ""} feeling right now?".appText(
          color: blueTextColor,
          fontWeight: FontWeight.w700,
        ),
        30.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _moodItem(
              title: LocaleKeys.happy.tr(),
              image: Assets.icons.icHappyIcon,
              onTap: () {
                context.read<DailyMoodCheckInCubit>().changeProps(
                  childMood: "HAPPY",
                );
              },
              isSelected: state.childMood == "HAPPY",
            ),
            _moodItem(
              title: LocaleKeys.sad.tr(),
              image: Assets.icons.icSadIcon,
              onTap: () {
                context.read<DailyMoodCheckInCubit>().changeProps(
                  childMood: "SAD",
                );
              },
              isSelected: state.childMood == "SAD",
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _moodItem(
              title: LocaleKeys.calm.tr(),
              image: Assets.icons.icCalmIcon,
              onTap: () {
                context.read<DailyMoodCheckInCubit>().changeProps(
                  childMood: "CALM",
                );
              },
              isSelected: state.childMood == "CALM",
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _moodItem(
              title: LocaleKeys.mad.tr(),
              image: Assets.icons.icMadIcon,
              onTap: () {
                context.read<DailyMoodCheckInCubit>().changeProps(
                  childMood: "MAD",
                );
              },
              isSelected: state.childMood == "MAD",
            ),
            _moodItem(
              title: LocaleKeys.worried.tr(),
              image: Assets.icons.icWorriedIcon,
              onTap: () {
                context.read<DailyMoodCheckInCubit>().changeProps(
                  childMood: "WORRIED",
                );
              },
              isSelected: state.childMood == "WORRIED",
            ),
          ],
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _parentFeeling(DailyMoodCheckInState state) {
    return Container(
      height: 350.h,
      decoration: BoxDecoration(
        color: yellowTextColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          20.spaceH,
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                "${LocaleKeys.howAreYouFeeling.tr()}, ${state.userModel?.parentName ?? ""}?"
                    .appText(fontWeight: FontWeight.w600, color: blueTextColor)
                    .padding(all: 5),
          ),
          40.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moodItem(
                title: LocaleKeys.happy.tr(),
                image: Assets.icons.icHappyIcon,
                onTap: () {
                  context.read<DailyMoodCheckInCubit>().changeProps(
                    parentMood: "HAPPY",
                  );
                },
                isSelected: state.parentMood == "HAPPY",
              ),
              _moodItem(
                title: LocaleKeys.sad.tr(),
                image: Assets.icons.icSadIcon,
                onTap: () {
                  context.read<DailyMoodCheckInCubit>().changeProps(
                    parentMood: "SAD",
                  );
                },
                isSelected: state.parentMood == "SAD",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _moodItem(
                title: LocaleKeys.calm.tr(),
                image: Assets.icons.icCalmIcon,
                onTap: () {
                  context.read<DailyMoodCheckInCubit>().changeProps(
                    parentMood: "CALM",
                  );
                },
                isSelected: state.parentMood == "CALM",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moodItem(
                title: LocaleKeys.mad.tr(),
                image: Assets.icons.icMadIcon,
                onTap: () {
                  context.read<DailyMoodCheckInCubit>().changeProps(
                    parentMood: "MAD",
                  );
                },
                isSelected: state.parentMood == "MAD",
              ),
              _moodItem(
                title: LocaleKeys.worried.tr(),
                image: Assets.icons.icWorriedIcon,
                onTap: () {
                  context.read<DailyMoodCheckInCubit>().changeProps(
                    parentMood: "WORRIED",
                  );
                },
                isSelected: state.parentMood == "WORRIED",
              ),
            ],
          ),
          30.spaceH,
          BaseButton(
            onTap: () {
              context.read<DailyMoodCheckInCubit>().logMoods();
            },
            child: Container(
              decoration: BoxDecoration(
                color: sliderTrackColor4,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocaleKeys.logMoodsLabel
                      .tr()
                      .appText(fontWeight: FontWeight.w800)
                      .padding(left: 16, right: 16, top: 8, bottom: 8),
                ],
              ),
            ),
          ),
          40.spaceH,
        ],
      ).appPadding(left: 30, right: 30),
    );
  }
}
