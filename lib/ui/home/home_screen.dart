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
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF6F0FF),
                  Color(0xFFFFF0F5),
                  Color(0xFFF9FAFB),
                  Color(0xFFF9FAFB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                color: primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.spaceH,
                      _heroDashboard(state),
                      16.spaceH,
                      _dailyInsightStrip(state),
                      24.spaceH,
                      "Quick Actions".appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.black87,
                      ).appPadding(left: 20, right: 20),
                      12.spaceH,
                      _quickActionsGrid(),
                      24.spaceH,
                      "Family Wellness".appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.black87,
                      ).appPadding(left: 20, right: 20),
                      12.spaceH,
                      _wellnessHub(),
                      40.spaceH,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _heroDashboard(HomeState state) {
    RoutineModel? routine = _getNextRoutine(state);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // Greeting & Profile
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Assets.icons.icProfileIcon2.image(
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
              ),
              16.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Hello, ${state.userModel?.parentName ?? ""}!".appText(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                    4.spaceH,
                    "Nurturing ${state.childModel?.childName ?? ""} (${state.childModel?.childAge ?? ""})"
                        .appText(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                  ],
                ),
              ),
            ],
          ),
          20.spaceH,
          // Streak & Schedule Row
          Row(
            children: [
              // Schedule Block
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocaleKeys.nextSchedule.tr().appText(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                      6.spaceH,
                      if (routine != null) ...[
                        DateFormat('hh:mm a').format(routine.timeStamp!).appText(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                        2.spaceH,
                        routine.description!.appText(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        "No Routines".appText(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade700,
                        ),
                        2.spaceH,
                        "All clear for now".appText(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                      8.spaceH,
                      BaseButton(
                        child: Row(
                          children: [
                            LocaleKeys.viewSchedule.tr().appText(
                              fontWeight: FontWeight.w700,
                              color: sliderTrackColor2,
                              fontSize: 12,
                            ),
                            4.spaceW,
                            const Icon(Icons.arrow_forward_rounded, size: 14, color: sliderTrackColor2),
                          ],
                        ),
                        onTap: () {
                          context.read<BaseCubit>().changeProps(bottomNavigationIndex: 1);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              16.spaceW,
              // Streak Block
              BaseButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const YourStreakScreen()),
                  );
                },
                child: Container(
                  width: 110,
                  height: 125,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -15,
                         child: Assets.icons.icStreakFire.image(height: 70, width: 70),
                      ),
                      Positioned(
                        bottom: 16,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                ((state.userModel?.streak ?? 0).toString()).appText(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.orange.shade800,
                                ),
                                2.spaceW,
                                ((state.userModel?.streak ?? 0) >= 1 ? "Day" : "Days").appText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange.shade800,
                                ),
                              ],
                            ),
                            "Streak!".appText(
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              color: Colors.orange.shade600,
                              letterSpacing: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dailyInsightStrip(HomeState state) {
    if (state.todayParentingTip.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.tips_and_updates_rounded, color: Colors.teal.shade600, size: 20),
          ),
          12.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleKeys.dailyParentingTip.tr().appText(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.teal.shade700,
                  letterSpacing: 0.5,
                ),
                4.spaceH,
                state.todayParentingTip.appText(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.learnPlay.tr(),
                  asset: Assets.icons.icPlayActivityIcon,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConnectDetailScreen())),
                ),
              ),
              16.spaceW,
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.trackKidBehaviour.tr(),
                  asset: Assets.icons.icPositiveBehavior,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewBehaviorScreen())),
                ),
              ),
            ],
          ),
          16.spaceH,
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.familySync.tr(),
                  asset: Assets.icons.icDailySchedulePlannerIcon,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EssentialsScreen())),
                ),
              ),
              16.spaceW,
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.howAreWeFeeling.tr(),
                  asset: Assets.icons.icDailyEmotionCheckIcon,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DailyMoodCheckInScreen())),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required AssetGenImage asset,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 110.h,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                shape: BoxShape.circle,
              ),
              child: asset.image(height: 38, width: 38),
            ),
            12.spaceH,
            title.appText(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black87,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _wellnessHub() {
    return Column(
      children: [
        // Sleep Summary
        BaseButton(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SleepSummaryScreen())),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                 BoxShadow(
                   color: primaryColor.withValues(alpha: 0.05),
                   blurRadius: 20,
                   offset: const Offset(0, 8),
                 ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.bedtime_rounded, size: 28, color: Colors.indigo),
                ),
                16.spaceW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocaleKeys.sleep.tr().appText(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      2.spaceH,
                      "Track restful nights & patterns".appText(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        16.spaceH,
        // Family Feel Meter
        BaseButton(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReflectYourEmotions())),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                 BoxShadow(
                   color: primaryColor.withValues(alpha: 0.05),
                   blurRadius: 20,
                   offset: const Offset(0, 8),
                 ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Assets.icons.icFamilyFeelMeter.image(height: 28),
                ),
                16.spaceW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Family Feel Meter".appText(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                      2.spaceH,
                      "Reflect and connect emotionally".appText(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
              ],
            ),
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
    final validRoutines = routines.where((r) => r.timeStamp != null).toList();
    if (validRoutines.isEmpty) return null;
    final now = DateTime.now();
    final futureRoutines = validRoutines.where((r) => r.timeStamp!.isAfter(now)).toList();
    if (futureRoutines.isEmpty) return null;
    futureRoutines.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    return futureRoutines.first;
  }
}
