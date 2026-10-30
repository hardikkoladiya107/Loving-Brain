import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/core/today_home_assembler.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/notification_preferences_model.dart';
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
  TodayCubit() : super(_initialState());

  static TodayState _initialState() {
    final int hour = DateTime.now().hour;
    String greeting = 'GOOD MORNING';
    if (hour >= 12 && hour < 17) {
      greeting = 'GOOD AFTERNOON';
    } else if (hour >= 17) {
      greeting = 'GOOD EVENING';
    }

    final UserModel? user = preferences.getUserModel();
    final ChildModel? child = preferences.getChildModel();

    String pName = user?.parentName ?? 'Parent';
    if (pName.trim().isEmpty) pName = 'Parent';

    String cName = child?.childName ?? user?.childName ?? '';
    final String finalChildId;
    if (child != null &&
        ((child.reference != null && child.reference!.id.isNotEmpty) ||
            (child.childName?.trim().isNotEmpty ?? false))) {
      finalChildId = child.reference?.id ?? 'local_${child.childName!.trim()}';
    } else {
      finalChildId = '';
      cName = '';
    }

    final bool isUserLoggedIn =
        preferences.getBool(SharedPreference.isLogin, defValue: false) ?? false;
    final bool initialLoading = isUserLoggedIn && finalChildId.isEmpty;

    return TodayState(
      isLoading: initialLoading,
      timeOfDayGreeting: greeting,
      parentName: pName.toUpperCase(),
      childName: cName,
      activeChildId: finalChildId,
    );
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _childDocSubscription;

  void reset() {
    _childDocSubscription?.cancel();
    _childDocSubscription = null;
    emit(const TodayState());
  }

  @override
  Future<void> close() {
    _childDocSubscription?.cancel();
    return super.close();
  }

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
    bool? showHealthHeadsUp,
    String? healthHeadsUpTitle,
    String? healthHeadsUpSubtitle,
    bool? showBehaviourHeadsUp,
    String? headsUpHeadline,
    String? headsUpReason,
    String? headsUpWindowStart,
    String? headsUpWindowEnd,
    bool? showNiceWork,
    String? niceWorkTitle,
    String? niceWorkSubtitle,
    bool? showNoticed,
    String? noticedTitle,
    TodayNoticedDestination? noticedDestination,
    bool? showSupportOffer,
    int? supportInconsistentDays,
    String? onboardingFocusLine,
    bool? prioritiseSleepFirst,
    String? instantResultTitle,
    String? instantResultAction,
    String? instantResultActionSubtitle,
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
        showHealthHeadsUp: showHealthHeadsUp ?? state.showHealthHeadsUp,
        healthHeadsUpTitle: healthHeadsUpTitle ?? state.healthHeadsUpTitle,
        healthHeadsUpSubtitle:
            healthHeadsUpSubtitle ?? state.healthHeadsUpSubtitle,
        showBehaviourHeadsUp:
            showBehaviourHeadsUp ?? state.showBehaviourHeadsUp,
        headsUpHeadline: headsUpHeadline ?? state.headsUpHeadline,
        headsUpReason: headsUpReason ?? state.headsUpReason,
        headsUpWindowStart: headsUpWindowStart ?? state.headsUpWindowStart,
        headsUpWindowEnd: headsUpWindowEnd ?? state.headsUpWindowEnd,
        showNiceWork: showNiceWork ?? state.showNiceWork,
        niceWorkTitle: niceWorkTitle ?? state.niceWorkTitle,
        niceWorkSubtitle: niceWorkSubtitle ?? state.niceWorkSubtitle,
        showNoticed: showNoticed ?? state.showNoticed,
        noticedTitle: noticedTitle ?? state.noticedTitle,
        noticedDestination: noticedDestination ?? state.noticedDestination,
        showSupportOffer: showSupportOffer ?? state.showSupportOffer,
        supportInconsistentDays:
            supportInconsistentDays ?? state.supportInconsistentDays,
        onboardingFocusLine: onboardingFocusLine ?? state.onboardingFocusLine,
        prioritiseSleepFirst: prioritiseSleepFirst ?? state.prioritiseSleepFirst,
        instantResultTitle: instantResultTitle ?? state.instantResultTitle,
        instantResultAction: instantResultAction ?? state.instantResultAction,
        instantResultActionSubtitle:
            instantResultActionSubtitle ?? state.instantResultActionSubtitle,
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

  void applyHomeSnapshot(TodayHomeSnapshot snapshot) {
    changeProps(
      mode: snapshot.mode,
      sleepForecastStart: snapshot.sleepForecastStart,
      sleepForecastEnd: snapshot.sleepForecastEnd,
      bedtimeEstimate: snapshot.bedtimeEstimate,
      forecastSubtitle: snapshot.forecastSubtitle,
      confidenceLevel: snapshot.confidenceLevel,
      confidenceDots: snapshot.confidenceDots,
      sleepForecastReason: snapshot.sleepForecastReason,
      hasSleepLogs: snapshot.hasSleepLogs,
      hasMultiDayPatterns: snapshot.hasMultiDayPatterns,
      hasAnyLogs: snapshot.hasAnyLogs,
      loggedDaysCount: snapshot.loggedDaysCount,
      showHealthHeadsUp: snapshot.showHealthHeadsUp,
      healthHeadsUpTitle: snapshot.healthHeadsUpTitle,
      healthHeadsUpSubtitle: snapshot.healthHeadsUpSubtitle,
      showBehaviourHeadsUp: snapshot.showBehaviourHeadsUp,
      headsUpHeadline: snapshot.headsUpHeadline,
      headsUpReason: snapshot.headsUpReason,
      headsUpWindowStart: snapshot.headsUpWindowStart,
      headsUpWindowEnd: snapshot.headsUpWindowEnd,
      showNiceWork: snapshot.showNiceWork,
      niceWorkTitle: snapshot.niceWorkTitle,
      niceWorkSubtitle: snapshot.niceWorkSubtitle,
      showNoticed: snapshot.showNoticed,
      noticedTitle: snapshot.noticedTitle,
      noticedDestination: snapshot.noticedDestination,
      showSupportOffer: snapshot.showSupportOffer,
      supportInconsistentDays: snapshot.supportInconsistentDays,
      onboardingFocusLine: snapshot.onboardingFocusLine,
      prioritiseSleepFirst: snapshot.prioritiseSleepFirst,
    );
  }

  Future<void> dismissSupportOffer() async {
    final String childId = _resolveTargetChildId();
    if (childId.isEmpty) {
      return;
    }
    await preferences.putString(
      TodayHomeAssembler.supportDismissalKey(childId),
      DateTime.now().toIso8601String(),
    );
    changeProps(showSupportOffer: false);
  }

  Future<void> _cacheHomeSnapshot(
    String childId,
    TodayHomeSnapshot snapshot,
  ) async {
    if (childId.isEmpty || childId.startsWith('local_')) {
      return;
    }
    await preferences.putString(
      TodayHomeAssembler.homeCacheKey(childId),
      json.encode(snapshot.toCacheMap()),
    );
  }

  TodayHomeSnapshot? _loadCachedHomeSnapshot(String childId) {
    if (childId.isEmpty) {
      return null;
    }
    final String? raw = preferences.getString(
      TodayHomeAssembler.homeCacheKey(childId),
    );
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final Object? decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return TodayHomeSnapshot.fromCacheMap(decoded);
      }
      if (decoded is Map) {
        return TodayHomeSnapshot.fromCacheMap(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (_) {}
    return null;
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
    final String? userUid = user?.uid;

    String pName = user?.parentName ?? 'Parent';
    String cName = child?.childName ?? user?.childName ?? '';
    if (pName.trim().isEmpty) pName = 'Parent';

    String currentChildId = '';
    if (child != null &&
        ((child.reference != null && child.reference!.id.isNotEmpty) ||
            (child.childName?.trim().isNotEmpty ?? false))) {
      currentChildId =
          child.reference?.id ?? 'local_${child.childName!.trim()}';
    } else {
      cName = '';
    }

    // If active child or parent changed (e.g. user switch/logout), wipe any stale previous user forecasts/logs immediately
    if (state.activeChildId != currentChildId ||
        (userUid != null && state.parentName != pName.toUpperCase())) {
      emit(
        TodayState(
          isLoading:
              currentChildId.isEmpty && (userUid != null && userUid.isNotEmpty),
          timeOfDayGreeting: greeting,
          parentName: pName.toUpperCase(),
          childName: cName,
          activeChildId: currentChildId,
        ),
      );
    } else {
      // Immediately present cached child profile to eliminate any delay/flash
      if (currentChildId.isNotEmpty) {
        changeProps(
          isLoading: false,
          timeOfDayGreeting: greeting,
          parentName: pName.toUpperCase(),
          childName: cName,
          activeChildId: currentChildId,
        );
      } else if (userUid != null && userUid.isNotEmpty) {
        // User is logged in but local cache has no child yet; show loading indicator while syncing
        changeProps(
          isLoading: true,
          timeOfDayGreeting: greeting,
          parentName: pName.toUpperCase(),
          activeChildId: '',
          childName: '',
        );
      } else {
        changeProps(
          isLoading: false,
          timeOfDayGreeting: greeting,
          parentName: pName.toUpperCase(),
          activeChildId: '',
          childName: '',
        );
      }
    }

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

    final ChildModel? updatedChild = preferences.getChildModel();
    pName = user?.parentName ?? 'Parent';
    cName = updatedChild?.childName ?? user?.childName ?? '';
    if (pName.trim().isEmpty) pName = 'Parent';

    final String finalChildId;
    if (updatedChild != null &&
        ((updatedChild.reference != null &&
                updatedChild.reference!.id.isNotEmpty) ||
            (updatedChild.childName?.trim().isNotEmpty ?? false))) {
      finalChildId =
          updatedChild.reference?.id ??
          'local_${updatedChild.childName!.trim()}';
    } else {
      finalChildId = '';
      cName = '';
    }

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

    _childDocSubscription?.cancel();
    if (finalChildId.isNotEmpty &&
        !finalChildId.startsWith('local_') &&
        userUid != null &&
        userUid.isNotEmpty) {
      try {
        _childDocSubscription = FirebaseFirestore.instance
            .collection('children')
            .doc(finalChildId)
            .snapshots()
            .listen((DocumentSnapshot<Map<String, dynamic>> snap) async {
              if (isClosed) return;
              if (!snap.exists) {
                _childDocSubscription?.cancel();
                final UserModel? refreshed = await AuthRepo.instance
                    .syncUserAndDefaultChild(uId: userUid);
                final String nextId =
                    refreshed?.defaultChild?.id ??
                    preferences.getChildModel()?.reference?.id ??
                    '';
                changeProps(
                  activeChildId: nextId,
                  childName: preferences.getChildModel()?.childName ?? '',
                  mode: TodayMode.normal,
                );
                if (nextId.isNotEmpty) {
                  init();
                }
                return;
              }

              final List<dynamic>? pIds =
                  snap.data()?['parent_reference_ids'] as List<dynamic>?;
              if (pIds != null && !pIds.contains(userUid)) {
                _childDocSubscription?.cancel();
                final UserModel? refreshed = await AuthRepo.instance
                    .syncUserAndDefaultChild(uId: userUid);
                final String nextId =
                    refreshed?.defaultChild?.id ??
                    preferences.getChildModel()?.reference?.id ??
                    '';
                changeProps(
                  activeChildId: nextId,
                  childName: preferences.getChildModel()?.childName ?? '',
                  mode: TodayMode.normal,
                );
                if (nextId.isNotEmpty) {
                  init();
                }
              }
            }, onError: (_) {});
      } catch (_) {}
    }

    if (finalChildId.isNotEmpty) {
      // Sync any pending offline quick updates in the background
      OfflineSyncRepo.instance.syncPendingUpdates();
      await recalculateForecast();
    } else {
      changeProps(
        mode: TodayMode.newParent,
        hasAnyLogs: false,
        hasSleepLogs: false,
        hasMultiDayPatterns: false,
        forecastSubtitle: '',
        sleepForecastStart: '',
        sleepForecastEnd: '',
        bedtimeEstimate: '',
        confidenceLevel: '',
        showBehaviourHeadsUp: false,
        showHealthHeadsUp: false,
        showNiceWork: false,
        showNoticed: false,
        showSupportOffer: false,
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

    await init();
  }

  /// Dynamically computes Energy Bridge sleep + behaviour home using child profile and recent logs.
  Future<void> recalculateForecast({ChildModel? childOverride}) async {
    final ChildModel? child = childOverride ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? _resolveTargetChildId();
    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];
    List<MoodLogModel> moodLogs = <MoodLogModel>[];
    List<HealthLogModel> healthLogs = <HealthLogModel>[];
    HealthLogModel? todayHealthLog;
    bool hasTantrumToday = false;
    bool sleepFetchFailed = false;

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 14);
      if (sleepResult is Data<List<SleepLogModel>>) {
        sleepLogs = sleepResult.data;
      } else if (sleepResult is Error<List<SleepLogModel>>) {
        sleepFetchFailed = true;
      }

      final bool canViewHealth = TodayLogRepo.instance
          .canCurrentCaregiverViewHealth();
      if (canViewHealth) {
        final ApiResultStatus<List<HealthLogModel>> healthResult =
            await TodayLogRepo.instance.getRecentHealthLogs(childId, limit: 10);
        if (healthResult is Data<List<HealthLogModel>>) {
          healthLogs = healthResult.data;
          final DateTime now = DateTime.now();
          for (final HealthLogModel h in healthLogs) {
            if (h.timestamp.year == now.year &&
                h.timestamp.month == now.month &&
                h.timestamp.day == now.day) {
              todayHealthLog = h;
              break;
            }
          }
        }
      }

      final ApiResultStatus<List<TantrumLogModel>> tantrumResult =
          await TodayLogRepo.instance.getRecentTantrumLogs(childId, limit: 20);
      if (tantrumResult is Data<List<TantrumLogModel>>) {
        tantrumLogs = tantrumResult.data;
        final DateTime now = DateTime.now();
        for (final TantrumLogModel t in tantrumLogs) {
          if (t.timestamp.year == now.year &&
              t.timestamp.month == now.month &&
              t.timestamp.day == now.day) {
            hasTantrumToday = true;
            break;
          }
        }
      }

      final ApiResultStatus<List<MoodLogModel>> moodResult = await TodayLogRepo
          .instance
          .getRecentMoodLogs(childId, limit: 10);
      if (moodResult is Data<List<MoodLogModel>>) {
        moodLogs = moodResult.data;
      }
    }

    if (sleepFetchFailed) {
      final TodayHomeSnapshot? cached = _loadCachedHomeSnapshot(childId);
      if (cached != null) {
        applyHomeSnapshot(cached);
        return;
      }
    }

    final bool canViewHealth = TodayLogRepo.instance
        .canCurrentCaregiverViewHealth();
    final SleepForecastResult forecast = EnergyBridgeSleepCalculator.calculate(
      child: child,
      sleepLogs: sleepLogs,
      todayHealthLog: canViewHealth ? todayHealthLog : null,
    );

    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child,
          tantrumLogs: tantrumLogs,
          sleepLogs: sleepLogs,
          moodLogs: moodLogs,
          healthLogs: canViewHealth ? healthLogs : <HealthLogModel>[],
        );

    DateTime? supportDismissedAt;
    if (childId.isNotEmpty) {
      final String? dismissedRaw = preferences.getString(
        TodayHomeAssembler.supportDismissalKey(childId),
      );
      if (dismissedRaw != null && dismissedRaw.isNotEmpty) {
        supportDismissedAt = DateTime.tryParse(dismissedRaw);
      }
    }

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child,
      sleepForecast: forecast,
      behaviourForecast: behaviour,
      sleepLogs: sleepLogs,
      tantrumLogs: tantrumLogs,
      todayHealthLog: canViewHealth ? todayHealthLog : null,
      supportDismissedAt: supportDismissedAt,
    );

    applyHomeSnapshot(snapshot);
    await _cacheHomeSnapshot(childId, snapshot);

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
        final NotificationPreferencesModel notifPrefs =
            V2NotificationScheduler.loadPreferences();
        DateTime? userDefinedNotifyTime;
        if (notifPrefs.sleepReminderTimeCustomized) {
          userDefinedNotifyTime =
              NotificationPreferencesModel.resolveDateTimeOn(
                day: DateTime.now(),
                timeString: notifPrefs.sleepReminderTime,
              );
        }
        await V2NotificationScheduler.scheduleSleepWindow(
          childId: childId,
          childName: child?.childName ?? state.childName,
          windDownStart: windDownStart,
          userDefinedNotifyTime: userDefinedNotifyTime,
        );
      }
    }

    // Schedule Gentle Check-In at user-selected time (default ~8:30 PM) if no logs today
    if (childId.isNotEmpty) {
      final DateTime now = DateTime.now();
      final NotificationPreferencesModel notifPrefs =
          V2NotificationScheduler.loadPreferences();
      final DateTime checkInTime =
          NotificationPreferencesModel.resolveDateTimeOn(
            day: now,
            timeString: notifPrefs.checkInReminderTime,
          ) ??
          DateTime(now.year, now.month, now.day, 20, 30);
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
          snapshot.hasMultiDayPatterns || sleepLogs.length >= 2;
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

  void setNapStartTime(String time) =>
      changeProps(napStartTime: time, showSleepUpdateErrors: false);

  void setNapEndTime(String time) =>
      changeProps(napEndTime: time, showSleepUpdateErrors: false);

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
    final int qualityIndex = state.sleepQualityIndex;

    // Check for duplicate sleep interval if not forced (Doc 06 §3)
    if (!forceSave) {
      final List<ResolvedSleepInterval> intervals = <ResolvedSleepInterval>[];
      if (hasNight) {
        intervals.add(
          TodayLogRepo.resolveSleepInterval(
            bedTimeText: state.fellAsleepTime!,
            wakeTimeText: state.wokeUpTime!,
            now: now,
          ),
        );
      }
      if (hasNap) {
        intervals.add(
          TodayLogRepo.resolveSleepInterval(
            bedTimeText: state.napStartTime!,
            wakeTimeText: state.napEndTime!,
            now: now,
          ),
        );
      }
      for (final ResolvedSleepInterval interval in intervals) {
        final SleepLogModel? duplicate = await findOverlappingSleepLog(
          bedTime: interval.bedTime,
          wakeTime: interval.wakeTime,
        );
        if (duplicate != null) {
          changeProps(duplicateSleepLogDetected: duplicate);
          return;
        }
      }
    }

    changeProps(isLoading: true, saveStatus: const ApiResultStatus.loading());

    final String prevEstimate = state.bedtimeEstimate;
    final String prevConfidence = state.confidenceLevel;
    ApiResultStatus<String> result = const ApiResultStatus.initial();

    if (hasNight) {
      final ResolvedSleepInterval interval = TodayLogRepo.resolveSleepInterval(
        bedTimeText: state.fellAsleepTime!,
        wakeTimeText: state.wokeUpTime!,
        now: now,
      );
      final DateTime bedTime = interval.bedTime;
      final DateTime wakeTime = interval.wakeTime;
      final int durationMins = wakeTime.difference(bedTime).inMinutes;
      if (durationMins <= 0) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception('Wake time must be after sleep time'),
          ),
        );
        return;
      }
      if (durationMins >= 1440) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception('Sleep duration cannot exceed 24 hours'),
          ),
        );
        return;
      }

      result = await TodayLogRepo.instance.addSleepLog(
        childId: childId,
        log: SleepLogModel(
          id: null,
          date: DateTime(now.year, now.month, now.day),
          bedTime: bedTime,
          wakeTime: wakeTime,
          fellAsleepTime: state.fellAsleepTime,
          wokeUpTime: state.wokeUpTime,
          isNightWaking: state.isNightWaking,
          sleepQualityIndex: qualityIndex,
          durationMinutes: durationMins,
          userId: userUid,
          childId: childId,
          createdAt: now,
        ),
      );
      if (result is Error<String>) {
        changeProps(isLoading: false, isSuccess: false, saveStatus: result);
        return;
      }
    }

    if (hasNap) {
      final ResolvedSleepInterval interval = TodayLogRepo.resolveSleepInterval(
        bedTimeText: state.napStartTime!,
        wakeTimeText: state.napEndTime!,
        now: now,
      );
      final DateTime napBed = interval.bedTime;
      final DateTime napWake = interval.wakeTime;
      final int napDurationMins = napWake.difference(napBed).inMinutes;
      if (napDurationMins <= 0) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception('Nap end time must be after start time'),
          ),
        );
        return;
      }
      if (napDurationMins >= 720) {
        changeProps(
          isLoading: false,
          saveStatus: ApiResultStatus.error(
            error: Exception('Nap duration cannot exceed 12 hours'),
          ),
        );
        return;
      }

      result = await TodayLogRepo.instance.addSleepLog(
        childId: childId,
        log: SleepLogModel(
          id: null,
          date: DateTime(now.year, now.month, now.day),
          bedTime: napBed,
          wakeTime: napWake,
          fellAsleepTime: state.napStartTime,
          wokeUpTime: state.napEndTime,
          isNightWaking: false,
          sleepQualityIndex: qualityIndex,
          durationMinutes: napDurationMins,
          userId: userUid,
          childId: childId,
          createdAt: now,
        ),
      );
    }

    if (result is Data<String>) {
      await _finishSleepSaveSuccess(
        childId: childId,
        result: result,
        prevEstimate: prevEstimate,
        prevConfidence: prevConfidence,
        now: now,
      );
    } else if (result is Error<String>) {
      changeProps(isLoading: false, isSuccess: false, saveStatus: result);
    }
  }

  Future<void> _finishSleepSaveSuccess({
    required String childId,
    required ApiResultStatus<String> result,
    required String prevEstimate,
    required String prevConfidence,
    required DateTime now,
  }) async {
    await recalculateForecast();

    bool changedSignificantly = false;
    String changeReason = state.sleepForecastReason;
    String instantTitle = '';
    String instantAction = '';
    String instantActionSubtitle = '';

    if (prevEstimate != '--:--' &&
        state.bedtimeEstimate != '--:--' &&
        state.bedtimeEstimate.isNotEmpty) {
      try {
        final DateTime prevDt = TodayLogRepo.parseTimeString(
          prevEstimate,
          referenceDate: now,
        );
        final DateTime newDt = TodayLogRepo.parseTimeString(
          state.bedtimeEstimate,
          referenceDate: now,
        );
        final int diffMinutes = newDt.difference(prevDt).inMinutes;
        if (diffMinutes.abs() >= 15) {
          changedSignificantly = true;
          final bool earlier = diffMinutes < 0;
          instantTitle = earlier
              ? 'Bedtime may shift a little earlier'
              : 'Bedtime may shift a little later';
          changeReason = state.sleepForecastReason.isNotEmpty
              ? state.sleepForecastReason
              : 'Bedtime estimate moved to ${state.bedtimeEstimate}.';
          final DateTime windDown = newDt.subtract(
            const Duration(minutes: 30),
          );
          final String windDownLabel = DateFormat('h:mm a').format(windDown);
          instantAction = 'Start wind-down at $windDownLabel';
          instantActionSubtitle = earlier
              ? 'About ${diffMinutes.abs()} minutes earlier than usual tonight.'
              : 'About ${diffMinutes.abs()} minutes later than usual tonight.';
        }
      } catch (_) {}
    }

    if (!changedSignificantly &&
        state.confidenceLevel != prevConfidence &&
        state.confidenceLevel != 'none' &&
        state.confidenceLevel.isNotEmpty) {
      changedSignificantly = true;
      instantTitle = 'Still learning this pattern';
      changeReason = state.sleepForecastReason.isNotEmpty
          ? state.sleepForecastReason
          : 'Confidence updated based on latest rest data.';
      instantAction = 'Check updated sleep plan';
      instantActionSubtitle = 'Wind-down timing reflects latest rest data.';
    }

    await V2NotificationScheduler.cancelSleepWindow(childId);
    await V2NotificationScheduler.cancelGentleCheckIn(childId);

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
      instantResultTitle: instantTitle,
      instantResultAction: instantAction,
      instantResultActionSubtitle: instantActionSubtitle,
      clearSleepInputs: true,
      clearDuplicateSleep: true,
      isNightWaking: false,
      sleepQualityIndex: -1,
      showSleepUpdateErrors: false,
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    changeProps(isSuccess: false);
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
    final String prevEstimate = state.bedtimeEstimate;
    final String prevConfidence = state.confidenceLevel;

    final String fellAsleep = state.fellAsleepTime ?? state.napStartTime ?? '';
    final String wokeUp = state.wokeUpTime ?? state.napEndTime ?? '';
    if (fellAsleep.isEmpty || wokeUp.isEmpty) {
      triggerSleepUpdateErrors();
      return;
    }

    final ResolvedSleepInterval interval = TodayLogRepo.resolveSleepInterval(
      bedTimeText: fellAsleep,
      wakeTimeText: wokeUp,
      now: now,
    );

    final SleepLogModel updated = SleepLogModel(
      id: dup.id,
      ref: dup.ref,
      date: dup.date,
      bedTime: interval.bedTime,
      wakeTime: interval.wakeTime,
      fellAsleepTime: fellAsleep,
      wokeUpTime: wokeUp,
      isNightWaking: state.isNightWaking,
      sleepQualityIndex: state.sleepQualityIndex,
      durationMinutes: interval.wakeTime
          .difference(interval.bedTime)
          .inMinutes,
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
      await _finishSleepSaveSuccess(
        childId: childId,
        result: const ApiResultStatus.data(data: 'updated'),
        prevEstimate: prevEstimate,
        prevConfidence: prevConfidence,
        now: now,
      );
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
    // What happened + time are required; trigger and what helped are optional (Doc 06 §4).
    if (state.tantrumWhatHappened.trim().isEmpty || state.tantrumTime == null) {
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
      changeProps(
        isLoading: false,
        showTantrumUpdateErrors: true,
        saveStatus: const ApiResultStatus.initial(),
      );
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
            ? updatedResult.reason
            : '',
        instantResultTitle: behaviourShifted
            ? updatedResult.headline
            : '',
        instantResultAction: behaviourShifted ? 'Explore Calm Plan' : '',
        instantResultActionSubtitle: behaviourShifted
            ? 'Strategies for the upcoming challenging window.'
            : '',
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
