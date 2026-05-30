import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';

import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../../other/snack_bar.dart';
import 'bloc/parent_profile_cubit.dart';
import 'bloc/parent_profile_state.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final TextEditingController parentNameTextEditingController =
      TextEditingController();
  final TextEditingController parentEmailTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ParentProfileCubit>().init();
    });
  }

  @override
  void dispose() {
    parentNameTextEditingController.dispose();
    parentEmailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileCubit, ParentProfileState>(
      builder: (context, state) {
        if (parentEmailTextEditingController.value.text !=
            state.parentEmailAddress) {
          parentEmailTextEditingController.value =
              parentEmailTextEditingController.value.copyWith(
                text: state.parentEmailAddress,
                selection: TextSelection.collapsed(
                  offset: min(
                    parentEmailTextEditingController.value.selection.start,
                    state.parentEmailAddress.length,
                  ),
                ),
              );
        }

        if (parentNameTextEditingController.value.text != state.parentName) {
          parentNameTextEditingController.value =
              parentNameTextEditingController.value.copyWith(
                text: state.parentName,
                selection: TextSelection.collapsed(
                  offset: min(
                    parentNameTextEditingController.value.selection.start,
                    state.parentName.length,
                  ),
                ),
              );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFF6F0FF),
                        Color(0xFFFFF0F5),
                        Color(0xFFF9FAFB),
                        Color(0xFFF9FAFB),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -65.h,
                right: -40.w,
                child: _decorativeOrb(
                  size: 180.r,
                  colors: [const Color(0xFFFFD7EE), const Color(0xFFFFEEF8)],
                ),
              ),
              Positioned(
                top: 120.h,
                left: -50.w,
                child: _decorativeOrb(
                  size: 140.r,
                  colors: [const Color(0xFFDDF3FF), const Color(0xFFF2FAFF)],
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        34.spaceH,
                        _header(),
                        28.spaceH,
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.08),
                                blurRadius: 30.r,
                                offset: Offset(0, 10.h),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _name(state),
                              16.spaceH,
                              _email(state),
                              16.spaceH,
                              _dateOfBirthButton(context, state),
                              16.spaceH,
                              _genderDropDown(state),
                              30.spaceH,
                              _nextButton(),
                            ],
                          ),
                        ).appPadding(left: 20, right: 20),
                        40.spaceH,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            context.read<ParentProfileCubit>().clearFields();
            context.replace(RoutePaths.childProfilePath(data.toString()));
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
        );
      },
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.08),
                blurRadius: 24.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: LocaleKeys.createYourAccountToBeginYourParentingJourney
              .tr()
              .appText(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF374151),
                fontSize: 20.sp,
                textAlign: TextAlign.center,
                height: 1.35,
              )
              .appPadding(left: 20, right: 20, top: 14, bottom: 14),
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _dateOfBirthButton(BuildContext context, ParentProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocaleKeys.dateOfBirth.tr().appText(fontSize: 14),
        8.spaceH,
        BaseButton(
          child: Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                16.spaceW,
                if (state.parentDateOfBirth != null) ...[
                  formatDate(state.parentDateOfBirth!).toString().appText(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ] else ...[
                  LocaleKeys.selectDateOfBirth.tr().appText(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
                Spacer(),
                Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.grey.shade500,
                  size: 20.sp,
                ),
                20.spaceW,
              ],
            ),
          ),
          onTap: () {
            _showDatePickerDialog();
          },
        ),
        Column(
          children: [
            4.spaceH,
            Row(
              children: [
                state.parentDateOfBirthError.appText(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ],
    ).appPadding(left: 24, right: 24);
  }

  Widget _genderDropDown(ParentProfileState state) {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        final List<Widget> widgetsList = <Widget>[];
        for (int i = 0; i < state.genderList.length; i++) {
          final String gender = state.genderList[i];
          widgetsList.add(
            BaseButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  8.spaceH,
                  gender
                      .appText(fontWeight: FontWeight.w500)
                      .appPadding(left: 16),
                  8.spaceH,
                  if (i < state.genderList.length - 1)
                    Divider(height: 0.1, thickness: 0.2),
                ],
              ),
              onTap: () {
                close.call();
                context.read<ParentProfileCubit>().changeProps(
                  parentGender: gender,
                );
              },
            ),
          );
        }

        return Container(
          height: 125.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.08),
                blurRadius: 12.r,
                spreadRadius: 1.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...widgetsList],
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocaleKeys.gender.tr().appText(fontSize: 14),
          8.spaceH,
          Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                16.spaceW,
                if (state.parentGender.isNotEmpty) ...[
                  state.parentGender.appText(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ] else ...[
                  LocaleKeys.selectGender.tr().appText(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade500,
                  size: 22.sp,
                ),
                20.spaceW,
              ],
            ),
          ),
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  state.parentGenderError.appText(
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
    ).appPadding(left: 24, right: 24);
  }

  Widget _nextButton() {
    return BaseButton(
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 15.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.next
                .tr()
                .appText(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                  letterSpacing: 0.3,
                )
                .appPadding(top: 14, bottom: 14),
          ],
        ),
      ),
      onTap: () {
        context.read<ParentProfileCubit>().addParentDetail();
      },
    );
  }

  Future<void> _showDatePickerDialog() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        context.read<ParentProfileCubit>().state.parentDateOfBirth ??
        DateTime(now.year - 24, now.month, now.day);
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (date == null) {
      return;
    }
    context.read<ParentProfileCubit>().changeProps(parentDateOfBirth: date);
  }

  Widget _name(ParentProfileState state) {
    return AppTextField(
      title: LocaleKeys.yourName.tr(),
      hint: LocaleKeys.enterYourName.tr(),
      controller: parentNameTextEditingController,
      error: state.parentNameError,
      onChanged: (value) {
        context.read<ParentProfileCubit>().changeProps(parentName: value);
      },
      fillColor: const Color(0xFFF9FAFB),
    ).appPadding(left: 24, right: 24);
  }

  Widget _email(ParentProfileState state) {
    return AppTextField(
      title: LocaleKeys.email.tr(),
      hint: LocaleKeys.enterEmail.tr(),
      keyboardType: TextInputType.emailAddress,
      error: state.parentEmailAddressError,
      controller: parentEmailTextEditingController,
      onChanged: (value) {
        context.read<ParentProfileCubit>().changeProps(
          parentEmailAddress: value,
        );
      },
      fillColor: const Color(0xFFF9FAFB),
    ).appPadding(left: 24, right: 24);
  }

  Widget _decorativeOrb({required double size, required List<Color> colors}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
