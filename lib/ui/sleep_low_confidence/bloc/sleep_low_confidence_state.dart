import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_low_confidence_state.freezed.dart';

@freezed
abstract class SleepLowConfidenceState with _$SleepLowConfidenceState {
  const factory SleepLowConfidenceState() = _SleepLowConfidenceState;
}
