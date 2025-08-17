import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/home_screen/home_screen.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../widget/app_dropdown.dart';
import 'bloc/child_profile_cubit.dart';
import 'bloc/child_profile_state.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildProfileCubit, ChildProfileState>(
      builder: (context, state) {
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
                  _childName(),
                  10.spaceH,
                  _relationshipToChild(),
                  10.spaceH,
                  childsAge(),
                  16.spaceH,
                  _startMyJourney(),
                  32.spaceH,
                  _signUpWithGoogle(),
                  16.spaceH,
                  _signUpWithApple(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
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

  Widget _childName() {
    return AppTextField(
      title: LocaleKeys.childName.tr(),
      hint: LocaleKeys.enterChildName.tr(),
    ).appPadding(left: 30, right: 30);
  }

  Widget _relationshipToChild() {
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
                LocaleKeys.selectRelationship.tr().appText(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
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

  Widget childsAge() {
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
                LocaleKeys.selectAge.tr().appText(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
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
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
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
