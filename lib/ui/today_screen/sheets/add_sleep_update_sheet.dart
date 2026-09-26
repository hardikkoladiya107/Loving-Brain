import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

void showAddSleepUpdateSheet(BuildContext context) {
  final cubit = context.read<TodayCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.75,
    ),
    builder: (context) =>
        BlocProvider.value(value: cubit, child: const AddSleepUpdateSheet()),
  );
}

class AddSleepUpdateSheet extends StatelessWidget {
  const AddSleepUpdateSheet({super.key});

  Future<void> _pickTime(BuildContext context, bool isWakeUp) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
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
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final formatted = DateFormat('hh:mm a').format(dt);
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
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
          showInstantResultSheet(context);
        }
      },
      builder: (context, state) {
        String? napTimeStr;
        if (state.fellAsleepTime != null && state.wokeUpTime != null) {
          napTimeStr = "${state.fellAsleepTime} \u2013 ${state.wokeUpTime}";
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                children: [
                  Expanded(
                    child: _buildTimeInput(
                      label: "FELL ASLEEP",
                      time: state.fellAsleepTime,
                      isError:
                          state.showSleepUpdateErrors &&
                          state.fellAsleepTime == null,
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
                      onTap: () => _pickTime(context, true),
                    ),
                  ),
                ],
              ),
              24.spaceH,
              _buildTimeInput(
                label: "NAP STARTED & ENDED",
                time: napTimeStr,
                isError: state.showSleepUpdateErrors && napTimeStr == null,
                isEditable: false,
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
                        color: index <= state.sleepQualityIndex
                            ? secondaryColor
                            : greyColor11,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                isLoading: state.isLoading,
                title: "Save update",
                onTap: () {
                  if (state.fellAsleepTime == null ||
                      state.wokeUpTime == null) {
                    context.read<TodayCubit>().triggerSleepUpdateErrors();
                  } else {
                    context.read<TodayCubit>().saveUpdate();
                  }
                },
                backgroundColor: primaryColor,
                textColor: Colors.white,
              ),
              24.spaceH,
            ],
          ).appPadding(all: 16),
        );
      },
    );
  }

  Widget _buildTimeInput({
    required String label,
    required String? time,
    required bool isError,
    bool isEditable = true,
    VoidCallback? onTap,
    String dummyText = "HH:MM AM",
  }) {
    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isError ? Colors.red : greyColor12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label.appText(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: greyColor,
                  letterSpacing: 1.2,
                ),
                if (isError) Icon(Icons.error, color: Colors.red, size: 16.sp),
              ],
            ),
            4.spaceH,
            (time ?? dummyText).appText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: time == null ? greyColor11 : blackTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
