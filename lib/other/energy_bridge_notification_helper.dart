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
    final DateTime triggerTime = DateTime.now().add(
      Duration(minutes: durationMinutes),
    );
    final String name = (childName ?? '').trim().isEmpty
        ? 'your child'
        : childName!.trim();
    await NotificationUtil.scheduleNotification(
      id: notificationIdForChild(childId),
      title: 'LovingBrain',
      body:
          'Time to slow things down — $name has been in high energy for $durationMinutes minutes',
      payload: 'energy_bridge:$childId',
      scheduledDate: triggerTime,
    );
  }

  static Future<void> cancelForChild(String childId) async {
    await NotificationUtil.cancelNotification(notificationIdForChild(childId));
  }
}
