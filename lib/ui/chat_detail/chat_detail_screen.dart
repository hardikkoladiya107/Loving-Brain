import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/conversation_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import '../../generated/locale_keys.g.dart';
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
  @override
  void initState() {
    context.read<ChatDetailCubit>().init(
      conversationId: widget.conversationId,
      initialChat: widget.initialChat,
    );
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailCubit, ChatDetailState>(
      builder: (context, state) {
        textEditingController.text = state.chatText;
        return Scaffold(
          backgroundColor: scheduleBgColor,
          body: Stack(
            children: [
              ListView.builder(
                itemCount: state.conversationList.length,
                itemBuilder: (context, index) {
                  var conversation = state.conversationList[index];
                  return _chatItem(conversation);
                },
              ),
              _bottomTextField(),
            ],
          ),
        );
      },
      listener: (context, state) {
        state.createResponseApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );

        state.getAllConversationApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );

        state.createConversationApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
          },
          error: (error) {
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _chatItem(ConversationItem conversation) {
    if (conversation.role != null && conversation.role == "user") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [userChatItem((conversation.content?.first.text ?? ""))],
      ).appPadding(left: 16.w, right: 16.w, top: 16);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [aiChatItem((conversation.content?.first.text ?? ""))],
      ).appPadding(left: 16.w, right: 16.w, top: 16);
    }
  }

  Widget aiChatItem(String item) {
    return Container(
      width: context.width * 0.8,
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

  Widget userChatItem(String item) {
    return Container(
      width: context.width * 0.8,
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
      child: item
          .appText(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          )
          .appPadding(all: 8),
    );
  }

  Widget _bottomTextField() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
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
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
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
                  children: [10.spaceW, Icon(Icons.search), 10.spaceW],
                ),
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
      ),
    );
  }
}
