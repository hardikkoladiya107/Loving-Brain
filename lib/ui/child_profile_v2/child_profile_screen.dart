import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_cubit.dart';
import 'package:loving_brain/ui/child_profile_v2/bloc/child_profile_v2_state.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/editable_field_card.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/location_picker_sheet.dart';

class ChildProfileScreen extends StatefulWidget {
  final String? userId;
  final bool fromManageChildren;
  const ChildProfileScreen({
    super.key,
    this.userId,
    this.fromManageChildren = false,
  });

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChildProfileV2Cubit>().init(
        createNew: widget.fromManageChildren,
      );
    });
  }

  Future<void> _pickDob(
    BuildContext context,
    ChildProfileV2Cubit cubit,
    DateTime? currentDob,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime defaultToddler = DateTime(now.year - 2, 6, 15);
    final DateTime initialDate = currentDob ?? defaultToddler;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(now.year - 18, 1, 1),
      lastDate: now,
      initialDatePickerMode: currentDob == null
          ? DatePickerMode.year
          : DatePickerMode.day,
    );
    if (picked != null) {
      cubit.updateDob(picked);
    }
  }

  Future<void> _editConcerns(
    BuildContext context,
    ChildProfileV2Cubit cubit,
  ) async {
    final List<String> initial = cubit.state.concerns
        .split(',')
        .map((String concern) => concern.trim())
        .where((String concern) => concern.isNotEmpty)
        .toList();
    final Object? result = await context.push<Object?>(
      RoutePaths.editChildConcerns,
      extra: initial,
    );
    if (result is List<String> && context.mounted) {
      cubit.updateField(concerns: result.join(', '));
    }
  }

  Future<void> _confirmDeleteChild(
    BuildContext context,
    ChildProfileV2Cubit cubit,
  ) async {
    final String childName = cubit.state.name.trim().isNotEmpty
        ? cubit.state.name.trim()
        : 'this child';
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: const Color(0xFFD84315),
                    size: 26.sp,
                  ),
                ),
                16.spaceH,
                'Delete child profile?'.appText(
                  fontSize: 20.sp,
                  color: greyColor9,
                  fraunces: true,
                  textAlign: TextAlign.center,
                ),
                10.spaceH,
                'This permanently deletes $childName\'s profile, shared logs, and access for every linked parent. This cannot be undone.'
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                20.spaceH,
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.zero,
                  title: 'Delete',
                  backgroundColor: const Color(0xFFD84315),
                  borderColor: const Color(0xFFD84315),
                  textColor: Colors.white,
                  onTap: () => Navigator.pop(dialogContext, true),
                ),
                12.spaceH,
                AppButton(
                  height: 48.h,
                  padding: EdgeInsets.zero,
                  title: 'Cancel',
                  backgroundColor: const Color(0xFFF8F5F2),
                  borderColor: const Color(0xFFE9E2DC),
                  textColor: greyColor9,
                  onTap: () => Navigator.pop(dialogContext, false),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (confirmed == true && context.mounted) {
      await cubit.removeChild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildProfileV2Cubit, ChildProfileV2State>(
      listener: (context, state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (dynamic message) {
            EasyLoading.dismiss();
            final String text = message is String && message.trim().isNotEmpty
                ? message.trim()
                : 'Profile saved successfully';
            showSnackBar(message: text, type: SnackBarType.SUCCESS);
            final bool deleted =
                text == ChildProfileV2Cubit.childDeletedMessage;
            if ((deleted || widget.fromManageChildren) && context.canPop()) {
              context.pop(true);
            }
          },
          error: (Exception exception) {
            EasyLoading.dismiss();
            showSnackBar(
              message: exception.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, ChildProfileV2State state) {
        final ChildProfileV2Cubit cubit = context.read<ChildProfileV2Cubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              // Bottom Right Glow
              Positioned(
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: darkBlue,
                                size: 24.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 40.w),
                                child: "Child profile".appText(
                                  fontSize: 24.sp,
                                  color: greyColor9,
                                  fraunces: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          24.spaceH,
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDC21A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.face,
                                size: 48.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          32.spaceH,
                          EditableFieldCard(
                            label: "CHILD'S NAME",
                            value: state.name,
                            maxLength: 50,
                            onChanged: (v) => cubit.updateField(name: v),
                            onEdit: () {},
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "DATE OF BIRTH",
                            value: state.dob,
                            hintText: "Select date of birth",
                            readOnly: true,
                            onTap: () =>
                                _pickDob(context, cubit, state.childDob),
                            onEdit: () =>
                                _pickDob(context, cubit, state.childDob),
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "ROUTINES & CONCERNS",
                            value: state.concerns,
                            hintText: "Choose routines and concerns",
                            readOnly: true,
                            onTap: () => _editConcerns(context, cubit),
                            onEdit: () => _editConcerns(context, cubit),
                          ),
                          12.spaceH,
                          EditableFieldCard(
                            label: "LOCATION / TIME ZONE",
                            value: state.location,
                            hintText: "Select location & time zone",
                            readOnly: true,
                            onTap: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                            onEdit: () => showLocationPickerSheet(
                              context,
                              initialLocation: state.location,
                              initialLocationData: cubit.locationData,
                              onLocationSelected: cubit.updateLocationData,
                            ),
                          ),
                          24.spaceH,
                          GestureDetector(
                            onTap: () {
                              context.push(RoutePaths.essentials);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: greyColor12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: orangeLightColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.medical_services_outlined,
                                        color: primaryColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                  12.spaceW,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "CHILD ESSENTIALS".appText(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: greyColor,
                                          textAlign: TextAlign.start,
                                        ),
                                        2.spaceH,
                                        "Allergies, medications & care notes"
                                            .appText(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: darkBlue,
                                              textAlign: TextAlign.start,
                                            ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: greyColor,
                                    size: 22.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          24.spaceH,
                          InfoBox.orange(
                            iconData: null,
                            body:
                                "Changing the date of birth will re-base age guidance from the next day.",
                          ),
                          if (cubit.canDeleteChild) ...<Widget>[
                            24.spaceH,
                            AppButton(
                              title: 'Delete child',
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              borderColor: const Color(0xFFD84315),
                              textColor: const Color(0xFFD84315),
                              onTap: () => _confirmDeleteChild(context, cubit),
                            ),
                          ],
                          if (state.isEdited) 120.spaceH else 40.spaceH,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isEdited) _buildBottomActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: isKeyboardOpen ? 10.h : 24.h,
          bottom: isKeyboardOpen
              ? 10.h
              : (20.h + MediaQuery.of(context).padding.bottom),
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: AppButton(
          title: "Save changes",
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read<ChildProfileV2Cubit>().saveProfile();
          },
        ),
      ),
    );
  }
}
