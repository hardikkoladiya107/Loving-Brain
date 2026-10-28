import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/transcribe_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:loving_brain/other/permission_helper.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../bloc/today_cubit.dart';
import '../bloc/today_state.dart';

void showAddNotesUpdateSheet(BuildContext context) {
  final TodayCubit cubit = context.read<TodayCubit>();
  cubit.changeProps(quickNoteText: '', showNotesUpdateErrors: false);
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFFFFFFFF),
    isScrollControlled: true,
    builder: (BuildContext context) => const AddNotesUpdateSheet(),
  );
}

class AddNotesUpdateSheet extends StatefulWidget {
  const AddNotesUpdateSheet({super.key});

  @override
  State<AddNotesUpdateSheet> createState() => _AddNotesUpdateSheetState();
}

class _AddNotesUpdateSheetState extends State<AddNotesUpdateSheet> {
  late final TextEditingController _textController;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  Timer? _recordTimer;
  int _recordElapsedSeconds = 0;

  bool _isRecording = false;
  bool _isTranscribing = false;
  String? _currentRecordingPath;

  // Recorded audio playback state
  String? _recordedAudioPath;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final String initialText = context.read<TodayCubit>().state.quickNoteText;
    _textController = TextEditingController(text: initialText);

    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _playbackPosition = p;
        });
      }
    }, onError: (_) {});

    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          _playbackDuration = d;
        });
      }
    }, onError: (_) {});

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = Duration.zero;
        });
      }
    }, onError: (_) {});

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      PlayerState state,
    ) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<bool> _ensurePermission() async {
    try {
      final bool hasPermission =
          await PermissionHelper.ensureMicrophonePermission(context);
      if (!hasPermission && mounted) {
        showSnackBar(
          message: "Microphone permission is required to record audio notes.",
          type: SnackBarType.ERROR,
        );
      }
      return hasPermission;
    } catch (_) {
      return false;
    }
  }

  Future<void> _startRecording() async {
    if (_isRecording || _isTranscribing) return;

    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    final bool permissionGranted = await _ensurePermission();
    if (!permissionGranted) return;

    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String path =
          '${dir.path}/quick_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentRecordingPath = path;
      _recordElapsedSeconds = 0;

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
        if (mounted) {
          setState(() {
            _recordElapsedSeconds++;
          });
        }
      });

      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
    } catch (_) {
      if (mounted) {
        showSnackBar(
          message: "Microphone unavailable. Please try typing your note.",
          type: SnackBarType.ERROR,
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();

    final int recordedSecs = _recordElapsedSeconds;
    final String? path = await _audioRecorder.stop();
    final String targetPath = path ?? _currentRecordingPath ?? '';

    if (mounted) {
      setState(() {
        _isRecording = false;
      });
    }

    if (recordedSecs < 1) {
      if (mounted) {
        showSnackBar(
          message: "Recording too short. Hold or tap to record.",
          type: SnackBarType.None,
        );
      }
      return;
    }

    if (targetPath.isNotEmpty && File(targetPath).existsSync()) {
      if (mounted) {
        setState(() {
          _recordedAudioPath = targetPath;
          _playbackPosition = Duration.zero;
          _playbackDuration = Duration(seconds: recordedSecs);
        });
      }

      try {
        await _audioPlayer.setSource(DeviceFileSource(targetPath));
        final Duration? duration = await _audioPlayer.getDuration();
        if (duration != null && duration.inSeconds > 0 && mounted) {
          setState(() {
            _playbackDuration = duration;
          });
        }
      } catch (_) {}

      _transcribeInBackground(targetPath);
    }
  }

  Future<void> _transcribeInBackground(String audioPath) async {
    if (mounted) {
      setState(() {
        _isTranscribing = true;
      });
    }
    try {
      final File file = File(audioPath);
      if (await file.exists()) {
        final ApiResultStatus result = await AiRepo.instance
            .transcribeAudio(file: file)
            .timeout(const Duration(seconds: 10));
        result.whenOrNull(
          data: (dynamic data) {
            final TranscribeModel model = TranscribeModel.fromJson(data);
            final String? recognized = model.text?.trim();
            if (recognized != null && recognized.isNotEmpty && mounted) {
              final String current = _textController.text.trim();
              final String combined = current.isEmpty
                  ? recognized
                  : '$current $recognized';
              _textController.text = combined;
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: combined.length),
              );
              context.read<TodayCubit>().setQuickNoteText(combined);
            }
          },
        );
      }
    } catch (_) {
      // Background transcription failure does not affect audio saving
    } finally {
      if (mounted) {
        setState(() {
          _isTranscribing = false;
        });
      }
    }
  }

  Future<void> _togglePlayback() async {
    if (_recordedAudioPath == null) return;
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));
      }
    } catch (_) {
      if (mounted) {
        showSnackBar(
          message: "Could not play audio file.",
          type: SnackBarType.ERROR,
        );
      }
    }
  }

  Future<void> _seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (_) {}
  }

  Future<void> _confirmDeleteVoiceNote() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    }
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFD84315),
                    size: 28.sp,
                  ),
                ),
                18.spaceH,
                "Delete voice note?".appText(
                  fontSize: 22.sp,
                  color: greyColor9,
                  fraunces: true,
                ),
                10.spaceH,
                "Are you sure you want to delete this voice note? You will be able to record a new one."
                    .appText(
                      fontSize: 14.sp,
                      color: greyColor,
                      height: 1.4,
                      textAlign: TextAlign.center,
                    ),
                24.spaceH,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 48.h,
                        padding: EdgeInsets.zero,
                        title: 'Cancel',
                        backgroundColor: const Color(0xFFF8F5F2),
                        borderColor: const Color(0xFFE9E2DC),
                        textColor: greyColor9,
                        onTap: () => Navigator.pop(dialogContext),
                      ),
                    ),
                    12.spaceW,
                    Expanded(
                      child: AppButton(
                        height: 48.h,
                        padding: EdgeInsets.zero,
                        title: 'Delete',
                        backgroundColor: const Color(0xFFE53935),
                        borderColor: const Color(0xFFE53935),
                        textColor: Colors.white,
                        onTap: () async {
                          Navigator.pop(dialogContext);
                          await _deleteRecording();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteRecording() async {
    try {
      await _audioPlayer.stop();
      if (_recordedAudioPath != null) {
        final File file = File(_recordedAudioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _recordedAudioPath = null;
        _isPlaying = false;
        _playbackPosition = Duration.zero;
        _playbackDuration = Duration.zero;
        _recordElapsedSeconds = 0;
      });
    }
  }

  Widget _buildAudioRecorderSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            onTap: () {
              if (_isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: _isRecording ? primaryColor : indigoLight,
                shape: BoxShape.circle,
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.4),
                          blurRadius: 14.r,
                          spreadRadius: 3.r,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: _isRecording ? Colors.white : secondaryColor,
                size: 32.sp,
              ),
            ),
          ),
          10.spaceH,
          if (_isRecording) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                6.spaceW,
                _formatDuration(
                  Duration(seconds: _recordElapsedSeconds),
                ).appText(
                  color: primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            4.spaceH,
            "Tap or release to finish".appText(
              color: primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ] else ...[
            "Tap or hold to record voice note".appText(
              color: greyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioPlayerCard() {
    final double maxMs = _playbackDuration.inMilliseconds > 0
        ? _playbackDuration.inMilliseconds.toDouble()
        : 1.0;
    final double currentMs = _playbackPosition.inMilliseconds.toDouble().clamp(
      0.0,
      maxMs,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7FC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: secondaryColor.withValues(alpha: 0.25),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
              ),
              12.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Voice note".appText(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: darkBlue,
                        ),
                        "${_formatDuration(_playbackPosition)} / ${_formatDuration(_playbackDuration)}"
                            .appText(
                              fontSize: 11.sp,
                              color: greyColor4,
                              fontWeight: FontWeight.w500,
                            ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3.h,
                        activeTrackColor: secondaryColor,
                        inactiveTrackColor: greyColor7,
                        thumbColor: secondaryColor,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.r,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12.r,
                        ),
                      ),
                      child: Slider(
                        value: currentMs,
                        min: 0.0,
                        max: maxMs,
                        onChanged: (double val) {
                          _seekAudio(Duration(milliseconds: val.toInt()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              6.spaceW,
              GestureDetector(
                onTap: _confirmDeleteVoiceNote,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          if (_isTranscribing) ...[
            6.spaceH,
            Row(
              children: [
                const AppLoadingIndicator(
                  centered: false,
                  size: 14,
                  color: secondaryColor,
                ),
                8.spaceW,
                "Transcribing audio to text...".appText(
                  fontSize: 11.sp,
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayCubit, TodayState>(
      listener: (BuildContext context, TodayState state) {
        state.saveStatus.whenOrNull(
          data: (_) {
            Navigator.pop(context);
            showSnackBar(
              message: LocaleKeys.noteSaved.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, TodayState state) {
        final bool hasAudio =
            _recordedAudioPath != null && _recordedAudioPath!.isNotEmpty;
        final bool hasText = _textController.text.trim().isNotEmpty;
        final bool isError =
            state.showNotesUpdateErrors && !hasText && !hasAudio;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: greyColor7,
                      ),
                    ),
                  ],
                ),
                12.spaceH,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: "Quick note".appText(
                        fontSize: 28.sp,
                        fraunces: true,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (isError) ...[
                      8.spaceW,
                      Icon(Icons.error, color: Colors.red, size: 24.sp),
                    ],
                  ],
                ),
                24.spaceH,
                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isError ? Colors.red : greyColor12,
                    ),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    onChanged: (String val) =>
                        context.read<TodayCubit>().setQuickNoteText(val),
                    decoration: InputDecoration(
                      hintText: "Anything you want to remember about today...",
                      hintStyle: getTextStyle(
                        fontSize: 16.sp,
                        color: greyColor4,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: greyColor9,
                    ),
                  ),
                ),
                24.spaceH,
                if (hasAudio)
                  _buildAudioPlayerCard()
                else
                  _buildAudioRecorderSection(),
                32.spaceH,
                AppButton(
                  isLoading: state.isLoading,
                  title: "Save note",
                  onTap: () async {
                    final String text = _textController.text.trim();
                    final bool hasTypedText = text.isNotEmpty;
                    final bool hasAttachedAudio =
                        _recordedAudioPath != null &&
                        _recordedAudioPath!.isNotEmpty;

                    if (!hasTypedText && !hasAttachedAudio) {
                      context.read<TodayCubit>().triggerNotesUpdateErrors();
                      showSnackBar(
                        message: "Please write a note or record audio first.",
                        type: SnackBarType.None,
                      );
                      return;
                    }

                    final TodayCubit cubit = context.read<TodayCubit>();

                    if (_isPlaying) {
                      await _audioPlayer.stop();
                    }

                    if (!mounted) return;

                    if (hasTypedText) {
                      cubit.setQuickNoteText(text);
                    }

                    final int durationSec = _playbackDuration.inSeconds > 0
                        ? _playbackDuration.inSeconds
                        : _recordElapsedSeconds;

                    await cubit.saveQuickNote(
                      audioLocalPath: hasAttachedAudio
                          ? _recordedAudioPath
                          : null,
                      audioDurationSeconds: hasAttachedAudio
                          ? durationSec
                          : null,
                    );
                  },
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                ),
                24.spaceH,
              ],
            ).appPadding(all: 16.r),
          ),
        );
      },
    );
  }
}
