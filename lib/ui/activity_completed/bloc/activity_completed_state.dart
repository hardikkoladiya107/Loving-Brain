import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_completed_state.freezed.dart';

@freezed
abstract class ActivityCompletedState with _$ActivityCompletedState {
  const factory ActivityCompletedState({@Default("message") String message}) =
      _ActivityCompletedState;
}
