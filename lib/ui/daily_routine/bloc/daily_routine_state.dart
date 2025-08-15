import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_routine_state.freezed.dart';

@freezed
abstract class DailyRoutineState with _$DailyRoutineState {
  const factory DailyRoutineState({@Default("message") String message}) =
      _DailyRoutineState;
}
