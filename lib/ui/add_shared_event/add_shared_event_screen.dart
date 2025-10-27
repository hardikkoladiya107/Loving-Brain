import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../widget/base_button.dart';
import 'cubit/add_shared_event_cubit.dart';
import 'cubit/add_shared_event_state.dart';

class AddSharedEventScreen extends StatefulWidget {
  const AddSharedEventScreen({super.key});

  @override
  State<AddSharedEventScreen> createState() => _AddSharedEventScreenState();
}

class _AddSharedEventScreenState extends State<AddSharedEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AddSharedEventCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSharedEventCubit, AddSharedEventState>(
      builder: (context, state) {
        if (titleController.text != state.title) {
          titleController.value = titleController.value.copyWith(
            text: state.title ?? '',
            selection: titleController.selection,
          );
        }

        if (locationController.text != state.locationText) {
          locationController.value = locationController.value.copyWith(
            text: state.locationText ?? '',
            selection: locationController.selection,
          );
        }

        if (noteController.text != state.title) {
          noteController.value = noteController.value.copyWith(
            text: state.note ?? '',
            selection: noteController.selection,
          );
        }

        return Scaffold(
          backgroundColor: addSharedEventBgColor,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Assets.images.imgAddSharedBg.image(
                      height: context.height,
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                    Container(height: context.height / 2),
                  ],
                ),
                Column(
                  children: [
                    30.h.spaceH,

                    60.h.spaceH,
                    LocaleKeys.addSharedEvent.tr().appText(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    20.h.spaceH,
                    _titleTextField(state),
                    4.h.spaceH,
                    _schoolPickUp(state),
                    20.h.spaceH,
                    _startEnd(state),
                    20.h.spaceH,
                    _location(state),
                    20.h.spaceH,
                    _children(state),
                    10.h.spaceH,
                    _assignedTo(state),
                    10.h.spaceH,
                    _requireApproval(state),
                    10.h.spaceH,
                    _note(state),
                    _attachDocument(state),
                    20.h.spaceH,
                    _button(),
                  ],
                ).appPadding(left: 20.w, right: 20.w),
                _appBar(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.getCoParentApiResultStatus.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );

        state.getChildApiResultStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
        );

        state.requestApprovalApiResultStatus.whenOrNull(
          data: (data) {
            EasyLoading.dismiss();
            Navigator.pop(context);
          },
          error: (error) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );

        state.uploadDocumentApiResultStatus.whenOrNull(
          error: (error) {
            EasyLoading.dismiss();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          loading: () {
            EasyLoading.show();
          },
        );
      },
    );
  }

  Widget _appBar() {
    return Positioned(
      top: 60,
      left: 20,
      child: BaseButton(
        child: Assets.icons.icBackIcon.image(height: 36, width: 36),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _chipWidget({
    required String text,
    required GestureTapCallback? onTap,
    required bool selected,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tabBarBgColor,
          borderRadius: BorderRadius.circular(20),
          border: selected ? Border.all(color: primaryColor, width: 2) : null,
        ),
        child: text
            .appText(fontWeight: FontWeight.w700)
            .appPadding(left: 16, right: 16, top: 8, bottom: 8),
      ),
    );
  }

  Widget accessCard({
    required bool switchValue,
    required bool isRequired,
    required String title,
    required String description,
    required ValueChanged<bool> onChanged,
    bool showSwitch = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title.appText(fontSize: 14, fontWeight: FontWeight.w700),
                    if (isRequired) ...[
                      16.spaceW,
                      "* Required".appText(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                description.appText(fontSize: 10, fontWeight: FontWeight.w700),
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.7,
              child: Switch(value: switchValue, onChanged: onChanged),
            ),
        ],
      ).appPadding(all: 10),
    );
  }

  Widget _attachDocument(AddSharedEventState state) {
    return Column(
      children: [
        BaseButton(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocaleKeys.attachDocument
                    .tr()
                    .appText(fontWeight: FontWeight.w600, fontSize: 14)
                    .appPadding(top: 6, bottom: 6),
                8.w.spaceW,
                Assets.icons.icPremiumIcon.image(height: 20, width: 20),
              ],
            ),
          ),
          onTap: () {
            _chooseImage(state);
          },
        ),
        20.spaceH,
        ...state.documentsList.map(
          (e) => Row(
            children: [
              Icon(Icons.file_copy_outlined),
              10.spaceW,
              Expanded(
                child: _getFileName(e).appText(textAlign: TextAlign.start),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _chooseImage(AddSharedEventState state) async {
    final XFile? photo = await ImagePicker().pickMedia();
    if (photo != null && navigatorKey.currentContext != null) {
      navigatorKey.currentContext!
          .read<AddSharedEventCubit>()
          .uploadToFirebaseStorage(photo.path);
    }
  }

  Widget _requestApprovalButton({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: cardColor2,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleTextField(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.title.tr(),
      hint: LocaleKeys.schoolPickUp.tr(),
      error: state.titleError,
      controller: titleController,
      onChanged: (value) {
        context.read<AddSharedEventCubit>().changeProps(title: value);
      },
    );
  }

  Widget _schoolPickUp(AddSharedEventState state) {
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
                    .padding(left: 8),
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

  Widget _startEnd(AddSharedEventState state) {
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
                          .padding(left: 8),
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
                          .padding(left: 8),
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

  Widget _location(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.location.tr(),
      hint: LocaleKeys.locationHint.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.icLocationIcon
              .image(height: 20, width: 20)
              .padding(left: 8),
        ],
      ),
      error: state.locationError,
      controller: locationController,
      onChanged: (value) {
        context.read<AddSharedEventCubit>().changeProps(locationText: value);
      },
    );
  }

  Widget _children(AddSharedEventState state) {
    List<Widget> childrenWidgetList = [];

    for (int i = 0; i < state.children.length; i++) {
      var child = state.children[i];
      childrenWidgetList.add(
        _chipWidget(
          text: child.childName ?? "",
          selected: state.selectedChildren.any(
            (element) => element.reference?.id == child.reference?.id,
          ),
          onTap: () {
            context.read<AddSharedEventCubit>().selectChild(child);
          },
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            LocaleKeys.child.tr().appText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            10.w.spaceW,
            Assets.icons.icChildEmojiIcon.image(height: 25, width: 25),
          ],
        ),
        10.h.spaceH,
        Row(
          children: [
            if (childrenWidgetList.isNotEmpty) ...[...childrenWidgetList],
          ],
        ),
        if (state.selectedChildError.isNotEmpty)
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.selectedChildError ?? "").appText(
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

  Widget _assignedTo(AddSharedEventState state) {
    List<Widget> coParentWidgetList = [];
    coParentWidgetList.add(
      _chipWidget(
        text: 'You',
        selected: state.selectedCoParentList.any(
          (element) => element.uid == state.userModel?.uid,
        ),
        onTap: () {
          if (state.userModel != null) {
            context.read<AddSharedEventCubit>().selectParent(state.userModel!);
          }
        },
      ),
    );

    for (int i = 0; i < state.coParentList.length; i++) {
      var user = state.coParentList[i];
      coParentWidgetList.add(
        _chipWidget(
          text: user.parentName ?? "",
          onTap: () {
            context.read<AddSharedEventCubit>().selectParent(user);
          },
          selected: state.selectedCoParentList.any(
            (element) => element.uid == user.uid,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            LocaleKeys.assignedTo.tr().appText(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        10.h.spaceH,
        Row(children: [...coParentWidgetList]),
        if (state.assignedToError.isNotEmpty)
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.assignedToError ?? "").appText(
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

  Widget _note(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.noteToCoParent.tr(),
      hint: LocaleKeys.anythingTheyShouldKnow.tr(),
      minLines: 5,
      controller: noteController,
      error: state.noteError,
      onChanged: (value) {
        context.read<AddSharedEventCubit>().changeProps(note: value);
      },
    );
  }

  Widget _button() {
    return _requestApprovalButton(
      text: LocaleKeys.requestApproval.tr(),
      onTap: () {
        context.read<AddSharedEventCubit>().requestApproval();
      },
    );
  }

  Widget _requireApproval(AddSharedEventState state) {
    return accessCard(
      isRequired: false,
      title: LocaleKeys.requireApproval.tr(),
      description: LocaleKeys.sendToCoParentForConfirmation.tr(),
      onChanged: (value) {
        context.read<AddSharedEventCubit>().changeProps(
          requiredApproval: value,
        );
      },
      switchValue: state.requiredApproval,
    );
  }

  void _showStartTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      if (value != null) {
        DateTime now = DateTime.now();
        navigatorKey.currentContext?.read<AddSharedEventCubit>().changeProps(
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
        navigatorKey.currentContext?.read<AddSharedEventCubit>().changeProps(
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
    ).then((value) {
      navigatorKey.currentContext?.read<AddSharedEventCubit>().changeProps(
        selectedDate: value,
      );
    });
  }

  String _getFileName(String e) {
    var finalPath = e.split("?").first.toString();
    var fileName = finalPath.split("%2F").last;
    return fileName.toString();
  }
}
