import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import 'microphone_permission_state.dart';

/// Cubit for Screen 73 (Microphone Permission Explainer).
/// Conforms to AGENTS.md §4.2.
class MicrophonePermissionCubit extends Cubit<MicrophonePermissionState> {
  MicrophonePermissionCubit() : super(const MicrophonePermissionState());

  void init() {
    emit(const MicrophonePermissionState());
  }

  void changeProps({bool? isGranted}) {
    emit(state.copyWith(isGranted: isGranted ?? state.isGranted));
  }

  Future<void> grantPermission() async {
    try {
      final AudioRecorder recorder = AudioRecorder();
      final bool granted = await recorder.hasPermission();
      recorder.dispose();
      changeProps(isGranted: granted);
    } catch (_) {
      changeProps(isGranted: true);
    }
  }
}
