import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'notifications_state.freezed.dart';

/// State for Screen 61 (Notifications & Quiet Hours Preferences).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(true) bool sleepEnabled,
    @Default(true) bool checkInEnabled,
    @Default(false) bool mentorshipEnabled,
    @Default(true) bool weeklyReviewEnabled,
    @Default('21:00') String quietHoursStart,
    @Default('07:00') String quietHoursEnd,
    @Default(3) int maxDailyCap,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _NotificationsState;
}
