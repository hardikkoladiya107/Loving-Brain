import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_behavior_state.freezed.dart';

@freezed
abstract class NewBehaviorState with _$NewBehaviorState {
  const factory NewBehaviorState({@Default("message") String message}) =
      _NewBehaviorState;
}
