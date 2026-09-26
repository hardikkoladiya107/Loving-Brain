import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_state.freezed.dart';

enum TodayMode { normal, newParent, importantHeadsUp }

@freezed
abstract class TodayState with _$TodayState {
  const factory TodayState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(TodayMode.normal) TodayMode mode,
    @Default('') String childName,
    @Default('') String parentName,
    @Default('GOOD EVENING') String timeOfDayGreeting,
    @Default('07:45') String sleepForecastStart,
    @Default('8:15 PM') String sleepForecastEnd,
    @Default('8:10 PM') String bedtimeEstimate,
    @Default("Today's nap ran about 25 minutes short.") String forecastSubtitle,
    @Default('moderate') String confidenceLevel,

    // Check-in fields
    @Default(null) String? fellAsleepTime,
    @Default(null) String? wokeUpTime,
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
    @Default(3) int sleepQualityIndex,

    // Notes
    @Default('') String quickNoteText,
    @Default(false) bool showNotesUpdateErrors,
  }) = _TodayState;
}
