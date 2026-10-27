import 'package:flutter/material.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/ui/microphone_permission/microphone_permission_screen.dart';
import 'package:loving_brain/ui/notifications_permission/notifications_permission_screen.dart';
import 'package:record/record.dart';

/// Centralized helper for managing system permissions and their explainer screens.
///
/// Flow:
/// 1. Checks if permission is already granted. If so, returns true immediately without displaying any UI.
/// 2. If not granted, displays the corresponding full-screen explainer dialog.
/// 3. The native OS permission dialog is requested ONLY when the user clicks "Allow".
/// 4. If the user taps "Not now" or dismisses the screen, returns false without prompting the OS.
class PermissionHelper {
  PermissionHelper._();

  /// Checks if microphone permission is already granted without prompting the OS.
  static Future<bool> isMicrophonePermissionGranted() async {
    try {
      final AudioRecorder recorder = AudioRecorder();
      final bool granted = await recorder.hasPermission(request: false);
      await recorder.dispose();
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// Checks if notification permission is already granted without prompting the OS.
  static Future<bool> isNotificationPermissionGranted() async {
    try {
      return await NotificationUtil.isPermissionGranted();
    } catch (_) {
      return false;
    }
  }

  /// Checks if microphone permission is granted.
  /// If already granted, returns true immediately without showing any UI.
  /// If not granted, opens [MicrophonePermissionScreen] as a full-screen modal.
  /// When the user taps "Allow microphone", the OS permission request is invoked.
  /// If the user taps "Not now", dismisses the screen and returns false.
  static Future<bool> ensureMicrophonePermission(BuildContext context) async {
    final bool alreadyGranted = await isMicrophonePermissionGranted();
    if (alreadyGranted) {
      return true;
    }

    if (!context.mounted) return false;

    final bool? result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext _) => const MicrophonePermissionScreen(),
      ),
    );

    return result ?? false;
  }

  /// Checks if notification permission is granted.
  /// If already granted, returns true immediately without showing any UI.
  /// If not granted, opens [NotificationsPermissionScreen] as a full-screen modal.
  /// When the user taps "Allow notifications", the OS permission request is invoked.
  /// If the user taps "Not now", dismisses the screen and returns false.
  static Future<bool> ensureNotificationPermission(BuildContext context) async {
    final bool alreadyGranted = await isNotificationPermissionGranted();
    if (alreadyGranted) {
      return true;
    }

    if (!context.mounted) return false;

    final bool? result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext _) => const NotificationsPermissionScreen(),
      ),
    );

    return result ?? false;
  }
}
