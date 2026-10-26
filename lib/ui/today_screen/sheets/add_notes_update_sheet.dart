import 'dart:io';

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
import 'package:loving_brain/ui/microphone_permission/microphone_permission_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
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
  bool _isRecording = false;
  bool _isTranscribing = false;
  String? _recordingPath;
  DateTime? _recordingStartTime;

  @override
  void initState() {
    super.initState();
    final String initialText = context.read<TodayCubit>().state.quickNoteText;
    _textController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isRecording || _isTranscribing) return;
    try {
      final bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          await Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext _) => const MicrophonePermissionScreen(),
            ),
          );
        }
        return;
      }

      final Directory dir = await getTemporaryDirectory();
      final String path =
          '${dir.path}/quick_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _recordingPath = path;
      _recordingStartTime = DateTime.now();

      await _audioRecorder.start(const RecordConfig(), path: path);
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

  Future<void> _stopRecordingAndTranscribe() async {
    if (!_isRecording) return;
    try {
      final DateTime? startTime = _recordingStartTime;
      final int elapsedMs = startTime != null
          ? DateTime.now().difference(startTime).inMilliseconds
          : 0;

      final String? path = await _audioRecorder.stop();
      if (mounted) {
        setState(() {
          _isRecording = false;
          _isTranscribing = true;
        });
      }

      // Ignore accidental micro-taps (< 500ms)
      if (elapsedMs < 500) {
        if (mounted) {
          setState(() {
            _isTranscribing = false;
          });
        }
        return;
      }

      final String targetPath = path ?? _recordingPath ?? '';
      if (targetPath.isNotEmpty) {
        final File file = File(targetPath);
        if (await file.exists()) {
          final ApiResultStatus result = await AiRepo.instance
              .transcribeAudio(file: file)
              .timeout(const Duration(seconds: 15));
          result.whenOrNull(
            data: (dynamic data) {
              final TranscribeModel model = TranscribeModel.fromJson(data);
              final String? recognized = model.text?.trim();
              if (recognized != null && recognized.isNotEmpty) {
                final String current = _textController.text.trim();
                final String combined = current.isEmpty
                    ? recognized
                    : '$current $recognized';
                _textController.text = combined;
                _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: combined.length),
                );
                if (mounted) {
                  context.read<TodayCubit>().setQuickNoteText(combined);
                }
              }
            },
            error: (Exception _) {
              if (mounted) {
                showSnackBar(
                  message: "Could not transcribe audio. Please type your note.",
                  type: SnackBarType.ERROR,
                );
              }
            },
          );
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isTranscribing = false;
        });
      }
    }
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
        final bool isError =
            state.showNotesUpdateErrors && _textController.text.trim().isEmpty;

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
                32.spaceH,
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPressStart: (_) => _startRecording(),
                        onLongPressEnd: (_) => _stopRecordingAndTranscribe(),
                        onTap: () {
                          if (_isRecording) {
                            _stopRecordingAndTranscribe();
                          } else {
                            _startRecording();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: _isRecording ? primaryColor : indigoLight,
                            shape: BoxShape.circle,
                            boxShadow: _isRecording
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 12.r,
                                      spreadRadius: 2.r,
                                    ),
                                  ]
                                : null,
                          ),
                          child: _isTranscribing
                              ? SizedBox(
                                  width: 32.sp,
                                  height: 32.sp,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: secondaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.mic,
                                  color: _isRecording
                                      ? Colors.white
                                      : secondaryColor,
                                  size: 32.sp,
                                ),
                        ),
                      ),
                      8.spaceH,
                      (_isTranscribing
                              ? "Transcribing audio..."
                              : _isRecording
                              ? "Recording... (Release to finish)"
                              : "Hold to record")
                          .appText(
                            color: _isRecording ? primaryColor : greyColor,
                            fontSize: 12.sp,
                            fontWeight: _isRecording
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                    ],
                  ),
                ),
                32.spaceH,
                AppButton(
                  isLoading: state.isLoading,
                  title: "Save note",
                  onTap: () {
                    final String text = _textController.text.trim();
                    if (text.isEmpty) {
                      context.read<TodayCubit>().triggerNotesUpdateErrors();
                      showSnackBar(
                        message: "Please type or record a note first.",
                        type: SnackBarType.None,
                      );
                    } else {
                      context.read<TodayCubit>().setQuickNoteText(text);
                      context.read<TodayCubit>().saveQuickNote();
                    }
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
