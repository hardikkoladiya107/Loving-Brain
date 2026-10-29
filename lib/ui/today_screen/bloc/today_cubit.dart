import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

import 'today_state.dart';

/// Cubit managing Today tab dashboard state and the 5 Quick Update logging flows.
class TodayCubit extends Cubit<TodayState> {
  TodayCubit() : super(const TodayState());

  /// Centralized state emission obeying AGENTS.md rule 4.2.
  /// All ApiResultStatus parameters default to ApiResultStatus.initial() when null.
  void changeProps({
    bool? isLoading,
    bool? isSuccess,
    TodayMode? mode,
    String? childName,
    String? parentName,
    String? activeChildId,
    String? timeOfDayGreeting,
    String? sleepForecastStart,
    String? sleepForecastEnd,
    String? bedtimeEstimate,
    String? forecastSubtitle,
    String? confidenceLevel,
    int? confidenceDots,
    String? sleepForecastReason,
    bool? hasSleepLogs,
    bool? hasMultiDayPatterns,
    bool? hasAnyLogs,
    int? loggedDaysCount,
    bool? didForecastChangeSignificantly,
    String? forecastChangeReason,
    SleepLogModel? duplicateSleepLogDetected,
    bool clearDuplicateSleep = false,
    String? fellAsleepTime,
    String? wokeUpTime,
    String? napStartTime,
    String? napEndTime,
    bool clearSleepInputs = false,
    bool clearNapInputs = false,
    bool? showSleepUpdateErrors,
    int? selectedChildMoodIndex,
    String? selectedParentMood,
    bool? showMoodUpdateErrors,
    String? tantrumWhatHappened,
    String? tantrumTime,
    double? tantrumIntensity,
    List<String>? selectedTantrumTriggers,
    String? tantrumWhatHelped,
    bool? showTantrumUpdateErrors,
    List<String>? selectedHealthIssues,
    String? healthNotes,
    bool? showHealthUpdateErrors,
    bool? isNightWaking,
    int? sleepQualityIndex,
    String? quickNoteText,
    bool? showNotesUpdateErrors,
    ApiResultStatus? saveStatus,
  }) {
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        isSuccess: isSuccess ?? state.isSuccess,
        mode: mode ?? state.mode,
        childName: childName ?? state.childName,
        parentName: parentName ?? state.parentName,
        activeChildId: activeChildId ?? state.activeChildId,
        timeOfDayGreeting: timeOfDayGreeting ?? state.timeOfDayGreeting,
        sleepForecastStart: sleepForecastStart ?? state.sleepForecastStart,
        sleepForecastEnd: sleepForecastEnd ?? state.sleepForecastEnd,
        bedtimeEstimate: bedtimeEstimate ?? state.bedtimeEstimate,
        forecastSubtitle: forecastSubtitle ?? state.forecastSubtitle,
        confidenceLevel: confidenceLevel ?? state.confidenceLevel,
        confidenceDots: confidenceDots ?? state.confidenceDots,
        sleepForecastReason: sleepForecastReason ?? state.sleepForecastReason,
        hasSleepLogs: hasSleepLogs ?? state.hasSleepLogs,
        hasMultiDayPatterns: hasMultiDayPatterns ?? state.hasMultiDayPatterns,
        hasAnyLogs: hasAnyLogs ?? state.hasAnyLogs,
        loggedDaysCount: loggedDaysCount ?? state.loggedDaysCount,
        didForecastChangeSignificantly:
            didForecastChangeSignificantly ??
            state.didForecastChangeSignificantly,
        forecastChangeReason:
            forecastChangeReason ?? state.forecastChangeReason,
        duplicateSleepLogDetected: clearDuplicateSleep
            ? null
            : (duplicateSleepLogDetected ?? state.duplicateSleepLogDetected),
        fellAsleepTime: clearSleepInputs
            ? null
            : (fellAsleepTime ?? state.fellAsleepTime),
        wokeUpTime: clearSleepInputs ? null : (wokeUpTime ?? state.wokeUpTime),
        napStartTime: (clearSleepInputs || clearNapInputs)
            ? null
            : (napStartTime ?? state.napStartTime),
        napEndTime: (clearSleepInputs || clearNapInputs)
            ? null
            : (napEndTime ?? state.napEndTime),
        showSleepUpdateErrors:
            showSleepUpdateErrors ?? state.showSleepUpdateErrors,
        selectedChildMoodIndex:
            selectedChildMoodIndex ?? state.selectedChildMoodIndex,
        selectedParentMood: selectedParentMood ?? state.selectedParentMood,
        showMoodUpdateErrors:
            showMoodUpdateErrors ?? state.showMoodUpdateErrors,
        tantrumWhatHappened: tantrumWhatHappened ?? state.tantrumWhatHappened,
        tantrumTime: tantrumTime ?? state.tantrumTime,
        tantrumIntensity: tantrumIntensity ?? state.tantrumIntensity,
        selectedTantrumTriggers:
            selectedTantrumTriggers ?? state.selectedTantrumTriggers,
        tantrumWhatHelped: tantrumWhatHelped ?? state.tantrumWhatHelped,
        showTantrumUpdateErrors:
            showTantrumUpdateErrors ?? state.showTantrumUpdateErrors,
        selectedHealthIssues:
            selectedHealthIssues ?? state.selectedHealthIssues,
        healthNotes: healthNotes ?? state.healthNotes,
        showHealthUpdateErrors:
            showHealthUpdateErrors ?? state.showHealthUpdateErrors,
        isNightWaking: isNightWaking ?? state.isNightWaking,
        sleepQualityIndex: sleepQualityIndex ?? state.sleepQualityIndex,
        quickNoteText: quickNoteText ?? state.quickNoteText,
        showNotesUpdateErrors:
            showNotesUpdateErrors ?? state.showNotesUpdateErrors,
        saveStatus: saveStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  void toggleMode() {
    final TodayMode current = state.mode;
    if (current == TodayMode.normal) {
      changeProps(mode: TodayMode.newParent);
    } else if (current == TodayMode.newParent) {
      changeProps(mode: TodayMode.importantHeadsUp);
    } else {
      changeProps(mode: TodayMode.normal);
    }
  }

  Future<void> init() async {
    final int hour = DateTime.now().hour;
    String greeting = 'GOOD MORNING';
    if (hour >= 12 && hour < 17) {
      greeting = 'GOOD AFTERNOON';
    } else if (hour >= 17) {
      greeting = 'GOOD EVENING';
    }

    UserModel? user = preferences.getUserModel();
    final String? userUid = user?.uid;

    // Sync latest user and default child first to guarantee accurate link status
    if (userUid != null && userUid.isNotEmpty) {
      try {
        final UserModel? freshUser = await AuthRepo.instance
            .syncUserAndDefaultChild(uId: userUid);
        if (freshUser != null) {
          user = freshUser;
        }
      } catch (_) {}
    } else {
      final DocumentReference<Object?>? defChild = user?.defaultChild;
      if (defChild != null) {
        try {
          final DocumentSnapshot<Object?> childSnap = await defChild.get();
          final Object? childData = childSnap.data();
          if (childData is Map<String, dynamic>) {
            final ChildModel c = ChildModel.fromJson(
              childData,
              childSnap.reference,
            );
            await preferences.saveChildModel(c);
          }
        } catch (_) {}
      }
    }

    final ChildModel? child = preferences.getChildModel();
    String pName = user?.parentName ?? 'Parent';
    String cName = child?.childName ?? user?.childName ?? '';
    if (pName.trim().isEmpty) pName = 'Parent';

    final String finalChildId =
        child?.reference?.id ??
        user?.defaultChild?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        (child != null && (child.childName?.trim().isNotEmpty ?? false)
            ? 'local_${child.childName!.trim()}'
            : '');

    if (finalChildId.isEmpty) {
      cName = '';
    } else if (cName.trim().isEmpty) {
      cName = 'Child';
    }

    changeProps(
      isLoading: false,
      timeOfDayGreeting: greeting,
      parentName: pName.toUpperCase(),
      childName: cName,
      activeChildId: finalChildId,
    );

    if (finalChildId.isNotEmpty) {
      // Sync any pending offline quick updates in the background
      OfflineSyncRepo.instance.syncPendingUpdates();
      await recalculateForecast(childOverride: child);
    } else {
      changeProps(
        mode: TodayMode.normal,
        hasAnyLogs: false,
        hasSleepLogs: false,
        hasMultiDayPatterns: false,
        forecastSubtitle: '',
        sleepForecastStart: '',
        sleepForecastEnd: '',
        bedtimeEstimate: '',
        confidenceLevel: '',
      );
    }
  }

  Future<void> switchActiveChild(ChildModel newChild) async {
    await preferences.saveChildModel(newChild);
    await preferences.saveDefaultChildModel(newChild);

    final UserModel? user = preferences.getUserModel();
    final String? userUid = user?.uid;
    if (userUid != null && userUid.isNotEmpty && newChild.reference != null) {
      try {
        await AuthRepo.instance.updateUserToFireStore(
          uId: userUid,
          request: <String, dynamic>{
            'default_child': newChild.reference,
            'child_name': newChild.childName ?? '',
            'child_age': newChild.childAge ?? '',
          },
        );
        await AuthRepo.instance.syncUserAndDefaultChild(uId: userUid);
      } catch (_) {}
    }

    init();
  }

  /// Dynamically computes Energy Bridge sleep forecast using child profile and recent logs.
  Future<void> recalculateForecast({ChildModel? childOverride}) async {
    final ChildModel? child = childOverride ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? _resolveTargetChildId();
    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    HealthLogModel? todayHealthLog;
    bool hasTantrumToday = false;

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 14);
      if (sleepResult is Data<List<SleepLogModel>>) {
        sleepLogs = sleepResult.data;
      }

      final ApiResultStatus<List<HealthLogModel>> healthResult =
          await TodayLogRepo.instance.getRecentHealthLogs(childId, limit: 5);
      if (healthResult is Data<List<HealthLogModel>>) {
        final DateTime now = DateTime.now();
        final List<HealthLogModel> recentHealth = healthResult.data;
        for (final HealthLogModel h in recentHealth) {
          if (h.timestamp.year == now.year &&
              h.timestamp.month == now.month &&
              h.timestamp.day == now.day) {
            todayHealthLog = h;
            break;
          }
        }
      }

      final ApiResultStatus<List<TantrumLogModel>> tantrumResult =
          await TodayLogRepo.instance.getRecentTantrumLogs(childId, limit: 5);
      if (tantrumResult is Data<List<TantrumLogModel>>) {
        final DateTime now = DateTime.now();
        for (final TantrumLogModel t in tantrumResult.data) {
          if (t.timestamp.year == now.year &&
              t.timestamp.month == now.month &&
              t.timestamp.day == now.day) {
            hasTantrumToday = true;
            break;
          }
        }
      }
    }

