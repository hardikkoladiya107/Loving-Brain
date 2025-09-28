import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/chat_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
      _scrollToBottomAnimated();
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
                _bottomTextField(),
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
      },
    );
  }

  Widget _chatItem(ChatModel chat) {
    if (chat.role != null && chat.role == "user") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [userChatItem((chat.text ?? ""))],
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

  Widget userChatItem(String item) {
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
          topLeft: Radius.circular(12),
        ),
      ),
      child: GptMarkdown(
        item,
        textAlign: TextAlign.start,
        style: getTextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ).padding(all: 8),
    );
  }

  Widget _bottomTextField() {
    return Container(
      height: 100.h,
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
          AppTextField(
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
                Icon(Icons.image_outlined),
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
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
