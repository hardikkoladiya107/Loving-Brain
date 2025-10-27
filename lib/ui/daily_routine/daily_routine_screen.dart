import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
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
  @override
  void initState() {
    context.read<DailyRoutineCubit>().init();
    super.initState();
  }

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyRoutineCubit, DailyRoutineState>(
      builder: (context, state) {
        if (descriptionController.text != state.descriptionText) {
          descriptionController.value = descriptionController.value.copyWith(
            text: state.descriptionText ?? '',
            selection: descriptionController.selection,
          );
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
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.spaceH,
                  Row(
                    children: [
                      20.spaceW,
                      BaseButton(
                        child: Assets.icons.icBackIcon.image(
                          height: 36,
                          width: 36,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  40.spaceH,
                  _header(),
                  80.spaceH,
                  Container(
                    decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.spaceH,
                        Row(),
                        "${LocaleKeys.addNewActivityFor.tr()} ${state.userModel?.childName ?? ""}"
                            .appText(fontWeight: FontWeight.w900, fontSize: 14),
                        20.spaceH,
                        _timeTextField(state),
                        6.spaceH,
                        _description(state),
                        6.spaceH,
                        _type(state),
                        24.spaceH,
                        _addActivityButton(),
                        20.spaceH,
                      ],
                    ).appPadding(left: 20, right: 20),
                  ).appPadding(left: 30, right: 30),
                  20.spaceH,
                  _currentDailyRoutine(state),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        state.addRoutineApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            showSnackBar(
              message: LocaleKeys.routineAddedSuccessfully.tr(),
              type: SnackBarType.SUCCESS,
            );
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: LocaleKeys.dailyRoutine
              .tr()
              .appText(fontWeight: FontWeight.w900, fontSize: 18)
              .appPadding(left: 8, right: 8, top: 2, bottom: 2),
        ),
      ],
    );
  }

  Widget _currentRoutingItem(RoutineModel routine) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(),
          6.spaceH,
          "${getStringTime(routine.timeStamp)} ${routine.description}".appText(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          8.spaceH,
          _typeButton(routine.type ?? ""),
          6.spaceH,
        ],
      ),
    ).appPadding(left: 30, right: 30, top: 10);
  }

  Widget _typeButton(String type) {
    return Container(
      decoration: BoxDecoration(
        color: greenPlayButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          6.spaceW,
          type.appText(fontSize: 12, fontWeight: FontWeight.w600),
          6.spaceW,
        ],
      ).appPadding(left: 6, right: 6, top: 2, bottom: 2),
    );
  }

  Widget _feedButton() {
    return Container(
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          6.spaceW,
          LocaleKeys.feed.tr().appText(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          6.spaceW,
          Assets.icons.icFeedIcon.image(height: 14),
          6.spaceW,
        ],
      ).appPadding(left: 6, right: 6, top: 2, bottom: 2),
    );
  }

  Widget _timeTextField(DailyRoutineState state) {
    return BaseButton(
      child: Column(
        children: [
          Row(
            children: [
              (LocaleKeys.time.tr() ?? "").appText(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          6.spaceH,
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,
                if (state.selectedDateTime != null) ...[
                  getStringTime(state.selectedDateTime).appText(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ] else ...[
                  LocaleKeys.selectTime.tr().appText(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              ],
            ),
          ),

          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.timeError ?? "").appText(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        _showTimerPicker();
      },
    );
  }

  Widget _description(DailyRoutineState state) {
    return AppTextField(
      controller: descriptionController,
      title: LocaleKeys.description.tr(),
      titleFontSize: 12,
      minLines: 2,
      maxLines: 2,
      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      error: state.descriptionError,
      hint: LocaleKeys.enterDescription.tr(),
      onChanged: (value) {
        context.read<DailyRoutineCubit>().changeProps(descriptionText: value);
      },
    );
  }

  Widget _type(DailyRoutineState state) {
    return Column(
      children: [
        Row(
          children: [
            (LocaleKeys.type.tr() ?? "").appText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        6.spaceH,
        AppDropDownButton(
          offset: Offset(0, 50),
          dropDownWidget: (close) {
            return Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: state.routineCategoryList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  var type = state.routineCategoryList[index];
                  return BaseButton(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            12.spaceW,
                            (type.routineType ?? "").appText(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        10.spaceH,
                        Divider(height: 1, thickness: 0.5),
                      ],
                    ),
                    onTap: () {
                      close.call();
                      context.read<DailyRoutineCubit>().changeProps(
                        selectedType: type.routineType,
                      );
                    },
                  ).appPadding(top: 5);
                },
              ),
            );
          },
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,
                if (state.selectedType.isNotEmpty) ...[
                  state.selectedType.appText(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ] else ...[
                  LocaleKeys.selectType.tr().appText(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
                Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
                16.spaceW,
              ],
            ),
          ),
        ),
        Column(
          children: [
            4.spaceH,
            Row(
              children: [
                (state.typeError ?? "").appText(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _addActivityButton() {
    return BaseButton(
      onTap: () {
        context.read<DailyRoutineCubit>().addActivity();
      },
      child: Container(
        decoration: BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "+ ${LocaleKeys.addActivity.tr()}"
                .appText(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                )
                .appPadding(top: 4, bottom: 4),
          ],
        ),
      ),
    ).appPadding(left: 60, right: 60);
  }

  void _showTimerPicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        DateTime now = DateTime.now();
        navigatorKey.currentContext?.read<DailyRoutineCubit>().changeProps(
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

  Widget _currentDailyRoutine(DailyRoutineState state) {
    if (state.routinesList.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "${state.userModel?.childName ?? ""}'s ${LocaleKeys.currentDailyRoutine.tr()}"
            .appText(fontWeight: FontWeight.w700, fontSize: 14)
            .appPadding(left: 30),
        ListView.builder(
          itemCount: state.routinesList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var routine = state.routinesList[index];
            return _currentRoutingItem(routine);
          },
        ),
      ],
    );
  }
}
