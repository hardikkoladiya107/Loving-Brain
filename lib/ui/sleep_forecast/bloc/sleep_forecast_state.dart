import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_forecast_state.freezed.dart';

@freezed
abstract class SleepForecastState with _$SleepForecastState {
  const factory SleepForecastState({
    @Default(false) bool isLoading,
    @Default(0) int selectedDayIndex,
  }) = _SleepForecastState;
}
