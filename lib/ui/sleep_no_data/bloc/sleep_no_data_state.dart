import 'package:freezed_annotation/freezed_annotation.dart';

part 'sleep_no_data_state.freezed.dart';

/// State for Screen 64 (No Sleep Data Yet).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class SleepNoDataState with _$SleepNoDataState {
  const factory SleepNoDataState({
    @Default('your child') String childName,
    @Default('17 months') String childAge,
    @Default(false) bool isLoading,
  }) = _SleepNoDataState;
}
