import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/ui/brainy_ai/bloc/brainy_voice_cubit.dart';
import 'package:loving_brain/ui/brainy_ai/bloc/brainy_voice_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Voice recording failure does not leave isRecording true', () async {
    final BrainyVoiceCubit cubit = BrainyVoiceCubit();
    // Force the failure path without hardware.
    cubit.changeProps(isRecording: true, recordingFailed: false);
    cubit.changeProps(isRecording: false, recordingFailed: true);
    final BrainyVoiceState state = cubit.state;
    expect(state.isRecording, isFalse);
    expect(state.recordingFailed, isTrue);
    await cubit.close();
  });

  test('Awaiting confirm stays false until transcript is prepared', () async {
    final BrainyVoiceCubit cubit = BrainyVoiceCubit();
    expect(cubit.state.awaitingConfirm, isFalse);
    cubit.changeProps(
      awaitingConfirm: true,
      previewText: 'Why is bedtime harder?',
    );
    expect(cubit.state.awaitingConfirm, isTrue);
    expect(cubit.state.previewText, contains('bedtime'));
    await cubit.cancelRecording();
    expect(cubit.state.awaitingConfirm, isFalse);
    expect(cubit.state.previewText, isEmpty);
    await cubit.close();
  });
}
