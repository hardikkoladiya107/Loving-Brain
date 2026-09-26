import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/info_box.dart';

import 'package:loving_brain/ui/invite_pending/invite_pending_screen.dart';

class InviteCaregiverScreen extends StatefulWidget {
  const InviteCaregiverScreen({super.key});

  @override
  State<InviteCaregiverScreen> createState() => _InviteCaregiverScreenState();
}

class _InviteCaregiverScreenState extends State<InviteCaregiverScreen> {
  String _selectedRole = "Grandparent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: [
          // Top Left Glow
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
          // Bottom Right Glow
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
                      "Invite a caregiver".appText(
                        fontSize: 28.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "They'll get a link to join no account needed first."
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor6,
                            textAlign: TextAlign.start,
                          ),
                      24.spaceH,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: secondaryColor, width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "EMAIL OR PHONE".appText(
                                    fontSize: 14.sp,
                                    color: greyColor11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  4.spaceH,
                                  "grandma@example.com".appText(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: greyColor9,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.spaceH,
                      "THEIR RELATIONSHIP TO IRA".appText(
                        fontSize: 16.sp,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      ),
                      12.spaceH,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          _buildRoleChip("Partner"),
                          _buildRoleChip("Grandparent"),
                          _buildRoleChip("Nanny"),
                          _buildRoleChip("Other"),
                        ],
                      ),
                      24.spaceH,
                      InfoBox(
                        backgroundColor: softPeachOrange,
                        textColor: primaryColor,
                        iconColor: primaryColor,
                        iconData: Icons.info,
                        body: "",

                        title:
                            "Grandparents start with sleep and plans only. You can change exactly what they see in Permissions before or after they join.",
                      ),
                      12.spaceH,
                      InfoBox.white(
                        title: "What they won't see",
                        body:
                            "Health notes, mentorship summaries and your own reflections stay private unless you choose to share them.",
                      ),
                      120.spaceH,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label) {
    bool isSelected = _selectedRole == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF673AB7)
                : greyColor.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: label.appText(
          fontSize: 14.sp,
          color: isSelected ? const Color(0xFF673AB7) : greyColor9,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 40.h,
          bottom: 40.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: AppButton(
          title: "Send invite",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InvitePendingScreen()),
            );
          },
        ),
      ),
    );
  }
}
