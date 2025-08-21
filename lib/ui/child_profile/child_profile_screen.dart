import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home_screen/home_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../../other/preferances.dart';
import '../../other/snack_bar.dart';
import '../widget/app_dropdown.dart';
import 'bloc/child_profile_cubit.dart';
import 'bloc/child_profile_state.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key, required this.userId});

  final String userId;

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
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(),
                  100.spaceH,
                  _header(),
                  80.spaceH,
                  _childName(state),
                  10.spaceH,
                  _relationshipToChild(state),
                  10.spaceH,
                  childsAge(state),
                  32.spaceH,
                  _startMyJourney(),
                  32.spaceH,
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
          data: (data) async {
            EasyLoading.dismiss();
            context.read<ChildProfileCubit>().clearFields();
            await preferences.putBool(SharedPreference.isLogin, true);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LocaleKeys.weGuideYouThroughParenting
          .tr()
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

  Widget _relationshipToChild(ChildProfileState state) {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        List<Widget> widgetsList = [];
        for (int i = 0; i < state.relationshipList.length; i++) {
          var relationShip = state.relationshipList[i];
          widgetsList.add(
            BaseButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  8.spaceH,
                  relationShip
                      .appText(fontWeight: FontWeight.w500)
                      .appPadding(left: 16),
                  8.spaceH,
                  if (i < state.relationshipList.length - 1)
                    Divider(height: 0.1, thickness: 0.2),
                ],
              ),
              onTap: () {
                close.call();
                context.read<ChildProfileCubit>().changeProps(
                  relationShipToChild: relationShip,
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
          LocaleKeys.yourRelationshipToChild.tr().appText(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          8.spaceH,
          Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,
                if (state.relationShipToChild.isNotEmpty) ...[
                  state.relationShipToChild.appText(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ] else ...[
                  LocaleKeys.selectRelationship.tr().appText(
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
                  (state.relationShipToChildError).appText(
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

  Widget childsAge(ChildProfileState state) {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        List<Widget> widgetsList = [];
        for (int i = 0; i < state.childAgeList.length; i++) {
          var age = state.childAgeList[i];
          widgetsList.add(
            BaseButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  8.spaceH,
                  age.appText(fontWeight: FontWeight.w500).appPadding(left: 16),
                  8.spaceH,
                  if (i < state.childAgeList.length - 1)
                    Divider(height: 0.1, thickness: 0.2),
                ],
              ),
              onTap: () {
                close.call();
                context.read<ChildProfileCubit>().changeProps(childAge: age);
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
          LocaleKeys.childAgeStage.tr().appText(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          8.spaceH,
          Container(
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                16.spaceW,

                if (state.childAge.isNotEmpty) ...[
                  state.childAge.appText(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ] else ...[
                  LocaleKeys.selectAge.tr().appText(
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
                  (state.childAgeError).appText(
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
            LocaleKeys.startMyJourney
                .tr()
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

  Widget _signUpWithGoogle() {
    return BaseButton(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icGoogleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.signUpWithGoogle
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 8, bottom: 8),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _signUpWithApple() {
    return BaseButton(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.icAppleIcon.image(height: 24, width: 24),
            20.spaceW,
            LocaleKeys.signInWithApple
                .tr()
                .appText(fontWeight: FontWeight.w700, fontSize: 14)
                .appPadding(top: 10, bottom: 10),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
