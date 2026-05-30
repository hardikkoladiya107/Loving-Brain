import 'package:easy_localization/easy_localization.dart';
import '../../generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/energy_bridge/bloc/energy_bridge_cubit.dart';
import 'package:loving_brain/ui/energy_bridge/bloc/energy_bridge_state.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class FamilyMeterStateDetailScreen extends StatefulWidget {
  const FamilyMeterStateDetailScreen({super.key});

  @override
  State<FamilyMeterStateDetailScreen> createState() =>
      _FamilyMeterStateDetailScreenState();
}

class _FamilyMeterStateDetailScreenState
    extends State<FamilyMeterStateDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, HomeState state) {},
      builder: (BuildContext context, HomeState state) {
        final String childName = state.childModel?.childName ?? 'Child';
        final ChildState? currentState = state.childModel?.childState;
        final String updatedText = _buildUpdatedText(
          state.childModel?.stateUpdatedAt,
        );
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: LocaleKeys.stateDetail.tr().appText(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: const Color(0xFF2F2A44),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(
                            0xFF2F2A44,
                          ).withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              currentState?.emoji ?? '💭',
                              style: TextStyle(fontSize: 28.sp),
                            ),
                            10.w.spaceW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  childName.appText(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF26223A),
                                  ),
                                  4.h.spaceH,
                                  (currentState?.label ?? 'Nothing logged yet')
                                      .appText(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            currentState?.color ??
                                            Colors.grey.shade600,
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        16.h.spaceH,
                        (currentState?.explanationText ??
                                'How is $childName feeling right now?')
                            .appText(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF47425E),
                              textAlign: TextAlign.start,
                            ),
                        10.h.spaceH,
                        BlocBuilder<EnergyBridgeCubit, EnergyBridgeState>(
                          builder:
                              (
                                BuildContext context,
                                EnergyBridgeState energyBridgeState,
                              ) {
                                final String timerText = _buildTimerText(
                                  energyBridgeState,
                                );
                                if (timerText.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return timerText.appText(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6A5A9A),
                                );
                              },
                        ),
                        8.h.spaceH,
                        updatedText.appText(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BaseButton(
                    onTap: () =>
                        context.push(RoutePaths.familyMeterStatePicker),
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF6A24B8), Color(0xFF8F58D7)],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: LocaleKeys.updateState.tr().appText(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  18.h.spaceH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _buildUpdatedText(DateTime? updatedAt) {
    if (updatedAt == null) {
      return 'Updated just now';
    }
    final Duration diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 1) {
      return 'Updated just now';
    }
    if (diff.inMinutes < 60) {
      return 'Last updated ${diff.inMinutes} minutes ago';
    }
    if (diff.inHours < 24) {
      return 'Last updated ${diff.inHours} hours ago';
    }
    return 'Last updated ${diff.inDays} days ago';
  }

  String _buildTimerText(EnergyBridgeState energyBridgeState) {
    if (energyBridgeState.timer == null) {
      return '';
    }
    if (energyBridgeState.timer!.isActive &&
        energyBridgeState.timer!.fireAt != null) {
      final int minutesLeft = energyBridgeState.timer!.fireAt!
          .difference(DateTime.now())
          .inMinutes
          .clamp(0, energyBridgeState.timer!.durationMinutes);
      return '~$minutesLeft mins before shift';
    }
    return '';
  }
}
