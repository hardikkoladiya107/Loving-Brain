import 'package:go_router/go_router.dart';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../main.dart';
import '../../../model/api_result_status.dart';

class AddSleepLogDialog extends StatefulWidget {
  const AddSleepLogDialog({super.key});

  @override
  State<AddSleepLogDialog> createState() => _AddSleepLogDialogState();

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const AddSleepLogDialog(),
        );
      },
    );
  }
}

class _AddSleepLogDialogState extends State<AddSleepLogDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack);

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepSummaryCubit, SleepSummaryState>(
      listener: (context, state) {
        state.addSleepLogApiResult.whenOrNull(
          initial: () => EasyLoading.dismiss(),
          error: (error) => EasyLoading.dismiss(),
          loading: () => EasyLoading.show(),
          data: (data) {
            EasyLoading.dismiss();
            context.pop();
            context.read<SleepSummaryCubit>().reload();
          },
        );
      },
      builder: (context, state) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, const Color(0xFFF4F7FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Image
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FE),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFC3D4FE).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Assets.images.imgSleepMoon.image(width: 80),
                      ),
                      24.spaceH,

                      // Title
                      LocaleKeys.addSleepLog.tr().appText(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                      16.spaceH,

                      // Form Fields
                      _selectDate(state),
                      16.spaceH,
                      _bedTimeWakeUpTime(state),
                      16.spaceH,
                      _notes(),
                      32.spaceH,

                      // Save Button
                      _saveButton(state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: blueColor2,
            ),
          ),
          child: child!,
        );
      },
    );
    return date;
  }

  Future<DateTime?> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await _showDatePicker();
    if (pickedDate == null) return null;
    if (navigatorKey.currentContext != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: navigatorKey.currentContext!,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: blueColor2,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime == null) return null;
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
    return null;
  }

  Widget _dateField({
    required String hint,
    String? value,
    String? title,
    IconData? icon,
    GestureTapCallback? onTap,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          title.appText(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B5563),
          ),
          8.spaceH,
        ],
        BaseButton(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (errorText ?? "").isNotEmpty
                    ? Colors.red.withValues(alpha: 0.6)
                    : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF3F4F6).withValues(alpha: 0.7),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: blueColor2, size: 22),
                  12.spaceW,
                ],
                Expanded(
                  child: ((value ?? "").isNotEmpty ? value : hint)
                      .toString()
                      .appText(
                        color: (value ?? "").isNotEmpty
                            ? const Color(0xFF111827)
                            : const Color(0xFF9CA3AF),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        if ((errorText ?? "").isNotEmpty) ...[
          4.spaceH,
          (errorText ?? "").appText(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ],
    );
  }

  Widget _selectDate(SleepSummaryState state) {
    return _dateField(
      title: LocaleKeys.date.tr(),
      value: state.selectedDate != null ? formatDate(state.selectedDate!) : "",
      hint: LocaleKeys.selectDate.tr(),
      icon: Icons.calendar_today_rounded,
      errorText: state.selectedDateError,
      onTap: () async {
        DateTime? date = await _showDatePicker();
        if (navigatorKey.currentContext != null) {
          navigatorKey.currentContext!.read<SleepSummaryCubit>().changeProps(
                selectedDate: date,
              );
        }
      },
    );
  }

  Widget _bedTimeWakeUpTime(SleepSummaryState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _dateField(
            title: LocaleKeys.bedTime.tr(),
            value: state.selectedBedTime != null
                ? coParentScheduleTime(state.selectedBedTime!)
                : "",
            hint: LocaleKeys.selectDateTime.tr(),
            icon: Icons.nights_stay_rounded,
            errorText: state.bedTimeError,
            onTap: () async {
              DateTime? date = await pickDateTime(context);
              if (navigatorKey.currentContext != null) {
                navigatorKey.currentContext!
                    .read<SleepSummaryCubit>()
                    .changeProps(selectedBedTime: date);
              }
            },
          ),
        ),
        12.spaceW,
        Expanded(
          child: _dateField(
            title: LocaleKeys.wakeUpTime.tr(),
            value: state.selectedWakeTime != null
                ? coParentScheduleTime(state.selectedWakeTime!)
                : "",
            hint: LocaleKeys.selectDateTime.tr(),
            icon: Icons.wb_sunny_rounded,
            errorText: state.wakeUpTimeError,
            onTap: () async {
              DateTime? date = await pickDateTime(context);
              if (navigatorKey.currentContext != null) {
                navigatorKey.currentContext!
                    .read<SleepSummaryCubit>()
                    .changeProps(selectedWakeTime: date);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _notes() {
    return BlocBuilder<SleepSummaryCubit, SleepSummaryState>(
      buildWhen: (previous, current) => previous.notesError != current.notesError,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocaleKeys.notes.tr().appText(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4B5563),
                ),
            8.spaceH,
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (state.notesError ?? "").isNotEmpty
                      ? Colors.red.withValues(alpha: 0.6)
                      : const Color(0xFFE5E7EB),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF3F4F6).withValues(alpha: 0.7),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                initialValue: state.notes,
                onChanged: (value) {
                  context.read<SleepSummaryCubit>().changeProps(notes: value);
                },
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys.enterAnyNotes.tr(),
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            if ((state.notesError ?? "").isNotEmpty) ...[
              4.spaceH,
              (state.notesError ?? "").appText(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _saveButton(SleepSummaryState state) {
    return BaseButton(
      onTap: () {
        context.read<SleepSummaryCubit>().addSleepLog();
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor2, const Color(0xFF4361EE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: LocaleKeys.save.tr().appText(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
