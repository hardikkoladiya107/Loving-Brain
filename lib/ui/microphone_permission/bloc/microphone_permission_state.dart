import 'package:freezed_annotation/freezed_annotation.dart';

part 'microphone_permission_state.freezed.dart';

/// State for Screen 73 (Microphone Permission Explainer).
/// Conforms to AGENTS.md §4.1.
@freezed
abstract class MicrophonePermissionState with _$MicrophonePermissionState {
  const factory MicrophonePermissionState({@Default(false) bool isGranted}) =
      _MicrophonePermissionState;
}
