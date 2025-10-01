import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../../other/snack_bar.dart';
import 'bloc/parent_profile_cubit.dart';
import 'bloc/parent_profile_state.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key,});


  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  TextEditingController parentNameTextEditingController =
      TextEditingController();
  TextEditingController parentEmailTextEditingController =
      TextEditingController();

  @override
  void initState() {
    context.read<ParentProfileCubit>().init();
    super.initState();
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

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgParentProfileBg.path),
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  80.spaceH,
                  _header(),
                  140.spaceH,
                  _name(state),
                  10.spaceH,
                  _email(state),
                  10.spaceH,
                  _dateOfBirthButton(context, state),
                  10.spaceH,
                  _genderDropDown(state),
                  30.spaceH,
                  _nextButton(),
                ],
              ),
            ),
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ChildProfileScreen(userId: data.toString()),
              ),
            );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.5),
      ),
      child: LocaleKeys.createYourAccountToBeginYourParentingJourney
          .tr()
          .appText(fontWeight: FontWeight.w900, color: yellowTextColor)
          .appPadding(all: 10),
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
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                Icon(Icons.calendar_month),
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
                (state.parentDateOfBirthError ?? "").appText(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Widget _genderDropDown(ParentProfileState state) {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        List<Widget> widgetsList = [];
        for (int i = 0; i < state.genderList.length; i++) {
          var gender = state.genderList[i];
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(1, 1),
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
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,
                if ((state.parentGender ?? "").isNotEmpty) ...[
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
                Icon(Icons.arrow_drop_down),
                20.spaceW,
              ],
            ),
          ),
          Column(
            children: [
              4.spaceH,
              Row(
                children: [
                  (state.parentGenderError ?? "").appText(
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
    ).appPadding(left: 30, right: 30);
  }

  Widget _nextButton() {
    return BaseButton(
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          color: buttonColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.next
                .tr()
                .appText(color: Colors.white, fontWeight: FontWeight.w800)
                .appPadding(top: 8, bottom: 8),
          ],
        ),
      ),
      onTap: () {
        context.read<ParentProfileCubit>().addParentDetail( );
      },
    );
  }

  Future<void> _showDatePickerDialog() async {
    var date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
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
    ).appPadding(left: 30, right: 30);
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
    ).appPadding(left: 30, right: 30);
  }
}
