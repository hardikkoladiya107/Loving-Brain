import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/info_box.dart';
import 'package:loving_brain/ui/widget/setting_tile.dart';
import 'package:loving_brain/ui/widget/warning_box.dart';

class HelpSafetyScreen extends StatelessWidget {
  const HelpSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            right: -150,
            bottom: 0,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: darkBlue,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      16.spaceH,
                      "Help & safety".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      SettingTile(
                        icon: Image.asset(
                          Assets.v2.icons.icFaqs.path,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        iconBackgroundColor: const Color(0xFFE8F5E9),
                        title: "FAQs",
                        subtitle: "Sleep, tantrums, sharing and billing",
                        onTap: () {},
                      ),
                      12.spaceH,
                      SettingTile(
                        icon: Image.asset(
                          Assets.v2.icons.icContactSupport.path,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        iconBackgroundColor: const Color(0xFFE3F2FD),
                        title: "Contact support",
                        subtitle: "Usually answered within a working day",
                        onTap: () {},
                      ),
                      12.spaceH,
                      SettingTile(
                        icon: Image.asset(
                          Assets.v2.icons.icMentorshipBooking.path,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        iconBackgroundColor: const Color(0xFFFFF3E0),
                        title: "Mentorship booking help",
                        subtitle: "Questions about guides and sessions",
                        onTap: () {},
                      ),
                      24.spaceH,
                      WarningBox(
                        label: "In an emergency",
                        title: "Contact your local emergency services",
                        body:
                            "LovingBrain can't help in an emergency and isn't monitored.",
                      ),
                      24.spaceH,
                      InfoBox.white(
                        title: "Medical disclaimer",
                        iconData: Icons.info,
                        iconColor: const Color(0xFFE64A19),
                        body:
                            "LovingBrain offers general guidance based on your own updates. It doesn't diagnose anything and doesn't replace professional medical advice.",
                      ),
                      40.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
