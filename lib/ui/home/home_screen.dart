import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/daily_mood_check_in/daily_mood_check_in_screen.dart';
import 'package:loving_brain/ui/essentials/essentials_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../base_screen/bloc/base_cubit.dart';
import '../choose_your_calm/choose_your_calm_screen.dart';
import '../module/module_screen.dart';
import '../new_behavior/new_behavior_screen.dart';
import '../play_and_connect/play_and_connect_screen.dart';
import '../your_streak/your_streak_screen.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                60.spaceH,
                _topCard(state),
                10.spaceH,
                _secondCard(),
                10.spaceH,
                _thirdCard(state),
                _reminder(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _topCard(HomeState state) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          10.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.spaceW,
              Assets.icons.icProfileIcon2.image(
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
              10.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Hello, ${state.userModel?.parentName ?? ""}!".appText(
                      fontWeight: FontWeight.w600,
                    ),
                    "Ready to nurture ${state.childModel?.childName ?? ""}'s journey?\n(Child: ${state.childModel?.childName ?? ""}, ${state.childModel?.childAge ?? ""} old)"
                        .appText(fontSize: 12, textAlign: TextAlign.start),
                  ],
                ),
              ),
              10.spaceW,
              Icon(CupertinoIcons.bell),
              10.spaceW,
            ],
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    LocaleKeys.nextSchedule.tr().appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    "3:00PM".appText(fontSize: 12),
                    "${state.childModel?.childName ?? ""}'s Nap Time".appText(fontSize: 12),
                    Row(
                      children: [
                        BaseButton(
                          child: LocaleKeys.viewSchedule.tr().appText(
                            fontWeight: FontWeight.w700,
                            color: sliderTrackColor2,
                            fontSize: 14,
                          ),
                          onTap: () {
                            context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              10.spaceW,
              Column(
                children: [
                  Row(
                    children: [
                      Assets.icons.icStreakIcon.image(),
                      5.spaceW,
                      (state.userModel?.streak ?? 0).toString().appText(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  "Streak!".appText(fontWeight: FontWeight.w600),
                  12.spaceH,
                  BaseButton(
                    child: Assets.icons.icCalenderIcon.image(
                      height: 50,
                      width: 50,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const YourStreakScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              20.spaceW,
            ],
          ),
          10.spaceH,
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _secondCard() {
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.images.imgHomeCardBg.path),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.calmCorner.tr(),
              asset: Assets.icons.icCalmCorner,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChooseYourCalmScreen(),
                  ),
                );
              },
            ),
          ),
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.challenges.tr(),
              asset: Assets.icons.icChallengesIcon,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ModuleScreen()),
                );
              },
            ),
          ),
          8.spaceW,
          Expanded(
            child: _secondCardItem(
              title: LocaleKeys.trackKidBehaviour.tr(),
              asset: Assets.icons.icTrackKidBehaviour,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewBehaviorScreen(),
                  ),
                );
              },
            ),
          ),
          8.spaceW,
        ],
      ).appPadding(bottom: 20),
    ).appPadding(left: 20, right: 20);
  }

  Widget _secondCardItem({
    required String title,
    required AssetGenImage asset,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title.appText(fontSize: 12, fontWeight: FontWeight.w600),
            8.spaceH,
            asset.image(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _thirdCard(HomeState state) {
    return Row(
      children: [
        20.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.learnPlay.tr(),
            asset: Assets.images.imgLearnAndPlay,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PlayAndConnectScreen(),
                ),
              );
            },
          ),
        ),
        10.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.familySync.tr(),
            asset: Assets.images.imgSleep,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EssentialsScreen(),
                ),
              );
            },
          ),
        ),
        10.spaceW,
        Expanded(
          child: _thirdCardItem(
            title: LocaleKeys.howAreWeFeeling.tr(),
            asset: Assets.images.imgHowAreWeFeeling,
            onTap: () {
              // if (!state.moodLoggedForToday) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DailyMoodCheckInScreen(),
                ),
              );
              // } else {
              //   showSnackBar(
              //     message: LocaleKeys.youAlreadyLoggedYourMoodToday.tr(),
              //     type: SnackBarType.ERROR,
              //   );
              // }
            },
          ),
        ),
        20.spaceW,
      ],
    );
  }

  Widget _thirdCardItem({
    required String title,
    required AssetGenImage asset,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(asset.path),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [title.appText(fontWeight: FontWeight.w700, fontSize: 14)],
        ),
      ),
    );
  }

  Widget _reminder() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: yellowColor4,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100),
              ),
            ),
          ),
        ),

        Container(height: 200.h),

        Positioned(
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseButton(
                child: Container(
                  height: 100.h,
                  width: 270.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.images.imgReminderBg.path),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Remember to re-evaluate".appText(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                          "Tantrum strategies in 3 days".appText(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          Row(
                            children: [
                              "Take action".appText(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              10.spaceW,
                              Assets.icons.icForwardArrow.image(
                                height: 22.h,
                                width: 22.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                      10.spaceW,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.icReminderIcon.image(
                            height: 25.h,
                            width: 25.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<HomeCubit>().dispose();
    }
    super.dispose();
  }
}
