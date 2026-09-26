import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_details_state.freezed.dart';

@freezed
abstract class SleepDetailsState with _$SleepDetailsState {
  const factory SleepDetailsState({
    @Default(false) bool isLoading,
    @Default("6h 52m") String timeInSleep,
    @Default("07:12 AM") String wakeUpTime,
    @Default("7h 23m") String wentToBed,
    @Default("25 min") String fellAsleepTime,
  }) = _SleepDetailsState;
}
