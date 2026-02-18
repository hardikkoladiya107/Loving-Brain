import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/routine_category_model.dart';
import 'package:loving_brain/model/routine_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import 'bloc/daily_routine_cubit.dart';
import 'bloc/daily_routine_state.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
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
            _descriptionController.value = _descriptionController.value
                .copyWith(
                  text: state.descriptionText,
                  selection: _descriptionController.selection,
                );
          });
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgDailyRoutineBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appBar(context),
                    24.h.spaceH,
                    _header(),
                    32.h.spaceH,
                    _formCard(context, state),
                    24.h.spaceH,
                    _currentDailyRoutineSection(context, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          BaseButton(
            onTap: () => Navigator.pop(context),
            child: Assets.icons.icBackIcon.image(
              height: 36.h,
              width: 36.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: LocaleKeys.dailyRoutine
            .tr()
            .appText(fontWeight: FontWeight.w900, fontSize: 18.sp),
      ),
    );
  }

  Widget _formCard(BuildContext context, DailyRoutineState state) {
    final String childName =
        state.childModel?.childName ?? state.userModel?.childName ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: greyColor2.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (childName.isNotEmpty)
            "${LocaleKeys.addNewActivityFor.tr()} $childName"
                .appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                  color: blackTextColor,
                ),
          20.h.spaceH,
          _timeField(context, state),
          14.h.spaceH,
          _descriptionField(context, state),
          14.h.spaceH,
          _typeField(context, state),
          24.h.spaceH,
          _addActivityButton(context),
        ],
      ),
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
            fontWeight: FontWeight.w600,
            color: blackTextColor,
          ),
          8.h.spaceH,
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            child: state.selectedDateTime != null
                ? getStringTime(state.selectedDateTime)
                    .appText(
                      fontSize: 14.sp,
                      color: blackTextColor,
                      fontWeight: FontWeight.w600,
                    )
                : LocaleKeys.selectTime
                    .tr()
                    .appText(fontSize: 14.sp, color: greyColor1),
          ),
          if ((state.timeError).isNotEmpty) ...[
            6.h.spaceH,
            state.timeError.appText(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: redColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _descriptionField(BuildContext context, DailyRoutineState state) {
    return AppTextField(
      controller: _descriptionController,
      title: LocaleKeys.description.tr(),
      titleFontSize: 14.sp,
      minLines: 2,
      maxLines: 2,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      error: state.descriptionError,
      hint: LocaleKeys.enterDescription.tr(),
      onChanged: (String value) {
        context.read<DailyRoutineCubit>().changeProps(descriptionText: value);
      },
    );
  }

  Widget _typeField(BuildContext context, DailyRoutineState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.type.tr().appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
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
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: state.routineCategoryList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  final RoutineCategoryModel category =
                      state.routineCategoryList[index];
                  final String label = category.routineType ?? '';
                  return BaseButton(
                    onTap: () {
                      close();
                      context
                          .read<DailyRoutineCubit>()
                          .changeProps(selectedType: category.routineType);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
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
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
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
                      : LocaleKeys.selectType
                          .tr()
                          .appText(fontSize: 14.sp, color: greyColor1),
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
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _addActivityButton(BuildContext context) {
    return BaseButton(
      onTap: () => context.read<DailyRoutineCubit>().addActivity(),
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: yellowColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: "+ ${LocaleKeys.addActivity.tr()}".appText(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
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

  Widget _currentDailyRoutineSection(
    BuildContext context,
    DailyRoutineState state,
  ) {
    final List<RoutineModel> routines = state.routinesList;
    final String childName =
        state.childModel?.childName ?? state.userModel?.childName ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (childName.isNotEmpty)
            "$childName's ${LocaleKeys.currentDailyRoutine.tr()}"
                .appText(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: blackTextColor,
                ),
          12.h.spaceH,
          if (routines.isEmpty)
            _emptyRoutineState()
          else
            ...routines.map(
              (RoutineModel routine) => _routineItem(routine),
            ),
        ],
      ),
    );
  }

  Widget _emptyRoutineState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 44.sp,
            color: greyColor2,
          ),
          14.h.spaceH,
          'noActivitiesInRoutineYet'.tr().appText(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: blackTextColor,
          ),
          8.h.spaceH,
          'addActivitiesAboveToSeeThemHere'.tr().appText(
            fontSize: 13.sp,
            color: greyColor1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _routineItem(RoutineModel routine) {
    final String type = routine.type ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: "${getStringTime(routine.timeStamp)} · ${routine.description ?? ''}"
                    .appText(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: blackTextColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (type.isNotEmpty) ...[
                8.w.spaceW,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: greenPlayButtonColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: type.appText(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
