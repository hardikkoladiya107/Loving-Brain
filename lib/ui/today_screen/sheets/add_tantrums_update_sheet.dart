import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_choice_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/snack_bar.dart';
import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';
import 'instant_result_sheet.dart';

void showAddTantrumsUpdateSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => const AddTantrumsUpdateSheet(),
  );
}

class AddTantrumsUpdateSheet extends StatelessWidget {
  const AddTantrumsUpdateSheet({super.key});

  Future<void> _pickTime(BuildContext context) async {
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
      if (dt.isAfter(now)) {
        showSnackBar(
          message: "Please choose a time that isn't in the future.",
          type: SnackBarType.ERROR,
        );
        return;
      }
      final String formatted = DateFormat('hh:mm a').format(dt);
      context.read<TodayCubit>().setTantrumTime(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> triggers = <String>[
      "Hunger",
      "Tiredness",
      "Transition",
      "Unknown",
    ];

    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (_) {
            Navigator.pop(context);
            showInstantResultSheet(
              context,
              title: "Tantrum update logged",
              reason:
                  "Understanding difficult moments helps LovingBrain notice patterns in timing and what helps your child calm down.",
              action: "Explore Calm Plan",
              actionSubtitle:
                  "Proven responses ready for upcoming challenging windows.",
            );
            showSnackBar(
              message: LocaleKeys.tantrumLogSaved.tr(),
              type: SnackBarType.SUCCESS,
            );
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

        return DraggableScrollableSheet(
          initialChildSize: 0.94,
          minChildSize: 0.4,
          maxChildSize: 0.96,
          expand: false,
          builder: (BuildContext sheetCtx, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 4.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
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
                        onChanged: (String val) => context
                            .read<TodayCubit>()
                            .setTantrumWhatHappened(val),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        letterSpacing: 1.2,
                        textAlign: TextAlign.start,
                      ),
                      12.spaceH,
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4.h,
                          activeTrackColor: secondaryColor,
                          inactiveTrackColor: greyColor11,
                          thumbColor: Colors.white,
                          overlayColor: secondaryColor.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: state.tantrumIntensity,
                          onChanged: (double value) => context
                              .read<TodayCubit>()
                              .setTantrumIntensity(value),
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
                          Expanded(
                            child: "POSSIBLE TRIGGER".appText(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              letterSpacing: 1.2,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          if (isTriggersError)
                            Icon(Icons.error, color: Colors.red, size: 16.sp),
                        ],
                      ),
                      12.spaceH,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        children: List.generate(triggers.length, (int index) {
                          final String trigger = triggers[index];
                          final bool isSelected = state.selectedTantrumTriggers
                              .contains(trigger);
                          return AppChoiceChip(
                            label: trigger,
                            isSelected: isSelected,
                            isError: isTriggersError && !isSelected,
                            onTap: () => context
                                .read<TodayCubit>()
                                .toggleTantrumTrigger(trigger),
                          );
                        }),
                      ),
                      24.spaceH,
                      _buildTextInput(
                        label: "WHAT HELPED",
                        hint: "Holding her close",
                        isError: isWhatHelpedError,
                        icon: Icons.description_outlined,
                        onChanged: (String val) => context
                            .read<TodayCubit>()
                            .setTantrumWhatHelped(val),
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
                            context
                                .read<TodayCubit>()
                                .triggerTantrumUpdateErrors();
                          } else {
                            context.read<TodayCubit>().saveTantrumLog();
                          }
                        },
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                      ),
                      24.spaceH,
                    ],
                  ).appPadding(all: 16.r),
                ),
              ),
            );
          },
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
    required void Function(String) onChanged,
    IconData? icon,
  }) {
    return Container(
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
                  fontWeight: FontWeight.bold,
                  color: greyColor,
                  letterSpacing: 1.2,
                  textAlign: TextAlign.start,
                ),
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
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: greyColor9,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: getTextStyle(
                      fontSize: 16.sp,
                      color: greyColor4,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                    letterSpacing: 1.2,
                    textAlign: TextAlign.start,
                  ),
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
                  color: time == null ? greyColor4 : greyColor9,
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
