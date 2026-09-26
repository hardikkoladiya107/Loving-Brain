import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_permission_state.freezed.dart';

@freezed
abstract class NotificationsPermissionState
    with _$NotificationsPermissionState {
  const factory NotificationsPermissionState() = _NotificationsPermissionState;
}
