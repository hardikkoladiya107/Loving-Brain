import 'package:freezed_annotation/freezed_annotation.dart';

part 'trying_this_week_state.freezed.dart';

@freezed
abstract class TryingThisWeekState with _$TryingThisWeekState {
  const factory TryingThisWeekState() = _TryingThisWeekState;
}
