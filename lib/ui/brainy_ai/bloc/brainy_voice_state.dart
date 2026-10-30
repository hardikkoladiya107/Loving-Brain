import 'dart:io';

class BrainyVoiceState {
  final bool isRecording;
  final bool isProcessing;
  final bool awaitingConfirm;
  final bool recordingFailed;
  final int elapsedSeconds;
  final String previewText;
  final File? recordedFile;
  final String topic;

  const BrainyVoiceState({
    this.isRecording = false,
    this.isProcessing = false,
    this.awaitingConfirm = false,
    this.recordingFailed = false,
    this.elapsedSeconds = 0,
    this.previewText = '',
    this.recordedFile,
    this.topic = 'Behaviour',
  });

  BrainyVoiceState copyWith({
    bool? isRecording,
    bool? isProcessing,
    bool? awaitingConfirm,
    bool? recordingFailed,
    int? elapsedSeconds,
    String? previewText,
    File? recordedFile,
    String? topic,
    bool clearRecordedFile = false,
  }) {
    return BrainyVoiceState(
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      awaitingConfirm: awaitingConfirm ?? this.awaitingConfirm,
      recordingFailed: recordingFailed ?? this.recordingFailed,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      previewText: previewText ?? this.previewText,
      recordedFile: clearRecordedFile
          ? null
          : (recordedFile ?? this.recordedFile),
      topic: topic ?? this.topic,
    );
  }
}
