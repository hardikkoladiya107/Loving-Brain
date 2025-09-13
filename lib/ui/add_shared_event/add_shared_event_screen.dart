import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../widget/base_button.dart';

class AddSharedEventScreen extends StatefulWidget {
  const AddSharedEventScreen({super.key});

  @override
  State<AddSharedEventScreen> createState() => _AddSharedEventScreenState();
}

class _AddSharedEventScreenState extends State<AddSharedEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgAddSharedBg.image(
                  height: context.height,
                  width: context.width,
                  fit: BoxFit.cover,
                ),
                Container(height: context.height / 2),
              ],
            ),
            Column(
              children: [
                45.h.spaceH,
                _appBar(),
                60.h.spaceH,
                LocaleKeys.addSharedEvent.tr().appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                20.h.spaceH,
                AppTextField(title: "Title", hint: "School Pick Up"),
                AppTextField(
                  title: "Date",
                  hint: "School Pick Up",
                  prefixIcon: Assets.icons.icCalenderIcon3.image(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        title: "Start",
                        hint: "4:00 PM",
                        prefixIcon: Assets.icons.icTimerIcon.image(),
                      ),
                    ),
                    10.spaceW,
                    Expanded(
                      child: AppTextField(
                        title: "End",
                        hint: "4:30 PM",
                        prefixIcon: Assets.icons.icTimerIcon.image(),
                      ),
                    ),
                  ],
                ),
                AppTextField(
                  title: "Location",
                  hint: "St. Mary’s Primary – Front Gate",
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.icLocationIcon
                          .image(height: 20, width: 20)
                          .padding(left: 8),
                    ],
                  ),
                ),
              ],
            ).appPadding(left: 20.w, right: 20.w),
          ],
        ),
      ),
    );
  }

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
      ],
    );
  }
}
