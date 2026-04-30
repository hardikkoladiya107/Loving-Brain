import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class SucessScreen extends StatelessWidget {
  const SucessScreen({super.key, required this.successText});
  final String successText;
  @override
  Widget build(BuildContext context) {
    Widget appBar() {
      return Row(
        children: [
          20.spaceW,
          BaseButton(
            child: Assets.icons.icBackIcon.image(
              height: 36,
              width: 36,
              color: Colors.black.withValues(alpha: 0.8),
            ),
            onTap: () {
              context.pop();
            },
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          60.spaceH,
          appBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.imgSuccessCartoon.image(
                  // height: 36,
                  // width: 36,
                  // color: Colors.transparent,
                ),
                successText.appText(),
                60.spaceH,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
