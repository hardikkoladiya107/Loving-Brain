import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';

part 'sleep_forecast_state.freezed.dart';

@freezed
abstract class SleepForecastState with _$SleepForecastState {
  const factory SleepForecastState({
    @Default(false) bool isLoading,
    @Default(0) int selectedDayIndex,
    @Default('Parent') String parentName,
    @Default('your child') String childName,
    @Default('GOOD EVENING') String timeOfDayGreeting,
    @Default('07:45 PM') String windowStart,
    @Default('08:15 PM') String windowEnd,
    @Default('08:10 PM') String bedtimeEstimate,
    @Default("Today's rest indicates normal wake pressure.") String reason,
    @Default('Bedtime estimate 08:10 PM. Moderate confidence.') String subtitle,
    @Default('Moderate') String confidenceLevel,
    @Default(2) int confidenceDots,
    @Default([]) List<TonightPlanStep> planSteps,
    @Default(false) bool hasRealLogs,
    @Default([]) List<int> loggedDays,
    String? healthCaveat,
  }) = _SleepForecastState;
}
