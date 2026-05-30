import 'dart:ui';

import 'package:go_router/go_router.dart';
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
            context.read<AddSharedEventCubit>().changeProps(
              requestApprovalApiResultStatus: ApiResultStatus.initial(),
            );
            context.pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showSnackBar(
                message: LocaleKeys.sharedEventCreated.tr(),
                type: SnackBarType.SUCCESS,
              );
            });
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
          backgroundColor: const Color(0xFFFAFAFA),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              _ambientBackground(),
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.14,
                    child: Assets.images.imgAddSharedBg.image(
                      fit: BoxFit.cover,
                      width: context.width,
                      height: context.height,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
                      child: _navHeader(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _heroBlock(),
                            18.h.spaceH,
                            _glassFormCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _sectionCard(
                                    title: LocaleKeys.title.tr(),
                                    icon: Icons.edit_calendar_rounded,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        _titleTextField(state),
                                        16.h.spaceH,
                                        _schoolPickUp(state),
                                        16.h.spaceH,
                                        _startEnd(state),
                                        16.h.spaceH,
                                        _location(state),
                                      ],
                                    ),
                                  ),
                                  14.h.spaceH,
                                  _sectionCard(
                                    title: LocaleKeys.assignedTo.tr(),
                                    icon: Icons.people_alt_rounded,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        _children(state),
                                        16.h.spaceH,
                                        _assignedTo(state),
                                        16.h.spaceH,
                                        _requireApproval(state),
                                      ],
                                    ),
                                  ),
                                  14.h.spaceH,
                                  _sectionCard(
                                    title: LocaleKeys.noteToCoParent.tr(),
                                    icon: Icons.notes_rounded,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        _note(state),
                                        16.h.spaceH,
                                        _attachDocument(state),
                                      ],
                                    ),
                                  ),
                                  24.h.spaceH,
                                  _button(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const List<Color> _ctaGradient = <Color>[
    Color(0xFF6A24B8),
    Color(0xFF894BCD),
    Color(0xFFA96EE0),
  ];

  Widget _ambientBackground() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  const Color(0xFFF5F0FF),
                  const Color(0xFFFFF8FB),
                  const Color(0xFFFAFAFA),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -90.h,
          left: -50.w,
          child: _softOrb(const Color(0xFF894BCD), 240.w),
        ),
        Positioned(
          top: 140.h,
          right: -70.w,
          child: _softOrb(const Color(0xFFFF66C4), 200.w),
        ),
        Positioned(
          bottom: 80.h,
          left: -60.w,
          child: _softOrb(const Color(0xFF5271FF), 220.w),
        ),
      ],
    );
  }

  Widget _softOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.14),
      ),
    );
  }

  Widget _navHeader() {
    return Row(
      children: <Widget>[
        BaseButton(
          onTap: () => context.pop(),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Assets.icons.icBackIcon.image(height: 22.h, width: 22.w),
              ),
            ),
          ),
        ),
        14.w.spaceW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LocaleKeys.addSharedEvent.tr().appText(
                fontWeight: FontWeight.w900,
                fontSize: 22.sp,
                color: Colors.black87,
                textAlign: TextAlign.start,
                letterSpacing: -0.3,
              ),
              4.h.spaceH,
              LocaleKeys.familySync.tr().appText(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroBlock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              primaryColor.withValues(alpha: 0.92),
              const Color(0xFFA96EE0).withValues(alpha: 0.88),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.event_available_rounded,
                color: Colors.white,
                size: 26.sp,
              ),
            ),
            14.w.spaceW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LocaleKeys.coParentingCalendar.tr().appText(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                    color: Colors.white,
                    textAlign: TextAlign.start,
                  ),
                  4.h.spaceH,
                  LocaleKeys.shareResponsibilityFairly
                      .tr()
                      .replaceAll('\n', ' ')
                      .appText(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        textAlign: TextAlign.start,
                        height: 1.3,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassFormCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.95)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18.sp, color: primaryColor),
              8.w.spaceW,
              title.appText(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: blackTextColor,
              ),
            ],
          ),
          12.h.spaceH,
          child,
        ],
      ),
    );
  }

  Widget _chipWidget({
    required String text,
    required VoidCallback? onTap,
    required bool selected,
  }) {
    return BaseButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: <Color>[
                    _ctaGradient[0].withValues(alpha: 0.95),
                    _ctaGradient[2].withValues(alpha: 0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.95),
            width: 1.5,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: selected
                  ? primaryColor.withValues(alpha: 0.28)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: selected ? 14 : 8,
              offset: Offset(0, selected ? 6 : 3),
            ),
          ],
        ),
        child: text
            .appText(
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
              color: selected ? Colors.white : Colors.black87,
            )
            .appPadding(left: 16.w, right: 16.w, top: 10.h, bottom: 10.h),
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
    IconData leadingIcon = Icons.tune_rounded,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(leadingIcon, color: primaryColor, size: 22.sp),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: title.appText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: blackTextColor,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isRequired) ...<Widget>[
                      8.w.spaceW,
                      LocaleKeys.starRequired.tr().appText(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                if (description.isNotEmpty) ...<Widget>[
                  4.h.spaceH,
                  description.appText(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: greyColor1,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.82,
              child: Switch(
                value: switchValue,
                onChanged: onChanged,
                activeTrackColor: primaryColor,
                activeThumbColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _pickerFieldDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: Colors.white, width: 1.25),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _attachDocument(AddSharedEventState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BaseButton(
          onTap: () => _chooseImage(state),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.28),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.upload_file_rounded,
                  color: primaryColor,
                  size: 22.sp,
                ),
                10.w.spaceW,
                LocaleKeys.attachDocument.tr().appText(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
                8.w.spaceW,
                Assets.icons.icPremiumIcon.image(height: 18.h, width: 18.w),
              ],
            ),
          ),
        ),
        12.h.spaceH,
        ...state.documentsList.map(
          (String url) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.description_outlined,
                    size: 20.sp,
                    color: primaryColor,
                  ),
                  10.w.spaceW,
                  Expanded(
                    child: _getFileName(url).appText(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
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
        height: 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _ctaGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.42),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: text
            .appText(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            )
            .appPadding(left: 10.w, right: 10.w),
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
            decoration: _pickerFieldDecoration(),
            child: Row(
              children: [
                Assets.icons.icCalenderIcon3.image(height: 22.h, width: 22.w),
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
                  decoration: _pickerFieldDecoration(),
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
                  decoration: _pickerFieldDecoration(),
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
        text: LocaleKeys.you.tr(),
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
      leadingIcon: Icons.verified_user_rounded,
      onChanged: (bool value) {
        context.read<AddSharedEventCubit>().changeProps(
          requiredApproval: value,
        );
      },
      switchValue: state.requiredApproval,
    );
  }

  void _showStartTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      TimeOfDay? value,
    ) {
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
    });
  }

  void _showEndTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      TimeOfDay? value,
    ) {
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
    });
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
