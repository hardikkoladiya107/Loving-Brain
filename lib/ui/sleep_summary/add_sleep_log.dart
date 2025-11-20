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
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_cubit.dart';
import 'package:loving_brain/ui/sleep_summary/bloc/sleep_summary_state.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class AddSleepLog extends StatefulWidget {
  const AddSleepLog({super.key});

  @override
  State<AddSleepLog> createState() => _AddSleepLogState();
}

class _AddSleepLogState extends State<AddSleepLog> {
  @override
  void initState() {
    context.read<SleepSummaryCubit>().clearSleepLogForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sleepSummaryBackgroundColor,
      body: BlocConsumer<SleepSummaryCubit, SleepSummaryState>(
        listener: (context, state) {
          if ((state.msg ?? "").isNotEmpty) {
            showSnackBar(message: state.msg ?? "", type: SnackBarType.ERROR);
          }
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
          return Stack(
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
                              borderRadius: BorderRadius.circular(12),
                              color: aiQuestionCardColor1,
                            ),
                            margin: EdgeInsets.all(12),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                12.spaceH,
                                "Add Sleep Log".appText(fontSize: 20),
                                16.spaceH,
                                BaseButton(
                                  onTap: () async {
                                    DateTime? date = await _showDatePicker();
                                    context
                                        .read<SleepSummaryCubit>()
                                        .changeProps(date: date);
                                  },
                                  child: _dateField(
                                    title: 'Date',
                                    value: state.date != null
                                        ? formatDate(state.date!)
                                        : "",
                                    hint: "Select Date",
                                  ),
                                ),
                                16.spaceH,
                                Row(
                                  children: [
                                    Expanded(
                                      child: BaseButton(
                                        onTap: () async {
                                          DateTime? date = await pickDateTime(
                                            context,
                                          );
                                          context
                                              .read<SleepSummaryCubit>()
                                              .changeProps(bedTime: date);
                                        },
                                        child: _dateField(
                                          title: 'Bed Time',
                                          value: state.bedTime != null
                                              ? coParentScheduleTime(
                                                  state.bedTime!,
                                                )
                                              : "",
                                          hint: "Select Date & time",
                                        ),
                                      ),
                                    ),
                                    6.spaceW,
                                    Expanded(
                                      child: BaseButton(
                                        onTap: () async {
                                          DateTime? date = await pickDateTime(
                                            context,
                                          );
                                          context
                                              .read<SleepSummaryCubit>()
                                              .changeProps(wakeTime: date);
                                        },
                                        child: _dateField(
                                          title: 'Wake-Up Time',
                                          value: state.wakeTime != null
                                              ? coParentScheduleTime(
                                                  state.wakeTime!,
                                                )
                                              : "",
                                          hint: "Select Date & time",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                16.spaceH,
                                AppTextField(
                                  title: 'Notes',
                                  hint: 'Enter any notes...',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  onChanged: (value) {
                                    context
                                        .read<SleepSummaryCubit>()
                                        .changeProps(notes: value);
                                  },
                                  // height: 100,
                                  maxLines: 3,
                                ),
                                12.spaceH,
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
          );
        },
      ),
    );
  }

  Widget _saveButton() {
    bool isEdit = false;
    return BaseButton(
      onTap: () {
        context.read<SleepSummaryCubit>().addSleepLog();
      },
      child: Container(
        // width: 158.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: LocaleKeys.save.tr().appText(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
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
  }

  Future<DateTime?> pickDateTime(BuildContext context) async {
    // Step 1: Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (pickedDate == null) return null;

    // Step 2: Pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    // Combine date + time
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Widget _dateField({required String hint, String? value, String? title}) {


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
                  ),
                ],
              ),
              6.spaceH,
            ],
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 55,
          child: Row(
            children: [
              10.spaceW,
              ((value ?? "").isNotEmpty ? value : hint).toString().appText(
                color: (value ?? "").isNotEmpty ? Colors.black : Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
