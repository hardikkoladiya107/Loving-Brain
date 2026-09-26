import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_pattern_state.freezed.dart';

@freezed
abstract class SleepPatternState with _$SleepPatternState {
  const factory SleepPatternState({
    @Default(false) bool isLoading,
    @Default(1) int selectedToggleIndex, // 0: Day, 1: Week, 2: Month
  }) = _SleepPatternState;
}
