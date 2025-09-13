import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../gen/assets.gen.dart';
import '../../other/app_color.dart';
import '../widget/base_button.dart';

class EventApprovalScreen extends StatefulWidget {
  const EventApprovalScreen({super.key});

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Assets.images.imgEventApprovalBg.image(
                  height: context.height,
                  width: context.width,
                  fit: BoxFit.cover,
                ),
                Container(height: context.height / 2),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                45.h.spaceH,
                _appBar(),
                70.h.spaceH,
                "Event Approval".appText(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                "Review and confirm the shared event".appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                120.h.spaceH,
                _approvalCard(),
                20.h.spaceH,
                "Your response updates the event for both parents.".appText(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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

  Widget _approvalCard() {
    return Container(
      decoration: BoxDecoration(
        color: aiQuestionCardColor4,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          12.h.spaceH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: "School Pick‐up"
                    .appText(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    )
                    .appPadding(left: 12.w, right: 12.w),
              ),
              Container(
                decoration: BoxDecoration(
                  color: yellowColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: "Pending • waiting for you"
                    .appText(fontSize: 10, fontWeight: FontWeight.w700)
                    .appPadding(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
              ).appPadding(right: 12.w),
            ],
          ),
          8.h.spaceH,
          "Requested by David • for Leo"
              .appText(fontSize: 10, fontWeight: FontWeight.w700)
              .appPadding(left: 12.w),
          12.h.spaceH,
          Row(
            children: [
              Assets.icons.icCalenderIcon3.image(height: 20, width: 20),
              12.w.spaceW,
              "Mon, Aug 5".appText(fontWeight: FontWeight.w600, fontSize: 14),
            ],
          ).appPadding(left: 12.w),
          10.h.spaceH,
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
          10.h.spaceH,
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
          10.h.spaceH,
          Row(
            children: [
              Assets.icons.icUserIcon.image(height: 24, width: 24),
              12.w.spaceW,
              "David (requester), Priya (you)".appText(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ],
          ).appPadding(left: 12.w),
          30.h.spaceH,

          Row(
            children: [
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: selectedTabColor,
                  text: 'Decline',
                  image: Assets.icons.icDeclineIcon,
                  onTap: () {},
                ),
              ),
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: greyColor,
                  text: 'Propose',
                  image: Assets.icons.icProposeIcon,
                  onTap: () {},
                ),
              ),
              10.w.spaceW,
              Expanded(
                child: _button(
                  color: gentleReminderIconColor,
                  text: 'Approve',
                  image: Assets.icons.icApproveIcon,
                  onTap: () {},
                ),
              ),
              10.w.spaceW,
            ],
          ),
          50.h.spaceH,
        ],
      ),
    );
  }

  Widget _button({
    required Color color,
    required String text,
    required AssetGenImage image,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image.image(height: 20, width: 20),
            8.w.spaceW,
            text.appText(fontWeight: FontWeight.w600, fontSize: 12),
          ],
        ).appPadding(top: 6.h, bottom: 6.h),
      ),
    );
  }
}
