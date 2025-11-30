import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/routine_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/daily_mood_check_in/daily_mood_check_in_screen.dart';
import 'package:loving_brain/ui/essentials/essentials_screen.dart';
import 'package:loving_brain/ui/notification_screen/notification_screen.dart';
import 'package:loving_brain/ui/sleep_summary/sleep_summary_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/your_streak/your_streak_screen.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../base_screen/bloc/base_cubit.dart';
import '../choose_your_calm/choose_your_calm_screen.dart';
import '../new_behavior/new_behavior_screen.dart';
import '../play_and_connect/play_and_connect_screen.dart';
import '../reflect_your_emotions/reflect_your_emotions.dart';
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
                10.spaceH,
                _fourthCardItem(state),
                10.spaceH,
                _fifthCardItem(),
                _sixthCardItem(),
                20.spaceH,
                // 10.spaceH,
                // _reminder(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _topCard(HomeState state) {
    RoutineModel? routine = _getNextRoutine(state);
    return Container(
      decoration: BoxDecoration(
        color: aiQuestionCardColor3,
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
              // BaseButton(
              //   child: Icon(CupertinoIcons.bell),
              //   onTap: () async {
              //     // var response = await CoParentRepo
              //     //     .instance
              //     //     .coParentInvitationCollection
              //     //     .doc("nvnLhKZrz7Yp00Kimc6u")
              //     //     .get();
              //     // var invitationModel = InvitationModel.fromJson(
              //     //   response.data(),
              //     // );
              //     // DeepLinkManager.instance.showSuccessMessage(
              //     //   ApiResultStatus.data(data: invitationModel),
              //     // );
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const NotificationScreen(),
              //       ),
              //     );
              //   },
              // ),

              10.spaceW,
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (routine != null)
                      LocaleKeys.nextSchedule.tr().appText(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    if (routine != null)
                      DateFormat(
                        'hh:mm a',
                      ).format(routine.timeStamp!).appText(fontSize: 12),
                    if (routine != null)
                      routine.description!.appText(fontSize: 12),
                  ],
                ),
              ),
              10.spaceW,
              BaseButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const YourStreakScreen(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Assets.icons.icStreakFire.image(height: 100, width: 80),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ((state.userModel?.streak ?? 0).toString()).appText(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                          ((state.userModel?.streak ?? 0) >= 1 ? "Day" : "Days")
                              .appText(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              )
                              .padding(bottom: 18),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: "Streak!".appText(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ,
              //
              //     // 12.spaceH,
              //     // BaseButton(
              //     //   child: Assets.icons.icCalenderIcon.image(
              //     //     height: 50,
              //     //     width: 50,
              //     //   ),
              //     //   onTap: () {
              //     //     Navigator.of(context).push(
              //     //       MaterialPageRoute(
              //     //         builder: (context) => const YourStreakScreen(),
              //     //       ),
              //     //     );
              //     //   },
              //     // ),
              //   ],
              // ),
              20.spaceW,
            ],
          ),

          8.spaceH,

          Row(
            children: [
              8.spaceW,
              BaseButton(
                child: LocaleKeys.viewSchedule.tr().appText(
                  fontWeight: FontWeight.w700,
                  color: sliderTrackColor2,
                  fontSize: 14,
                ),
                onTap: () {
                  context.read<BaseCubit>().changeProps(
                    bottomNavigationIndex: 1,
                  );
                },
              ),

              12.spaceW,
              Icon(Icons.arrow_circle_right),
            ],
          ),
          8.spaceH,
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _secondCard() {
    return Row(
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
        20.spaceW,
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
          color: aiQuestionCardColor2,
          // image: DecorationImage(
          //   fit: BoxFit.cover,
          //   image: AssetImage(asset.path),
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [title.appText(fontWeight: FontWeight.w700, fontSize: 14)],
        ),
      ),
    );
  }

  Widget _fourthCardItem(HomeState state) {
    return BaseButton(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: greyColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LocaleKeys.dailyParentingTip.tr().appText(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Row(
              children: [
                Expanded(
                  child: state.todayParentingTip.appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fifthCardItem() {
    return BaseButton(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SleepSummaryScreen()),
        );
      },
      child: Container(
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: yellowColor5,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 80) * 0.8,
                    child: Assets.images.imgSleepHomeBackground.image(
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: LocaleKeys.sleep.appText(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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

  RoutineModel? _getNextRoutine(HomeState state) {
    final routines = state.childModel?.routinesList ?? [];

    // Filter only routines that have a valid timestamp
    final validRoutines = routines.where((r) => r.timeStamp != null).toList();
    if (validRoutines.isEmpty) return null;

    final now = DateTime.now();

    // Get only future routines
    final futureRoutines = validRoutines
        .where((r) => r.timeStamp!.isAfter(now))
        .toList();
    if (futureRoutines.isEmpty) return null;

    // Return the routine with the smallest timestamp
    futureRoutines.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    return futureRoutines.first;
  }

  DateTime? getNearestUpcomingTime(List<DateTime> timestamps) {
    final now = DateTime.now();

    // Filter only future times
    final futureTimes = timestamps.where((t) => t.isAfter(now)).toList();
    if (futureTimes.isEmpty) return null;

    // Sort and return nearest
    futureTimes.sort((a, b) => a.compareTo(b));
    return futureTimes.first;
  }

  Widget _sixthCardItem() {
    return BaseButton(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ReflectYourEmotions(),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 80.h,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: cardColor2,
            ),
            child: Stack(
              children: [
                Center(
                  child: "Family Feel Meter".appText(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ).appPadding(top: 20),

          Positioned(
            top: -0,
            left: 30,
            child: Row(
              children: [
                SizedBox(
                  child: Assets.icons.icFamilyFeelMeter.image(
                    fit: BoxFit.fill,
                    height: 90.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
