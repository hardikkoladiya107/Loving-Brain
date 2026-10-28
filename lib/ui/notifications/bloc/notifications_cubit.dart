import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/user_repo.dart';

import 'notifications_state.dart';

/// Cubit managing notification preferences and quiet hours (Screen 61).
/// Conforms to AGENTS.md §4.2 and v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  void init() {
    final Map<String, dynamic>? rawPrefs = preferences
        .getNotificationPreferences();
    if (rawPrefs != null) {
      final NotificationPreferencesModel model =
          NotificationPreferencesModel.fromJson(rawPrefs);
      changeProps(
        sleepEnabled: model.sleepReminders,
        checkInEnabled: model.checkInReminders,
        mentorshipEnabled: model.mentorshipUpdates,
        weeklyReviewEnabled: model.weeklyReview,
        sleepReminderTime: model.sleepReminderTime,
        checkInReminderTime: model.checkInReminderTime,
        quietHoursStart: model.quietHoursStart,
        quietHoursEnd: model.quietHoursEnd,
        maxDailyCap: model.maxDailyCap,
      );
    } else {
      const NotificationPreferencesModel defaultModel =
          NotificationPreferencesModel();
      changeProps(
        sleepEnabled: defaultModel.sleepReminders,
        checkInEnabled: defaultModel.checkInReminders,
        mentorshipEnabled: defaultModel.mentorshipUpdates,
        weeklyReviewEnabled: defaultModel.weeklyReview,
        sleepReminderTime: defaultModel.sleepReminderTime,
        checkInReminderTime: defaultModel.checkInReminderTime,
        quietHoursStart: defaultModel.quietHoursStart,
        quietHoursEnd: defaultModel.quietHoursEnd,
        maxDailyCap: defaultModel.maxDailyCap,
      );
    }
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final bool isGranted = await NotificationUtil.isPermissionGranted();
    changeProps(isPermissionDenied: !isGranted);
  }

  void changeProps({
    bool? sleepEnabled,
    bool? checkInEnabled,
    bool? mentorshipEnabled,
    bool? weeklyReviewEnabled,
    String? sleepReminderTime,
    String? checkInReminderTime,
    String? quietHoursStart,
    String? quietHoursEnd,
    int? maxDailyCap,
    bool? isPermissionDenied,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        sleepEnabled: sleepEnabled ?? state.sleepEnabled,
        checkInEnabled: checkInEnabled ?? state.checkInEnabled,
        mentorshipEnabled: mentorshipEnabled ?? state.mentorshipEnabled,
        weeklyReviewEnabled: weeklyReviewEnabled ?? state.weeklyReviewEnabled,
        sleepReminderTime: sleepReminderTime ?? state.sleepReminderTime,
        checkInReminderTime: checkInReminderTime ?? state.checkInReminderTime,
        quietHoursStart: quietHoursStart ?? state.quietHoursStart,
        quietHoursEnd: quietHoursEnd ?? state.quietHoursEnd,
        maxDailyCap: maxDailyCap ?? state.maxDailyCap,
        isPermissionDenied: isPermissionDenied ?? state.isPermissionDenied,
        saveStatus: saveStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> toggleSleep({bool? enabled}) async {
    final bool updated = enabled ?? !state.sleepEnabled;
    changeProps(sleepEnabled: updated);
    await _persist();
  }

  Future<void> toggleCheckIn({bool? enabled}) async {
    final bool updated = enabled ?? !state.checkInEnabled;
    changeProps(checkInEnabled: updated);
    await _persist();
  }

  Future<void> toggleMentorship({bool? enabled}) async {
    final bool updated = enabled ?? !state.mentorshipEnabled;
    changeProps(mentorshipEnabled: updated);
    await _persist();
  }

  Future<void> toggleWeeklyReview({bool? enabled}) async {
    final bool updated = enabled ?? !state.weeklyReviewEnabled;
    changeProps(weeklyReviewEnabled: updated);
    await _persist();
  }

  Future<void> updateSleepReminderTime(String time) async {
    changeProps(sleepReminderTime: time);
    await _persist();
  }

  Future<void> updateCheckInReminderTime(String time) async {
    changeProps(checkInReminderTime: time);
    await _persist();
  }

  Future<void> updateQuietHours({String? start, String? end}) async {
    changeProps(
      quietHoursStart: start ?? state.quietHoursStart,
      quietHoursEnd: end ?? state.quietHoursEnd,
    );
    await _persist();
  }

  Future<void> _persist() async {
    final NotificationPreferencesModel model = NotificationPreferencesModel(
      sleepReminders: state.sleepEnabled,
      checkInReminders: state.checkInEnabled,
      mentorshipUpdates: state.mentorshipEnabled,
      weeklyReview: state.weeklyReviewEnabled,
      sleepReminderTime: state.sleepReminderTime,
      checkInReminderTime: state.checkInReminderTime,
      quietHoursStart: state.quietHoursStart,
      quietHoursEnd: state.quietHoursEnd,
      maxDailyCap: state.maxDailyCap,
    );
    await preferences.saveNotificationPreferences(model.toJson());

    // Sync to cloud Firestore when authenticated
    try {
      final String? uid = preferences.getUserModel()?.uid;
      if (uid != null && uid.isNotEmpty) {
        await UserRepo.instance.updateUserToFireStore(
          uId: uid,
          request: <String, dynamic>{
            'notification_preferences': model.toJson(),
          },
        );
      }
    } catch (_) {}

    changeProps(saveStatus: const ApiResultStatus.data(data: null));
  }
}
