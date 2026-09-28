import 'dart:io';

class BrainyVoiceState {
  final bool isRecording;
  final bool isProcessing;
  final int elapsedSeconds;
  final String previewText;
  final File? recordedFile;
  final String topic;

  const BrainyVoiceState({
    this.isRecording = false,
    this.isProcessing = false,
    this.elapsedSeconds = 0,
    this.previewText = 'She keeps waking around four in the morning...',
    this.recordedFile,
    this.topic = 'Behaviour',
  });

  BrainyVoiceState copyWith({
    bool? isRecording,
    bool? isProcessing,
    int? elapsedSeconds,
    String? previewText,
    File? recordedFile,
    String? topic,
  }) {
    return BrainyVoiceState(
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      previewText: previewText ?? this.previewText,
      recordedFile: recordedFile ?? this.recordedFile,
      topic: topic ?? this.topic,
    );
  }
}
