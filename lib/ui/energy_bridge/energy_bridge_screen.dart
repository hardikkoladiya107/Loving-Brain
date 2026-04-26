import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/model/api_result_status.dart';

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
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: "Energy Bridge".appText(
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
                colors: [Color(0xFF894BCD), Color(0xFFB185DB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 80.sp,
                            color: const Color(0xFF894BCD),
                          ),
                          16.h.spaceH,
                          "Tantrum Stopper".appText(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                          12.h.spaceH,
                          "We'll start a 120-minute timer and notify you at the 105-minute mark to help transition your child to a calm state."
                              .appText(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            textAlign: TextAlign.center,
                            height: 1.5,
                          ),
                          32.h.spaceH,
                          if (state.isTimerActive && state.startTime != null)
                            _buildActiveTimer(state)
                          else
                            _buildStartButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveTimer(EnergyBridgeState state) {
    final startDateTime = DateTime.fromMillisecondsSinceEpoch(state.startTime!);
    final elapsedMinutes = DateTime.now().difference(startDateTime).inMinutes;
    final remainingMinutes = 105 - elapsedMinutes;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF894BCD).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFF894BCD).withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              "Time Active".appText(
                fontSize: 14.sp,
                color: const Color(0xFF894BCD),
                fontWeight: FontWeight.w700,
              ),
              8.h.spaceH,
              "$elapsedMinutes min".appText(
                fontSize: 32.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF894BCD),
              ),
              if (remainingMinutes > 0) ...[
                8.h.spaceH,
                "Notification in $remainingMinutes min".appText(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ] else ...[
                8.h.spaceH,
                "Bridge Card is now active!".appText(
                  fontSize: 13.sp,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w800,
                ),
              ]
            ],
          ),
        ),
        24.h.spaceH,
        BaseButton(
          onTap: () {
            context.read<EnergyBridgeCubit>().stopTimer();
          },
          child: Container(
            height: 56.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: Colors.red.shade400, width: 2),
            ),
            child: Center(
              child: "Cancel Timer".appText(
                color: Colors.red.shade500,
                fontSize: 16.sp,
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
        height: 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF894BCD), Color(0xFFB185DB)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF894BCD).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: "Start High Energy Play".appText(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
