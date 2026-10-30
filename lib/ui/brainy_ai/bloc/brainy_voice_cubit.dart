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
    bool? awaitingConfirm,
    bool? recordingFailed,
    int? elapsedSeconds,
    File? recordedFile,
    bool clearRecordedFile = false,
  }) {
    emit(
      state.copyWith(
        topic: topic ?? state.topic,
        previewText: previewText ?? state.previewText,
        isRecording: isRecording ?? state.isRecording,
        isProcessing: isProcessing ?? state.isProcessing,
        awaitingConfirm: awaitingConfirm ?? state.awaitingConfirm,
        recordingFailed: recordingFailed ?? state.recordingFailed,
        elapsedSeconds: elapsedSeconds ?? state.elapsedSeconds,
        recordedFile: recordedFile,
        clearRecordedFile: clearRecordedFile,
      ),
    );
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    try {
      _recorder.stop().catchError((_) => null);
    } catch (_) {}
    emit(const BrainyVoiceState());
  }

  Future<void> init({String? topic}) async {
    final String selectedTopic = topic ?? 'Behaviour';
    changeProps(
      topic: selectedTopic,
      previewText: '',
      awaitingConfirm: false,
      recordingFailed: false,
      clearRecordedFile: true,
    );
    await startRecording();
  }

  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        changeProps(
          isRecording: true,
          recordingFailed: false,
          awaitingConfirm: false,
          elapsedSeconds: 0,
        );
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
          if (!isClosed) {
            changeProps(elapsedSeconds: state.elapsedSeconds + 1);
          }
        });
      } else {
        changeProps(
          isRecording: false,
          recordingFailed: true,
          awaitingConfirm: false,
        );
      }
    } catch (_) {
      changeProps(
        isRecording: false,
        recordingFailed: true,
        awaitingConfirm: false,
      );
    }
  }

  /// Stops recording and transcribes. Does not send — waits for confirm.
  Future<(File?, String)> stopAndPrepareTranscript() async {
    _timer?.cancel();
    changeProps(isRecording: false, isProcessing: true, recordingFailed: false);

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
            .timeout(const Duration(seconds: 45));
        result.whenOrNull(
          data: (dynamic data) {
            final TranscribeModel transcribeModel = TranscribeModel.fromJson(
              data is Map<String, dynamic>
                  ? data
                  : Map<String, dynamic>.from(data as Map),
            );
            if (transcribeModel.text != null &&
                transcribeModel.text!.trim().isNotEmpty) {
              finalText = transcribeModel.text!.trim();
            }
          },
        );
      } catch (_) {}
    }

    final bool hasAudio = recordedFile != null && await recordedFile.exists();
    if (!isClosed) {
      changeProps(
        isProcessing: false,
        recordedFile: hasAudio ? recordedFile : null,
        clearRecordedFile: !hasAudio,
        previewText: finalText,
        awaitingConfirm: hasAudio || finalText.isNotEmpty,
        recordingFailed: !hasAudio && finalText.isEmpty,
      );
    }
    return (hasAudio ? recordedFile : null, finalText);
  }

  /// Backward-compatible alias used by older callers.
  Future<(File?, String)> stopAndFinishRecording() =>
      stopAndPrepareTranscript();

  (File?, String) confirmPreparedNote() {
    return (state.recordedFile, state.previewText);
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {}
    if (!isClosed) {
      changeProps(
        isRecording: false,
        isProcessing: false,
        awaitingConfirm: false,
        recordingFailed: false,
        previewText: '',
        clearRecordedFile: true,
      );
    }
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
