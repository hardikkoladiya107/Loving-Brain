import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/sleep_log_model.dart';

part 'today_state.freezed.dart';

enum TodayMode { normal, newParent, importantHeadsUp }

/// Destination for a Noticed insight card on Today.
enum TodayNoticedDestination { none, sleepPattern, behaviourPattern }

/// One daytime nap inside the sleep update sheet.
class NapDraft {
  const NapDraft({this.start, this.end, this.error = ''});

  final String? start;
  final String? end;
  final String error;

  bool get hasStart => start != null && start!.trim().isNotEmpty;

  bool get hasEnd => end != null && end!.trim().isNotEmpty;

  bool get isComplete => hasStart && hasEnd;

  NapDraft copyWith({
    String? start,
    String? end,
    String? error,
    bool clearStart = false,
    bool clearEnd = false,
  }) {
    return NapDraft(
      start: clearStart ? null : (start ?? this.start),
      end: clearEnd ? null : (end ?? this.end),
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NapDraft &&
        other.start == start &&
        other.end == end &&
        other.error == error;
  }

  @override
  int get hashCode => Object.hash(start, end, error);
}

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

    // Assembled home card copy (never invent in widgets)
    @Default(false) bool showHealthHeadsUp,
    @Default('') String healthHeadsUpTitle,
    @Default('') String healthHeadsUpSubtitle,
    @Default(false) bool showBehaviourHeadsUp,
    @Default('') String headsUpHeadline,
    @Default('') String headsUpReason,
    @Default('') String headsUpWindowStart,
    @Default('') String headsUpWindowEnd,
    @Default(false) bool showNiceWork,
    @Default('') String niceWorkTitle,
    @Default('') String niceWorkSubtitle,
    @Default(false) bool showNoticed,
    @Default('') String noticedTitle,
    @Default(TodayNoticedDestination.none)
    TodayNoticedDestination noticedDestination,
    @Default(false) bool showSupportOffer,
    @Default(0) int supportInconsistentDays,
    @Default('') String onboardingFocusLine,
    @Default(true) bool prioritiseSleepFirst,
    @Default('') String instantResultTitle,
    @Default('') String instantResultAction,
    @Default('') String instantResultActionSubtitle,

    // Check-in fields
    @Default(null) String? fellAsleepTime,
    @Default(null) String? wokeUpTime,
    @Default(false) bool includeNaps,
    @Default(<NapDraft>[]) List<NapDraft> napDrafts,
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

    // Sleep Add-ons (-1 = unrated)
    @Default(false) bool isNightWaking,
    @Default(-1) int sleepQualityIndex,

    // Notes
    @Default('') String quickNoteText,
    @Default(false) bool showNotesUpdateErrors,
  }) = _TodayState;
}
