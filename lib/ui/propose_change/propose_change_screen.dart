import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'bloc/propose_change_cubit.dart';
import 'bloc/propose_change_state.dart';

class ProposeChangeScreen extends StatefulWidget {
  const ProposeChangeScreen({super.key, required this.sharedEvent});

  final SharedEventModel sharedEvent;

  @override
  State<ProposeChangeScreen> createState() => _ProposeChangeScreenState();
}

class _ProposeChangeScreenState extends State<ProposeChangeScreen> {
  @override
  void initState() {
    context.read<ProposeChangeCubit>().init(widget.sharedEvent);
    super.initState();
  }

  TextEditingController noteForCoParentTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposeChangeCubit, ProposeChangeState>(
      builder: (context, state) {

        if (noteForCoParentTextEditingController.text !=
            state.noteForCoParent) {
          noteForCoParentTextEditingController.value =
              noteForCoParentTextEditingController.value.copyWith(
                text: state.noteForCoParent ?? '',
                selection: noteForCoParentTextEditingController.selection,
              );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(children: [_backgroundImage(), _screenBody(state)]),
          ),
        );
      },
      listener: (context, state) {
        state.sendProposalApiResultStatus.whenOrNull(
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
          data: (data) {
            EasyLoading.dismiss();
            context.pop();
          },
          loading: () {
            EasyLoading.show();
          },
        );
      },
    );
  }

  Widget _backgroundImage() {
    return Column(
      children: [
        Assets.images.imgEssentialsBg.image(
          height: context.height,
          fit: BoxFit.cover,
        ),
        Container(height: context.height / 2),
      ],
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: LocaleKeys.proposeChange
              .tr()
              .appText(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )
              .appPadding(left: 10, right: 10, top: 6, bottom: 6),
        ),
      ],
    );
  }

  Widget _youAreProposing(ProposeChangeState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.spaceH,
          LocaleKeys.current
              .tr()
              .appText(fontSize: 14, fontWeight: FontWeight.w600)
              .appPadding(left: 20.w),
          4.spaceH,
          _timeWidget(
            coParentEventDetailTime(state.sharedEvent?.date),
            "${getStringTime(state.sharedEvent?.startTime)} - ${getStringTime(state.sharedEvent?.endTime)}",
          ),
          10.spaceH,
          LocaleKeys.proposed
              .tr()
              .appText(fontSize: 14, fontWeight: FontWeight.w600)
              .appPadding(left: 20.w),
          4.spaceH,
          _timeWidget(
            coParentEventDetailTime(state.selectedDate),
            "${getStringTime(state.startTime)} - ${getStringTime(state.endTime)}",
          ),
          10.spaceH,
        ],
      ),
    );
  }

  Widget _timeWidget(String start, String end) {
    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          start
              .appText(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              )
              .appPadding(left: 10.w),
          end
              .appText(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.end,
              )
              .appPadding(right: 10.w),
        ],
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _newDate(ProposeChangeState state) {
    return Column(
      children: [
        Row(
          children: [
            LocaleKeys.date.tr().appText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        6.spaceH,
        BaseButton(
          onTap: () {
            _showDatePicker();
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Assets.icons.icCalenderIcon3
                    .image(height: 20, width: 20)
                    .appPadding(left: 8),
                12.spaceW,
                (state.selectedDate != null
                        ? getStringDate(state.selectedDate)
                        : LocaleKeys.chooseDate.tr())
                    .appText(
                      fontSize: 14,
                      color: state.selectedDate != null
                          ? Colors.black
                          : Colors.grey.shade400,
                    ),
              ],
            ),
          ),
        ),
        if (state.dateError.isNotEmpty)
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.dateError ?? "").appText(
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

  Widget _noteToCoParent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.noteToCoParent.tr().appText(
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          fontSize: 14,
        ),
        10.h.spaceH,
        AppTextField(
          minLines: 3,
          controller: noteForCoParentTextEditingController,
          fillColor: Colors.grey.withValues(alpha: 0.2),
          onChanged: (value) {
            context.read<ProposeChangeCubit>().changeProps(
              noteForCoParent: value,
            );
          },
        ),
      ],
    );
  }

  Widget _screenBody(ProposeChangeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        45.h.spaceH,
        _appBar(),
        80.spaceH,
        _header(),
        130.spaceH,
        Row(),
        LocaleKeys.youProposing.tr().appText(fontWeight: FontWeight.w600),
        10.h.spaceH,
        _youAreProposing(state),
        10.h.spaceH,
        LocaleKeys.newDate.tr().appText(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        10.h.spaceH,
        _newDate(state),
        10.h.spaceH,
        _startEnd(state),
        20.h.spaceH,
        _quickWidget(state),
        20.h.spaceH,
        _noteToCoParent(),
        10.h.spaceH,
        proposeButton(
          text: LocaleKeys.sendProposal.tr(),
          onTap: () {
            context.read<ProposeChangeCubit>().sendProposal(state);
          },
        ),
      ],
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            context.pop();
          },
        ),
      ],
    );
  }

  Widget _startEnd(ProposeChangeState state) {
    return Row(
      children: [
        Expanded(
          child: BaseButton(
            child: Column(
              children: [
                Row(
                  children: [
                    LocaleKeys.start.tr().appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                6.spaceH,
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Assets.icons.icTimerIcon
                          .image(height: 20, width: 20)
                          .appPadding(left: 8),
                      12.spaceW,

                      (state.startTime != null
                              ? getStringTime(state.startTime)
                              : LocaleKeys.startHint.tr())
                          .appText(
                            fontSize: 14,
                            color: state.startTime != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                    ],
                  ),
                ),
                if (state.startTimeError.isNotEmpty)
                  Column(
                    children: [
                      4.spaceH,
                      Row(
                        children: [
                          (state.startTimeError ?? "").appText(
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
              _showStartTime();
            },
          ),
        ),
        10.spaceW,
        Expanded(
          child: BaseButton(
            child: Column(
              children: [
                Row(
                  children: [
                    LocaleKeys.end.tr().appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                6.spaceH,
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Assets.icons.icTimerIcon
                          .image(height: 20, width: 20)
                          .appPadding(left: 8),
                      12.spaceW,
                      (state.endTime != null
                              ? getStringTime(state.endTime)
                              : LocaleKeys.endHint.tr())
                          .appText(
                            fontSize: 14,
                            color: state.endTime != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                    ],
                  ),
                ),
                if (state.endTimeError.isNotEmpty)
                  Column(
                    children: [
                      4.spaceH,
                      Row(
                        children: [
                          (state.endTimeError ?? "").appText(
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
              _showEndTime();
            },
          ),
        ),
      ],
    );
  }

  Widget proposeButton({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: blueColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    ).appPadding(left: 15, right: 15);
  }

  Widget _quickWidget(ProposeChangeState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LocaleKeys.quick.tr().appText(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        _quickItem(
          label: "+15",
          onTap: () {
            var startTime = state.startTime ?? state.sharedEvent?.startTime;
            var endTime = state.endTime ?? state.sharedEvent?.endTime;
            context.read<ProposeChangeCubit>().changeProps(
              startTime: startTime?.add(Duration(minutes: 15)),
              endTime: endTime?.add(Duration(minutes: 15)),
              selectedDate: state.selectedDate ?? state.sharedEvent?.date,
            );
          },
        ),
        _quickItem(
          label: "+30",
          onTap: () {
            var startTime = state.startTime ?? state.sharedEvent?.startTime;
            var endTime = state.endTime ?? state.sharedEvent?.endTime;
            context.read<ProposeChangeCubit>().changeProps(
              startTime: startTime?.add(Duration(minutes: 30)),
              endTime: endTime?.add(Duration(minutes: 30)),
              selectedDate: state.selectedDate ?? state.sharedEvent?.date,
            );
          },
        ),
        _quickItem(
          label: LocaleKeys.moveToTomorrow.tr(),
          onTap: () {
            var date = state.selectedDate ?? state.sharedEvent?.date;
            var startTime = state.startTime ?? state.sharedEvent?.startTime;
            var endTime = state.endTime ?? state.sharedEvent?.endTime;
            context.read<ProposeChangeCubit>().changeProps(
              startTime: startTime,
              endTime: endTime,
              selectedDate: date?.add(Duration(days: 1)),
            );
          },
        ),
      ],
    );
  }

  Widget _quickItem({required String label, GestureTapCallback? onTap}) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: label
            .appText(fontWeight: FontWeight.w600, fontSize: 14)
            .appPadding(all: 8),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
    ).then((value) {
      navigatorKey.currentContext?.read<ProposeChangeCubit>().changeProps(
        selectedDate: value,
      );
    });
  }

  void _showStartTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        DateTime now = DateTime.now();
        navigatorKey.currentContext?.read<ProposeChangeCubit>().changeProps(
          startTime: DateTime(
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

  void _showEndTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        DateTime now = DateTime.now();
        navigatorKey.currentContext?.read<ProposeChangeCubit>().changeProps(
          endTime: DateTime(
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
