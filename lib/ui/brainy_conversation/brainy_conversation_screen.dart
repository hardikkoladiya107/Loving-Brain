import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/brainy_ai/sheets/brainy_voice_sheet.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import 'bloc/brainy_conversation_cubit.dart';
import 'bloc/brainy_conversation_state.dart';

class BrainyConversationScreen extends StatefulWidget {
  const BrainyConversationScreen({
    super.key,
    this.conversationId,
    this.initialChat,
    this.initialAudioFile,
    this.topic,
  });

  final String? conversationId;
  final String? initialChat;
  final File? initialAudioFile;
  final String? topic;

  @override
  State<BrainyConversationScreen> createState() =>
      _BrainyConversationScreenState();
}

class _BrainyConversationScreenState extends State<BrainyConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null && context.mounted) {
        context.read<BrainyConversationCubit>().selectImage(picked.path);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrainyConversationCubit()
        ..init(
          conversationId: widget.conversationId,
          initialChat: widget.initialChat,
          initialAudioFile: widget.initialAudioFile,
          topic: widget.topic,
        ),
      child: BlocConsumer<BrainyConversationCubit, BrainyConversationState>(
        listenWhen: (previous, current) =>
            previous.messages.length != current.messages.length ||
            previous.isTyping != current.isTyping,
        listener: (context, state) {
          _scrollToBottom();
        },
        builder: (context, state) {
          return Scaffold(
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
                                borderRadius: BorderRadius.circular(24),
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
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
                            final msg = state.messages[index];
                            return _buildMessageCardFromData(
                              context,
                              state,
                              msg,
                              index,
                            );
                          },
                        ),
                      ),
                      if (state.selectedImagePath != null &&
                          state.selectedImagePath!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    File(state.selectedImagePath!),
                                    height: 76.h,
                                    width: 76.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<BrainyConversationCubit>()
                                        .removeSelectedImage(),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
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
                                borderRadius: BorderRadius.circular(30),
                                contentPadding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 8.w,
                                  top: 0.h,
                                  bottom: 6.h,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _pickImage(context),
                                      icon: Icon(
                                        Icons.image_outlined,
                                        color: greyColor4,
                                        size: 20.sp,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        final cubit = context
                                            .read<BrainyConversationCubit>();
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (_) => BrainyVoiceSheet(
                                            topic: state.topic,
                                            onSendAudio: (audioFile, text) {
                                              cubit.sendMessage(
                                                text,
                                                audioFile: audioFile,
                                              );
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
                                    4.spaceW,
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
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    context
                                        .read<BrainyConversationCubit>()
                                        .sendMessage(_controller.text);
                                    _controller.clear();
                                    _scrollToBottom();
                                  },
                                  child: SizedBox(
                                    width: 56.w,
                                    height: 56.w,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

    switch (msg.type) {
      case MessageType.user:
        icon = Icons.stars;
        chipColor = primaryColor;
        chipBgColor = orangeLightColor;
        break;
      case MessageType.aiInfo:
        icon = Icons.info;
        chipColor = primaryColor;
        chipBgColor = orangeLightColor;
        break;
      case MessageType.aiAction:
        icon = Icons.stars;
        chipColor = indigoLight;
        chipBgColor = const Color(0xFFE5E7EB);
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
    required String headline,
    String? subtext,
  }) {
    final bool hasLocalImage =
        msg.imageLocalPath != null &&
        msg.imageLocalPath!.isNotEmpty &&
        File(msg.imageLocalPath!).existsSync();
    final bool hasNetworkImage =
        msg.imageNetworkPath != null && msg.imageNetworkPath!.isNotEmpty;
    final bool hasAudio =
        (msg.audioLocalPath != null && msg.audioLocalPath!.isNotEmpty) ||
        (msg.audioNetworkPath != null && msg.audioNetworkPath!.isNotEmpty);
    final String msgKey = msg.id ?? msg.headline;
    final bool isPlayingThis =
        state.playingMessageId == msgKey && state.isAudioPlaying;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoChip(
                chipTitle: chipTitle,
                iconData: icon,
                color: chipColor,
                bgColor: chipBgColor,
              ),
              if (msg.type != MessageType.user)
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
          if (hasLocalImage || hasNetworkImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasLocalImage
                  ? Image.file(
                      File(msg.imageLocalPath!),
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      msg.imageNetworkPath!,
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                    (isPlayingThis ? "Playing voice note..." : "Play voice note")
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
    final double opacity = 0.45 + 0.55 * ((math.sin(phase) + 1) / 2);
    return Transform.translate(
      offset: Offset(0, -offset.clamp(-3.5, 3.5)),
      child: Container(
        width: 7.w,
        height: 7.w,
        margin: EdgeInsets.symmetric(horizontal: 2.5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(secondaryColor, primaryColor, index / 2)!
              .withValues(alpha: opacity),
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
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFF3ECE7),
          width: 1,
        ),
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
                      colors: <Color>[
                        Color(0xFFFFEDE6),
                        Color(0xFFECEAFF),
                      ],
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
                        "Brainy is thinking".appText(
                          fontSize: 15.sp,
                          color: greyColor9,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
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