    final SleepForecastResult forecast = EnergyBridgeSleepCalculator.calculate(
      child: child,
      sleepLogs: sleepLogs,
      todayHealthLog: todayHealthLog,
    );

    final bool hasSevereHealthIssue =
        todayHealthLog != null &&
        todayHealthLog.issues.any(
          (String issue) =>
              issue.toLowerCase().contains("fever") ||
              issue.toLowerCase().contains("breath") ||
              issue.toLowerCase().contains("illness"),
        );

    final bool isOvertiredOrDisrupted =
        forecast.healthCaveat != null ||
        forecast.subtitle.contains("nap ran about") ||
        hasTantrumToday ||
        hasSevereHealthIssue;

    final bool hasMultiDayPatterns = sleepLogs.length >= 3;
    final Set<String> loggedDates = <String>{};
    for (final SleepLogModel log in sleepLogs) {
      loggedDates.add(
        '${log.wakeTime.year}-${log.wakeTime.month}-${log.wakeTime.day}',
      );
    }
    final int loggedDaysCount = loggedDates.length;

    final bool hasAnyLogs =
        sleepLogs.isNotEmpty || hasTantrumToday || todayHealthLog != null;

    final TodayMode updatedMode;
    if (!forecast.hasPersonalLogs) {
      updatedMode = TodayMode.newParent;
    } else if (hasMultiDayPatterns && isOvertiredOrDisrupted) {
      // Require at least 3 logged sessions before predicting harder evening disruption (BUG-30)
      updatedMode = TodayMode.importantHeadsUp;
    } else {
      updatedMode = TodayMode.normal;
    }

