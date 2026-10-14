import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_permission_state.freezed.dart';

/// State for Screen 72 (Notification Permission Explainer).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class NotificationsPermissionState
    with _$NotificationsPermissionState {
  const factory NotificationsPermissionState({
    @Default('your child') String childName,
    @Default(false) bool isGranted,
  }) = _NotificationsPermissionState;
}
