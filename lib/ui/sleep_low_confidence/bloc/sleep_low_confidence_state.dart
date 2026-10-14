import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_low_confidence_state.freezed.dart';

/// State for Screen 69 (Low Confidence Sleep Window).
/// Conforms to AGENTS.md §4.1 and v2-doc/02_CORE_RULES_AND_FORMULAS.md.
@freezed
abstract class SleepLowConfidenceState with _$SleepLowConfidenceState {
  const factory SleepLowConfidenceState({
    @Default('7:15 – 8:30 PM') String windowTimeRange,
    @Default(4) int nightsCount,
    @Default('low') String confidence,
    @Default(
      "A wider window than usual the last few days have been unsettled, so we're less sure tonight.",
    )
    String explanation,
    @Default(false) bool isLoading,
  }) = _SleepLowConfidenceState;
}
