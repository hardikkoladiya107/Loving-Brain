import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
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
      backgroundColor: addSharedEventBgColor,
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
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.icCalenderIcon3
                          .image(height: 20, width: 20)
                          .padding(left: 8),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        title: "Start",
                        hint: "4:00 PM",
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.icTimerIcon
                                .image(height: 20, width: 20)
                                .padding(left: 8),
                          ],
                        ),
                      ),
                    ),
                    10.spaceW,
                    Expanded(
                      child: AppTextField(
                        title: "End",
                        hint: "4:30 PM",
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.icTimerIcon
                                .image(height: 20, width: 20)
                                .padding(left: 8),
                          ],
                        ),
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

                Row(
                  children: [
                    "Child".appText(fontSize: 14, fontWeight: FontWeight.w600),
                    10.w.spaceW,
                    Assets.icons.icChildEmojiIcon.image(height: 25, width: 25),
                  ],
                ),
                10.h.spaceH,
                Row(
                  children: [
                    _chipWidget(text: 'Leo'),
                    8.w.spaceW,
                    _chipWidget(text: 'Ava'),
                  ],
                ),
                10.h.spaceH,
                Row(
                  children: [
                    "Assigned to".appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                10.h.spaceH,
                Row(
                  children: [
                    _chipWidget(text: 'You'),
                    8.w.spaceW,
                    _chipWidget(text: 'Priya'),
                  ],
                ),
                10.h.spaceH,
                accessCard(
                  isRequired: false,
                  title: 'Require approval',
                  description: 'Send to co‐parent for confirmation',
                ),
                10.h.spaceH,

                AppTextField(
                  title: "Note to co‐parent (optional)",
                  hint: "Anything they should know ?..",
                  minLines: 5,
                ),

                _attachDocument(),
                20.h.spaceH,
                _requestApprovalButton(text: 'Request Approval', onTap: () {}),
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

  Widget _chipWidget({required String text}) {
    return Container(
      decoration: BoxDecoration(
        color: tabBarBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: text
          .appText(fontWeight: FontWeight.w700)
          .appPadding(left: 16, right: 16, top: 8, bottom: 8),
    );
  }

  Widget accessCard({
    required bool isRequired,
    required String title,
    required String description,
    bool showSwitch = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title.appText(fontSize: 14, fontWeight: FontWeight.w700),
                    if (isRequired) ...[
                      16.spaceW,
                      "* Required".appText(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ],
                ),
                description.appText(fontSize: 10, fontWeight: FontWeight.w700),
              ],
            ),
          ),
          if (showSwitch)
            Transform.scale(
              scale: 0.7,
              child: Switch(value: true, onChanged: (value) {}),
            ),
        ],
      ).appPadding(all: 10),
    );
  }

  Widget _attachDocument() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Attach Document"
              .appText(fontWeight: FontWeight.w600, fontSize: 14)
              .appPadding(top: 6, bottom: 6),
          8.w.spaceW,
          Assets.icons.icPremiumIcon.image(height: 20, width: 20),
        ],
      ),
    );
  }

  Widget _requestApprovalButton({
    required String text,
    required GestureTapCallback? onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: yellowColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.appText(
              color: cardColor2,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
