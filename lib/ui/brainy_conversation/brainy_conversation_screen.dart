import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/core/emergency_detector.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/permission_helper.dart';
import 'package:loving_brain/ui/brainy_ai/sheets/brainy_voice_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/brainy_conversation_cubit.dart';
import 'bloc/brainy_conversation_state.dart';

class BrainyConversationScreen extends StatefulWidget {
  const BrainyConversationScreen({
    super.key,
    this.conversationId,
    this.initialChat,
    this.initialAudioFile,
    this.initialImagePaths,
    this.topic,
    this.attachedContext,
  });

  final String? conversationId;
  final String? initialChat;
  final File? initialAudioFile;
  final List<String>? initialImagePaths;
  final String? topic;
  final String? attachedContext;

  @override
  State<BrainyConversationScreen> createState() =>
      _BrainyConversationScreenState();
}

class _BrainyConversationScreenState extends State<BrainyConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  late BrainyConversationCubit _cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = context.read<BrainyConversationCubit>();
  }

  void _clearDraft() {
    _controller.clear();
    _cubit.clearDraft();
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    _clearDraft();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrainyConversationCubit>().init(
        conversationId: widget.conversationId,
        initialChat: widget.initialChat,
        initialAudioFile: widget.initialAudioFile,
        topic: widget.topic,
        attachedContext: widget.attachedContext,
      );
      if (widget.initialImagePaths != null &&
          widget.initialImagePaths!.isNotEmpty) {
        context.read<BrainyConversationCubit>().addSelectedImages(
          widget.initialImagePaths!,
        );
      }
    });
  }

  @override
  void dispose() {
    _clearDraft();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourcePicker(BuildContext context) async {
    final BrainyConversationCubit cubit = context
        .read<BrainyConversationCubit>();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: greyColor4,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  16.spaceH,
                  "Attach Photos".appText(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                    fraunces: true,
                    textAlign: TextAlign.start,
                  ),
                  4.spaceH,
                  "Take a new photo or choose from your gallery".appText(
                    fontSize: 13.sp,
                    color: greyColor6,
                    textAlign: TextAlign.start,
                  ),
                  20.spaceH,
                  InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      try {
                        final XFile? picked = await _imagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          cubit.addSelectedImages(<String>[picked.path]);
                        }
                      } catch (_) {}
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF9FD),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFECEBFA)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEEBFF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: secondaryColor,
                              size: 22.sp,
                            ),
                          ),
                          14.spaceW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Camera".appText(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlue,
                                  textAlign: TextAlign.start,
                                ),
                                2.spaceH,
                                "Take a new photo using your camera".appText(
                                  fontSize: 12.sp,
                                  color: greyColor6,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: greyColor4,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.spaceH,
                  InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      try {
                        final List<XFile> pickedList = await _imagePicker
                            .pickMultiImage(imageQuality: 80);
                        if (pickedList.isNotEmpty) {
                          final List<String> paths = pickedList
                              .map((XFile e) => e.path)
                              .toList();
                          cubit.addSelectedImages(paths);
                        }
                      } catch (_) {}
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF9FD),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFECEBFA)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF2EE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo_library_rounded,
                              color: primaryColor,
                              size: 22.sp,
                            ),
                          ),
                          14.spaceW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Gallery".appText(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: darkBlue,
                                  textAlign: TextAlign.start,
                                ),
                                2.spaceH,
                                "Select one or multiple photos from gallery"
                                    .appText(
                                      fontSize: 12.sp,
                                      color: greyColor6,
                                      textAlign: TextAlign.start,
                                    ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: greyColor4,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatAudioDuration(Duration d) {
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPlaybackClock(Duration position, Duration total) {
    return '${_formatAudioDuration(position)} / ${_formatAudioDuration(total)}';
  }

  double _attachedSliderMax(BrainyConversationState state) {
    final int totalMs = state.attachedAudioDuration.inMilliseconds;
    return totalMs > 0 ? totalMs.toDouble() : 1;
  }

  double _attachedSliderValue(BrainyConversationState state) {
    final int totalMs = state.attachedAudioDuration.inMilliseconds;
    if (totalMs <= 0) return 0;
    final int positionMs = state.attachedAudioPosition.inMilliseconds;
    return positionMs.clamp(0, totalMs).toDouble();
  }

  Future<void> _confirmDeleteVoiceNote() async {
    final BrainyConversationCubit cubit = context
        .read<BrainyConversationCubit>();
    if (cubit.state.isAttachedAudioPlaying) {
      await cubit.togglePlayAttachedAudio();
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
                    color: const Color(0xFFD84315),
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
                          await cubit.removeAttachedAudio();
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrainyConversationCubit, BrainyConversationState>(
      listenWhen:
          (BrainyConversationState previous, BrainyConversationState current) {
            return previous.messages.length != current.messages.length ||
                previous.isTyping != current.isTyping ||
                previous.pendingSafetyMode != current.pendingSafetyMode;
          },
      listener: (BuildContext context, BrainyConversationState state) {
        _scrollToBottom();
        final String? pendingMode = state.pendingSafetyMode;
        if (pendingMode != null && pendingMode.isNotEmpty) {
          final String? sourceMessage = state.pendingSafetySourceMessage;
          context
              .read<BrainyConversationCubit>()
              .clearPendingSafetyNavigation();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.push(
              RoutePaths.safetyConcern,
              extra: <String, dynamic>{
                'mode': pendingMode,
                'sourceMessage': sourceMessage,
              },
            );
          });
        }
      },
      builder: (BuildContext context, BrainyConversationState state) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              _clearDraft();
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                          const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24.r),
                                onTap: _onBack,
                                child: Padding(
                                  padding: EdgeInsets.all(8.r),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: darkBlue,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          itemCount:
                              state.messages.length + (state.isTyping ? 1 : 0),
                          separatorBuilder: (_, _) => 16.spaceH,
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return _buildTypingIndicator();
                            }
                            final BrainyMessage msg = state.messages[index];
                            return _buildMessageCardFromData(
                              context,
                              state,
                              msg,
                              index,
                            );
                          },
                        ),
                      ),
                      // Multiple images preview thumbnails
                      if (state.selectedImagePaths.isNotEmpty)
                        Container(
                          height: 72.h,
                          margin: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            bottom: 4.h,
                          ),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.selectedImagePaths.length,
                            separatorBuilder:
                                (BuildContext context, int index) => 10.spaceW,
                            itemBuilder: (BuildContext _, int imgIdx) {
                              final String imagePath =
                                  state.selectedImagePaths[imgIdx];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Image.file(
                                      File(imagePath),
                                      height: 72.h,
                                      width: 72.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4.r,
                                    top: 4.r,
                                    child: GestureDetector(
                                      onTap: () => context
                                          .read<BrainyConversationCubit>()
                                          .removeSelectedImageAt(imgIdx),
                                      child: Container(
                                        padding: EdgeInsets.all(4.r),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 13.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      // Attached audio note preview widget
                      if (state.attachedAudioPath != null &&
                          state.attachedAudioPath!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            bottom: 4.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F6FE),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: const Color(0xFFE9E3FC),
                              width: 1.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => context
                                    .read<BrainyConversationCubit>()
                                    .togglePlayAttachedAudio(),
                                child: Container(
                                  width: 38.w,
                                  height: 38.w,
                                  decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    state.isAttachedAudioPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                              12.spaceW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Voice note".appText(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: darkBlue,
                                        ),
                                        _formatPlaybackClock(
                                          state.attachedAudioPosition,
                                          state.attachedAudioDuration,
                                        ).appText(
                                          fontSize: 12.sp,
                                          color: darkBlue,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                        ),
                                      ],
                                    ),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 4.h,
                                        thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6.r,
                                        ),
                                        overlayShape:
                                            SliderComponentShape.noOverlay,
                                        activeTrackColor: secondaryColor,
                                        inactiveTrackColor: const Color(
                                          0xFFE2DCF8,
                                        ),
                                        thumbColor: secondaryColor,
                                        disabledActiveTrackColor: const Color(
                                          0xFFE2DCF8,
                                        ),
                                        disabledInactiveTrackColor: const Color(
                                          0xFFE2DCF8,
                                        ),
                                        disabledThumbColor: const Color(
                                          0xFFD9D3F5,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _attachedSliderValue(state),
                                        max: _attachedSliderMax(state),
                                        onChanged:
                                            state
                                                    .attachedAudioDuration
                                                    .inMilliseconds >
                                                0
                                            ? (double value) {
                                                context
                                                    .read<
                                                      BrainyConversationCubit
                                                    >()
                                                    .seekAttachedAudio(
                                                      Duration(
                                                        milliseconds: value
                                                            .round(),
                                                      ),
                                                    );
                                              }
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              8.spaceW,
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: 32.w,
                                  minHeight: 32.w,
                                ),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: redColor,
                                  size: 20.sp,
                                ),
                                onPressed: _confirmDeleteVoiceNote,
                              ),
                            ],
                          ),
                        ),

                      Builder(
                        builder: (BuildContext composerCtx) {
                          final bool isKeyboardOpen =
                              MediaQuery.of(composerCtx).viewInsets.bottom > 0;
                          final double bottomPadding = isKeyboardOpen
                              ? 8.h
                              : (12.h +
                                    MediaQuery.of(composerCtx).padding.bottom);
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              top: 4.h,
                              bottom: bottomPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _controller,
                                    hint: "Ask Brainy...",
                                    tfType: TFTYPE.FILLED,
                                    filled: true,
                                    fillColor: Colors.white,
                                    borderRadius: BorderRadius.circular(27.r),
                                    height: 54.h,
                                    maxLines: 4,
                                    minLines: 1,
                                    textAlignVertical: TextAlignVertical.center,
                                    rowCrossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(500),
                                    ],
                                    contentPadding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 6.w,
                                      top: 0,
                                      bottom: 0,
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(
                                            minWidth: 32.w,
                                            minHeight: 32.w,
                                          ),
                                          onPressed: () =>
                                              _showImageSourcePicker(context),
                                          icon: Icon(
                                            Icons.image_outlined,
                                            color: greyColor4,
                                            size: 20.sp,
                                          ),
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(
                                            minWidth: 32.w,
                                            minHeight: 32.w,
                                          ),
                                          onPressed: () async {
                                            final bool granted =
                                                await PermissionHelper.ensureMicrophonePermission(
                                                  context,
                                                );
                                            if (!granted || !context.mounted) {
                                              return;
                                            }

                                            final BrainyConversationCubit
                                            cubit = context
                                                .read<
                                                  BrainyConversationCubit
                                                >();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) => BrainyVoiceSheet(
                                                topic: state.topic,
                                                addsToMessage: true,
                                                onSendAudio:
                                                    (
                                                      File? audioFile,
                                                      String text,
                                                      Duration recordedDuration,
                                                    ) {
                                                      if (audioFile != null) {
                                                        cubit.attachAudio(
                                                          audioFile.path,
                                                          knownDuration:
                                                              recordedDuration,
                                                        );
                                                      }
                                                      if (text
                                                              .trim()
                                                              .isNotEmpty &&
                                                          _controller.text
                                                              .trim()
                                                              .isEmpty) {
                                                        _controller.text = text
                                                            .trim();
                                                      }
                                                    },
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.mic_none_rounded,
                                            color: greyColor4,
                                            size: 20.sp,
                                          ),
                                        ),
                                        6.spaceW,
                                      ],
                                    ),
                                    onSubmitted: (val) {
                                      context
                                          .read<BrainyConversationCubit>()
                                          .sendMessage(val);
                                      _controller.clear();
                                      _scrollToBottom();
                                    },
                                  ),
                                ),
                                12.spaceW,
                                Material(
                                  color: Colors.transparent,
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      color: secondaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(27.r),
                                      onTap: () {
                                        context
                                            .read<BrainyConversationCubit>()
                                            .sendMessage(_controller.text);
                                        _controller.clear();
                                        _scrollToBottom();
                                      },
                                      child: SizedBox(
                                        width: 54.h,
                                        height: 54.h,
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageCardFromData(
    BuildContext context,
    BrainyConversationState state,
    BrainyMessage msg,
    int index,
  ) {
    IconData icon;
    Color chipColor;
    Color chipBgColor;
    Color? chipBorderColor;

    switch (msg.type) {
      case MessageType.user:
        icon = Icons.stars;
        chipColor = primaryColor;
        chipBgColor = orangeLightColor;
        chipBorderColor = null;
        break;
      case MessageType.aiInfo:
        if (msg.chipTitle.toLowerCase().contains('when to get help')) {
          icon = Icons.health_and_safety_outlined;
          chipColor = const Color(0xFF665FCE);
          chipBgColor = const Color(0xFFF3F2FE);
          chipBorderColor = const Color(0xFF665FCE).withValues(alpha: 0.22);
        } else {
          icon = Icons.info;
          chipColor = primaryColor;
          chipBgColor = orangeLightColor;
          chipBorderColor = primaryColor.withValues(alpha: 0.18);
        }
        break;
      case MessageType.aiAction:
        icon = Icons.stars_rounded;
        chipColor = const Color(0xFF3D348C);
        chipBgColor = const Color(0xFFE4DEFF);
        chipBorderColor = const Color(0xFF665FCE).withValues(alpha: 0.45);
        break;
      case MessageType.safetyAlert:
        icon = Icons.warning_amber_rounded;
        chipColor = const Color(0xFFD32F2F);
        chipBgColor = const Color(0xFFFFEBEE);
        chipBorderColor = const Color(0xFFD32F2F).withValues(alpha: 0.22);
        break;
      case MessageType.clinicalConcern:
        icon = Icons.medical_services_outlined;
        chipColor = const Color(0xFFB45309);
        chipBgColor = const Color(0xFFFFF7ED);
        chipBorderColor = const Color(0xFFB45309).withValues(alpha: 0.22);
        break;
      case MessageType.error:
        icon = Icons.refresh_rounded;
        chipColor = const Color(0xFFD97706);
        chipBgColor = const Color(0xFFFEF3C7);
        chipBorderColor = const Color(0xFFD97706).withValues(alpha: 0.28);
        break;
    }

    return _buildMessageCard(
      context: context,
      state: state,
      msg: msg,
      index: index,
      chipTitle: msg.chipTitle,
      icon: icon,
      chipColor: chipColor,
      chipBgColor: chipBgColor,
      chipBorderColor: chipBorderColor,
      chipFontWeight: msg.type == MessageType.aiAction
          ? FontWeight.w700
          : FontWeight.w600,
      headline: msg.headline,
      subtext: msg.subtext,
    );
  }

  Widget _buildTypingIndicator() {
    return const _BrainyThinkingIndicator();
  }

  Widget _buildMessageCard({
    required BuildContext context,
    required BrainyConversationState state,
    required BrainyMessage msg,
    required int index,
    required String chipTitle,
    required IconData icon,
    required Color chipColor,
    required Color chipBgColor,
    required Color? chipBorderColor,
    required FontWeight chipFontWeight,
    required String headline,
    String? subtext,
  }) {
    final List<String> localImages = msg.imageLocalPaths.isNotEmpty
        ? msg.imageLocalPaths
              .where((String p) => p.isNotEmpty && File(p).existsSync())
              .toList()
        : (msg.imageLocalPath != null &&
                  msg.imageLocalPath!.isNotEmpty &&
                  File(msg.imageLocalPath!).existsSync()
              ? <String>[msg.imageLocalPath!]
              : <String>[]);
    final List<String> networkImages = msg.imageNetworkPaths.isNotEmpty
        ? msg.imageNetworkPaths.where((String p) => p.isNotEmpty).toList()
        : (msg.imageNetworkPath != null && msg.imageNetworkPath!.isNotEmpty
              ? <String>[msg.imageNetworkPath!]
              : <String>[]);
    final bool hasImages = localImages.isNotEmpty || networkImages.isNotEmpty;
    final bool hasAudio =
        (msg.audioLocalPath != null && msg.audioLocalPath!.isNotEmpty) ||
        (msg.audioNetworkPath != null && msg.audioNetworkPath!.isNotEmpty);
    final String msgKey = msg.id ?? msg.headline;
    final bool isPlayingThis =
        state.playingMessageId == msgKey && state.isAudioPlaying;

    final bool isUser = msg.type == MessageType.user;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? 24.r : 4.r),
          topRight: Radius.circular(isUser ? 4.r : 24.r),
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: InfoChip(
                  chipTitle: chipTitle,
                  iconData: icon,
                  color: chipColor,
                  bgColor: chipBgColor,
                  borderColor: chipBorderColor,
                  fontWeight: chipFontWeight,
                  letterSpacing: 0.15,
                ),
              ),
              if (msg.type != MessageType.user &&
                  msg.type != MessageType.safetyAlert &&
                  msg.type != MessageType.clinicalConcern &&
                  msg.type != MessageType.error)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context
                      .read<BrainyConversationCubit>()
                      .toggleSaveGuidance(msg, index),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      msg.isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: msg.isSaved ? primaryColor : greyColor4,
                      size: 20.sp,
                    ),
                  ),
                ),
            ],
          ),
          16.spaceH,
          if (hasImages) ...[
            if (localImages.length == 1)
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(
                  File(localImages.first),
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (networkImages.length == 1 && localImages.isEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  networkImages.first,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              SizedBox(
                height: 110.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: localImages.isNotEmpty
                      ? localImages.length
                      : networkImages.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      8.spaceW,
                  itemBuilder: (BuildContext _, int imgIdx) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: localImages.isNotEmpty
                          ? Image.file(
                              File(localImages[imgIdx]),
                              height: 110.h,
                              width: 110.h,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              networkImages[imgIdx],
                              height: 110.h,
                              width: 110.h,
                              fit: BoxFit.cover,
                            ),
                    );
                  },
                ),
              ),
            12.spaceH,
          ],
          if (hasAudio) ...[
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  context.read<BrainyConversationCubit>().togglePlayAudio(msg),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: orangeLightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPlayingThis
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: primaryColor,
                      size: 22.sp,
                    ),
                    8.spaceW,
                    (isPlayingThis
                            ? "Playing voice note..."
                            : "Play voice note")
                        .appText(
                          fontSize: 12.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ],
                ),
              ),
            ),
            12.spaceH,
          ],
          headline.appText(
            fontSize: 22.sp,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          if (subtext != null && subtext.isNotEmpty) ...[
            12.spaceH,
            subtext.appText(
              fontSize: 14.sp,
              color: greyColor,
              textAlign: TextAlign.start,
              height: 1.4,
            ),
          ],
          if (msg.type == MessageType.safetyAlert) ...[
            20.spaceH,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                icon: Icon(Icons.phone_in_talk_rounded, size: 20.sp),
                label:
                    "Call emergency services (${EmergencyDetector.getEmergencyDisplayNumber()})"
                        .appText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                onPressed: () async {
                  final Uri uri = Uri.parse(
                    EmergencyDetector.getEmergencyPhone(),
                  );
                  try {
                    await launchUrl(uri);
                  } catch (_) {}
                },
              ),
            ),
            10.spaceH,
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: "Read safety information".appText(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD32F2F),
                ),
                onPressed: () {
                  context.push(RoutePaths.helpSafety);
                },
              ),
            ),
            10.spaceH,
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: "Not now — stay in chat".appText(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: greyColor9,
              ),
            ),
          ],
          if (msg.type == MessageType.clinicalConcern) ...[
            20.spaceH,
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB45309), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: "Read safety information".appText(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB45309),
                ),
                onPressed: () {
                  context.push(RoutePaths.helpSafety);
                },
              ),
            ),
            10.spaceH,
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: "Not now — stay in chat".appText(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: greyColor9,
              ),
            ),
          ],
          if (msg.type == MessageType.error) ...[
            18.spaceH,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                title: "Try again",
                backgroundColor: primaryColor,
                textColor: Colors.white,
                onTap: () {
                  context.read<BrainyConversationCubit>().retryLastMessage();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrainyThinkingIndicator extends StatefulWidget {
  const _BrainyThinkingIndicator();

  @override
  State<_BrainyThinkingIndicator> createState() =>
      _BrainyThinkingIndicatorState();
}

class _BrainyThinkingIndicatorState extends State<_BrainyThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    final double phase = (_controller.value * 2 * math.pi) - (index * 0.65);
    final double offset = math.sin(phase) * 3.5;
    final double opacity = (0.45 + 0.55 * ((math.sin(phase) + 1) / 2)).clamp(
      0.0,
      1.0,
    );
    return Transform.translate(
      offset: Offset(0, -offset.clamp(-3.5, 3.5)),
      child: Container(
        width: 7.w,
        height: 7.w,
        margin: EdgeInsets.symmetric(horizontal: 2.5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(
            secondaryColor,
            primaryColor,
            index / 2,
          )!.withValues(alpha: opacity),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.r),
          topRight: Radius.circular(24.r),
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        border: Border.all(color: const Color(0xFFF3ECE7), width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double pulse =
              0.92 + 0.08 * math.sin(_controller.value * 2 * math.pi);
          return Row(
            children: <Widget>[
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFFFFEDE6), Color(0xFFECEAFF)],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: secondaryColor.withValues(alpha: 0.18),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: secondaryColor,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
              14.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: "Looking at the last two weeks…".appText(
                            fontSize: 15.sp,
                            color: greyColor9,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        6.spaceW,
                        _buildDot(0),
                        _buildDot(1),
                        _buildDot(2),
                      ],
                    ),
                    3.spaceH,
                    "Crafting a thoughtful response for you".appText(
                      fontSize: 12.sp,
                      color: greyColor,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
