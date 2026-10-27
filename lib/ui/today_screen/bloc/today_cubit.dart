import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    ChildModel? child = preferences.getChildModel();

    String initialPName = user?.parentName ?? 'Parent';
    String initialCName = child?.childName ?? user?.childName ?? 'Child';
    if (initialPName.trim().isEmpty) initialPName = 'Parent';
    if (initialCName.trim().isEmpty) initialCName = 'Child';

    String initialChildId =
        child?.reference?.id ??
        user?.defaultChild?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    changeProps(
      isLoading: true,
      timeOfDayGreeting: greeting,
      parentName: initialPName.toUpperCase(),
      childName: initialCName,
      activeChildId: initialChildId,
    );

    final String? userUid = user?.uid;
    if (userUid != null && userUid.isNotEmpty) {
      try {
        final UserModel? freshUser = await AuthRepo.instance
            .syncUserAndDefaultChild(uId: userUid);
        if (freshUser != null) {
          user = freshUser;
          child = preferences.getChildModel();
        }
      } catch (_) {}
    } else {
      final DocumentReference<Object?>? defChild = user?.defaultChild;
      if (defChild != null) {
        try {
          final DocumentSnapshot<Object?> childSnap = await defChild.get();
          final Object? childData = childSnap.data();
          if (childData is Map<String, dynamic>) {
            child = ChildModel.fromJson(childData, childSnap.reference);
            await preferences.saveChildModel(child);
          }
        } catch (_) {}
      }
    }

    String pName = user?.parentName ?? 'Parent';
    String cName = child?.childName ?? user?.childName ?? 'Child';
    if (pName.trim().isEmpty) pName = 'Parent';
    if (cName.trim().isEmpty) cName = 'Child';

    final String finalChildId =
        child?.reference?.id ??
        user?.defaultChild?.id ??
        TodayLogRepo.instance.resolveActiveChildId() ??
        '';

    changeProps(
      isLoading: false,
      timeOfDayGreeting: greeting,
      parentName: pName.toUpperCase(),
      childName: cName,
      activeChildId: finalChildId,
    );

    // Sync any pending offline quick updates in the background
    OfflineSyncRepo.instance.syncPendingUpdates();

    await recalculateForecast(childOverride: child);
  }

  /// Dynamically computes Energy Bridge sleep forecast using child profile and recent logs.
  Future<void> recalculateForecast({ChildModel? childOverride}) async {
    final ChildModel? child = childOverride ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? _resolveTargetChildId();
    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    HealthLogModel? todayHealthLog;

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
    }

    final SleepForecastResult forecast = EnergyBridgeSleepCalculator.calculate(
      child: child,
      sleepLogs: sleepLogs,
      todayHealthLog: todayHealthLog,
    );

    final TodayMode updatedMode =
        (!forecast.hasPersonalLogs && state.mode == TodayMode.normal)
        ? TodayMode.newParent
        : (forecast.hasPersonalLogs && state.mode == TodayMode.newParent)
        ? TodayMode.normal
        : state.mode;

    final bool hasMultiDayPatterns = sleepLogs.length >= 3;

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
    );
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

  void setFellAsleepTime(String time) => changeProps(
    fellAsleepTime: time,
    napStartTime: time,
    showSleepUpdateErrors: false,
  );

  void setWokeUpTime(String time) => changeProps(
    wokeUpTime: time,
    napEndTime: time,
    showSleepUpdateErrors: false,
  );

  void setNapTimes(String? start, String? end) => changeProps(
    napStartTime: start,
    napEndTime: end,
    showSleepUpdateErrors: false,
  );

  void clearNapTimes() => changeProps(clearNapInputs: true);

  void triggerSleepUpdateErrors() => changeProps(showSleepUpdateErrors: true);

  void toggleNightWaking(bool val) => changeProps(isNightWaking: val);

  Future<void> saveSleepLog() async {
    final bool hasNight =
        state.fellAsleepTime != null && state.wokeUpTime != null;
    final bool hasNap = state.napStartTime != null && state.napEndTime != null;

    if (!hasNight && !hasNap) {
      triggerSleepUpdateErrors();
      return;
    }

    final String childId = _resolveTargetChildId();
    final String userUid = _resolveUserUid();

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final DateTime now = DateTime.now();
    ApiResultStatus<String> result = const ApiResultStatus.initial();

    if (hasNight) {
      final DateTime bedTime = TodayLogRepo.parseTimeString(
        state.fellAsleepTime!,
        referenceDate: now,
      );
      DateTime wakeTime = TodayLogRepo.parseTimeString(
        state.wokeUpTime!,
        referenceDate: now,
      );

      // If wake is earlier or same as bed (e.g. overnight 11:00 PM to 07:00 AM), add 1 day
      if (!wakeTime.isAfter(bedTime)) {
        wakeTime = wakeTime.add(const Duration(days: 1));
      }
      final int durationMins = wakeTime.difference(bedTime).inMinutes;

      final SleepLogModel nightLog = SleepLogModel(
        id: null,
        date: DateTime(now.year, now.month, now.day),
        bedTime: bedTime,
        wakeTime: wakeTime,
        fellAsleepTime: state.fellAsleepTime,
        wokeUpTime: state.wokeUpTime,
        isNightWaking: state.isNightWaking,
        sleepQualityIndex: state.sleepQualityIndex,
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
      final int napDurationMins = napWake.difference(napBed).inMinutes;

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
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        clearSleepInputs: true,
        isNightWaking: false,
        sleepQualityIndex: 3,
        showSleepUpdateErrors: false,
      );
      await recalculateForecast();
      // Reset isSuccess flag shortly after
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    } else if (result is Error<String>) {
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
      'Happy',
      'Good',
      'Stable',
      'Difficult',
      'Sad',
    ];
    final String childMoodLabel =
        (state.selectedChildMoodIndex >= 0 &&
            state.selectedChildMoodIndex < moodLabels.length)
        ? moodLabels[state.selectedChildMoodIndex]
        : 'Normal';

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
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
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
      changeProps(
        isLoading: false,
        isSuccess: true,
        saveStatus: result,
        quickNoteText: '',
        showNotesUpdateErrors: false,
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      changeProps(isSuccess: false);
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
