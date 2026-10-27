import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/permission_helper.dart';

import 'bloc/notifications_cubit.dart';
import 'bloc/notifications_state.dart';

/// Screen 61: Notifications Preferences & Quiet Hours.
/// Conforms to AGENTS.md §5.1 and v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final NotificationsCubit cubit = context.read<NotificationsCubit>();
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (BuildContext context, NotificationsState state) {},
      builder: (BuildContext context, NotificationsState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
                right: -150.w,
                bottom: 0,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
                          padding: EdgeInsets.all(8.r),
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
                          if (state.isPermissionDenied) ...[
                            16.spaceH,
                            GestureDetector(
                              onTap: () async {
                                final bool granted =
                                    await PermissionHelper.ensureNotificationPermission(
                                      context,
                                    );
                                cubit.changeProps(isPermissionDenied: !granted);
                              },
                              child: Container(
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3CD),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0xFFFFEEBA),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: const Color(0xFF856404),
                                      size: 22.sp,
                                    ),
                                    10.spaceW,
                                    Expanded(
                                      child:
                                          "Notifications are turned off in your system settings. Reminders will not be delivered until enabled."
                                              .appText(
                                                fontSize: 13.sp,
                                                color: const Color(0xFF856404),
                                                fontWeight: FontWeight.w500,
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          24.spaceH,
                          _buildToggleCard(
                            title: "Sleep reminders",
                            subtitle:
                                "A nudge when the wind-down window is approaching",
                            timePill: "7:15 PM",
                            value: state.sleepEnabled,
                            onChanged: (bool val) async {
                              if (val) {
                                final bool granted =
                                    await PermissionHelper.ensureNotificationPermission(
                                      context,
                                    );
                                if (!granted) {
                                  cubit.changeProps(isPermissionDenied: true);
                                  return;
                                }
                                cubit.changeProps(isPermissionDenied: false);
                              }
                              cubit.toggleSleep();
                            },
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Check-in reminders",
                            subtitle:
                                "One gentle prompt if nothing has been logged",
                            timePill: "8:30 PM",
                            value: state.checkInEnabled,
                            onChanged: (bool val) async {
                              if (val) {
                                final bool granted =
                                    await PermissionHelper.ensureNotificationPermission(
                                      context,
                                    );
                                if (!granted) {
                                  cubit.changeProps(isPermissionDenied: true);
                                  return;
                                }
                                cubit.changeProps(isPermissionDenied: false);
                              }
                              cubit.toggleCheckIn();
                            },
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Mentorship updates",
                            subtitle:
                                "Only when a guide replies or a session changes",
                            value: state.mentorshipEnabled,
                            onChanged: (bool val) async {
                              if (val) {
                                final bool granted =
                                    await PermissionHelper.ensureNotificationPermission(
                                      context,
                                    );
                                if (!granted) {
                                  cubit.changeProps(isPermissionDenied: true);
                                  return;
                                }
                                cubit.changeProps(isPermissionDenied: false);
                              }
                              cubit.toggleMentorship();
                            },
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Weekly review",
                            subtitle: "A note when Sunday's review is ready",
                            value: state.weeklyReviewEnabled,
                            onChanged: (bool val) async {
                              if (val) {
                                final bool granted =
                                    await PermissionHelper.ensureNotificationPermission(
                                      context,
                                    );
                                if (!granted) {
                                  cubit.changeProps(isPermissionDenied: true);
                                  return;
                                }
                                cubit.changeProps(isPermissionDenied: false);
                              }
                              cubit.toggleWeeklyReview();
                            },
                          ),
                          20.spaceH,
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: const Color(0xFFEDE8E3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3E5F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.bedtime_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF673AB7),
                                  ),
                                ),
                                12.spaceW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "Quiet Hours Active".appText(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: darkBlue,
                                        textAlign: TextAlign.start,
                                      ),
                                      2.spaceH,
                                      "9:00 PM – 7:00 AM local time. Only confirmed sessions break through."
                                          .appText(
                                            fontSize: 12.sp,
                                            color: greyColor,
                                            textAlign: TextAlign.start,
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          16.spaceH,
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(16.r),
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
      },
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
        borderRadius: BorderRadius.circular(16.r),
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
                      borderRadius: BorderRadius.circular(20.r),
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
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF673AB7),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: greyColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
