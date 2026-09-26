import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';
import 'package:intl/intl.dart';

void showAddTantrumsUpdateSheet(BuildContext context) {
  final cubit = context.read<TodayCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    builder: (context) =>
        BlocProvider.value(value: cubit, child: const AddTantrumsUpdateSheet()),
  );
}

class AddTantrumsUpdateSheet extends StatelessWidget {
  const AddTantrumsUpdateSheet({super.key});

  Future<void> _pickTime(BuildContext context) async {
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
      context.read<TodayCubit>().setTantrumTime(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> triggers = ["Hunger", "Tiredness", "Transition", "Unknown"];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
          showInstantResultSheet(context);
        }
      },
      builder: (context, state) {
        final bool isWhatHappenedError =
            state.showTantrumUpdateErrors &&
            state.tantrumWhatHappened.trim().isEmpty;
        final bool isTimeError =
            state.showTantrumUpdateErrors && state.tantrumTime == null;
        final bool isTriggersError =
            state.showTantrumUpdateErrors &&
            state.selectedTantrumTriggers.isEmpty;
        final bool isWhatHelpedError =
            state.showTantrumUpdateErrors &&
            state.tantrumWhatHelped.trim().isEmpty;

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
                "Tantrum update".appText(
                  fontSize: 28.sp,
                  fraunces: true,
                  textAlign: TextAlign.start,
                ),
                24.spaceH,
                _buildTextInput(
                  label: "WHAT HAPPENED",
                  hint: "Refused to leave the park",
                  isError: isWhatHappenedError,
                  onChanged: (val) =>
                      context.read<TodayCubit>().setTantrumWhatHappened(val),
                ),
                16.spaceH,
                _buildTimePickerInput(
                  context: context,
                  label: "APPROXIMATE TIME",
                  time: state.tantrumTime,
                  isError: isTimeError,
                  onTap: () => _pickTime(context),
                ),
                24.spaceH,
                "INTENSITY".appText(
                  color: secondaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                  letterSpacing: 1.2,
                ),
                12.spaceH,
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: secondaryColor,
                    inactiveTrackColor: greyColor11,
                    thumbColor: Colors.white,
                    overlayColor: secondaryColor.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: state.tantrumIntensity,
                    onChanged: (value) =>
                        context.read<TodayCubit>().setTantrumIntensity(value),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Mild".appText(color: greyColor, fontSize: 12.sp),
                    "Intense".appText(color: greyColor, fontSize: 12.sp),
                  ],
                ),
                24.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "POSSIBLE TRIGGER".appText(
                      color: secondaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.sp,
                      letterSpacing: 1.2,
                    ),
                    if (isTriggersError)
                      Icon(Icons.error, color: Colors.red, size: 16.sp),
                  ],
                ),
                12.spaceH,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(triggers.length, (index) {
                    final trigger = triggers[index];
                    final isSelected = state.selectedTantrumTriggers.contains(
                      trigger,
                    );
                    return GestureDetector(
                      onTap: () => context
                          .read<TodayCubit>()
                          .toggleTantrumTrigger(trigger),
                      child: Chip(
                        label: trigger.appText(
                          color: isSelected ? secondaryColor : Colors.black,
                        ),
                        backgroundColor: isSelected
                            ? indigoLight
                            : Colors.white,
                        side: BorderSide(
                          color: isErrorColor(isSelected, isTriggersError)
                              ? Colors.red
                              : (isSelected ? secondaryColor : greyColor12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    );
                  }),
                ),
                24.spaceH,
                _buildTextInput(
                  label: "WHAT HELPED",
                  hint: "Holding her close",
                  isError: isWhatHelpedError,
                  icon: Icons.description_outlined,
                  onChanged: (val) =>
                      context.read<TodayCubit>().setTantrumWhatHelped(val),
                ),
                24.spaceH,
                AppButton(
                  isLoading: state.isLoading,
                  title: "Save update",
                  onTap: () {
                    if (state.tantrumWhatHappened.trim().isEmpty ||
                        state.tantrumTime == null ||
                        state.selectedTantrumTriggers.isEmpty ||
                        state.tantrumWhatHelped.trim().isEmpty) {
                      context.read<TodayCubit>().triggerTantrumUpdateErrors();
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
          ),
        );
      },
    );
  }

  bool isErrorColor(bool isSelected, bool isError) {
    if (isError && !isSelected) return true;
    return false;
  }

  Widget _buildTextInput({
    required String label,
    required String hint,
    required bool isError,
    required Function(String) onChanged,
    IconData? icon,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: primaryColor, size: 20.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerInput({
    required BuildContext context,
    required String label,
    required String? time,
    required bool isError,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (time ?? "05:20 PM").appText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: time == null ? greyColor11 : blackTextColor,
                ),
                Icon(
                  Icons.access_time_filled,
                  color: primaryColor,
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