    changeProps(
      mode: updatedMode,
      sleepForecastStart: forecast.windowStart,
      sleepForecastEnd: forecast.windowEnd,
      bedtimeEstimate: forecast.bedtimeEstimate,
      forecastSubtitle: forecast.subtitle,
      confidenceLevel: forecast.confidenceLabel.toLowerCase(),
      confidenceDots: forecast.confidenceDots,
      sleepForecastReason: forecast.reason,
      hasSleepLogs: forecast.hasPersonalLogs,
      hasMultiDayPatterns: hasMultiDayPatterns,
      hasAnyLogs: hasAnyLogs,
      loggedDaysCount: loggedDaysCount,
    );

    // Schedule Sleep Window notification if confidence >= moderate (Doc 03 §1)
    if (childId.isNotEmpty &&
        (forecast.confidenceTier == ConfidenceTier.moderate ||
            forecast.confidenceTier == ConfidenceTier.high)) {
      DateTime? windDownStart;
      if (forecast.planSteps.isNotEmpty) {
        windDownStart = forecast.planSteps.first.scheduledTime;
      } else {
        windDownStart = forecast.bedtimeEstimateDateTime.subtract(
          const Duration(minutes: 30),
        );
      }
      if (windDownStart.isAfter(DateTime.now())) {
        await V2NotificationScheduler.scheduleSleepWindow(
          childId: childId,
          childName: child?.childName ?? state.childName,
          windDownStart: windDownStart,
        );
      }
    }

