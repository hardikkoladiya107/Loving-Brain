import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/transcribe_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
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
    final ChildModel? child = preferences.getChildModel();
    final UserModel? user = preferences.getUserModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : (user?.childName != null && user!.childName!.trim().isNotEmpty)
        ? user.childName!.trim()
        : 'She';

    final String selectedTopic = topic ?? 'Behaviour';
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

    changeProps(topic: selectedTopic, previewText: promptPreview);
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
    String finalText = state.previewText;

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
