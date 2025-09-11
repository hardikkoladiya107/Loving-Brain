import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shared_event_state.freezed.dart';

@freezed
abstract class AddSharedEventState with _$AddSharedEventState {
  const factory AddSharedEventState({@Default("") String message}) =
      _AddSharedEventState;
}
