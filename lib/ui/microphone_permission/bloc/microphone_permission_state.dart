import 'package:freezed_annotation/freezed_annotation.dart';

part 'microphone_permission_state.freezed.dart';

@freezed
abstract class MicrophonePermissionState with _$MicrophonePermissionState {
  const factory MicrophonePermissionState() = _MicrophonePermissionState;
}
