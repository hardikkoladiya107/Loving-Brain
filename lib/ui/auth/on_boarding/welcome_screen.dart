import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:flutter/gestures.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../other/app_color.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.v2.images.imgWelcomeBg.path),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              32.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.v2.icons.icAppIcon.svg(height: 80.h, width: 80.w),
                  15.spaceW,
                  Assets.v2.icons.icLovingBrainText2.svg(),
                ],
              ),
              Spacer(),
              "Understand\npatterns.".appText(
                textStyle: getTextStyle2(fontSize: 30, height: 0.8),
              ),
              10.spaceH,
              "Know what to try next.".appText(color: greyColor),
              24.spaceH,
              AppButton(onTap: () {
                context.push(RoutePaths.register);
              }, title: "Get Started"),
              32.spaceH,
            ],
          ),
        ),
      ),
    );
  }
}
