import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

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
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            80.spaceH,
            _header(),
            140.spaceH,
            AppTextField(title: "Your Name").appPadding(left: 30, right: 30),
            10.spaceH,
            AppTextField(title: "Email").appPadding(left: 30, right: 30),
            10.spaceH,
            AppTextField(
              title: "Date of Birth",
            ).appPadding(left: 30, right: 30),
            10.spaceH,
            AppTextField(title: "Gender").appPadding(left: 30, right: 30),
          ],
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
}
