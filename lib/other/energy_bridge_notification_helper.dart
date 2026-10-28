import 'package:loving_brain/other/notification_util.dart';

/// Schedules and cancels local Energy Bridge notifications for a child.
///
/// Called from [HomeCubit] (Family Meter state change) and [EnergyBridgeCubit]
/// so timer side-effects stay consistent regardless of entry point.
class EnergyBridgeNotificationHelper {
  EnergyBridgeNotificationHelper._();

  static int notificationIdForChild(String childId) {
    return 900000 + childId.hashCode.abs() % 99999;
  }

  static Future<void> scheduleFireNotification({
    required String childId,
    required int durationMinutes,
    String? childName,
  }) async {
    // Deprecated in V2: Predictive notifications are managed exclusively via
    // V2NotificationScheduler which respects daily caps (max 3), quiet hours (9 PM-7 AM),
    // and requires moderate or high confidence.
    return;
  }

  static Future<void> cancelForChild(String childId) async {
    await NotificationUtil.cancelNotification(notificationIdForChild(childId));
  }
}
