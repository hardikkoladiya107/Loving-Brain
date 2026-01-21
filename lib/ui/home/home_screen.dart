import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/routine_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/daily_mood_check_in/daily_mood_check_in_screen.dart';
import 'package:loving_brain/ui/essentials/essentials_screen.dart';
import 'package:loving_brain/ui/sleep_summary/sleep_summary_screen.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/your_streak/your_streak_screen.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../base_screen/bloc/base_cubit.dart';
import '../new_behavior/new_behavior_screen.dart';
import '../connect_detail/connect_detail_screen.dart';
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
                8.spaceH,
                _fourthCardItem(state),
                8.spaceH,
                _fifthCardItem(),
                8.spaceH,
                _sixthCardItem(),
                20.spaceH,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            aiQuestionCardColor3,
            aiQuestionCardColor3.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          14.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              14.spaceW,
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Assets.icons.icProfileIcon2.image(
                  height: 54,
                  width: 54,
                  fit: BoxFit.contain,
                ),
              ),
              14.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Hello, ${state.userModel?.parentName ?? ""}!".appText(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    4.spaceH,
                    "Ready to nurture ${state.childModel?.childName ?? ""}'s journey?\n(Child: ${state.childModel?.childName ?? ""}, ${state.childModel?.childAge ?? ""} old)"
                        .appText(
                          fontSize: 13,
                          textAlign: TextAlign.start,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                  ],
                ),
              ),
              10.spaceW,
            ],
          ),
          10.spaceH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              14.spaceW,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (routine != null)
                        LocaleKeys.nextSchedule.tr().appText(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      if (routine != null) ...[
                        4.spaceH,
                        DateFormat(
                          'hh:mm a',
                        ).format(routine.timeStamp!).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                        routine.description!.appText(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ] else
                        "No upcoming routines".appText(
                          fontSize: 12,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                    ],
                  ),
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
                      bottom: 15,
                      right: 0,
                      left: 0,
                      child: Center(
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            ((state.userModel?.streak ?? 0).toString()).appText(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                            2.spaceW,
                            ((state.userModel?.streak ?? 0) >= 1 ? "Day" : "Days")
                                .appText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: "Streak!".appText(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.spaceW,
            ],
          ),
          12.spaceH,
          Row(
            children: [
              14.spaceW,
              BaseButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      LocaleKeys.viewSchedule.tr().appText(
                        fontWeight: FontWeight.w700,
                        color: sliderTrackColor2,
                        fontSize: 13,
                      ),
                      8.spaceW,
                      Icon(Icons.arrow_forward_rounded, size: 16, color: sliderTrackColor2),
                    ],
                  ),
                ),
                onTap: () {
                  context.read<BaseCubit>().changeProps(
                    bottomNavigationIndex: 1,
                  );
                },
              ),
            ],
          ),
          14.spaceH,
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
            title: LocaleKeys.learnPlay.tr(),
            icon: Icons.palette_outlined,
            gradient: const LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconColor: Colors.blue.shade700,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConnectDetailScreen(),
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
            gradient: const LinearGradient(
              colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconColor: Colors.green.shade700,
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
    AssetGenImage? asset,
    IconData? icon,
    required GestureTapCallback onTap,
    Gradient? gradient,
    Color? iconColor,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          gradient: gradient ?? LinearGradient(colors: [greyColor, Colors.grey.shade300]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title.appText(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
            10.spaceH,
            if (icon != null)
              Icon(icon, size: 30.r, color: iconColor ?? Colors.black87)
            else if (asset != null)
              asset.image(height: 30.r),
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
            title: LocaleKeys.familySync.tr(),
            asset: Assets.images.imgSleep,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)], // Soft orange
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
            gradient: const LinearGradient(
              colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)], // Soft Purple
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DailyMoodCheckInScreen(),
                ),
              );
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
    Gradient? gradient,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient ?? LinearGradient(colors: [aiQuestionCardColor2, aiQuestionCardColor2]),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title.appText(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _fourthCardItem(HomeState state) {
    return BaseButton(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // Cyan/Teal
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
             BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
             ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LocaleKeys.dailyParentingTip.tr().appText(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.teal.shade800,
            ),
            4.spaceH,
            Row(
              children: [
                Expanded(
                  child: state.todayParentingTip.appText(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal.shade900,
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
        height: 70.h,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)], // Light Yellow
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
          ),
          boxShadow: [
             BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
             ),
          ],
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.brown.shade700,
              ),
            ),
          ],
        ),
      ),
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
            height: 70.h,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)], // Red/Pink
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                 BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                 ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: "Family Feel Meter".appText(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade900,
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
                    height: 80.r,
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
