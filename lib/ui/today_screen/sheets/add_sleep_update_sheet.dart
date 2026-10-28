import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/snack_bar.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

Future<void> showAddSleepUpdateSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.75,
    ),
    builder: (BuildContext context) => const AddSleepUpdateSheet(),
  );
}

class AddSleepUpdateSheet extends StatelessWidget {
  const AddSleepUpdateSheet({super.key});

  Future<void> _pickTime(BuildContext context, bool isWakeUp) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final DateTime now = DateTime.now();
      final DateTime dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final String formatted = DateFormat('hh:mm a').format(dt);
      if (isWakeUp) {
        context.read<TodayCubit>().setWokeUpTime(formatted);
      } else {
        context.read<TodayCubit>().setFellAsleepTime(formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        if (state.duplicateSleepLogDetected != null) {
          final SleepLogModel dup = state.duplicateSleepLogDetected!;
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: "Overlapping sleep entry".appText(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              content:
                  "An existing sleep entry was already logged around ${dup.fellAsleepTime ?? 'this time'} \u2013 ${dup.wokeUpTime ?? ''}. Do you want to add a separate entry anyway?"
                      .appText(fontSize: 14.sp),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().clearDuplicateSleepAlert();
                  },
                  child: "Cancel".appText(color: greyColor4),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().updateDuplicateSleepLog();
                  },
                  child: "Edit existing".appText(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TodayCubit>().saveSleepLog(forceSave: true);
                  },
                  child: "Save as separate".appText(
                    color: greyColor8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
          return;
        }

        state.saveStatus.whenOrNull(
          data: (dynamic data) {
            Navigator.pop(context);
            if (data == 'offline_queued') {
              showSnackBar(
                message: "Saved offline. Will sync when reconnected.",
                type: SnackBarType.SUCCESS,
              );
            } else {
              if (state.didForecastChangeSignificantly) {
                showInstantResultSheet(
                  context,
                  title: "Sleep update recorded",
                  reason: state.forecastChangeReason.isNotEmpty
                      ? state.forecastChangeReason
                      : "Today's sleep timing has updated tonight's settling window by 15+ minutes.",
                  action: "Check updated sleep plan",
                  actionSubtitle: "Wind-down timing reflects latest rest data.",
                );
              }
              showSnackBar(
                message: LocaleKeys.sleepLogSaved.tr(),
                type: SnackBarType.SUCCESS,
              );
            }
          },
          error: (Exception error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, TodayState state) {
        String? napTimeStr;
        if (state.napStartTime != null && state.napEndTime != null) {
          napTimeStr = "${state.napStartTime} \u2013 ${state.napEndTime}";
        } else if (state.napStartTime != null) {
          napTimeStr = "${state.napStartTime} \u2013 HH:MM";
        } else if (state.napEndTime != null) {
          napTimeStr = "HH:MM \u2013 ${state.napEndTime}";
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: greyColor7,
                      ),
                    ),
                  ],
                ),
                12.spaceH,
                "Sleep update".appText(
                  fontSize: 28.sp,
                  fraunces: true,
                  textAlign: TextAlign.start,
                ),
                12.spaceH,
                "Takes about twenty seconds".appText(
                  color: greyColor,
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                ),
                24.spaceH,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTimeInput(
                        label: "FELL ASLEEP",
                        time: state.fellAsleepTime,
                        isError:
                            state.showSleepUpdateErrors &&
                            state.fellAsleepTime == null,
                        errorText: "Required",
                        onTap: () => _pickTime(context, false),
                      ),
                    ),
                    12.spaceW,
                    Expanded(
                      child: _buildTimeInput(
                        label: "WOKE UP",
                        time: state.wokeUpTime,
                        isError:
                            state.showSleepUpdateErrors &&
                            state.wokeUpTime == null,
                        errorText: "Required",
                        onTap: () => _pickTime(context, true),
                      ),
                    ),
                  ],
                ),
                24.spaceH,
                _buildTimeInput(
                  label: "NAP STARTED & ENDED",
                  time: napTimeStr,
                  isError: false,
                  isEditable: false,
                  onTap: null,
                  dummyText: "HH:MM AM - HH:MM PM",
                ),
                24.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Night waking".appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    CupertinoSwitch(
                      value: state.isNightWaking,
                      onChanged: (value) =>
                          context.read<TodayCubit>().toggleNightWaking(value),
                      activeTrackColor: primaryColor,
                    ),
                  ],
                ),
                24.spaceH,
                "SLEEP QUALITY".appText(
                  color: secondaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                  letterSpacing: 1.2,
                ),
                12.spaceH,
                Row(
                  children: List.generate(
                    5,
                    (index) => GestureDetector(
                      onTap: () =>
                          context.read<TodayCubit>().setSleepQuality(index),
                      child: Container(
                        height: 24.h,
                        width: 24.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (state.sleepQualityIndex >= 0 &&
                                  index <= state.sleepQualityIndex)
                              ? secondaryColor
                              : greyColor11,
                        ),
                      ),
                    ),
                  ),
                ),
                24.spaceH,
                AppButton(
                  isLoading: state.isLoading,
                  title: "Save update",
                  onTap: () {
                    if (state.fellAsleepTime == null ||
                        state.wokeUpTime == null) {
                      context.read<TodayCubit>().triggerSleepUpdateErrors();
                    } else {
                      context.read<TodayCubit>().saveSleepLog();
                    }
                  },
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                ),
                24.spaceH,
              ],
            ).appPadding(all: 16.r),
          ),
        );
      },
    );
  }

  Widget _buildTimeInput({
    required String label,
    required String? time,
    required bool isError,
    String? errorText,
    bool isEditable = true,
    VoidCallback? onTap,
    String dummyText = "HH:MM AM",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isEditable ? onTap : null,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: isError ? Colors.red : greyColor12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: label.appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: isError ? Colors.red : greyColor,
                        letterSpacing: 1.2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (isError)
                      Icon(Icons.error, color: Colors.red, size: 16.sp),
                  ],
                ),
                4.spaceH,
                (time ?? dummyText).appText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: time == null ? greyColor4 : blackTextColor,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        if (isError) ...[
          4.spaceH,
          (errorText ?? "Please select time").appText(
            fontSize: 12.sp,
            color: Colors.red,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
          ),
        ],
      ],
    );
  }
}
