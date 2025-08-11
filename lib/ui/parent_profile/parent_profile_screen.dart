import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/child_profile/child_profile_screen.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
              AppTextField(title: "Your Name").appPadding(left: 30, right: 30),
              10.spaceH,
              AppTextField(title: "Email").appPadding(left: 30, right: 30),
              10.spaceH,
              _dateOfBirthButton(),
              10.spaceH,
              _genderDropDown(),
              30.spaceH,
              _nextButton(),
            ],
          ),
        ),
      ),
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

  Widget _dateOfBirthButton() {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        return Container(
          height: 200,
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
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocaleKeys.dateOfBirth.tr().appText(fontSize: 14),
          8.spaceH,
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                "".appText(),
                Spacer(),
                Icon(Icons.arrow_drop_down),
                20.spaceW,
              ],
            ),
          ),
        ],
      ),
    ).appPadding(left: 30, right: 30);
  }

  Widget _genderDropDown() {
    return AppDropDownButton(
      offset: Offset(0, 78.h),
      dropDownWidget: (close) {
        return Container(
          height: 200,
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
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Gender".appText(fontSize: 14),
          8.spaceH,
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                "".appText(),
                Spacer(),
                Icon(Icons.arrow_drop_down),
                20.spaceW,
              ],
            ),
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
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ChildProfileScreen()),
        );
      },
    );
  }
}
