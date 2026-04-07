import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/extra_methods.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../main.dart';

class AddSleepLogScreen extends StatefulWidget {
  const AddSleepLogScreen({super.key});

  @override
  State<AddSleepLogScreen> createState() => _AddSleepLogScreenState();
}

class _AddSleepLogScreenState extends State<AddSleepLogScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SleepSummaryCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepSummaryCubit, SleepSummaryState>(
      listener: (context, state) {
        state.addSleepLogApiResult.whenOrNull(
          initial: () {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            Navigator.pop(context);
            context.read<SleepSummaryCubit>().reload();
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: sleepSummaryBackgroundColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          60.spaceH,
                          Assets.images.imgSleepMoon.image(width: 120),
                          16.spaceH,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                12.spaceH,
                                LocaleKeys.addSleepLog.tr().appText(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                                24.spaceH,
                                _selectDate(state),
                                20.spaceH,
                                _bedTimeWakeUpTime(state),
                                20.spaceH,
                                _notes(),
                                30.spaceH,
                                _saveButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _appBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _saveButton() {
    return BaseButton(
      onTap: () {
        context.read<SleepSummaryCubit>().addSleepLog();
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: LocaleKeys.save.tr().appText(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Positioned(
      top: 60,
      left: 16,
      child: Row(
        children: [
          BaseButton(
            child: Assets.icons.icBackIcon.image(height: 36, width: 36),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).appPadding(left: 20),
    );
  }

  Future<DateTime?> _showDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      return date;
    }
    return null;
  }

  Future<DateTime?> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return null;
    if (navigatorKey.currentContext != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: navigatorKey.currentContext!,
        initialTime: TimeOfDay.now(),
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
  }) {
    return Column(
      children: [
        if (title != null)
          Column(
            children: [
              Row(
                children: [
                  (title ?? "").appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ],
              ),
              8.spaceH,
            ],
          ),
        BaseButton(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: blueColor2, size: 20),
                  12.spaceW,
                ],
                Expanded(
                  child: ((value ?? "").isNotEmpty ? value : hint)
                      .toString()
                      .appText(
                        color: (value ?? "").isNotEmpty
                            ? Colors.black87
                            : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectDate(SleepSummaryState state) {
    return _dateField(
      title: LocaleKeys.date.tr(),
      value: state.selectedDate != null ? formatDate(state.selectedDate!) : "",
      hint: LocaleKeys.selectDate.tr(),
      icon: Icons.calendar_today_rounded,
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
      children: [
        Expanded(
          child: _dateField(
            title: LocaleKeys.bedTime.tr(),
            value: state.selectedBedTime != null
                ? coParentScheduleTime(state.selectedBedTime!)
                : "",
            hint: LocaleKeys.selectDateTime.tr(),
            icon: Icons.nights_stay_rounded,
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
    return AppTextField(
      title: LocaleKeys.notes.tr(),
      hint: LocaleKeys.enterAnyNotes.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onChanged: (value) {
        context.read<SleepSummaryCubit>().changeProps(notes: value);
      },
      maxLines: 3,
    );
  }
}
