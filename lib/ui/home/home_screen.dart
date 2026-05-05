import 'dart:async';
import 'dart:ui';

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
import 'package:loving_brain/ui/energy_bridge/energy_bridge_screen.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../base_screen/bloc/base_cubit.dart';
import '../new_behavior/new_behavior_screen.dart';
import '../reflect_your_emotions/reflect_your_emotions.dart';
import 'package:loving_brain/ui/energy_bridge/bloc/energy_bridge_cubit.dart';
import 'package:loving_brain/ui/energy_bridge/bloc/energy_bridge_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/core/home_time_greeting.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Timer? _bridgeTicker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<HomeCubit>().init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<EnergyBridgeCubit>().init();
    });
    // Refreshes time-based UI (greeting, bridge copy) at least once per minute.
    _bridgeTicker = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                color: primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.spaceH,
                      _heroDashboard(state),
                      // _dailyInsightStrip(state),
                      20.spaceH,
                      _bridgeCard(context),
                      20.spaceH,
                      "Jump Back In"
                          .appText(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Colors.black87,
                          )
                          .appPadding(left: 20, right: 20),
                      12.spaceH,
                      _quickActionsGrid(),
                      24.spaceH,
                      "Family Wellness"
                          .appText(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Colors.black87,
                          )
                          .appPadding(left: 20, right: 20),
                      20.spaceH,
                      _wellnessHub(),
                      120.spaceH,
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

  Widget _bridgeCard(BuildContext context) {
    return BlocBuilder<EnergyBridgeCubit, EnergyBridgeState>(
      builder: (context, energyState) {
        final timer = energyState.timer;
        if (timer == null) {
          return const SizedBox.shrink();
        }

        if (timer.fired) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFB3BA),
                  Color(0xFFFFDFBA),
                ], // Calming Pastel
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFB3BA).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.self_improvement_rounded,
                      color: Colors.orange.shade800,
                      size: 28.sp,
                    ),
                    8.w.spaceW,
                    "energyBridgeTimeToTransition".tr().appText(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.orange.shade900,
                    ),
                  ],
                ),
                8.h.spaceH,
                "energyBridgeTransitionBody".tr().appText(
                  fontSize: 13.sp,
                  color: Colors.orange.shade900.withValues(alpha: 0.8),
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
                16.h.spaceH,
                BaseButton(
                  onTap: () async {
                    // Placeholder video URL
                    final url = Uri.parse(
                      "https://www.youtube.com/watch?v=l_mAefX-q0c",
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.orange.shade600,
                          size: 20.sp,
                        ),
                        8.w.spaceW,
                        "energyBridgePlayCalmingVideo".tr().appText(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (timer.isActive && timer.fireAt != null) {
          final int minutesLeft = timer.fireAt!
              .difference(DateTime.now())
              .inMinutes
              .clamp(0, timer.durationMinutes);
          return Container(
            margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFE7D9FF), Color(0xFFF3EAFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB287E6).withValues(alpha: 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.bolt_rounded,
                  color: const Color(0xFF7A46C9),
                  size: 26.sp,
                ),
                10.w.spaceW,
                Expanded(
                  child: "energyBridgeMinutesBeforeShift"
                      .tr(
                        namedArgs: <String, String>{
                          "minutes": minutesLeft.toString(),
                        },
                      )
                      .appText(
                        fontSize: 14.sp,
                        color: const Color(0xFF4A2B7C),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _heroDashboard(HomeState state) {
    final RoutineModel? routine = _getNextRoutine(state);
    final int streakDays = state.userModel?.streak ?? 0;
    final String name = state.userModel?.parentName ?? "Parent";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A24B8), Color(0xFF894BCD), Color(0xFFA96EE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A24B8).withValues(alpha: 0.42),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Decorative orb — top right
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Decorative orb — bottom left
            Positioned(
              bottom: -40,
              left: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),

            // ── Main content ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row: greeting text + streak badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: greeting + name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${homeGreetingLocaleKey(DateTime.now()).tr()},",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                                letterSpacing: 0.2,
                              ),
                            ),
                            4.spaceH,
                            Text(
                              "$name!",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: -0.3,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.spaceW,
                      // Right: streak badge
                      BaseButton(
                        onTap: () => context.push(RoutePaths.yourStreak),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.icStreakFire.image(
                                height: 20,
                                width: 20,
                              ),
                              6.spaceW,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "$streakDays",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    "Days",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  20.spaceH,

                  // Schedule row inside translucent card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Calendar icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        14.spaceW,
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (routine != null) ...[
                                Text(
                                  DateFormat(
                                    'hh:mm a',
                                  ).format(routine.timeStamp!),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                3.spaceH,
                                Text(
                                  routine.description!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ] else ...[
                                Text(
                                  "Free Time",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                3.spaceH,
                                Text(
                                  "No upcoming schedule",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        10.spaceW,
                        // View button
                        BaseButton(
                          onTap: () => context.read<BaseCubit>().changeProps(
                            bottomNavigationIndex: 1,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              "View",
                              style: TextStyle(
                                color: Color(0xFF6A24B8),
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  title: LocaleKeys.howAreWeFeeling.tr(),
                  subtitle: "Daily mood check",
                  icon: Icons.favorite_rounded,
                  themeColor: Colors.purple.shade500,
                  onTap: () => context.push(RoutePaths.dailyMoodCheckIn),
                ),
              ),
              12.spaceW,
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.trackKidBehaviour.tr(),
                  subtitle: "Log behaviors",
                  icon: Icons.auto_awesome_rounded,
                  themeColor: Colors.green.shade500,
                  onTap: () => context.push(RoutePaths.newBehavior),
                ),
              ),
            ],
          ),
          12.spaceH,
          Row(
            children: [
              Expanded(
                child: _actionCard(
                  title: LocaleKeys.familySync.tr(),
                  subtitle: "Shared schedules",
                  icon: Icons.sync_rounded,
                  themeColor: Colors.orange.shade600,
                  onTap: () => context.push(RoutePaths.essentials),
                ),
              ),
              12.spaceW,
              Expanded(
                child: _actionCard(
                  title: "energyBridgeTitle".tr(),
                  subtitle: "energyBridgeConnectEnergy".tr(),
                  icon: Icons.bolt_rounded,
                  themeColor: Colors.blue.shade500,
                  onTap: () => context.push(RoutePaths.energyBridge),
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
    required String subtitle,
    required IconData icon,
    required Color themeColor,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 140.h,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Abstract background accent 1
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Abstract background accent 2
            Positioned(
              bottom: -40,
              right: 20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: themeColor, size: 28),
                  ),
                  // Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title.appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.black87,
                        maxLines: 2,
                        height: 1.2,
                      ),
                      4.spaceH,
                      subtitle.appText(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
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
          onTap: () => context.push(RoutePaths.sleepSummary),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 110.h,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2C3E50),
                  Color(0xFF0F2027),
                ], // Deep Night Sky
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF0F2027).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Faded background graphic on the right
                Positioned(
                  right: -20,
                  bottom: -20,
                  top: -20,
                  child: Assets.images.imgSleepHomeBackground.image(
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                // Text overlay
                Positioned(
                  left: 24,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocaleKeys.sleep.tr().appText(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      4.spaceH,
                      "Track restful nights".appText(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        10.spaceH,
        // Family Feel Meter
        BaseButton(
          onTap: () => context.push(RoutePaths.reflectYourEmotions),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 110.h,
            clipBehavior: Clip.none, // Allow meter to pop out top!
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Base
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF859B),
                          Color(0xFFFF416C),
                        ], // Beautiful Pink/Red
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF416C).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Family Feel Meter".appText(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        4.spaceH,
                        "Connect emotionally".appText(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                // Overlapping icon
                Positioned(
                  right: 15,
                  top: -15, // Pops out slightly
                  child: Assets.icons.icFamilyFeelMeter.image(height: 100.h),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bridgeTicker?.cancel();
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
    final futureRoutines = validRoutines
        .where((r) => r.timeStamp!.isAfter(now))
        .toList();
    if (futureRoutines.isEmpty) return null;
    futureRoutines.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    return futureRoutines.first;
  }
}
