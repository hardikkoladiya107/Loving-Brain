import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_safety_state.freezed.dart';

@freezed
abstract class HelpSafetyState with _$HelpSafetyState {
  const factory HelpSafetyState() = _HelpSafetyState;
}
