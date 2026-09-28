import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/transcribe_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'brainy_voice_state.dart';

class BrainyVoiceCubit extends Cubit<BrainyVoiceState> {
  BrainyVoiceCubit() : super(const BrainyVoiceState());

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;

  Future<void> init({String? topic}) async {
    final child = preferences.getChildModel();
    final user = preferences.getUserModel();
    final cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'She';

    final selectedTopic = topic ?? 'Behaviour';
    String promptPreview = '$cName keeps waking around four in the morning...';
    if (selectedTopic == 'Behaviour') {
      promptPreview =
          '$cName has been having a harder time winding down in the evening...';
    } else if (selectedTopic == 'Mood') {
      promptPreview =
          'How can I help $cName calm down after a big emotional meltdown?';
    } else if (selectedTopic == 'Health') {
      promptPreview =
          '$cName seems uncomfortable tonight — what can we do to help?';
    }

    emit(state.copyWith(topic: selectedTopic, previewText: promptPreview));
    await startRecording();
  }

  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        emit(state.copyWith(isRecording: true, elapsedSeconds: 0));
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!isClosed) {
            emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
          }
        });
      }
    } catch (_) {
      // Even if recorder fails on emulator/missing hardware, keep UI responsive
      emit(state.copyWith(isRecording: true));
    }
  }

  Future<(File?, String)> stopAndFinishRecording() async {
    _timer?.cancel();
    emit(state.copyWith(isRecording: false, isProcessing: true));

    File? recordedFile;
    String finalText = state.previewText;

    try {
      if (await _recorder.isRecording()) {
        final recordedPath = await _recorder.stop();
        if (recordedPath != null && recordedPath.isNotEmpty) {
          recordedFile = File(recordedPath);
        }
      }
    } catch (_) {}

    if (recordedFile != null && await recordedFile.exists()) {
      try {
        final result = await AiRepo.instance
            .transcribeAudio(file: recordedFile)
            .timeout(const Duration(seconds: 6));
        result.whenOrNull(
          data: (data) {
            final transcribeModel = TranscribeModel.fromJson(data);
            if (transcribeModel.text != null &&
                transcribeModel.text!.trim().isNotEmpty) {
              finalText = transcribeModel.text!.trim();
            }
          },
        );
      } catch (_) {}
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          isProcessing: false,
          recordedFile: recordedFile,
          previewText: finalText,
        ),
      );
    }
    return (recordedFile, finalText);
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    try {
      await _recorder.dispose();
    } catch (_) {}
    return super.close();
  }
}
