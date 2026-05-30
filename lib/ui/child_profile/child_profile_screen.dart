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
  final TextEditingController childNameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ChildProfileCubit>().init();
    });
  }

  @override
  void dispose() {
    childNameTextEditingController.dispose();
    super.dispose();
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

        return Scaffold(
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
                top: -60.h,
                left: -40.w,
                child: _decorativeOrb(
                  size: 170.r,
                  colors: [const Color(0xFFFFD7EE), const Color(0xFFFFEEF8)],
                ),
              ),
              Positioned(
                top: 120.h,
                right: -45.w,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        16.spaceH,
                        if (widget.fromManageChildren) _backButton(),
                        if (widget.fromManageChildren) 18.spaceH else 32.spaceH,
                        _header(),
                        26.spaceH,
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
                              _childName(state),
                              16.spaceH,
                              _childDob(state),
                              30.spaceH,
                              _startMyJourney(),
                            ],
                          ),
                        ).appPadding(left: 20, right: 20),
                        32.spaceH,
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
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.12),
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
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
      child: "Tell us about your child"
          .appText(
            fontWeight: FontWeight.w800,
            fontSize: 19.sp,
            color: const Color(0xFF374151),
            textAlign: TextAlign.center,
          )
          .appPadding(left: 24, right: 24, top: 14, bottom: 14),
    ).appPadding(left: 28, right: 28);
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
      fillColor: const Color(0xFFF9FAFB),
    ).appPadding(left: 24, right: 24);
  }

  Widget _childDob(ChildProfileState state) {
    final String dobText = state.childDob != null
        ? DateFormat('dd MMM yyyy').format(state.childDob!)
        : 'Select date of birth';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Child date of birth".appText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        8.spaceH,
        BaseButton(
          onTap: _pickChildDob,
          child: Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
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
                Icon(
                  Icons.calendar_month_rounded,
                  size: 20.sp,
                  color: Colors.grey.shade500,
                ),
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
    ).appPadding(left: 24, right: 24);
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
            "Continue"
                .appText(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 16.sp,
                  letterSpacing: 0.3,
                )
                .appPadding(top: 14, bottom: 14),
          ],
        ),
      ),
      onTap: () {
        context.read<ChildProfileCubit>().addChildDetail(widget.userId);
      },
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
