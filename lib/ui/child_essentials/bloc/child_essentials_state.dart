import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_essentials_state.freezed.dart';

@freezed
abstract class ChildEssentialsState with _$ChildEssentialsState {
  const factory ChildEssentialsState() = _ChildEssentialsState;
}
