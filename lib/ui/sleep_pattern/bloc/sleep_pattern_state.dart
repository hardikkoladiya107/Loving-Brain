import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_pattern_state.freezed.dart';

@freezed
abstract class SleepPatternState with _$SleepPatternState {
  const factory SleepPatternState({
    @Default(false) bool isLoading,
    @Default(1) int selectedToggleIndex, // 0: Day, 1: Week, 2: Month
    @Default('your child') String childName,
    @Default(10.5) double averageSleepHours,
    @Default(85) int consistencyScore,
    @Default("Naps have been shorter this week.") String patternInsight,
    @Default(
      "Four of the last five ended early, which tends to show up as harder evenings.",
    )
    String patternDetail,
    @Default([10.0, 11.0, 9.5, 10.5, 11.2, 10.0, 10.5])
    List<double> dailySleepHours,
    @Default(false) bool hasData,
  }) = _SleepPatternState;
}
