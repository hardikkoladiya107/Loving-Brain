import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../other/app_color.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF8F4),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(Assets.v2.images.imgWelcomeBg.path),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              32.spaceH,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.v2.icons.icAppIconSvg.svg(height: 80.h, width: 80.w),
                  15.spaceW,
                  Assets.v2.icons.icLovingBrainText2.svg(),
                ],
              ),
              Spacer(),
              "Understand\npatterns.".appText(
                textStyle: getTextStyle(
                  fraunces: true,
                  fontSize: 30,
                  height: 0.8,
                ),
              ),
              10.spaceH,
              "Know what to try next".appText(color: greyColor),
              24.spaceH,
              AppButton(
                onTap: () {
                  context.push(RoutePaths.register);
                },
                title: "Get Started",
              ),
              32.spaceH,
            ],
          ),
        ),
      ),
    );
  }
}
