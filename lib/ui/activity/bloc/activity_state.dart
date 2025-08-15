import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_state.freezed.dart';

@freezed
abstract class ActivityState with _$ActivityState {
  const factory ActivityState({@Default("message") String message}) =
      _ActivityState;
}
