import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_details_state.freezed.dart';

@freezed
abstract class SleepDetailsState with _$SleepDetailsState {
  const factory SleepDetailsState({
    @Default(false) bool isLoading,
    @Default("6h 52m") String timeInSleep,
    @Default("07:12 AM") String wakeUpTime,
    @Default("08:00 PM") String wentToBed,
    @Default("20 min") String fellAsleepTime,
    @Default("4/5") String sleepQuality,
    @Default("07:45 PM") String windowStart,
    @Default("08:15 PM") String windowEnd,
    @Default("08:10 PM") String bedtimeEstimate,
    @Default("Moderate") String confidenceLabel,
    @Default(2) int confidenceDots,
    @Default("your child") String childName,
    @Default("Recent rest indicates normal wake pressure.")
    String whyWeExpectIt,
    @Default(
      "Illness, travel or a change of setting can make today less predictable.",
    )
    String whatCouldChange,
    @Default(false) bool hasRealLogs,
  }) = _SleepDetailsState;
}
