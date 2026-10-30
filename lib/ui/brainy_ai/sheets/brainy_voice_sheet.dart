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
    this.onSendAudio,
  });

  final String? topic;
  final String? actionButtonTitle;
  final void Function(File? audioFile, String transcriptText)? onSendAudio;

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
    return BlocBuilder<BrainyVoiceCubit, BrainyVoiceState>(
      builder: (context, state) {
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
                    child: const Icon(
                      Icons.mic,
                      color: secondaryColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
              32.spaceH,
              // Animated equalizer (fixed height container so sheet doesn't jump)
              SizedBox(
                height: 90.h,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                  ),
                ),
              ),
              40.spaceH,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child:
                    (state.previewText.isNotEmpty
                            ? '"${state.previewText}"'
                            : (state.recordingFailed
                                  ? 'Microphone unavailable'
                                  : (state.awaitingConfirm
                                        ? 'Ready to send'
                                        : 'Listening...')))
                        .appText(
                          fontSize: 24.sp,
                          fraunces: true,
                          textAlign: TextAlign.center,
                        ),
              ),
              12.spaceH,
              (state.isProcessing
                      ? 'Processing your voice note...'
                      : (state.awaitingConfirm
                            ? 'Check the transcript, then send.'
                            : (state.recordingFailed
                                  ? 'Typed chat still works without the microphone.'
                                  : 'Listening... take your time.')))
                  .appText(
                    fontSize: 14.sp,
                    color: greyColor6,
                    textAlign: TextAlign.center,
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
                        title: state.isProcessing
                            ? 'Processing...'
                            : (state.awaitingConfirm
                                  ? (widget.actionButtonTitle ??
                                        (widget.onSendAudio != null
                                            ? 'Attach Note'
                                            : 'Send'))
                                  : 'Done'),
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
                                  widget.onSendAudio!(file, text);
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
