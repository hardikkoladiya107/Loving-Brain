import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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

  String _formatDisplayTime(String raw) {
    if (raw.isEmpty) return '9:00 PM';
    try {
      if (raw.contains(':')) {
        final List<String> parts = raw.split(':');
        final int hour = int.parse(parts[0].trim());
        final int minute = int.parse(
          parts[1].replaceAll(RegExp(r'[^0-9]'), '').trim(),
        );
        final bool isAlreadyAmPm =
            raw.toLowerCase().contains('am') ||
            raw.toLowerCase().contains('pm');
        if (isAlreadyAmPm) {
          return raw.trim();
        }
        final bool isPm = hour >= 12;
        final int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final String ampm = isPm ? 'PM' : 'AM';
        final String minuteStr = minute.toString().padLeft(2, '0');
        return '$displayHour:$minuteStr $ampm';
      }
    } catch (_) {}
    return raw;
  }

  Future<void> _pickReminderTime(
    BuildContext context, {
    required String currentTime,
    required Function(String) onSelected,
  }) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 19, minute: 15);
    try {
      if (currentTime.contains(':')) {
        final List<String> parts = currentTime.split(':');
        int hour = int.parse(parts[0].trim());
        final int minute = int.parse(
          parts[1].replaceAll(RegExp(r'[^0-9]'), '').trim(),
        );
        if (currentTime.toLowerCase().contains('pm') && hour < 12) {
          hour += 12;
        } else if (currentTime.toLowerCase().contains('am') && hour == 12) {
          hour = 0;
        }
        initialTime = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final DateTime now = DateTime.now();
      final DateTime dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final String formatted = DateFormat('h:mm a').format(dt);
      onSelected(formatted);
    }
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
                            timePill: state.sleepReminderTime,
                            onTimePillTap: () => _pickReminderTime(
                              context,
                              currentTime: state.sleepReminderTime,
                              onSelected: (String time) =>
                                  cubit.updateSleepReminderTime(time),
                            ),
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
                              cubit.toggleSleep(enabled: val);
                            },
                          ),
                          12.spaceH,
                          _buildToggleCard(
                            title: "Check-in reminders",
                            subtitle:
                                "One gentle prompt if nothing has been logged",
                            timePill: state.checkInReminderTime,
                            onTimePillTap: () => _pickReminderTime(
                              context,
                              currentTime: state.checkInReminderTime,
                              onSelected: (String time) =>
                                  cubit.updateCheckInReminderTime(time),
                            ),
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
                              cubit.toggleCheckIn(enabled: val);
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
                              cubit.toggleMentorship(enabled: val);
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
                              cubit.toggleWeeklyReview(enabled: val);
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF3E5F5),
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
                                          "${_formatDisplayTime(state.quietHoursStart)} – ${_formatDisplayTime(state.quietHoursEnd)} local time. Only confirmed sessions break through."
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
                                12.spaceH,
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _pickReminderTime(
                                        context,
                                        currentTime: _formatDisplayTime(
                                          state.quietHoursStart,
                                        ),
                                        onSelected: (String time) =>
                                            cubit.updateQuietHours(start: time),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3E5F5),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
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
                                            "Start: ${_formatDisplayTime(state.quietHoursStart)}"
                                                .appText(
                                                  fontSize: 12.sp,
                                                  color: const Color(
                                                    0xFF673AB7,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            6.spaceW,
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 12.sp,
                                              color: const Color(0xFF673AB7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _pickReminderTime(
                                        context,
                                        currentTime: _formatDisplayTime(
                                          state.quietHoursEnd,
                                        ),
                                        onSelected: (String time) =>
                                            cubit.updateQuietHours(end: time),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3E5F5),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
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
                                            "End: ${_formatDisplayTime(state.quietHoursEnd)}"
                                                .appText(
                                                  fontSize: 12.sp,
                                                  color: const Color(
                                                    0xFF673AB7,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            6.spaceW,
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 12.sp,
                                              color: const Color(0xFF673AB7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
    VoidCallback? onTimePillTap,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onTimePillTap,
                          child: Container(
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
                                6.spaceW,
                                Icon(
                                  Icons.edit_outlined,
                                  size: 12.sp,
                                  color: const Color(0xFF673AB7),
                                ),
                              ],
                            ),
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
                  trackOutlineColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
