import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:path_provider/path_provider.dart';

import 'calm_plan_state.dart';

class CalmPlanCubit extends Cubit<CalmPlanState> {
  CalmPlanCubit() : super(const CalmPlanState());

  AudioPlayer? _audioPlayer;
  Timer? _playbackTicker;
  File? _calmAudioFile;

  void reset() {
    _playbackTicker?.cancel();
    _playbackTicker = null;
    try {
      _audioPlayer?.stop().catchError((_) {});
    } catch (_) {}
    emit(const CalmPlanState());
  }

  void init({BehaviourForecastResult? forecast}) {
    emit(const CalmPlanState());
    _initAudioPlayer();
    if (forecast != null) {
      changeProps(
        forecast: forecast,
        actions: forecast.actions,
        avoidInstructionTitle: forecast.avoidInstructionTitle,
        avoidInstructionSubtitle: forecast.avoidInstructionSubtitle,
        childName: forecast.childName,
      );
    } else {
      _loadDefaultPlan();
    }
  }

  void _initAudioPlayer() {
    _audioPlayer ??= AudioPlayer();
  }

  void changeProps({
    bool? isLoading,
    bool? isAudioPlaying,
    ApiResultStatus? fetchStatus,
    BehaviourForecastResult? forecast,
    List<CalmPlanAction>? actions,
    String? avoidInstructionTitle,
    String? avoidInstructionSubtitle,
    String? childName,
    int? audioPositionSeconds,
    int? audioDurationSeconds,
  }) {
    emit(
      state.copyWith(
        isLoading: isLoading ?? state.isLoading,
        isAudioPlaying: isAudioPlaying ?? state.isAudioPlaying,
        fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
        forecast: forecast ?? state.forecast,
        actions: actions ?? state.actions,
        avoidInstructionTitle:
            avoidInstructionTitle ?? state.avoidInstructionTitle,
        avoidInstructionSubtitle:
            avoidInstructionSubtitle ?? state.avoidInstructionSubtitle,
        childName: childName ?? state.childName,
        audioPositionSeconds:
            audioPositionSeconds ?? state.audioPositionSeconds,
        audioDurationSeconds:
            audioDurationSeconds ?? state.audioDurationSeconds,
      ),
    );
  }

  Future<void> toggleAudio() async {
    if (state.isAudioPlaying) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  Future<void> playAudio() async {
    _initAudioPlayer();
    changeProps(isAudioPlaying: true);

    // Ensure audio file is generated
    try {
      if (_calmAudioFile == null || !_calmAudioFile!.existsSync()) {
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/calm_guide_ambient.wav');
        if (!file.existsSync()) {
          final List<int> wavBytes = _generateCalmWav();
          await file.writeAsBytes(wavBytes);
        }
        _calmAudioFile = file;
      }

      if (_calmAudioFile != null && _calmAudioFile!.existsSync()) {
        await _audioPlayer?.play(DeviceFileSource(_calmAudioFile!.path));
      }
    } catch (_) {}

    // Start progress timer
    _playbackTicker?.cancel();
    _playbackTicker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final int nextPos = state.audioPositionSeconds + 1;
      if (nextPos >= state.audioDurationSeconds) {
        timer.cancel();
        _audioPlayer?.stop();
        changeProps(isAudioPlaying: false, audioPositionSeconds: 0);
      } else {
        changeProps(audioPositionSeconds: nextPos);
      }
    });
  }

  Future<void> pauseAudio() async {
    _playbackTicker?.cancel();
    changeProps(isAudioPlaying: false);
    try {
      await _audioPlayer?.pause();
    } catch (_) {}
  }

  static List<int> _generateCalmWav({
    int durationSeconds = 180,
    int sampleRate = 8000,
  }) {
    final int totalSamples = durationSeconds * sampleRate;
    const int numChannels = 1;
    const int bytesPerSample = 2;
    final int byteRate = sampleRate * numChannels * bytesPerSample;
    final int dataSize = totalSamples * bytesPerSample;
    final ByteData header = ByteData(44);

    // RIFF header
    header.setUint8(0, 0x52); // R
    header.setUint8(1, 0x49); // I
    header.setUint8(2, 0x46); // F
    header.setUint8(3, 0x46); // F
    header.setUint32(4, 36 + dataSize, Endian.little);
    header.setUint8(8, 0x57); // W
    header.setUint8(9, 0x41); // A
    header.setUint8(10, 0x56); // V
    header.setUint8(11, 0x45); // E

    // fmt subchunk
    header.setUint8(12, 0x66); // f
    header.setUint8(13, 0x6D); // m
    header.setUint8(14, 0x74); // t
    header.setUint8(15, 0x20); // space
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little); // PCM
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, numChannels * bytesPerSample, Endian.little);
    header.setUint16(34, bytesPerSample * 8, Endian.little);

    // data subchunk
    header.setUint8(36, 0x64); // d
    header.setUint8(37, 0x61); // a
    header.setUint8(38, 0x74); // t
    header.setUint8(39, 0x61); // a
    header.setUint32(40, dataSize, Endian.little);

    final Uint8List result = Uint8List(44 + dataSize);
    result.setRange(0, 44, header.buffer.asUint8List());

    final ByteData samplesData = ByteData.view(result.buffer, 44, dataSize);
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double envelope = 0.5 * (1.0 + math.sin(2 * math.pi * 0.25 * t));
      final double sample = math.sin(2 * math.pi * 432.0 * t) * 0.25 * envelope;
      final int intSample = (sample * 32767).toInt().clamp(-32768, 32767);
      samplesData.setInt16(i * 2, intSample, Endian.little);
    }
    return result;
  }

  void _loadDefaultPlan() {
    final ChildModel? child = preferences.getChildModel();
    final String? childName = child?.childName?.trim();
    final String name = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';

    final BehaviourForecastResult forecast =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child,
          tantrumLogs: <TantrumLogModel>[],
          sleepLogs: <SleepLogModel>[],
          moodLogs: <MoodLogModel>[],
          healthLogs: <HealthLogModel>[],
        );

    changeProps(
      forecast: forecast,
      actions: forecast.actions,
      avoidInstructionTitle: forecast.avoidInstructionTitle,
      avoidInstructionSubtitle: forecast.avoidInstructionSubtitle,
      childName: name,
    );
  }

  @override
  Future<void> close() async {
    _playbackTicker?.cancel();
    await _audioPlayer?.dispose();
    return super.close();
  }
}
