import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import 'bloc/activity_completed_cubit.dart';
import 'bloc/activity_completed_state.dart';

class ActivityCompletedScreen extends StatefulWidget {
  const ActivityCompletedScreen({super.key});

  @override
  State<ActivityCompletedScreen> createState() =>
      _ActivityCompletedScreenState();
}

class _ActivityCompletedScreenState extends State<ActivityCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCompletedCubit, ActivityCompletedState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgActivityCompleted.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  50.spaceH,
                  _checkMark(),
                  20.spaceH,
                  LocaleKeys.activityCompleted.tr().appText(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  LocaleKeys.youveAddedToYourStreak.tr().appText(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  60.spaceH,
                  _brainStreak(),
                  20.spaceH,
                  _getAiPlayInsight(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _checkMark() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Assets.icons.icCheck
              .image(height: 40, width: 40)
              .appPadding(all: 15),
        ),
      ],
    );
  }

  Widget _brainStreak() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.icStreakMailIcon.image(height: 65, width: 65),
          16.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleKeys.brainStreaks.tr().appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
                Row(
                  children: [
                    "5 day streak".appText(fontSize: 14),
                    8.spaceW,
                    ...List.generate(7, (index) {
                      return Container(
                        height: 13.h,
                        width: 13.w,
                        decoration: BoxDecoration(
                          color: index > 4 ? greyColor3 : pinkColor,
                          shape: BoxShape.circle,
                        ),
                      ).appPadding(left: 2, right: 2);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).appPadding(all: 12),
    ).appPadding(left: 30, right: 30);
  }

  Widget _getAiPlayInsight() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cardColor1,
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.icQuestion
                    .image(height: 18, width: 18)
                    .appPadding(all: 5),
              ),
              10.spaceW,
              LocaleKeys.getAIPlayInsight.tr().appText(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ],
          ).appPadding(left: 20, right: 20),
          15.spaceH,
          LocaleKeys.getAIPlayInsightDescription
              .tr()
              .appText(textAlign: TextAlign.start)
              .appPadding(left: 20, right: 20),
          15.spaceH,
          _recapWithBrainAiButton(),
          15.spaceH,
          _reflectInJournal(),
          30.spaceH,
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _reflectInJournal() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icReflactInJournal.image(),
            10.spaceW,
            LocaleKeys.reflectInJournal.tr().appText(
              fontWeight: FontWeight.w600,
            ),
          ],
        ).appPadding(top: 4.h, bottom: 4.h),
      ),
      onTap: () {},
    ).appPadding(left: 30.w, right: 30.w);
  }

  Widget _recapWithBrainAiButton() {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: cardColor2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Recap with Brain AI".appText(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ],
        ).appPadding(top: 8, bottom: 8),
      ),
      onTap: () {},
    ).appPadding(left: 30, right: 30);
  }
}
