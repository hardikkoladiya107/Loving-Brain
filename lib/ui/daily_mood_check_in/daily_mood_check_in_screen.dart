import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import 'bloc/daily_mood_check_in_cubit.dart';
import 'bloc/daily_mood_check_in_state.dart';

class DailyMoodCheckInScreen extends StatefulWidget {
  const DailyMoodCheckInScreen({super.key});

  @override
  State<DailyMoodCheckInScreen> createState() => _DailyMoodCheckInScreenState();
}

class _DailyMoodCheckInScreenState extends State<DailyMoodCheckInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyMoodCheckInCubit, DailyMoodCheckInState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgDailyMoodCheckInBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                50.spaceH,
                _header(),
                200.spaceH,

                _childFeeling(),
                Spacer(),
                _parentFeeling(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
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

  Widget _moodItem({required String title, required AssetGenImage image}) {
    return Container(
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
    );
  }

  Widget _childFeeling() {
    return Column(
      children: [
        "How is Rohan feeling right now?".appText(
          color: blueTextColor,
          fontWeight: FontWeight.w700,
        ),
        50.spaceH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _moodItem(
              title: LocaleKeys.happy.tr(),
              image: Assets.icons.icHappyIcon,
            ),
            _moodItem(
              title: LocaleKeys.sad.tr(),
              image: Assets.icons.icSadIcon,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _moodItem(
              title: LocaleKeys.calm.tr(),
              image: Assets.icons.icCalmIcon,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _moodItem(
              title: LocaleKeys.mad.tr(),
              image: Assets.icons.icMadIcon,
            ),
            _moodItem(
              title: LocaleKeys.worried.tr(),
              image: Assets.icons.icWorriedIcon,
            ),
          ],
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _parentFeeling() {
    return Container(
      decoration: BoxDecoration(
        color: yellowTextColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          40.spaceH,
          "${LocaleKeys.howAreYouFeeling.tr()}, Sarah?".appText(
            fontWeight: FontWeight.w600,
            color: blueTextColor,
          ),
          50.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moodItem(
                title: LocaleKeys.happy.tr(),
                image: Assets.icons.icHappyIcon,
              ),
              _moodItem(
                title: LocaleKeys.sad.tr(),
                image: Assets.icons.icSadIcon,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _moodItem(
                title: LocaleKeys.calm.tr(),
                image: Assets.icons.icCalmIcon,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moodItem(
                title: LocaleKeys.mad.tr(),
                image: Assets.icons.icMadIcon,
              ),
              _moodItem(
                title: LocaleKeys.worried.tr(),
                image: Assets.icons.icWorriedIcon,
              ),
            ],
          ),
          50.spaceH,
        ],
      ).appPadding(left: 30, right: 30),
    );
  }
}
