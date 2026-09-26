import 'package:freezed_annotation/freezed_annotation.dart';

part 'harder_week_state.freezed.dart';

@freezed
abstract class HarderWeekState with _$HarderWeekState {
  const factory HarderWeekState() = _HarderWeekState;
}
