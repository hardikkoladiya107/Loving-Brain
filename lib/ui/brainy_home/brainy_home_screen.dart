import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/brainy_ai/sheets/brainy_voice_sheet.dart';
import 'package:loving_brain/other/permission_helper.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';

import 'bloc/brainy_home_cubit.dart';
import 'bloc/brainy_home_state.dart';

class BrainyHomeScreen extends StatefulWidget {
  const BrainyHomeScreen({super.key});

  @override
  State<BrainyHomeScreen> createState() => _BrainyHomeScreenState();
}

class _BrainyHomeScreenState extends State<BrainyHomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrainyHomeCubit>().init();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _openConversation(
    BuildContext context, {
    required String initialChat,
    required String topic,
  }) {
    final String trimmed = initialChat.trim();
    if (trimmed.isEmpty) return;
    context.read<BrainyHomeCubit>().clearChatText();
    _textController.clear();
    FocusScope.of(context).unfocus();
    context.push(
      RoutePaths.brainyConversation,
      extra: <String, dynamic>{
        'initialChat': trimmed,
        'topic': topic,
      },
    );
  }

  Future<void> _showImageSourcePicker(
    BuildContext context,
    String topic,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                        if (picked != null && context.mounted) {
                          context.push(
                            RoutePaths.brainyConversation,
                            extra: <String, dynamic>{
                              'initialImagePaths': <String>[picked.path],
                              'topic': topic,
                            },
                          );
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
                        if (pickedList.isNotEmpty && context.mounted) {
                          final List<String> paths = pickedList
                              .map((XFile e) => e.path)
                              .toList();
                          context.push(
                            RoutePaths.brainyConversation,
                            extra: <String, dynamic>{
                              'initialImagePaths': paths,
                              'topic': topic,
                            },
                          );
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrainyHomeCubit, BrainyHomeState>(
      builder: (context, state) {
        if (_textController.text != state.chatText) {
          _textController.value = _textController.value.copyWith(
            text: state.chatText,
            selection: TextSelection.collapsed(offset: state.chatText.length),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              // Top Left Glow
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 400.w,
                  height: 400.w,
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
                    _buildTopBar(context),
                    Expanded(
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          16.spaceH,
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      Assets.v2.images.imgBrainyHome.path,
                                    ),
                                  ),
                                ),
                              ),
                              16.spaceW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "Hi ${state.parentName}, I'm Brainy"
                                        .appText(
                                          fontSize: 24.sp,
                                          fraunces: true,
                                          color: darkBlue,
                                          textAlign: TextAlign.start,
                                          height: 1.2,
                                        ),
                                    12.spaceH,
                                    "I know ${state.childName}'s age, recent sleep and what you're working on."
                                        .appText(
                                          fontSize: 14.sp,
                                          color: greyColor,
                                          textAlign: TextAlign.start,
                                          height: 1.4,
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          32.spaceH,
                          "TOPICS".appText(
                            fontSize: 12.sp,
                            color: secondaryColor,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.start,
                          ),
                          12.spaceH,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 12.h,
                            children: [
                              _buildTopicChip(context, state, "Sleep"),
                              _buildTopicChip(context, state, "Behaviour"),
                              _buildTopicChip(context, state, "Mood"),
                              _buildTopicChip(context, state, "Health"),
                              _buildTopicChip(context, state, "General"),
                            ],
                          ),
                          32.spaceH,
                          "SUGGESTED FOR TODAY".appText(
                            fontSize: 12.sp,
                            color: greyColor4,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.start,
                          ),
                          12.spaceH,
                          ...state.suggestedQuestions.map(
                            (q) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildSuggestedCard(context, state, q),
                            ),
                          ),
                          24.spaceH,
                        ],
                      ),
                    ),
                    _buildBottomInputAndNav(context, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      context.push(RoutePaths.brainyHistory);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: "History".appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              8.spaceW,
              Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      context.push(RoutePaths.brainySaved);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: "Saved".appText(
                        fontSize: 14.sp,
                        color: greyColor9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(
    BuildContext context,
    BrainyHomeState state,
    String title,
  ) {
    final bool isSelected = title == state.selectedTopic;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? indigoLight : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.read<BrainyHomeCubit>().setTopic(title),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: title.appText(
              fontSize: 14.sp,
              color: isSelected ? secondaryColor : greyColor9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCard(
    BuildContext context,
    BrainyHomeState state,
    String text,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _openConversation(
              context,
              initialChat: text,
              topic: state.selectedTopic,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: text.appText(
                fontSize: 14.sp,
                color: greyColor9,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInputAndNav(BuildContext context, BrainyHomeState state) {
    final bool hasText = state.chatText.trim().isNotEmpty;
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: 20.w,
            left: 20.w,
            top: 0.h,
            bottom: isKeyboardOpen ? 8.h : 16.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _textController,
                  hint: "Ask Brainy anything...",
                  hintMaxLines: 1,
                  hintStyle: getTextStyle(
                    fontSize: 13.5.sp,
                    color: greyColor4,
                    fontWeight: FontWeight.w400,
                  ),
                  tfType: TFTYPE.FILLED,
                  filled: true,
                  fillColor: Colors.white,
                  borderRadius: BorderRadius.circular(27.r),
                  maxLines: 4,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 32.w,
                          minHeight: 32.w,
                        ),
                        onPressed: () => _showImageSourcePicker(
                          context,
                          state.selectedTopic,
                        ),
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
                          if (!granted || !context.mounted) return;

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (sheetContext) => BrainyVoiceSheet(
                              topic: state.selectedTopic,
                              onSendAudio: (audioFile, text) {
                                context.push(
                                  RoutePaths.brainyConversation,
                                  extra: <String, dynamic>{
                                    'initialAudioFile': audioFile,
                                    'initialChat': text,
                                    'topic': state.selectedTopic,
                                  },
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
                      6.spaceW,
                    ],
                  ),
                  onChanged: (val) {
                    context.read<BrainyHomeCubit>().updateChatText(val);
                  },
                  onSubmitted: (val) => _openConversation(
                    context,
                    initialChat: val,
                    topic: state.selectedTopic,
                  ),
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
                      if (hasText) {
                        _openConversation(
                          context,
                          initialChat: state.chatText,
                          topic: state.selectedTopic,
                        );
                      }
                    },
                    child: SizedBox(
                      width: 54.h,
                      height: 54.h,
                      child: Icon(Icons.send, color: Colors.white, size: 22.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isKeyboardOpen)
          SizedBox(
            height: 90.h,
          ), // padding so it floats above the actual base_screen navigation bar
      ],
    );
  }
}
