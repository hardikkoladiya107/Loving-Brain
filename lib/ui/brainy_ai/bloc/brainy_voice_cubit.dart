import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/transcribe_model.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'brainy_voice_state.dart';

class BrainyVoiceCubit extends Cubit<BrainyVoiceState> {
  BrainyVoiceCubit() : super(const BrainyVoiceState());

  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;

  void changeProps({
    String? topic,
    String? previewText,
    bool? isRecording,
    bool? isProcessing,
    int? elapsedSeconds,
    File? recordedFile,
  }) {
    emit(
      state.copyWith(
        topic: topic ?? state.topic,
        previewText: previewText ?? state.previewText,
        isRecording: isRecording ?? state.isRecording,
        isProcessing: isProcessing ?? state.isProcessing,
        elapsedSeconds: elapsedSeconds ?? state.elapsedSeconds,
        recordedFile: recordedFile ?? state.recordedFile,
      ),
    );
  }

  Future<void> init({String? topic}) async {
    final String selectedTopic = topic ?? 'Behaviour';
    changeProps(topic: selectedTopic, previewText: '');
    await startRecording();
  }

  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        changeProps(isRecording: true, elapsedSeconds: 0);
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
          if (!isClosed) {
            changeProps(elapsedSeconds: state.elapsedSeconds + 1);
          }
        });
      }
    } catch (_) {
      // Even if recorder fails on emulator/missing hardware, keep UI responsive
      changeProps(isRecording: true);
    }
  }

  Future<(File?, String)> stopAndFinishRecording() async {
    _timer?.cancel();
    changeProps(isRecording: false, isProcessing: true);

    File? recordedFile;
    String finalText = '';

    try {
      if (await _recorder.isRecording()) {
        final String? recordedPath = await _recorder.stop();
        if (recordedPath != null && recordedPath.isNotEmpty) {
          recordedFile = File(recordedPath);
        }
      }
    } catch (_) {}

    if (recordedFile != null && await recordedFile.exists()) {
      try {
        final ApiResultStatus result = await AiRepo.instance
            .transcribeAudio(file: recordedFile)
            .timeout(const Duration(seconds: 6));
        result.whenOrNull(
          data: (dynamic data) {
            final TranscribeModel transcribeModel = TranscribeModel.fromJson(
              data,
            );
            if (transcribeModel.text != null &&
                transcribeModel.text!.trim().isNotEmpty) {
              finalText = transcribeModel.text!.trim();
            }
          },
        );
      } catch (_) {}
    }

    if (!isClosed) {
      changeProps(
        isProcessing: false,
        recordedFile: recordedFile,
        previewText: finalText,
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
