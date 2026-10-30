import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/core/brainy_entry_context.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_tantrums_update_sheet.dart';
import 'package:loving_brain/ui/today_screen/sheets/view_support_sheet.dart';
import 'package:loving_brain/ui/today_screen/widgets/action_grid.dart';
import 'package:loving_brain/ui/today_screen/widgets/add_sleep_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/heads_up_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/main_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/nice_work_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/noticed_row.dart';
import 'package:loving_brain/ui/today_screen/widgets/still_learning_patterns_card.dart';
import 'package:loving_brain/ui/today_screen/widgets/today_header.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';
import 'package:loving_brain/ui/widget/offline_banner.dart';

import 'bloc/today_cubit.dart';
import 'bloc/today_state.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodayCubit>().init();
    });

    Connectivity().checkConnectivity().then((List<ConnectivityResult> results) {
      if (!mounted) return;
      setState(() {
        _isOffline =
            results.isEmpty ||
            results.every(
              (ConnectivityResult r) => r == ConnectivityResult.none,
            );
      });
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (!mounted) return;
      setState(() {
        _isOffline =
            results.isEmpty ||
            results.every(
              (ConnectivityResult r) => r == ConnectivityResult.none,
            );
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Map<String, dynamic> _headsUpBrainyContext(TodayState state) {
    return BrainyEntryContext.fromHeadsUp(
      headline: state.headsUpHeadline,
      reason: state.headsUpReason,
      windowStart: state.headsUpWindowStart,
      windowEnd: state.headsUpWindowEnd,
      confidenceLabel: state.confidenceLevel,
      childName: state.childName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayCubit, TodayState>(
      builder: (BuildContext context, TodayState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -283,
                top: -283,
                child: IgnorePointer(
                  child: Container(
                    width: 450,
                    height: 450,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cardColor4.withValues(alpha: 0.5),
                          cardColor4.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                      child: const TodayHeader(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isOffline) ...[
                              16.spaceH,
                              const OfflineBanner(isVisible: true),
                            ],
                            SizedBox(height: 24.h),
                            if (state.isLoading &&
                                state.activeChildId.isEmpty) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 48.h),
                                child: const Center(
                                  child: AppLoadingIndicator(),
                                ),
                              ),
                            ] else if (state.activeChildId.isEmpty) ...[
                              _buildNoChildCard(context),
                            ] else if (state.mode == TodayMode.newParent) ...[
                              if (state.showHealthHeadsUp) ...[
                                const HeadsUpCard(isHealthNote: true),
                                SizedBox(height: 16.h),
                              ],
                              ..._learningHomeCards(context, state),
                              SizedBox(height: 24.h),
                              const ActionGrid(),
                              SizedBox(height: 16.h),
                              AppButton(
                                title: 'Ask Brainy',
                                onTap: () {
                                  context.push(
                                    RoutePaths.brainyConversation,
                                    extra: BrainyEntryContext.gettingStarted(),
                                  );
                                },
                                backgroundColor: Colors.transparent,
                                textColor: greyColor9,
                              ),
                            ] else ...[
                              if (state.showBehaviourHeadsUp) ...[
                                const HeadsUpCard(),
                                SizedBox(height: 16.h),
                                AppButton(
                                  title: 'Ask Brainy',
                                  onTap: () {
                                    context.push(
                                      RoutePaths.brainyConversation,
                                      extra: _headsUpBrainyContext(state),
                                    );
                                  },
                                  backgroundColor: Colors.transparent,
                                  textColor: greyColor9,
                                ),
                                SizedBox(height: 16.h),
                              ],
                              if (state.showHealthHeadsUp &&
                                  !state.showBehaviourHeadsUp) ...[
                                const HeadsUpCard(isHealthNote: true),
                                SizedBox(height: 16.h),
                              ],
                              const MainCard(),
                              SizedBox(height: 24.h),
                              if (state.showSupportOffer) ...[
                                AppButton(
                                  title: 'View support',
                                  onTap: () {
                                    showViewSupportSheet(
                                      context,
                                      daysCount: state.supportInconsistentDays,
                                    );
                                  },
                                  backgroundColor: Colors.white,
                                  textColor: greyColor9,
                                ),
                                SizedBox(height: 16.h),
                              ],
                              if (state.hasMultiDayPatterns) ...[
                                if (state.showBehaviourHeadsUp ||
                                    state.showNoticed) ...[
                                  const NoticedRow(),
                                  SizedBox(height: 24.h),
                                ],
                                if (state.showNiceWork) ...[
                                  const NiceWorkCard(),
                                  SizedBox(height: 24.h),
                                ],
                              ] else ...[
                                const StillLearningPatternsCard(),
                                SizedBox(height: 24.h),
                              ],
                              const ActionGrid(),
                            ],
                            SizedBox(height: 100.h),
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

  List<Widget> _learningHomeCards(BuildContext context, TodayState state) {
    final Widget sleepCard = const AddSleepCard();
    final Widget behaviourButton = AppButton(
      title: 'Add behaviour update',
      onTap: () {
        showAddTantrumsUpdateSheet(context);
      },
      backgroundColor: Colors.white,
      textColor: greyColor9,
    );

    if (state.prioritiseSleepFirst) {
      return <Widget>[sleepCard, SizedBox(height: 16.h), behaviourButton];
    }
    return <Widget>[behaviourButton, SizedBox(height: 16.h), sleepCard];
  }

  Widget _buildNoChildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFF3ECE7)),
      ),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0E5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care_rounded,
              color: primaryColor,
              size: 32.sp,
            ),
          ),
          16.spaceH,
          'No child profile linked'.appText(
            fontSize: 22.sp,
            color: greyColor9,
            fraunces: true,
          ),
          10.spaceH,
          'You are not currently linked to a child. You can create a new child profile to start tracking routines, or ask your partner to send an invite.'
              .appText(
                fontSize: 14.sp,
                color: greyColor,
                textAlign: TextAlign.center,
                height: 1.4,
              ),
          24.spaceH,
          AppButton(
            title: 'Add child profile',
            onTap: () async {
              final TodayCubit cubit = context.read<TodayCubit>();
              await context.push(
                RoutePaths.childProfilePath(
                  preferences.getUserModel()?.uid ?? '',
                  fromManageChildren: true,
                ),
              );
              cubit.init();
            },
          ),
        ],
      ),
    );
  }
}