    // Schedule Gentle Check-In at 8:30 PM if no logs today (Doc 03 §4)
    if (childId.isNotEmpty) {
      final DateTime now = DateTime.now();
      final DateTime checkInTime = DateTime(
        now.year,
        now.month,
        now.day,
        20,
        30,
      );
      if (checkInTime.isAfter(now)) {
        final bool hasLogsToday =
            sleepLogs.any(
              (SleepLogModel l) =>
                  l.date.year == now.year &&
                  l.date.month == now.month &&
                  l.date.day == now.day,
            ) ||
            (todayHealthLog != null) ||
            hasTantrumToday;
        await V2NotificationScheduler.scheduleGentleCheckIn(
          childId: childId,
          checkInTime: checkInTime,
          hasLogsToday: hasLogsToday,
        );
      }

      // Schedule Weekly Review notification for next Sunday 9:00 AM only when enough meaningful data exists (Doc 03 §5)
      final bool hasMeaningfulWeeklyData =
          hasMultiDayPatterns || sleepLogs.length >= 2;
      if (hasMeaningfulWeeklyData) {
        DateTime nextSunday = DateTime(now.year, now.month, now.day, 9, 0);
        int daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
        if (daysUntilSunday == 0 && now.hour >= 9) {
          daysUntilSunday = 7;
        }
        nextSunday = nextSunday.add(Duration(days: daysUntilSunday));
        await V2NotificationScheduler.scheduleWeeklyReview(
          sundayDate: nextSunday,
        );
      }
    }
  }

  // Helper to obtain the active child ID safely
  String _resolveTargetChildId() {
    if (state.activeChildId.isNotEmpty) {
      return state.activeChildId;
    }
    final String? prefChildId = preferences.getChildModel()?.reference?.id;
    if (prefChildId != null && prefChildId.isNotEmpty) {
      changeProps(activeChildId: prefChildId);
      return prefChildId;
    }
    final String? userChildId = preferences.getUserModel()?.defaultChild?.id;
    if (userChildId != null && userChildId.isNotEmpty) {
      changeProps(activeChildId: userChildId);
      return userChildId;
    }
    final String? resolved = TodayLogRepo.instance.resolveActiveChildId();
    if (resolved != null && resolved.isNotEmpty) {
      changeProps(activeChildId: resolved);
      return resolved;
    }
    return '';
  }

  // Helper to obtain current user UID
  String _resolveUserUid() {
    return preferences.getUserModel()?.uid ?? '';
  }

  // =========================================================================
  // Sleep Update
  // =========================================================================

  void setSleepQuality(int index) => changeProps(sleepQualityIndex: index);

  void setFellAsleepTime(String time) =>
      changeProps(fellAsleepTime: time, showSleepUpdateErrors: false);

  void setWokeUpTime(String time) =>
      changeProps(wokeUpTime: time, showSleepUpdateErrors: false);

  void setNapTimes(String? start, String? end) => changeProps(
    napStartTime: start,
    napEndTime: end,
    showSleepUpdateErrors: false,
  );

  void clearNapTimes() => changeProps(clearNapInputs: true);

  void triggerSleepUpdateErrors() => changeProps(showSleepUpdateErrors: true);

  void toggleNightWaking(bool val) => changeProps(isNightWaking: val);

  void clearDuplicateSleepAlert() => changeProps(clearDuplicateSleep: true);

  /// Checks if an existing sleep log already covers the proposed interval (Doc 06 §3).
  Future<SleepLogModel?> findOverlappingSleepLog({
    required DateTime bedTime,
    required DateTime wakeTime,
  }) async {
    final String childId = _resolveTargetChildId();
    if (childId.isEmpty) return null;
    final ApiResultStatus<List<SleepLogModel>> result = await TodayLogRepo
        .instance
        .getRecentSleepLogs(childId, limit: 10);
    if (result is Data<List<SleepLogModel>>) {
      for (final SleepLogModel log in result.data) {
        final DateTime startMax = bedTime.isAfter(log.bedTime)
            ? bedTime
            : log.bedTime;
        final DateTime endMin = wakeTime.isBefore(log.wakeTime)
            ? wakeTime
            : log.wakeTime;
        if (endMin.isAfter(startMax) &&
            endMin.difference(startMax).inMinutes >= 30) {
          return log;
        }
      }
    }
    return null;
  }

  Future<void> saveSleepLog({bool forceSave = false}) async {
    final bool hasNight =
        state.fellAsleepTime != null && state.wokeUpTime != null;
    final bool hasNap = state.napStartTime != null && state.napEndTime != null;

    if (!hasNight && !hasNap) {
      triggerSleepUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    final DateTime now = DateTime.now();

    // Check for duplicate sleep interval if not forced (Doc 06 §3)
    if (!forceSave) {
      DateTime checkBed;
      DateTime checkWake;
      if (hasNight) {
        checkBed = TodayLogRepo.parseTimeString(
          state.fellAsleepTime!,
          referenceDate: now,
        );
        checkWake = TodayLogRepo.parseTimeString(
          state.wokeUpTime!,
          referenceDate: now,
        );
        if (!checkWake.isAfter(checkBed)) {
          checkWake = checkWake.add(const Duration(days: 1));
        }
      } else {
        checkBed = TodayLogRepo.parseTimeString(
          state.napStartTime!,
          referenceDate: now,
        );
        checkWake = TodayLogRepo.parseTimeString(
          state.napEndTime!,
          referenceDate: now,
        );
        if (!checkWake.isAfter(checkBed)) {
          checkWake = checkWake.add(const Duration(days: 1));
        }
      }

      final SleepLogModel? duplicate = await findOverlappingSleepLog(
        bedTime: checkBed,
        wakeTime: checkWake,
      );
      if (duplicate != null) {
        changeProps(duplicateSleepLogDetected: duplicate);
        return;
      }
    }

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final String prevEstimate = state.bedtimeEstimate;
    final String prevConfidence = state.confidenceLevel;

    ApiResultStatus<String> result = const ApiResultStatus.initial();

    if (hasNight) {
      DateTime bedTime = TodayLogRepo.parseTimeString(
        state.fellAsleepTime!,
        referenceDate: now,
      );
      DateTime wakeTime = TodayLogRepo.parseTimeString(
        state.wokeUpTime!,
        referenceDate: now,
      );

      // If wake is earlier or same as bed (e.g. overnight 11:00 PM to 07:00 AM)
      if (!wakeTime.isAfter(bedTime)) {
        if (wakeTime.isBefore(now)) {
          // Bedtime was last night, wake was earlier today
          bedTime = bedTime.subtract(const Duration(days: 1));
        } else {
          wakeTime = wakeTime.add(const Duration(days: 1));
        }
      }

      if (wakeTime.isAfter(now)) {
        changeProps(
          isLoading: false,
          showSleepUpdateErrors: true,
          saveStatus: ApiResultStatus.error(
            error: Exception("Wake time cannot be in the future"),
          ),
        );
        return;
      }

      final int durationMins = wakeTime.difference(bedTime).inMinutes;
      if (durationMins <= 0) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception("Wake time must be after sleep time"),
          ),
        );
        return;
      }
      if (durationMins >= 1440) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception("Sleep duration cannot exceed 24 hours"),
          ),
        );
        return;
      }

      final SleepLogModel nightLog = SleepLogModel(
        id: null,
        date: DateTime(now.year, now.month, now.day),
        bedTime: bedTime,
        wakeTime: wakeTime,
        fellAsleepTime: state.fellAsleepTime,
        wokeUpTime: state.wokeUpTime,
        isNightWaking: state.isNightWaking,
        sleepQualityIndex: state.sleepQualityIndex >= 0
            ? state.sleepQualityIndex
            : 3,
        durationMinutes: durationMins,
        userId: userUid,
        childId: childId,
        createdAt: now,
      );

      result = await TodayLogRepo.instance.addSleepLog(
        childId: childId,
        log: nightLog,
      );
    } else if (hasNap) {
      final DateTime napBed = TodayLogRepo.parseTimeString(
        state.napStartTime!,
        referenceDate: now,
      );
      DateTime napWake = TodayLogRepo.parseTimeString(
        state.napEndTime!,
        referenceDate: now,
      );
      if (!napWake.isAfter(napBed)) {
        napWake = napWake.add(const Duration(days: 1));
      }
      if (napWake.isAfter(now)) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception("Nap end time cannot be in the future"),
          ),
        );
        return;
      }
      final int napDurationMins = napWake.difference(napBed).inMinutes;
      if (napDurationMins <= 0) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception("Nap end time must be after start time"),
          ),
        );
        return;
      }
      if (napDurationMins >= 720) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception("Nap duration cannot exceed 12 hours"),
          ),
        );
        return;
      }

      final SleepLogModel napLog = SleepLogModel(
        id: null,
        date: DateTime(now.year, now.month, now.day),
        bedTime: napBed,
        wakeTime: napWake,
        fellAsleepTime: state.napStartTime,
        wokeUpTime: state.napEndTime,
        isNightWaking: false,
        sleepQualityIndex: state.sleepQualityIndex,
        durationMinutes: napDurationMins,
        userId: userUid,
        childId: childId,
        createdAt: now,
      );

      result = await TodayLogRepo.instance.addSleepLog(
        childId: childId,
        log: napLog,
      );
    }

    if (result is Data<String>) {
      await recalculateForecast();

      bool changedSignificantly = false;
      String changeReason = '';

      if (state.confidenceLevel != prevConfidence &&
          state.confidenceLevel != 'none') {
        changedSignificantly = true;
        changeReason =
            "Confidence updated to ${state.confidenceLevel} based on latest rest data.";
      } else if (prevEstimate != '--:--' && state.bedtimeEstimate != '--:--') {
        try {
          final DateTime prevDt = TodayLogRepo.parseTimeString(
            prevEstimate,
            referenceDate: now,
          );
          final DateTime newDt = TodayLogRepo.parseTimeString(
            state.bedtimeEstimate,
            referenceDate: now,
          );
          final int diffMinutes = newDt.difference(prevDt).inMinutes.abs();
          if (diffMinutes >= 15) {
            changedSignificantly = true;
            changeReason =
                "Bedtime estimate moved to ${state.bedtimeEstimate} (${diffMinutes}m change).";
          }
        } catch (_) {}
      }

      // Cancel pending sleep window reminder since parent logged sleep (Doc 03 §1, Doc 06 §8)
      await V2NotificationScheduler.cancelSleepWindow(childId);
      await V2NotificationScheduler.cancelGentleCheckIn(childId);

      // If estimate changed materially (>=15 min), notify parent (Doc 03 §2)
      if (changedSignificantly && state.bedtimeEstimate != '--:--') {
        await V2NotificationScheduler.notifySleepEstimateChanged(
          childId: childId,
          childName: state.childName,
          newBedtime: state.bedtimeEstimate,
        );
      }

      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        didForecastChangeSignificantly: changedSignificantly,
        forecastChangeReason: changeReason,
        clearSleepInputs: true,
        clearDuplicateSleep: true,
        isNightWaking: false,
        sleepQualityIndex: 3,
        showSleepUpdateErrors: false,
      );
      // Reset isSuccess flag shortly after
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  /// Updates an overlapping sleep log instead of inserting a duplicate entry (QA Audit X1).
  Future<void> updateDuplicateSleepLog() async {
    final SleepLogModel? dup = state.duplicateSleepLogDetected;
    if (dup == null || dup.id == null) {
      await saveSleepLog(forceSave: true);
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();
    final DateTime now = DateTime.now();

    final String fellAsleep = state.fellAsleepTime ?? state.napStartTime ?? '';
    final String wokeUp = state.wokeUpTime ?? state.napEndTime ?? '';
    final DateTime bedTime = TodayLogRepo.parseTimeString(
      fellAsleep,
      referenceDate: now,
    );
    DateTime wakeTime = TodayLogRepo.parseTimeString(
      wokeUp,
      referenceDate: now,
    );
    if (wakeTime.isBefore(bedTime)) {
      wakeTime = wakeTime.add(const Duration(days: 1));
    }

    final SleepLogModel updated = SleepLogModel(
      id: dup.id,
      ref: dup.ref,
      date: dup.date,
      bedTime: bedTime,
      wakeTime: wakeTime,
      fellAsleepTime: fellAsleep,
      wokeUpTime: wokeUp,
      isNightWaking: state.isNightWaking,
      sleepQualityIndex: state.sleepQualityIndex,
      durationMinutes: wakeTime.difference(bedTime).inMinutes,
      userId: userUid,
      childId: childId,
      createdAt: dup.createdAt,
    );

    changeProps(
      isLoading: true,
      saveStatus: const ApiResultStatus.loading(),
      clearDuplicateSleep: true,
    );

    final ApiResultStatus<bool> result = await TodayLogRepo.instance
        .updateSleepLog(childId: childId, logId: dup.id!, log: updated);

    if (result is Data<bool>) {
      await V2NotificationScheduler.cancelSleepWindow(childId);
      await V2NotificationScheduler.cancelGentleCheckIn(childId);
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: const ApiResultStatus.data(data: 'updated'),
        clearSleepInputs: true,
        clearDuplicateSleep: true,
        isNightWaking: false,
        sleepQualityIndex: 3,
        showSleepUpdateErrors: false,
        didForecastChangeSignificantly: false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    } else {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  // =========================================================================
  // Mood Update
  // =========================================================================

  void setChildMood(int index) =>
      changeProps(selectedChildMoodIndex: index, showMoodUpdateErrors: false);

  void setParentMood(String mood) => changeProps(selectedParentMood: mood);

  void triggerMoodUpdateErrors() => changeProps(showMoodUpdateErrors: true);

  Future<void> saveMoodLog() async {
    if (state.selectedChildMoodIndex == -1) {
      triggerMoodUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final List<String> moodLabels = <String>[
      'Very happy',
      'Content',
      'Neutral',
      'Unsettled',
      'Upset',
    ];
    final String childMoodLabel =
        (state.selectedChildMoodIndex >= 0 &&
            state.selectedChildMoodIndex < moodLabels.length)
        ? moodLabels[state.selectedChildMoodIndex]
        : 'Neutral';

    final DateTime now = DateTime.now();
    final MoodLogModel log = MoodLogModel(
      childMood: childMoodLabel,
      childMoodIndex: state.selectedChildMoodIndex,
      parentMood: state.selectedParentMood,
      logTime: now,
      userId: userUid,
      childId: childId,
      createdAt: now,
    );

    final ApiResultStatus<String> result = await TodayLogRepo.instance
        .addMoodLog(childId: childId, log: log);

    if (result is Data<String>) {
      await V2NotificationScheduler.cancelGentleCheckIn(childId);
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        selectedChildMoodIndex: -1,
        selectedParentMood: '',
        showMoodUpdateErrors: false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
      await recalculateForecast();
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  // =========================================================================
  // Tantrum / Meltdown Update
  // =========================================================================

  void setTantrumWhatHappened(String val) =>
      changeProps(tantrumWhatHappened: val, showTantrumUpdateErrors: false);

  void setTantrumTime(String time) =>
      changeProps(tantrumTime: time, showTantrumUpdateErrors: false);

  void setTantrumIntensity(double value) =>
      changeProps(tantrumIntensity: value);

  void toggleTantrumTrigger(String trigger) {
    final List<String> triggers = List<String>.from(
      state.selectedTantrumTriggers,
    );
    if (triggers.contains(trigger)) {
      triggers.remove(trigger);
    } else {
      triggers.add(trigger);
    }
    changeProps(
      selectedTantrumTriggers: triggers,
      showTantrumUpdateErrors: false,
    );
  }

  void setTantrumWhatHelped(String val) =>
      changeProps(tantrumWhatHelped: val, showTantrumUpdateErrors: false);

  void triggerTantrumUpdateErrors() =>
      changeProps(showTantrumUpdateErrors: true);

  Future<void> saveTantrumLog() async {
    if (state.tantrumWhatHappened.trim().isEmpty ||
        state.tantrumTime == null ||
        state.selectedTantrumTriggers.isEmpty ||
        state.tantrumWhatHelped.trim().isEmpty) {
      triggerTantrumUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final DateTime now = DateTime.now();
    final DateTime eventTime = state.tantrumTime != null
        ? TodayLogRepo.parseTimeString(state.tantrumTime!, referenceDate: now)
        : now;

    if (eventTime.isAfter(now)) {
      triggerTantrumUpdateErrors();
      return;
    }

    final TantrumLogModel log = TantrumLogModel(
      whatHappened: state.tantrumWhatHappened.trim(),
      time: state.tantrumTime,
      timestamp: eventTime,
      intensity: state.tantrumIntensity,
      triggers: List<String>.from(state.selectedTantrumTriggers),
      whatHelped: state.tantrumWhatHelped.trim(),
      userId: userUid,
      childId: childId,
      createdAt: now,
    );

    final ApiResultStatus<String> result = await TodayLogRepo.instance
        .addTantrumLog(childId: childId, log: log);

    if (result is Data<String>) {
      await V2NotificationScheduler.cancelGentleCheckIn(childId);
      // Recalculate combined behaviour risk using the same multi-log engine as Calm Heads-Up (Doc 04 §4)
      final ChildModel? activeChild = preferences.getChildModel();
      List<TantrumLogModel> recentTantrums = <TantrumLogModel>[log];
      List<SleepLogModel> recentSleep = <SleepLogModel>[];
      List<MoodLogModel> recentMood = <MoodLogModel>[];
      List<HealthLogModel> recentHealth = <HealthLogModel>[];

      try {
        final ApiResultStatus<List<TantrumLogModel>> tRes = await TodayLogRepo
            .instance
            .getRecentTantrumLogs(childId);
        if (tRes is Data<List<TantrumLogModel>>) {
          recentTantrums = <TantrumLogModel>[
            log,
            ...tRes.data.where((TantrumLogModel t) => t.id != result.data),
          ];
        }
        final ApiResultStatus<List<SleepLogModel>> sRes = await TodayLogRepo
            .instance
            .getRecentSleepLogs(childId);
        if (sRes is Data<List<SleepLogModel>>) {
          recentSleep = sRes.data;
        }
        final ApiResultStatus<List<MoodLogModel>> mRes = await TodayLogRepo
            .instance
            .getRecentMoodLogs(childId);
        if (mRes is Data<List<MoodLogModel>>) {
          recentMood = mRes.data;
        }
        final ApiResultStatus<List<HealthLogModel>> hRes = await TodayLogRepo
            .instance
            .getRecentHealthLogs(childId);
        if (hRes is Data<List<HealthLogModel>>) {
          recentHealth = hRes.data;
        }
      } catch (_) {}

      final BehaviourForecastResult prevResult =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: activeChild,
            tantrumLogs: recentTantrums
                .where((TantrumLogModel t) => t != log)
                .toList(),
            sleepLogs: recentSleep,
            moodLogs: recentMood,
            healthLogs: recentHealth,
          );

      final BehaviourForecastResult updatedResult =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: activeChild,
            tantrumLogs: recentTantrums,
            sleepLogs: recentSleep,
            moodLogs: recentMood,
            healthLogs: recentHealth,
          );

      final bool hasEnoughHistory = recentTantrums.length >= 3;
      final bool behaviourShifted =
          hasEnoughHistory &&
          updatedResult.isPushWorthy &&
          (updatedResult.riskLevel != prevResult.riskLevel ||
              updatedResult.windowStart != prevResult.windowStart);

      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        tantrumWhatHappened: '',
        tantrumTime: null,
        tantrumIntensity: 0.5,
        selectedTantrumTriggers: <String>[],
        tantrumWhatHelped: '',
        showTantrumUpdateErrors: false,
        didForecastChangeSignificantly: behaviourShifted,
        forecastChangeReason: behaviourShifted
            ? 'Harder window updated to ${updatedResult.windowStart}–${updatedResult.windowEnd} based on recent patterns'
            : null,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
      await recalculateForecast();
    } else if (result is Error<String>) {
      changeProps(
        isLoading: false,
        isSuccess: false,
        saveStatus: result,
        didForecastChangeSignificantly: false,
        forecastChangeReason: null,
      );
    }
  }

  // =========================================================================
  // Health Update
  // =========================================================================

  void toggleHealthIssue(String issue) {
    final List<String> issues = List<String>.from(state.selectedHealthIssues);
    if (issues.contains(issue)) {
      issues.remove(issue);
    } else {
      issues.add(issue);
    }
    changeProps(selectedHealthIssues: issues, showHealthUpdateErrors: false);
  }

  void setHealthNotes(String val) =>
      changeProps(healthNotes: val, showHealthUpdateErrors: false);

  void triggerHealthUpdateErrors() => changeProps(showHealthUpdateErrors: true);

  Future<void> saveHealthLog() async {
    if (state.selectedHealthIssues.isEmpty) {
      triggerHealthUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final DateTime now = DateTime.now();
    final HealthLogModel log = HealthLogModel(
      issues: List<String>.from(state.selectedHealthIssues),
      notes: state.healthNotes.trim(),
      timestamp: now,
      userId: userUid,
      childId: childId,
      createdAt: now,
    );

    final ApiResultStatus<String> result = await TodayLogRepo.instance
        .addHealthLog(childId: childId, log: log);

    if (result is Data<String>) {
      await V2NotificationScheduler.cancelGentleCheckIn(childId);
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        selectedHealthIssues: <String>[],
        healthNotes: '',
        showHealthUpdateErrors: false,
      );
      await recalculateForecast();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  // =========================================================================
  // Notes Update
  // =========================================================================

  void setQuickNoteText(String val) =>
      changeProps(quickNoteText: val, showNotesUpdateErrors: false);

  void triggerNotesUpdateErrors() => changeProps(showNotesUpdateErrors: true);

  Future<void> saveQuickNote({
    String? audioLocalPath,
    int? audioDurationSeconds,
  }) async {
    final bool hasText = state.quickNoteText.trim().isNotEmpty;
    final bool hasAudio =
        audioLocalPath != null && audioLocalPath.trim().isNotEmpty;

    if (!hasText && !hasAudio) {
      triggerNotesUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final DateTime now = DateTime.now();
    final String resolvedText = hasText
        ? state.quickNoteText.trim()
        : 'Voice note';

    final QuickNoteModel log = QuickNoteModel(
      note: resolvedText,
      audioLocalPath: hasAudio ? audioLocalPath.trim() : null,
      audioDurationSeconds: hasAudio ? audioDurationSeconds : null,
      timestamp: now,
      userId: userUid,
      childId: childId,
      createdAt: now,
    );

    final ApiResultStatus<String> result = await TodayLogRepo.instance
        .addQuickNote(childId: childId, log: log);

    if (result is Data<String>) {
      await V2NotificationScheduler.cancelGentleCheckIn(childId);
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        quickNoteText: '',
        showNotesUpdateErrors: false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
      await recalculateForecast();
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  /// Backward-compatible saveUpdate handler (dispatches to relevant active log).
  Future<void> saveUpdate() async {
    if (state.fellAsleepTime != null && state.wokeUpTime != null) {
      await saveSleepLog();
    } else if (state.tantrumWhatHappened.trim().isNotEmpty) {
      await saveTantrumLog();
    } else if (state.selectedChildMoodIndex != -1) {
      await saveMoodLog();
    } else if (state.selectedHealthIssues.isNotEmpty) {
      await saveHealthLog();
    } else if (state.quickNoteText.trim().isNotEmpty) {
      await saveQuickNote();
    } else {
      changeProps(isLoading: true);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      changeProps(isLoading: false, isSuccess: true);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    }
  }
}
