import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      return Row(
        children: [
          BaseButton(
            child: Assets.icons.icBackIcon.image(
              height: 36,
              width: 36,
              color: Colors.black.withValues(alpha: 0.8),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          12.w.spaceW,
          "Your Streak !".appText(fontWeight: FontWeight.w700),
        ],
      );
    }

    return Scaffold(body: Column(children: [_appBar()]));
  }
}
