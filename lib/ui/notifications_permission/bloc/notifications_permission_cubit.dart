import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';

import 'notifications_permission_state.dart';

/// Cubit for Screen 72 (Notification Permission Explainer).
/// Conforms to AGENTS.md §4.2.
class NotificationsPermissionCubit extends Cubit<NotificationsPermissionState> {
  NotificationsPermissionCubit() : super(const NotificationsPermissionState());

  void reset() {
    emit(const NotificationsPermissionState());
  }

  void init() {
    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'your child';

    changeProps(childName: cName);
  }

  void changeProps({String? childName, bool? isGranted}) {
    emit(
      state.copyWith(
        childName: childName ?? state.childName,
        isGranted: isGranted ?? state.isGranted,
      ),
    );
  }

  Future<bool> grantPermission() async {
    changeProps(isGranted: true);
    try {
      final bool granted =
          await NotificationUtil.requestNotificationPermission();
      changeProps(isGranted: granted);
      return granted;
    } catch (_) {
      return true;
    }
  }
}
