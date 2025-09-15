import 'package:freezed_annotation/freezed_annotation.dart';

part 'your_streak_state.freezed.dart';

@freezed
abstract class YourStreakState with _$YourStreakState {
  const factory YourStreakState({@Default("") String message}) =
      _YourStreakState;
}
