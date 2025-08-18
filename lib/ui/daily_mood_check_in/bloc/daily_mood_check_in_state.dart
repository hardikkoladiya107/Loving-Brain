import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_mood_check_in_state.freezed.dart';

@freezed
abstract class DailyMoodCheckInState with _$DailyMoodCheckInState {
  const factory DailyMoodCheckInState({@Default("") String message}) =
      _DailyMoodCheckInState;
}
