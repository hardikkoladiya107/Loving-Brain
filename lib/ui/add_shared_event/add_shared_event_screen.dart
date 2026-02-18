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
import '../../model/child_model.dart';
import '../../model/user_model.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddSharedEventCubit>().init();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSharedEventCubit, AddSharedEventState>(
      listener: (context, state) {
        state.getCoParentApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.read<AddSharedEventCubit>().changeProps(
                  getCoParentApiResultStatus: ApiResultStatus.initial(),
                );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            context.read<AddSharedEventCubit>().changeProps(
                  getCoParentApiResultStatus: ApiResultStatus.initial(),
                );
          },
        );
        state.getChildApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.read<AddSharedEventCubit>().changeProps(
                  getChildApiResultStatus: ApiResultStatus.initial(),
                );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            context.read<AddSharedEventCubit>().changeProps(
                  getChildApiResultStatus: ApiResultStatus.initial(),
                );
          },
        );
        state.requestApprovalApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'sharedEventCreated'.tr(),
              type: SnackBarType.SUCCESS,
            );
            context.read<AddSharedEventCubit>().changeProps(
                  requestApprovalApiResultStatus: ApiResultStatus.initial(),
                );
            Navigator.pop(context);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            context.read<AddSharedEventCubit>().changeProps(
                  requestApprovalApiResultStatus: ApiResultStatus.initial(),
                );
          },
        );
        state.uploadDocumentApiResultStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            context.read<AddSharedEventCubit>().changeProps(
                  uploadDocumentApiResultStatus: ApiResultStatus.initial(),
                );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            context.read<AddSharedEventCubit>().changeProps(
                  uploadDocumentApiResultStatus: ApiResultStatus.initial(),
                );
          },
        );
      },
      builder: (context, state) {
        if (_titleController.text != (state.title)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _titleController.value = _titleController.value.copyWith(
              text: state.title,
              selection: _titleController.selection,
            );
          });
        }
        if (_locationController.text != (state.locationText)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _locationController.value = _locationController.value.copyWith(
              text: state.locationText,
              selection: _locationController.selection,
            );
          });
        }
        if (_noteController.text != (state.note)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _noteController.value = _noteController.value.copyWith(
              text: state.note,
              selection: _noteController.selection,
            );
          });
        }

        return Scaffold(
          backgroundColor: addSharedEventBgColor,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Assets.images.imgAddSharedBg.image(
                    fit: BoxFit.cover,
                    width: context.width,
                    height: context.height,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 8.h,
                    bottom: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      56.h.spaceH,
                      LocaleKeys.addSharedEvent.tr().appText(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                        color: blackTextColor,
                      ),
                      20.h.spaceH,
                      _titleTextField(state),
                      12.h.spaceH,
                      _schoolPickUp(state),
                      16.h.spaceH,
                      _startEnd(state),
                      16.h.spaceH,
                      _location(state),
                      16.h.spaceH,
                      _children(state),
                      12.h.spaceH,
                      _assignedTo(state),
                      12.h.spaceH,
                      _requireApproval(state),
                      12.h.spaceH,
                      _note(state),
                      _attachDocument(state),
                      20.h.spaceH,
                      _button(),
                    ],
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 12.w,
                  child: BaseButton(
                    onTap: () => Navigator.pop(context),
                    child: Assets.icons.icBackIcon.image(
                      height: 36.h,
                      width: 36.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chipWidget({
    required String text,
    required VoidCallback? onTap,
    required bool selected,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tabBarBgColor,
          borderRadius: BorderRadius.circular(20.r),
          border: selected ? Border.all(color: primaryColor, width: 2) : null,
        ),
        child: text
            .appText(fontWeight: FontWeight.w700, fontSize: 13.sp)
            .appPadding(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
      ),
    );
  }

  Widget _accessCard({
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    title.appText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: blackTextColor,
                    ),
                    if (isRequired) ...[
                      8.w.spaceW,
                      LocaleKeys.starRequired.tr().appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                4.h.spaceH,
                description.appText(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: greyColor1,
                ),
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.8,
              child: Switch(value: switchValue, onChanged: onChanged),
            ),
        ],
      ),
    );
  }

  Widget _attachDocument(AddSharedEventState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseButton(
          onTap: () => _chooseImage(state),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocaleKeys.attachDocument
                    .tr()
                    .appText(fontWeight: FontWeight.w600, fontSize: 14.sp),
                8.w.spaceW,
                Assets.icons.icPremiumIcon.image(height: 20.h, width: 20.w),
              ],
            ),
          ),
        ),
        12.h.spaceH,
        ...state.documentsList.map(
          (String url) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file_outlined, size: 22.sp),
                10.w.spaceW,
                Expanded(
                  child: _getFileName(url).appText(
                    fontSize: 12.sp,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
    required VoidCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
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
        child: text.appText(
          color: cardColor2,
          fontWeight: FontWeight.w800,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  Widget _titleTextField(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.title.tr(),
      hint: LocaleKeys.schoolPickUp.tr(),
      error: state.titleError,
      controller: _titleController,
      onChanged: (String value) {
        context.read<AddSharedEventCubit>().changeProps(title: value);
      },
    );
  }

  Widget _schoolPickUp(AddSharedEventState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.date.tr().appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: blackTextColor,
        ),
        8.h.spaceH,
        BaseButton(
          onTap: _showDatePicker,
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Assets.icons.icCalenderIcon3
                    .image(height: 22.h, width: 22.w),
                12.w.spaceW,
                (state.selectedDate != null
                        ? getStringDate(state.selectedDate)
                        : LocaleKeys.chooseDate.tr())
                    .appText(
                      fontSize: 14.sp,
                      color: state.selectedDate != null
                          ? blackTextColor
                          : greyColor1,
                    ),
              ],
            ),
          ),
        ),
        if (state.dateError.isNotEmpty) ...[
          6.h.spaceH,
          state.dateError.appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _startEnd(AddSharedEventState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocaleKeys.start.tr().appText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: blackTextColor,
              ),
              8.h.spaceH,
              BaseButton(
                onTap: _showStartTime,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Assets.icons.icTimerIcon.image(height: 22.h, width: 22.w),
                      12.w.spaceW,
                      (state.startTime != null
                              ? getStringTime(state.startTime)
                              : LocaleKeys.startHint.tr())
                          .appText(
                            fontSize: 14.sp,
                            color: state.startTime != null
                                ? blackTextColor
                                : greyColor1,
                          ),
                    ],
                  ),
                ),
              ),
              if (state.startTimeError.isNotEmpty) ...[
                6.h.spaceH,
                state.startTimeError.appText(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: redColor,
                ),
              ],
            ],
          ),
        ),
        12.w.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocaleKeys.end.tr().appText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: blackTextColor,
              ),
              8.h.spaceH,
              BaseButton(
                onTap: _showEndTime,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Assets.icons.icTimerIcon.image(height: 22.h, width: 22.w),
                      12.w.spaceW,
                      (state.endTime != null
                              ? getStringTime(state.endTime)
                              : LocaleKeys.endHint.tr())
                          .appText(
                            fontSize: 14.sp,
                            color: state.endTime != null
                                ? blackTextColor
                                : greyColor1,
                          ),
                    ],
                  ),
                ),
              ),
              if (state.endTimeError.isNotEmpty) ...[
                6.h.spaceH,
                state.endTimeError.appText(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: redColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _location(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.location.tr(),
      hint: LocaleKeys.locationHint.tr(),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.icLocationIcon.image(height: 22.h, width: 22.w),
        ],
      ),
      error: state.locationError,
      controller: _locationController,
      onChanged: (String value) {
        context.read<AddSharedEventCubit>().changeProps(locationText: value);
      },
    );
  }

  Widget _children(AddSharedEventState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            LocaleKeys.child.tr().appText(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: blackTextColor,
            ),
            8.w.spaceW,
            Assets.icons.icChildEmojiIcon.image(height: 24.h, width: 24.w),
          ],
        ),
        10.h.spaceH,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: state.children
              .map(
                (ChildModel child) => _chipWidget(
                  text: child.childName ?? '',
                  selected: state.selectedChildren.any(
                    (ChildModel e) => e.reference?.id == child.reference?.id,
                  ),
                  onTap: () {
                    context.read<AddSharedEventCubit>().selectChild(child);
                  },
                ),
              )
              .toList(),
        ),
        if (state.selectedChildError.isNotEmpty) ...[
          8.h.spaceH,
          state.selectedChildError.appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _assignedTo(AddSharedEventState state) {
    final List<Widget> chips = <Widget>[
      _chipWidget(
        text: 'you'.tr(),
        selected: state.selectedCoParentList.any(
          (UserModel e) => e.uid == state.userModel?.uid,
        ),
        onTap: () {
          if (state.userModel != null) {
            context.read<AddSharedEventCubit>().selectParent(state.userModel!);
          }
        },
      ),
      ...state.coParentList.map(
        (UserModel user) => _chipWidget(
          text: user.parentName ?? '',
          selected: state.selectedCoParentList.any(
            (UserModel e) => e.uid == user.uid,
          ),
          onTap: () {
            context.read<AddSharedEventCubit>().selectParent(user);
          },
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LocaleKeys.assignedTo.tr().appText(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: blackTextColor,
        ),
        10.h.spaceH,
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.w,
          runSpacing: 8.h,
          children: chips,
        ),
        if (state.assignedToError.isNotEmpty) ...[
          8.h.spaceH,
          state.assignedToError.appText(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: redColor,
          ),
        ],
      ],
    );
  }

  Widget _note(AddSharedEventState state) {
    return AppTextField(
      title: LocaleKeys.noteToCoParent.tr(),
      hint: LocaleKeys.anythingTheyShouldKnow.tr(),
      minLines: 4,
      maxLines: 5,
      controller: _noteController,
      error: state.noteError,
      onChanged: (String value) {
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
    return _accessCard(
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
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then(
      (TimeOfDay? value) {
        if (value != null && navigatorKey.currentContext != null) {
          final DateTime now = DateTime.now();
          navigatorKey.currentContext!.read<AddSharedEventCubit>().changeProps(
                startTime: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  value.hour,
                  value.minute,
                ),
              );
        }
      },
    );
  }

  void _showEndTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then(
      (TimeOfDay? value) {
        if (value != null && navigatorKey.currentContext != null) {
          final DateTime now = DateTime.now();
          navigatorKey.currentContext!.read<AddSharedEventCubit>().changeProps(
                endTime: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  value.hour,
                  value.minute,
                ),
              );
        }
      },
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1971),
      lastDate: DateTime(2030),
    ).then((DateTime? value) {
      if (value != null && navigatorKey.currentContext != null) {
        navigatorKey.currentContext!.read<AddSharedEventCubit>().changeProps(
              selectedDate: value,
            );
      }
    });
  }

  String _getFileName(String url) {
    final String path = url.split('?').first;
    final List<String> parts = path.split('%2F');
    return parts.isNotEmpty ? parts.last : url;
  }
}
