import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_state.freezed.dart';

@freezed
abstract class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default("message") String message,
    @Default(0) int tabIndex,
  }) = _ScheduleState;
}
