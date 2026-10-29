import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/sleep_log_model.dart';

part 'today_state.freezed.dart';

enum TodayMode { normal, newParent, importantHeadsUp }

@freezed
abstract class TodayState with _$TodayState {
  const factory TodayState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
    @Default('') String activeChildId,
    @Default(TodayMode.newParent) TodayMode mode,
    @Default('') String childName,
    @Default('') String parentName,
    @Default('GOOD EVENING') String timeOfDayGreeting,
    @Default('--:--') String sleepForecastStart,
    @Default('--:--') String sleepForecastEnd,
    @Default('--:--') String bedtimeEstimate,
    @Default('Log sleep updates to view personalised forecasts.')
    String forecastSubtitle,
    @Default('none') String confidenceLevel,
    @Default(0) int confidenceDots,
    @Default('') String sleepForecastReason,
    @Default(false) bool hasSleepLogs,
    @Default(false) bool hasMultiDayPatterns,
    @Default(false) bool hasAnyLogs,
    @Default(0) int loggedDaysCount,

    // Meaningful forecast change tracking (Doc 01 screens 22 & 66, Doc 06 §3)
    @Default(false) bool didForecastChangeSignificantly,
    @Default('') String forecastChangeReason,
    @Default(null) SleepLogModel? duplicateSleepLogDetected,

    // Check-in fields
    @Default(null) String? fellAsleepTime,
    @Default(null) String? wokeUpTime,
    @Default(null) String? napStartTime,
    @Default(null) String? napEndTime,
    @Default(false) bool showSleepUpdateErrors,

    // Mood
    @Default(-1) int selectedChildMoodIndex,
    @Default('') String selectedParentMood,
    @Default(false) bool showMoodUpdateErrors,

    // Tantrum
    @Default('') String tantrumWhatHappened,
    @Default(null) String? tantrumTime,
    @Default(0.5) double tantrumIntensity,
    @Default([]) List<String> selectedTantrumTriggers,
    @Default('') String tantrumWhatHelped,
    @Default(false) bool showTantrumUpdateErrors,

    // Health
    @Default([]) List<String> selectedHealthIssues,
    @Default('') String healthNotes,
    @Default(false) bool showHealthUpdateErrors,

    // Sleep Add-ons
    @Default(false) bool isNightWaking,
    @Default(-1) int sleepQualityIndex,

    // Notes
    @Default('') String quickNoteText,
    @Default(false) bool showNotesUpdateErrors,
  }) = _TodayState;
}
