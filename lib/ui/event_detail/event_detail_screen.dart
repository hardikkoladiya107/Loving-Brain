import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: addSharedEventBgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgEventDetailBg.image(
                  height: context.height,
                  width: context.width,
                  fit: BoxFit.cover,
                ),
                Container(height: context.height / 2),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                45.h.spaceH,
                _appBar(),
                30.h.spaceH,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "School Pick‐up".appText(fontWeight: FontWeight.w800),
                      "For Leo • Created by David".appText(fontSize: 14),
                    ],
                  ).appPadding(all: 8),
                ),
                40.h.spaceH,
                Row(
                  children: [
                    Assets.icons.icCalenderIcon3.image(height: 20, width: 20),
                    12.w.spaceW,
                    "Mon, Aug 5".appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ).appPadding(left: 12.w),
                16.h.spaceH,
                Row(
                  children: [
                    Assets.icons.icTimerIcon.image(height: 24, width: 24),
                    12.w.spaceW,
                    "4:00 PM – 4:30 PM".appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ).appPadding(left: 12.w),
                16.h.spaceH,
                Row(
                  children: [
                    Assets.icons.icLocationIcon.image(height: 24, width: 24),
                    12.w.spaceW,
                    "St. Mary’s Primary – Front Gate".appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ).appPadding(left: 12.w),
                16.h.spaceH,
                Row(
                  children: [
                    Assets.icons.icUserIcon.image(height: 24, width: 24),
                    12.w.spaceW,
                    "Sarah (you), David".appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ],
                ).appPadding(left: 12.w),
                45.h.spaceH,
                _note(),
                10.h.spaceH,
                _attachments(),
                10.h.spaceH,
                _history(),
                30.h.spaceH,
                _bottomButtons(),
                30.h.spaceH,
                "This event appears in both calendars. Changes will ask for approval."
                    .appText(fontSize: 10, fontWeight: FontWeight.w700),
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
        20.w.spaceW,
        "Event Details".appText(fontWeight: FontWeight.w700, fontSize: 20),
      ],
    );
  }

  Widget _note() {
    return Container(
      decoration: BoxDecoration(
        color: aiQuestionCardColor1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Note".appText(color: cardColor2, fontWeight: FontWeight.w700),
          "I’ll be on campus by 3:55 PM. Call me if gates are busy.".appText(
            fontSize: 12,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
        ],
      ).appPadding(all: 8),
    );
  }

  Widget _attachments() {
    return Container(
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          8.h.spaceH,
          Row(
            children: [
              10.w.spaceW,
              Assets.icons.icAttachmentPin.image(height: 20, width: 20),
              10.w.spaceW,
              "Attachment".appText(fontSize: 10, fontWeight: FontWeight.w700),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: "Add Attachment"
                    .appText(fontSize: 10, fontWeight: FontWeight.w700)
                    .appPadding(left: 6, right: 6, top: 4, bottom: 4),
              ),
              10.w.spaceW,
            ],
          ),
          8.h.spaceH,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.h.spaceH,
                "Premium feature".appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                "Attach documents to events with Loving Brain Premium.".appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                10.h.spaceH,
                _upgradeButton(),
                10.h.spaceH,
              ],
            ),
          ).appPadding(all: 20),
        ],
      ),
    );
  }

  Widget _upgradeButton() {
    return BaseButton(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            "Upgrade"
                .appText(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )
                .appPadding(left: 10, right: 10, top: 5, bottom: 5),
          ],
        ),
      ),
    ).appPadding(left: 20.w, right: 20.w);
  }

  Widget _history() {
    return Container(
      decoration: BoxDecoration(
        color: fillTextfieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.spaceH,
          "History".appText(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          4.spaceH,
          Row(
            children: [
              Assets.icons.icSuccessCheck.image(),
              4.spaceW,
              "Approved by Priya • Aug 4, 7:12 pm".appText(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ],
          ),
          4.spaceH,
          Row(
            children: [
              Assets.icons.icSuccessCheck.image(),
              4.spaceW,
              "Approved by Priya • Aug 4, 7:12 pm".appText(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ],
          ),
          10.spaceH,
        ],
      ).appPadding(left: 20),
    );
  }

  Widget _bottomButton({
    required GestureTapCallback? onTap,
    required String text,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text
                .appText(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )
                .appPadding(top: 5, bottom: 5),
          ],
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _bottomButton(onTap: () {}, text: 'Propose change'),
        ),
        10.w.spaceW,
        Expanded(
          child: _bottomButton(onTap: () {}, text: 'Reminder'),
        ),
        10.w.spaceW,
        Expanded(
          child: _bottomButton(onTap: () {}, text: 'Share'),
        ),
      ],
    );
  }
}
