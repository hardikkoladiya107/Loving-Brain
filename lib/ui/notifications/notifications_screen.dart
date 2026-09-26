import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _sleepEnabled = true;
  bool _checkInEnabled = true;
  bool _mentorshipEnabled = false;
  bool _weeklyReviewEnabled = true;

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
                      "Notifications".appText(
                        fontSize: 32.sp,
                        color: greyColor9,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                      8.spaceH,
                      "We'd rather send less. Turn off anything you don't need."
                          .appText(
                            fontSize: 14.sp,
                            color: greyColor,
                            textAlign: TextAlign.start,
                          ),
                      24.spaceH,
                      _buildToggleCard(
                        title: "Sleep reminders",
                        subtitle:
                            "A nudge when the wind-down window is approaching",
                        timePill: "7:15 PM",
                        value: _sleepEnabled,
                        onChanged: (val) => setState(() => _sleepEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Check-in reminders",
                        subtitle:
                            "One gentle prompt if nothing has been logged",
                        timePill: "8:30 PM",
                        value: _checkInEnabled,
                        onChanged: (val) =>
                            setState(() => _checkInEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Mentorship updates",
                        subtitle:
                            "Only when a guide replies or a session changes",
                        value: _mentorshipEnabled,
                        onChanged: (val) =>
                            setState(() => _mentorshipEnabled = val),
                      ),
                      12.spaceH,
                      _buildToggleCard(
                        title: "Weekly review",
                        subtitle: "A note when Sunday's review is ready",
                        value: _weeklyReviewEnabled,
                        onChanged: (val) =>
                            setState(() => _weeklyReviewEnabled = val),
                      ),
                      24.spaceH,
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5), // Light purple
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            "We never send streak reminders or messages about missed days."
                                .appText(
                                  fontSize: 14.sp,
                                  color: greyColor9,
                                  textAlign: TextAlign.start,
                                ),
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

  Widget _buildToggleCard({
    required String title,
    required String subtitle,
    String? timePill,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  color: greyColor9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 14.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
                if (timePill != null) ...[
                  12.spaceH,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14.sp,
                          color: const Color(0xFF673AB7),
                        ),
                        6.spaceW,
                        timePill.appText(
                          fontSize: 12.sp,
                          color: const Color(0xFF673AB7),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          16.spaceW,
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF673AB7),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: greyColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
