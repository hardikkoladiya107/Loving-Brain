import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/setting_tile.dart';
import 'package:loving_brain/ui/widget/status_pill.dart';
import 'package:loving_brain/ui/widget/warning_box.dart';

class PrivacyDataScreen extends StatelessWidget {
  const PrivacyDataScreen({super.key});

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
                      "Privacy & data".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      24.spaceH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusPill(
                              text: "In short",
                              textColor: yellowColor1,
                              backgroundColor: lightYellowColor,
                              leading: Icon(
                                Icons.stars,
                                color: yellowColor1,
                                size: 14.sp,
                              ),
                            ),
                            16.spaceH,
                            "Invite sent to Grandma".appText(
                              fontSize: 20.sp,
                              color: greyColor9,
                              fraunces: true,
                              textAlign: TextAlign.start,
                            ),
                            8.spaceH,
                            "Sent 2 days ago to grandma@example.com. We'll let you know as soon as she accepts."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                  textAlign: TextAlign.start,
                                ),
                          ],
                        ),
                      ),
                      12.spaceH,
                      SettingTile(
                        icon: Image.asset(
                          Assets.v2.icons.icLinkedCaregivers.path,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        iconBackgroundColor: const Color(0xFFFCF4FF),
                        title: "Linked caregivers",
                        subtitle: "2 people Â· Ravi and Grandma",
                        onTap: () {},
                      ),
                      12.spaceH,
                      SettingTile(
                        icon: Image.asset(
                          Assets.v2.icons.icPrivacyPolicy.path,
                          width: 24.sp,
                          height: 24.sp,
                        ),
                        iconBackgroundColor: const Color(0xFFF0F6FF),
                        title: "Read the full privacy policy",
                        subtitle: "Updated March 2026",
                        onTap: () {},
                      ),
                      24.spaceH,
                      AppButton(
                        title: "Export my data",
                        backgroundColor: Colors.white,
                        textColor: greyColor9,
                        borderColor: greyColor.withValues(alpha: 0.2),
                        onTap: () {},
                      ),
                      24.spaceH,
                      WarningBox(
                        label: "Permanent",
                        body:
                            "Deleting removes Ira's profile, every update and all guidance. Linked caregivers lose access immediately. This can't be undone.",
                      ),
                      24.spaceH,
                      AppButton(
                        title: "Delete account",
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFFD84315), // Red
                        borderColor: const Color(0xFFD84315),
                        onTap: () {},
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
