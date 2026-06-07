import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/routine_category_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../main.dart';
import '../../../../other/app_color.dart';
import '../../../../other/extra_methods.dart';
import '../../../model/api_result_status.dart';
import '../../daily_routine/bloc/daily_routine_cubit.dart';
import '../../daily_routine/bloc/daily_routine_state.dart';

class AddDailyRoutineDialog extends StatefulWidget {
  const AddDailyRoutineDialog({super.key});

  @override
  State<AddDailyRoutineDialog> createState() => _AddDailyRoutineDialogState();
}

class _AddDailyRoutineDialogState extends State<AddDailyRoutineDialog> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyRoutineCubit>().init();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyRoutineCubit, DailyRoutineState>(
      listener: (context, state) {
        state.addRoutineApiResult.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.routineAddedSuccessfully.tr(),
              type: SnackBarType.SUCCESS,
            );
            context.pop();
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (context, state) {
        if (_descriptionController.text != (state.descriptionText)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _descriptionController.value = _descriptionController.value.copyWith(
              text: state.descriptionText,
              selection: _descriptionController.selection,
            );
          });
        }

        final String childName =
            state.childModel?.childName ?? state.userModel?.childName ?? '';

        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.schedule_rounded,
                          color: primaryColor,
                          size: 24.sp,
                        ),
                      ),
                      12.w.spaceW,
                      Expanded(
                        child: childName.isNotEmpty 
                          ? "${LocaleKeys.addNewActivityFor.tr()} $childName".appText(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                              color: blackTextColor,
                              maxLines: 2,
                            )
                          : LocaleKeys.addActivity.tr().appText(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                              color: blackTextColor,
                              maxLines: 2,
                            ),
                      ),
                      BaseButton(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: greyColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, size: 20.sp, color: greyColor1),
                        ),
                      ),
                    ],
                  ),
                  24.h.spaceH,
                  _timeField(context, state),
                  16.h.spaceH,
                  _descriptionField(context, state),
                  16.h.spaceH,
                  _typeField(context, state),
                  32.h.spaceH,
                  _addActivityButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _timeField(BuildContext context, DailyRoutineState state) {
    return BaseButton(
      onTap: () => _showTimePicker(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocaleKeys.time.tr().appText(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: blackTextColor,
          ),
          8.h.spaceH,
          Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: greyColor3.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: greyColor.withValues(alpha: 0.5)),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.access_time_rounded, color: greyColor1, size: 20.sp),
                12.w.spaceW,
                Expanded(
                  child: state.selectedDateTime != null
                      ? getStringTime(state.selectedDateTime).appText(
                          fontSize: 14.sp,
                          color: blackTextColor,
                          fontWeight: FontWeight.w600,
                        )
                      : LocaleKeys.selectTime.tr().appText(fontSize: 14.sp, color: greyColor1),
                ),
              ],
            ),
          ),
          if ((state.timeError).isNotEmpty) ...[
            6.h.spaceH,
            state.timeError.appText(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: redColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _descriptionField(BuildContext context, DailyRoutineState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.description.tr().appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: blackTextColor,
        ),
        8.h.spaceH,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: greyColor3.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: greyColor.withValues(alpha: 0.5)),
          ),
          child: TextField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 4,
            style: getTextStyle(
              fontSize: 14.sp,
              color: blackTextColor,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: LocaleKeys.enterDescription.tr(),
              hintStyle: getTextStyle(fontSize: 14.sp, color: greyColor1),
            ),
            onChanged: (String value) {
              context.read<DailyRoutineCubit>().changeProps(descriptionText: value);
            },
            textInputAction: TextInputAction.done,
          ),
        ),
        if ((state.descriptionError).isNotEmpty) ...[
          6.h.spaceH,
          state.descriptionError.appText(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _typeField(BuildContext context, DailyRoutineState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.type.tr().appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: blackTextColor,
        ),
        8.h.spaceH,
        AppDropDownButton(
          offset: Offset(0, 56.h),
          dropDownWidget: (void Function() close) {
            return Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: state.routineCategoryList.length,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemBuilder: (BuildContext context, int index) {
                  final RoutineCategoryModel category = state.routineCategoryList[index];
                  final String label = category.routineType ?? '';
                  return BaseButton(
                    onTap: () {
                      close();
                      context.read<DailyRoutineCubit>().changeProps(selectedType: category.routineType);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          label.appText(
                            color: blackTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: greyColor3.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16.r),
               border: Border.all(color: greyColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: state.selectedType.isNotEmpty
                      ? state.selectedType.appText(
                          fontSize: 14.sp,
                          color: blackTextColor,
                          fontWeight: FontWeight.w600,
                        )
                      : LocaleKeys.selectType.tr().appText(fontSize: 14.sp, color: greyColor1),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: greyColor1,
                  size: 28.sp,
                ),
              ],
            ),
          ),
        ),
        if ((state.typeError).isNotEmpty) ...[
          6.h.spaceH,
          state.typeError.appText(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _addActivityButton(BuildContext context) {
    return BaseButton(
      onTap: () {
         FocusScope.of(context).unfocus();
         context.read<DailyRoutineCubit>().addActivity();
      },
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primaryColor, blueColor2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: [
            BoxShadow(
              color: blueColor2.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: "+ ${LocaleKeys.addActivity.tr()}".appText(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
     FocusScope.of(context).unfocus();
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((TimeOfDay? value) {
      if (value != null && navigatorKey.currentContext != null) {
        final DateTime now = DateTime.now();
        navigatorKey.currentContext!.read<DailyRoutineCubit>().changeProps(
              selectedDateTime: DateTime(
                now.year,
                now.month,
                now.day,
                value.hour,
                value.minute,
              ),
            );
      }
    });
  }
}
