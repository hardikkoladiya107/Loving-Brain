import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/conversation_list_item.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../chat_detail/chat_detail_screen.dart';
import 'bloc/chat_list_cubit.dart';
import 'bloc/chat_list_state.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    context.read<ChatListCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView.builder(
            itemCount: state.conversationList.length,
            itemBuilder: (context, index) {
              var conversation = state.conversationList[index];
              return _chatItem(conversation);
            },
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _chatItem(ConversationListItem conversation) {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: conversation.conversationId?.appText(fontSize: 14).appPadding(all: 12),
      ).appPadding(left: 20, right: 20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ChatDetailScreen(conversationId: conversation.conversationId),
          ),
        );
      },
    );
  }
}
