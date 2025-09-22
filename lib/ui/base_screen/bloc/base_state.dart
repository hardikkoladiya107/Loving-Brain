import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

@freezed
abstract class BaseState with _$BaseState {
  const factory BaseState({
    @Default("") String message,
    @Default(0) int bottomNavigationIndex,
  }) = _BaseState;
}
