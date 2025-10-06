import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
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
          backgroundColor: scheduleBgColor,
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

        state.imageUploadApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          error: (error) {
            EasyLoading.dismiss();
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
          },
          data: (data) {
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _chatItem(ChatModel chat) {
    if (chat.role != null && chat.role == "user") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [userChatItem((chat.text ?? ""), chat.networkImage ?? "")],
      ).appPadding(left: 16.w, right: 16.w, top: 16);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [aiChatItem((chat.text ?? ""))],
      ).appPadding(left: 16.w, right: 16.w, top: 16);
    }
  }

  Widget chatLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [loadingItem()],
    ).appPadding(left: 16.w, right: 16.w, top: 16);
  }

  Widget aiChatItem(String item) {
    return Container(
      constraints: BoxConstraints(maxWidth: context.width * 0.8),
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
      child: item
          .appText(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          )
          .appPadding(all: 8),
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

  Widget userChatItem(String item, String networkImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(networkImage.isNotEmpty)...[
          AppImage(
            imageUrl: networkImage,
            height: 90.h,
            width: 90.h,
            shape: BoxShape.rectangle,
            borderRadius: 12,
          ),
          4.spaceH,
        ],
        Container(
          constraints: BoxConstraints(maxWidth: context.width * 0.8),
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
              topLeft: Radius.circular(12),
            ),
          ),
          child: GptMarkdown(
            item,
            textAlign: TextAlign.start,
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ).padding(all: 8),
        ),
      ],
    );
  }

  Widget _bottomTextField(ChatDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: scheduleBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            offset: Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          10.spaceH,
          if (state.selectedNetworkImage.isNotEmpty ||
              state.selectedFile != null) ...[
            Row(
              children: [
                16.spaceW,
                Stack(
                  children: [
                    if (state.selectedNetworkImage.isNotEmpty) ...[
                      AppImage(
                        imageUrl: state.selectedNetworkImage,
                        height: 80.h,
                        width: 80.h,
                        shape: BoxShape.rectangle,
                        borderRadius: 12,
                      ),
                    ] else if (state.selectedFile != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.selectedFile!,
                          height: 80.h,
                          width: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],

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
          ],
          10.spaceH,
          AppTextField(
            minLines: 1,
            maxLines: 3,
            tfType: TFTYPE.FILLED,
            controller: textEditingController,
            hint: LocaleKeys.connectWithBrainAI.tr(),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.spaceW,
                Icon(Icons.mic_outlined),
                10.spaceW,
                _selectImage(),
                10.spaceW,
              ],
            ),
            suffixIcon: BaseButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [10.spaceW, Icon(Icons.send), 10.spaceW],
              ),
              onTap: () {
                context.read<ChatDetailCubit>().createResponse();
                //_scrollToBottomAnimated();
              },
            ),
            onChanged: (value) {
              context.read<ChatDetailCubit>().changeProps(chatText: value);
            },
          ).appPadding(left: 16, right: 16),
          10.spaceH,
        ],
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        LocaleKeys.askToAI.tr().appText(fontWeight: FontWeight.w700),
      ],
    ).appPadding(left: 20);
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
        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
        itemBuilder: (context, index) {
          if (index == state.chatList.length) {
            return chatLoading();
          }
          var chat = state.chatList[index];
          return _chatItem(chat);
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
              ).padding(top: 12, bottom: 12),
              onTap: () async {
                Navigator.of(context).pop();
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
              ).padding(top: 12, bottom: 12),
              onTap: () async {
                Navigator.of(context).pop();
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
}
