import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/brainy_ai/bloc/brainy_voice_cubit.dart';
import 'package:loving_brain/ui/brainy_ai/bloc/brainy_voice_state.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class BrainyVoiceSheet extends StatefulWidget {
  const BrainyVoiceSheet({
    super.key,
    this.topic,
    this.actionButtonTitle,
    this.addsToMessage = false,
    this.onSendAudio,
  });

  final String? topic;
  final String? actionButtonTitle;

  /// Chat composer keeps the note above the message box. Home sends it.
  final bool addsToMessage;
  final void Function(
    File? audioFile,
    String transcriptText,
    Duration recordedDuration,
  )?
  onSendAudio;

  @override
  State<BrainyVoiceSheet> createState() => _BrainyVoiceSheetState();
}

class _BrainyVoiceSheetState extends State<BrainyVoiceSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrainyVoiceCubit>().init(topic: widget.topic);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrainyVoiceCubit, BrainyVoiceState>(
      listenWhen: (BrainyVoiceState previous, BrainyVoiceState next) {
        return previous.isRecording != next.isRecording;
      },
      listener: (BuildContext context, BrainyVoiceState state) {
        if (state.isRecording) {
          _controller.repeat(reverse: true);
        } else {
          _controller.stop();
        }
      },
      builder: (BuildContext context, BrainyVoiceState state) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.spaceH,
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: greyColor4,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              40.spaceH,
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFAF9FF),
                ),
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF4F3FF),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFECEAFF),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      state.awaitingConfirm
                          ? Icons.check_rounded
                          : (state.isProcessing
                                ? Icons.hourglass_top_rounded
                                : Icons.mic_rounded),
                      color: secondaryColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
              32.spaceH,
              SizedBox(
                height: 90.h,
                child: Center(child: _buildRecorderVisual(state)),
              ),
              40.spaceH,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: _headline(state).appText(
                  fontSize: 24.sp,
                  fraunces: true,
                  textAlign: TextAlign.center,
                ),
              ),
              12.spaceH,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: _subtitle(state).appText(
                  fontSize: 14.sp,
                  color: greyColor6,
                  textAlign: TextAlign.center,
                  height: 1.4,
                ),
              ),
              40.spaceH,
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 40.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: 'Cancel',
                        onTap: () async {
                          await context
                              .read<BrainyVoiceCubit>()
                              .cancelRecording();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        backgroundColor: Colors.white,
                        textColor: greyColor9,
                        padding: EdgeInsetsGeometry.zero,
                        height: 48,
                        borderColor: const Color(0xFFE8E8E8),
                      ),
                    ),
                    16.spaceW,
                    Expanded(
                      child: AppButton(
                        height: 48,
                        title: _primaryTitle(state),
                        onTap: state.isProcessing || state.recordingFailed
                            ? null
                            : () async {
                                final BrainyVoiceCubit cubit = context
                                    .read<BrainyVoiceCubit>();

                                if (!state.awaitingConfirm) {
                                  final (File? file, String text) = await cubit
                                      .stopAndPrepareTranscript();
                                  if (!context.mounted) return;
                                  if ((file == null || !await file.exists()) &&
                                      text.trim().isEmpty) {
                                    showSnackBar(
                                      message:
                                          'No audio was recorded. Please speak and try again.',
                                      type: SnackBarType.ERROR,
                                    );
                                    return;
                                  }
                                  if (widget.addsToMessage) {
                                    final Duration recordedDuration = Duration(
                                      seconds: cubit.state.elapsedSeconds,
                                    );
                                    Navigator.of(context).pop();
                                    widget.onSendAudio?.call(
                                      file,
                                      text,
                                      recordedDuration,
                                    );
                                  }
                                  return;
                                }

                                final NavigatorState navigator = Navigator.of(
                                  context,
                                );
                                final (File? file, String text) = cubit
                                    .confirmPreparedNote();
                                if ((file == null || !await file.exists()) &&
                                    text.trim().isEmpty) {
                                  showSnackBar(
                                    message:
                                        'No audio was recorded. Please speak and try again.',
                                    type: SnackBarType.ERROR,
                                  );
                                  return;
                                }

                                if (!context.mounted) return;
                                navigator.pop();
                                if (widget.onSendAudio != null) {
                                  widget.onSendAudio!(
                                    file,
                                    text,
                                    Duration(
                                      seconds: cubit.state.elapsedSeconds,
                                    ),
                                  );
                                } else {
                                  context.push(
                                    RoutePaths.brainyConversation,
                                    extra: <String, dynamic>{
                                      'initialChat': text,
                                      'initialAudioFile': file,
                                      'topic': widget.topic,
                                    },
                                  );
                                }
                              },
                        backgroundColor: secondaryColor,
                        textColor: Colors.white,
                        padding: EdgeInsetsGeometry.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecorderVisual(BrainyVoiceState state) {
    if (state.isRecording) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildEqBar(16.0 + _random.nextDouble() * 10),
              _buildEqBar(24.0 + _random.nextDouble() * 20),
              _buildEqBar(32.0 + _random.nextDouble() * 30),
              _buildEqBar(48.0 + _random.nextDouble() * 40),
              _buildEqBar(32.0 + _random.nextDouble() * 30),
              _buildEqBar(24.0 + _random.nextDouble() * 20),
              _buildEqBar(16.0 + _random.nextDouble() * 10),
            ],
          );
        },
      );
    }

    if (state.awaitingConfirm) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F3FF),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: secondaryColor.withValues(alpha: 0.28),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.graphic_eq_rounded, color: secondaryColor, size: 18.sp),
            8.spaceW,
            _clock(state.elapsedSeconds).appText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: secondaryColor,
              letterSpacing: 0.2,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _headline(BrainyVoiceState state) {
    if (state.recordingFailed) return 'Microphone unavailable';
    if (state.isProcessing) return 'Saving your note';
    if (state.awaitingConfirm) {
      if (state.previewText.trim().isNotEmpty) {
        return '"${state.previewText.trim()}"';
      }
      return 'Voice note ready';
    }
    return _clock(state.elapsedSeconds);
  }

  String _subtitle(BrainyVoiceState state) {
    if (state.recordingFailed) {
      return 'You can still type your message.';
    }
    if (state.isProcessing) {
      return 'Writing down what you said.';
    }
    if (state.awaitingConfirm) {
      if (widget.addsToMessage) {
        return 'Add it to your message. You can play it above the box, then send.';
      }
      return 'Send this note to Brainy when it looks right.';
    }
    return 'Recording. Tap Done when you finish speaking.';
  }

  String _primaryTitle(BrainyVoiceState state) {
    if (state.isProcessing) return 'Saving...';
    if (!state.awaitingConfirm) return 'Done';
    final String custom = (widget.actionButtonTitle ?? '').trim();
    if (custom.isNotEmpty) return custom;
    return widget.addsToMessage ? 'Add to message' : 'Send';
  }

  String _clock(int totalSeconds) {
    final int safe = totalSeconds < 0 ? 0 : totalSeconds;
    final int minutes = safe ~/ 60;
    final int seconds = safe % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildEqBar(double height) {
    return Container(
      width: 6.w,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
