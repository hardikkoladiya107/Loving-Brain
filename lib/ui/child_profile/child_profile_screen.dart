import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../../other/preferances.dart';
import '../../other/snack_bar.dart';
import 'bloc/child_profile_cubit.dart';
import 'bloc/child_profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({
    super.key,
    required this.userId,
    this.fromManageChildren = false,
  });

  final String userId;
  final bool fromManageChildren;

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  TextEditingController childNameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    context.read<ChildProfileCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildProfileCubit, ChildProfileState>(
      builder: (context, state) {
        if (childNameTextEditingController.value.text != state.childName) {
          childNameTextEditingController.value = childNameTextEditingController
              .value
              .copyWith(
                text: state.childName,
                selection: TextSelection.collapsed(
                  offset: min(
                    childNameTextEditingController.value.selection.start,
                    state.childName.length,
                  ),
                ),
              );
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgChildProfileBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.fromManageChildren) _backButton(),
                    if (widget.fromManageChildren) 24.spaceH else 100.spaceH,
                    _header(),
                    80.spaceH,
                    _childName(state),
                    10.spaceH,
                    _childDob(state),
                    32.spaceH,
                    _startMyJourney(),
                    32.spaceH,
                  ],
                ),
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
          data: (data) async {
            EasyLoading.dismiss();
            if (data is! UserModel || navigatorKey.currentContext == null) {
              if (data is! UserModel && data != null) {
                showSnackBar(
                  message: LocaleKeys.somethingWentWrong.tr(),
                  type: SnackBarType.ERROR,
                );
              }
              return;
            }
            await preferences.saveUserModel(data);
            navigatorKey.currentContext!
                .read<ChildProfileCubit>()
                .clearFields();
            if (widget.fromManageChildren) {
              navigatorKey.currentContext!.pop(true);
              return;
            }
            await preferences.putBool(SharedPreference.isLogin, true);
            navigatorKey.currentContext!.go(RoutePaths.baseScreen);
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
    );
  }

  Widget _backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: BaseButton(
        onTap: () => context.pop(),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.sp,
              color: primaryColor,
            ),
          ),
        ),
      ),
    ).appPadding(left: 16.w);
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: "Tell us about your child"
          .appText(fontWeight: FontWeight.w700, fontSize: 12)
          .appPadding(all: 8),
    );
  }

  Widget _childName(ChildProfileState state) {
    return AppTextField(
      title: LocaleKeys.childName.tr(),
      hint: LocaleKeys.enterChildName.tr(),
      error: state.childNameError,
      controller: childNameTextEditingController,
      onChanged: (value) {
        context.read<ChildProfileCubit>().changeProps(childName: value);
      },
    ).appPadding(left: 30, right: 30);
  }

  Widget _childDob(ChildProfileState state) {
    final String dobText = state.childDob != null
        ? DateFormat('dd MMM yyyy').format(state.childDob!)
        : 'Select date of birth';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Child date of birth'.appText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        8.spaceH,
        BaseButton(
          onTap: _pickChildDob,
          child: Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,
                Expanded(
                  child: dobText.appText(
                    fontSize: 14,
                    color: state.childDob != null
                        ? Colors.black
                        : Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                ),
                Icon(Icons.calendar_month_rounded, size: 20.sp),
                16.spaceW,
              ],
            ),
          ),
        ),
        4.spaceH,
        (state.childDobError).appText(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ],
    ).appPadding(left: 30, right: 30);
  }

  Future<void> _pickChildDob() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        context.read<ChildProfileCubit>().state.childDob ??
        DateTime(now.year - 2, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 12, 1, 1),
      lastDate: now,
    );
    if (pickedDate == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    context.read<ChildProfileCubit>().changeProps(
      childDob: DateTime(pickedDate.year, pickedDate.month, pickedDate.day),
      childDobError: '',
    );
  }

  Widget _startMyJourney() {
    return BaseButton(
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: pinkColor1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Continue"
                .appText(fontWeight: FontWeight.w700)
                .appPadding(top: 8, bottom: 8),
          ],
        ),
      ),
      onTap: () {
        context.read<ChildProfileCubit>().addChildDetail(widget.userId);
      },
    );
  }
}
