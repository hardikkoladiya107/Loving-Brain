import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/energy_bridge_cubit.dart';
import 'bloc/energy_bridge_state.dart';

class EnergyBridgeScreen extends StatefulWidget {
  const EnergyBridgeScreen({super.key});

  @override
  State<EnergyBridgeScreen> createState() => _EnergyBridgeScreenState();
}

class _EnergyBridgeScreenState extends State<EnergyBridgeScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnergyBridgeCubit>().init();
    });
    // Start a ticker to rebuild the UI every minute to update the countdown
    _ticker = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnergyBridgeCubit, EnergyBridgeState>(
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () => EasyLoading.show(),
          data: (data) => EasyLoading.dismiss(),
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (context, state) {
        final bool isActive = state.timer?.isActive ?? false;
        final bool isFired = state.timer?.fired ?? false;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: LocaleKeys.energyBridgeTitle.tr().appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF6F3CC3),
                  Color(0xFF9C76DA),
                  Color(0xFFEDE3FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: <double>[0.0, 0.42, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: <Widget>[
                    24.h.spaceH,
                    _headerCard(isActive),
                    18.h.spaceH,
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(32.r),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _heroIcon(isActive),
                              14.h.spaceH,
                              (isActive
                                      ? LocaleKeys.energyBridgeSessionActive.tr()
                                      : LocaleKeys.energyBridgeTantrumStopper.tr())
                                  .appText(
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                    textAlign: TextAlign.center,
                                  ),
                              8.h.spaceH,
                              LocaleKeys.energyBridgeIntro.tr().appText(
                                fontSize: 13.sp,
                                color: Colors.grey.shade700,
                                textAlign: TextAlign.center,
                                height: 1.5,
                              ),
                              24.h.spaceH,
                              if (isActive)
                                _buildActiveTimer(state)
                              else if (isFired)
                                _buildFiredState()
                              else
                                _buildStartButton(context),
                              18.h.spaceH,
                              _quickTipsCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    18.h.spaceH,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerCard(bool isActive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: const Color(0xFF7A46C9),
              size: 24.sp,
            ),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LocaleKeys.energyBridgeMode.tr().appText(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
                2.h.spaceH,
                (isActive
                        ? LocaleKeys.energyBridgeRunning.tr()
                        : LocaleKeys.energyBridgeReady.tr())
                    .appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                    ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF17B26A).withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child:
                (isActive
                        ? LocaleKeys.energyBridgeActiveBadge.tr()
                        : LocaleKeys.energyBridgeIdleBadge.tr())
                    .appText(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.sp,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _heroIcon(bool isActive) {
    return Container(
      width: 94.w,
      height: 94.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF7D4BCE), Color(0xFFB287E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF7D4BCE).withValues(alpha: 0.34),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        isActive
            ? Icons.self_improvement_rounded
            : Icons.play_circle_fill_rounded,
        color: Colors.white,
        size: 46.sp,
      ),
    );
  }

  Widget _quickTipsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F1FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8DEFA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.tips_and_updates_rounded,
            color: const Color(0xFF7A46C9),
            size: 18.sp,
          ),
          8.w.spaceW,
          Expanded(
            child: LocaleKeys.energyBridgeTip.tr().appText(
              fontSize: 11.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimer(EnergyBridgeState state) {
    final DateTime? fireAt = state.timer?.fireAt;
    final DateTime? startedAt = state.timer?.startedAt;
    final int durationMinutes = state.timer?.durationMinutes ?? 105;
    final int elapsedMinutes = startedAt == null
        ? 0
        : DateTime.now().difference(startedAt).inMinutes;
    final int remainingMinutes = fireAt == null
        ? durationMinutes
        : fireAt.difference(DateTime.now()).inMinutes;
    final int clampedElapsed = elapsedMinutes.clamp(0, durationMinutes);
    final double progress = durationMinutes == 0
        ? 0
        : clampedElapsed / durationMinutes;

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF7A46C9).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: LocaleKeys.energyBridgeElapsed.tr().appText(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  "${clampedElapsed}m / ${durationMinutes}m".appText(
                    fontSize: 12.sp,
                    color: const Color(0xFF7A46C9),
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
              10.h.spaceH,
              ClipRRect(
                borderRadius: BorderRadius.circular(99.r),
                child: LinearProgressIndicator(
                  minHeight: 10.h,
                  value: progress,
                  backgroundColor: const Color(0xFFDCCBF7),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7A46C9),
                  ),
                ),
              ),
              14.h.spaceH,
              if (remainingMinutes > 0) ...[
                LocaleKeys.energyBridgeNotificationIn
                    .tr(
                      namedArgs: <String, String>{
                        "minutes": remainingMinutes.toString(),
                      },
                    )
                    .appText(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
              ] else ...[
                LocaleKeys.energyBridgeCardActive.tr().appText(
                  fontSize: 13.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w800,
                ),
              ],
            ],
          ),
        ),
        18.h.spaceH,
        BaseButton(
          onTap: () {
            context.read<EnergyBridgeCubit>().stopTimer();
          },
          child: Container(
            height: 54.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFFFBAC2), width: 1.3),
            ),
            child: Center(
              child: LocaleKeys.energyBridgeCancelTimer.tr().appText(
                color: Colors.red.shade500,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return BaseButton(
      onTap: () {
        context.read<EnergyBridgeCubit>().startTimer();
      },
      child: Container(
        height: 54.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF7A46C9), Color(0xFFB287E6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF7A46C9).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: LocaleKeys.energyBridgeStartPlay.tr().appText(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildFiredState() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFFFE69C)),
          ),
          child: LocaleKeys.energyBridgeFiredMessage.tr().appText(
            fontSize: 13.sp,
            color: Colors.brown.shade700,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            height: 1.4,
          ),
        ),
        16.h.spaceH,
        _buildStartButton(context),
      ],
    );
  }
}
