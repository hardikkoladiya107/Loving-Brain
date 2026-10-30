import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/notification_util.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/repo/user_repo.dart';

import 'notifications_state.dart';

/// Cubit managing notification preferences and quiet hours (Screen 61).
/// Conforms to AGENTS.md §4.2 and v2-doc/03_NOTIFICATION_ENGAGEMENT_RULES.md.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  Future<void>? _persistQueue;
  NotificationsState? _stateBeforePersist;

  void reset() {
    emit(const NotificationsState());
  }

  void init() {
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _hydrateFromFirestoreIfNeeded();
    _loadLocalPreferences();
    await refreshPermissionStatus();
  }

  void _loadLocalPreferences() {
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
        sleepReminderTimeCustomized: model.sleepReminderTimeCustomized,
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
        sleepReminderTimeCustomized: defaultModel.sleepReminderTimeCustomized,
        quietHoursStart: defaultModel.quietHoursStart,
        quietHoursEnd: defaultModel.quietHoursEnd,
        maxDailyCap: defaultModel.maxDailyCap,
      );
    }
  }

  /// Copies Firestore preferences into local storage only when the local key
  /// is missing. Never overwrites a value already saved on this device.
  Future<void> _hydrateFromFirestoreIfNeeded() async {
    try {
      if (preferences.getNotificationPreferences() != null) {
        return;
      }
      final String? uid = preferences.getUserModel()?.uid;
      if (uid == null || uid.isEmpty) {
        return;
      }
      final Map<String, dynamic>? remote = await UserRepo.instance
          .getNotificationPreferencesMap(uid: uid);
      if (remote == null || remote.isEmpty) {
        return;
      }
      await preferences.saveNotificationPreferences(remote);
    } catch (_) {}
  }

  Future<void> refreshPermissionStatus() async {
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
    bool? sleepReminderTimeCustomized,
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
        sleepReminderTimeCustomized:
            sleepReminderTimeCustomized ?? state.sleepReminderTimeCustomized,
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
    _stateBeforePersist ??= state;
    changeProps(sleepEnabled: updated);
    await _persist();
  }

  Future<void> toggleCheckIn({bool? enabled}) async {
    final bool updated = enabled ?? !state.checkInEnabled;
    _stateBeforePersist ??= state;
    changeProps(checkInEnabled: updated);
    await _persist();
  }

  Future<void> toggleMentorship({bool? enabled}) async {
    final bool updated = enabled ?? !state.mentorshipEnabled;
    _stateBeforePersist ??= state;
    changeProps(mentorshipEnabled: updated);
    await _persist();
  }

  Future<void> toggleWeeklyReview({bool? enabled}) async {
    final bool updated = enabled ?? !state.weeklyReviewEnabled;
    _stateBeforePersist ??= state;
    changeProps(weeklyReviewEnabled: updated);
    await _persist();
  }

  Future<void> updateSleepReminderTime(String time) async {
    _stateBeforePersist ??= state;
    changeProps(sleepReminderTime: time, sleepReminderTimeCustomized: true);
    await _persist();
  }

  Future<void> updateCheckInReminderTime(String time) async {
    _stateBeforePersist ??= state;
    changeProps(checkInReminderTime: time);
    await _persist();
  }

  Future<void> updateQuietHours({String? start, String? end}) async {
    _stateBeforePersist ??= state;
    changeProps(
      quietHoursStart: start ?? state.quietHoursStart,
      quietHoursEnd: end ?? state.quietHoursEnd,
    );
    await _persist();
  }

  /// Serializes persist calls so a slower toggle cannot overwrite a newer one.
  Future<void> _persist() {
    final Future<void>? inFlight = _persistQueue;
    final Future<void> next = () async {
      if (inFlight != null) {
        await inFlight;
      }
      await _persistNow();
    }();
    _persistQueue = next;
    return next;
  }

  Future<void> _persistNow() async {
    // When a later toggle already advanced state, falling back to [state]
    // makes previous == next so side effects are a no-op.
    final NotificationsState snapshotBefore = _stateBeforePersist ?? state;
    _stateBeforePersist = null;

    final NotificationPreferencesModel previous = NotificationPreferencesModel(
      sleepReminders: snapshotBefore.sleepEnabled,
      checkInReminders: snapshotBefore.checkInEnabled,
      mentorshipUpdates: snapshotBefore.mentorshipEnabled,
      weeklyReview: snapshotBefore.weeklyReviewEnabled,
      sleepReminderTime: snapshotBefore.sleepReminderTime,
      checkInReminderTime: snapshotBefore.checkInReminderTime,
      sleepReminderTimeCustomized: snapshotBefore.sleepReminderTimeCustomized,
      quietHoursStart: snapshotBefore.quietHoursStart,
      quietHoursEnd: snapshotBefore.quietHoursEnd,
      maxDailyCap: snapshotBefore.maxDailyCap,
    );

    final NotificationPreferencesModel model = NotificationPreferencesModel(
      sleepReminders: state.sleepEnabled,
      checkInReminders: state.checkInEnabled,
      mentorshipUpdates: state.mentorshipEnabled,
      weeklyReview: state.weeklyReviewEnabled,
      sleepReminderTime: state.sleepReminderTime,
      checkInReminderTime: state.checkInReminderTime,
      sleepReminderTimeCustomized: state.sleepReminderTimeCustomized,
      quietHoursStart: state.quietHoursStart,
      quietHoursEnd: state.quietHoursEnd,
      maxDailyCap: state.maxDailyCap,
    );

    final bool? localSaved = await preferences.saveNotificationPreferences(
      model.toJson(),
    );
    if (localSaved != true) {
      changeProps(
        sleepEnabled: previous.sleepReminders,
        checkInEnabled: previous.checkInReminders,
        mentorshipEnabled: previous.mentorshipUpdates,
        weeklyReviewEnabled: previous.weeklyReview,
        sleepReminderTime: previous.sleepReminderTime,
        checkInReminderTime: previous.checkInReminderTime,
        sleepReminderTimeCustomized: previous.sleepReminderTimeCustomized,
        quietHoursStart: previous.quietHoursStart,
        quietHoursEnd: previous.quietHoursEnd,
        maxDailyCap: previous.maxDailyCap,
        saveStatus: ApiResultStatus.error(
          error: Exception('Could not save notification preferences'),
        ),
      );
      return;
    }

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

    await V2NotificationScheduler.applyPreferenceSideEffects(
      previous: previous,
      next: model,
      childIds: _resolveChildIds(),
      childName: preferences.getChildModel()?.childName ?? 'your child',
    );

    changeProps(saveStatus: const ApiResultStatus.data(data: null));
  }

  List<String> _resolveChildIds() {
    final List<String> ids = <String>[];
    final UserModel? user = preferences.getUserModel();
    final DocumentReference? defaultChild = user?.defaultChild;
    if (defaultChild != null && defaultChild.id.isNotEmpty) {
      ids.add(defaultChild.id);
    }
    final List<DocumentReference>? children = user?.children;
    if (children != null) {
      for (final DocumentReference ref in children) {
        if (ref.id.isNotEmpty && !ids.contains(ref.id)) {
          ids.add(ref.id);
        }
      }
    }
    final String? prefChildId = preferences.getChildModel()?.reference?.id;
    if (prefChildId != null &&
        prefChildId.isNotEmpty &&
        !ids.contains(prefChildId)) {
      ids.add(prefChildId);
    }
    return ids;
  }
}
