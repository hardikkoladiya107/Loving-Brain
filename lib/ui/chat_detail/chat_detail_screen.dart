import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/chat_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/chat_detail/recording_widget.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../other/app_color.dart';
import '../widget/app_text_field.dart';
import '../widget/base_button.dart';
import 'bloc/chat_detail_cubit.dart';
import 'bloc/chat_detail_state.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, this.conversationId, this.initialChat});

  final String? conversationId;
  final String? initialChat;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatDetailCubit>().init(
        conversationId: widget.conversationId,
        initialChat: widget.initialChat,
      );
      _initAudioPlayer();
    });
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailCubit, ChatDetailState>(
      builder: (context, state) {
        if (textEditingController.text != state.chatText) {
          textEditingController.value = textEditingController.value.copyWith(
            text: state.chatText ?? '',
            selection: textEditingController.selection,
          );
        }

        return Scaffold(
          backgroundColor: scheduleBgColor, // Use a clean background color
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                20.spaceH,
                _appBar(),
                _chatList(state),
                _bottomTextField(state),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.createConversationApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            _scrollToBottomAnimated();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );

        state.createResponseApiResult.whenOrNull(
          data: (data) {
            _scrollToBottomAnimated();
          },
          loading: () {
            _scrollToBottomAnimated();
          },
        );

        state.getConversationApiResult.whenOrNull(
          data: (data) {
            _scrollToBottom();
          },
        );
      },
    );
  }

  Widget _chatItem(ChatModel chat, ChatDetailState state) {
    if (chat.role != null && chat.role == "user") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [userChatItem(chat, state)],
      ).appPadding(left: 16.w, right: 16.w, top: 12);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [aiChatItem(chat)],
      ).appPadding(left: 16.w, right: 16.w, top: 12);
    }
  }

  Widget chatLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [loadingItem()],
    ).appPadding(left: 16.w, right: 16.w, top: 12);
  }

  Widget aiChatItem(ChatModel chat) {
    return Container(
      width: context.width * 0.8,
      constraints: BoxConstraints(maxWidth: context.width * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Added Expanded to fix overflow
            child: GptMarkdown(
              chat.text ?? "",
              textAlign: TextAlign.start,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ).appPadding(all: 12),
          ),

          AppDropDownButton(
            offset: Offset(-140, 30),
            dropdownWidth: 170.w,
            dropDownWidget: (close) {
              return BaseButton(
                child: Container(
                  height: 40.h,
                  width: 170.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        offset: Offset(0, 1),
                        spreadRadius: 5,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      8.spaceW,
                      Icon(Icons.bookmark),
                      8.spaceW,
                      LocaleKeys.saveToJournal.tr().appText(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  close.call();
                },
              );
            },
            child: Icon(Icons.more_vert, color: Colors.grey).appPadding(all: 5),
          ),
        ],
      ),
    );
  }

  Widget loadingItem() {
    return Container(
      width: context.width * 0.3,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            offset: Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Transform.scale(
        scale: 0.5,
        child: SpinKitThreeInOut(color: Colors.black, size: 50),
      ).appPadding(all: 8),
    );
  }

  Widget userChatItem(ChatModel chat, ChatDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if ((chat.imageNetworkPath ?? "").isNotEmpty) ...[
          AppImage(
            imageUrl: (chat.imageNetworkPath ?? ""),
            height: 90.h,
            width: 90.h,
            shape: BoxShape.rectangle,
            borderRadius: 12,
          ),
          4.spaceH,
        ] else if ((chat.imageLocalPath ?? "").isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(chat.imageLocalPath!),
              height: 90.h,
              width: 90.h,
              fit: BoxFit.cover,
            ),
          ),
          4.spaceH,
        ],

        if ((chat.audioNetworkPath ?? "").isNotEmpty) ...[
          10.spaceH,
          SizedBox(
            width: context.width - 100,
            child: _audioPlayerWidget(
              state,
              chatReferenceId: chat.reference?.id ?? "",
              ontap: () async {
                if (navigatorKey.currentContext != null) {
                  if (state.currentPlayingItem != chat.reference?.id) {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(
                          currentAudioDuration: Duration.zero,
                          totalAudioDuration: Duration.zero,
                          currentPlayingItem: chat.reference?.id,
                        );
                    await audioPlayer.release();
                    await audioPlayer.play(UrlSource(chat.audioNetworkPath!));
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                    return;
                  }

                  navigatorKey.currentContext!
                      .read<ChatDetailCubit>()
                      .changeProps(currentPlayingItem: chat.reference?.id);
                  if (state.audioPlayerState == PlayerState.paused) {
                    audioPlayer.resume();
                  } else if (state.audioPlayerState == PlayerState.stopped ||
                      state.audioPlayerState == null ||
                      state.audioPlayerState == PlayerState.completed) {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: true);
                    await audioPlayer.play(UrlSource(chat.audioNetworkPath!));
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                  } else if (state.audioPlayerState == PlayerState.playing) {
                    audioPlayer.pause();
                  }
                }
              },
            ),
          ),
          4.spaceH,
        ] else if ((chat.audioLocalPath ?? "").isNotEmpty) ...[
          10.spaceH,
          SizedBox(
            width: context.width - 100,
            child: _audioPlayerWidget(
              state,
              chatReferenceId: chat.reference?.id ?? "",
              ontap: () async {
                if (navigatorKey.currentContext != null) {
                  if (state.currentPlayingItem != chat.reference?.id) {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(
                          currentAudioDuration: Duration.zero,
                          totalAudioDuration: Duration.zero,
                          currentPlayingItem: chat.reference?.id,
                          currentAudioLoading: true,
                        );
                    await audioPlayer.release();
                    await audioPlayer.play(
                      DeviceFileSource(chat.audioLocalPath!),
                    );
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                    return;
                  }

                  navigatorKey.currentContext!
                      .read<ChatDetailCubit>()
                      .changeProps(currentPlayingItem: chat.reference?.id);
                  if (state.audioPlayerState == PlayerState.paused) {
                    audioPlayer.resume();
                  } else if (state.audioPlayerState == PlayerState.stopped ||
                      state.audioPlayerState == null ||
                      state.audioPlayerState == PlayerState.completed) {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: true);
                    await audioPlayer.play(
                      DeviceFileSource(chat.audioLocalPath!),
                    );
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                  } else if (state.audioPlayerState == PlayerState.playing) {
                    audioPlayer.pause();
                  }
                }
              },
            ),
          ),
          4.spaceH,
        ],

        if ((chat.text ?? "").isNotEmpty) ...[
          if ((chat.text ?? "").isNotEmpty) ...[
            Container(
              constraints: BoxConstraints(maxWidth: context.width * 0.8),
              decoration: BoxDecoration(
                color: primaryColor,
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.9)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GptMarkdown(
                      chat.text ?? "",
                      textAlign: TextAlign.start,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ).appPadding(all: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _bottomTextField(ChatDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        children: [
          if (state.selectedImageFile != null) ...[
            Row(
              children: [
                16.spaceW,
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        state.selectedImageFile!,
                        height: 80.h,
                        width: 80.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: BaseButton(
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                        onTap: () {
                          context.read<ChatDetailCubit>().removeSelectedImage();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            10.spaceH,
          ],
          if (state.selectedAudioRecordedFile != null) ...[
            _audioPlayerWidget(
              state,
              chatReferenceId: "INPUTAUDIO",
              ontap: () async {
                if (navigatorKey.currentContext != null &&
                    (state.selectedAudioRecordedFile?.path ?? "").isNotEmpty) {
                  if (state.currentPlayingItem != "INPUTAUDIO") {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(
                          currentAudioDuration: Duration.zero,
                          totalAudioDuration: Duration.zero,
                          currentPlayingItem: "INPUTAUDIO",
                          currentAudioLoading: true,
                        );
                    await audioPlayer.release();
                    await audioPlayer.play(
                      DeviceFileSource(state.selectedAudioRecordedFile!.path),
                    );
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                    return;
                  }

                  navigatorKey.currentContext!
                      .read<ChatDetailCubit>()
                      .changeProps(currentPlayingItem: "INPUTAUDIO");
                  if (state.audioPlayerState == PlayerState.paused) {
                    audioPlayer.resume();
                  } else if (state.audioPlayerState == PlayerState.stopped ||
                      state.audioPlayerState == null ||
                      state.audioPlayerState == PlayerState.completed) {
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: true);
                    await audioPlayer.play(
                      DeviceFileSource(state.selectedAudioRecordedFile!.path),
                    );
                    navigatorKey.currentContext!
                        .read<ChatDetailCubit>()
                        .changeProps(currentAudioLoading: false);
                  } else if (state.audioPlayerState == PlayerState.playing) {
                    audioPlayer.pause();
                  }
                }
              },
            ).appPadding(left: 16.w, right: 16.w),
            10.spaceH,
          ],
          AppTextField(
            minLines: 1,
            maxLines: 3,
            tfType: TFTYPE.FILLED,
            fillColor: Colors.grey.shade100,
            controller: textEditingController,
            hint: LocaleKeys.connectWithBrainAI.tr(),
            hintStyle: TextStyle(color: Colors.grey.shade600),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.spaceW,
                _recordAudio(state),
                10.spaceW,
                _selectImage(),
                10.spaceW,
              ],
            ),
            suffixIcon: BaseButton(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_upward, color: Colors.white, size: 20),
              ).appPadding(right: 8),
              onTap: () {
                context.read<ChatDetailCubit>().createResponse();
              },
            ),
            onChanged: (value) {
              context.read<ChatDetailCubit>().changeProps(chatText: value);
            },
          ).appPadding(left: 16, right: 16),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseButton(
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Assets.icons.icBackIcon.image(height: 24.w, width: 24.w),
            ),
            onTap: () => context.pop(),
          ),
          Expanded(
            child: LocaleKeys.askToAI.tr().appText(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 18.sp,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 40.w), // To balance the back button for centering
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<ChatDetailCubit>().dispose();
    }
    super.dispose();
  }

  Widget _chatList(ChatDetailState state) {
    if (state.chatList.isEmpty) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocaleKeys.noChatAvailable.tr().appText(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ],
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: (state.createResponseApiResult == ApiResultStatus.loading())
            ? state.chatList.length + 1
            : state.chatList.length,
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        itemBuilder: (context, index) {
          if (index == state.chatList.length) {
            return chatLoading();
          }
          var chat = state.chatList[index];
          return _chatItem(chat, state);
        },
      ),
    );
  }

  void _scrollToBottomAnimated() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Widget _selectImage() {
    return BaseButton(
      child: Icon(Icons.image_outlined),
      onTap: () {
        _showImagePickerDropdown();
      },
    );
  }

  void _showImagePickerDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseButton(
              child: Row(
                children: [
                  12.spaceW,
                  Icon(Icons.camera_alt_outlined),
                  12.spaceW,
                  LocaleKeys.pickFromCamera.tr().appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ).appPadding(top: 12, bottom: 12),
              onTap: () async {
                context.pop();
                _chooseImage(ImageSource.camera);
              },
            ),
            BaseButton(
              child: Row(
                children: [
                  12.spaceW,
                  Icon(Icons.photo_size_select_actual_outlined),
                  12.spaceW,
                  LocaleKeys.pickGallery.tr().appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ).appPadding(top: 12, bottom: 12),
              onTap: () async {
                context.pop();
                _chooseImage(ImageSource.gallery);
              },
            ),
            20.spaceH,
          ],
        );
      },
    );
  }

  Future<void> _chooseImage(ImageSource camera) async {
    final XFile? photo = await ImagePicker().pickImage(source: camera);
    if (photo != null && navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<ChatDetailCubit>().selectImage(
        photo.path,
      );
    }
  }

  Widget _recordAudio(ChatDetailState state) {
    return BaseButton(
      child: Icon(Icons.mic_outlined),
      onTap: () {
        showAppDialog(
          child: (context) {
            return BlocBuilder<ChatDetailCubit, ChatDetailState>(
              builder: (context, state) {
                return Dialog(
                  child: SizedBox(
                    height: 200.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RecordingAnimation(isRecording: state.isRecording),
                        30.spaceH,
                        BaseButton(
                          child:
                              (state.isRecording
                                      ? LocaleKeys.stopRecording.tr()
                                      : LocaleKeys.startRecording.tr())
                                  .appText(fontWeight: FontWeight.w600),
                          onTap: () {
                            if (state.isRecording) {
                              _stopRecording();
                              context.pop();
                            } else {
                              _startRecording();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  final _recorder = AudioRecorder();

  Future<void> _startRecording() async {
    if (navigatorKey.currentContext != null) {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        navigatorKey.currentContext?.read<ChatDetailCubit>().changeProps(
          isRecording: true,
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    var recordedPath = await _recorder.stop();
    if ((recordedPath ?? "").isNotEmpty) {
      navigatorKey.currentContext?.read<ChatDetailCubit>().selectAudio(
        isRecording: false,
        audioRecordedFile: File(recordedPath!),
      );
      navigatorKey.currentContext?.read<ChatDetailCubit>().createResponse();
    }
  }

  final audioPlayer = AudioPlayer();

  void _initAudioPlayer() {
    audioPlayer.onPositionChanged.listen((event) {
      if (navigatorKey.currentContext != null) {
        navigatorKey.currentContext?.read<ChatDetailCubit>().changeProps(
          currentAudioDuration: event,
        );
      }
    });

    audioPlayer.onDurationChanged.listen((event) {
      if (navigatorKey.currentContext != null) {
        navigatorKey.currentContext?.read<ChatDetailCubit>().changeProps(
          totalAudioDuration: event,
        );
      }
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (navigatorKey.currentContext != null) {
        navigatorKey.currentContext?.read<ChatDetailCubit>().changeProps(
          audioPlayerState: event,
        );
      }
    });
  }

  Widget _audioPlayerWidget(
    ChatDetailState state, {
    required String chatReferenceId,
    required GestureTapCallback ontap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          8.spaceW,
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.audiotrack, color: Colors.white),
          ),
          8.spaceW,
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                overlayShape: SliderComponentShape.noOverlay,
                trackShape: const RoundedRectSliderTrackShape(),
                activeTrackColor: cardColor2,
                inactiveTrackColor: greyColor3,
              ),
              child: Slider(
                value: state.currentPlayingItem == chatReferenceId
                    ? (state.currentAudioDuration.inMilliseconds ?? 0)
                          .toDouble()
                    : 0,
                max: state.currentPlayingItem == chatReferenceId
                    ? (state.totalAudioDuration.inMilliseconds ?? 0).toDouble()
                    : 0,
                min: 0,
                onChanged: (value) {
                  audioPlayer.seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
          ),
          8.spaceW,

          BaseButton(
            onTap: ontap,
            child:
                state.currentPlayingItem == chatReferenceId &&
                    state.currentAudioLoading
                ? CupertinoActivityIndicator()
                : Icon(
                    state.currentPlayingItem == chatReferenceId
                        ? (state.audioPlayerState == PlayerState.stopped ||
                                  state.audioPlayerState ==
                                      PlayerState.paused ||
                                  state.audioPlayerState == null)
                              ? Icons.play_arrow
                              : (state.audioPlayerState ==
                                    PlayerState.completed)
                              ? Icons.replay
                              : Icons.pause
                        : Icons.play_arrow,
                    size: 28,
                  ),
          ),
          12.spaceW,
          BaseButton(
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12),
            ),
            onTap: () async {
              await audioPlayer.stop();
              await audioPlayer.release();
              navigatorKey.currentContext
                  ?.read<ChatDetailCubit>()
                  .removeSelectedAudio();
            },
          ),
          16.spaceW,
        ],
      ),
    );
  }
}
