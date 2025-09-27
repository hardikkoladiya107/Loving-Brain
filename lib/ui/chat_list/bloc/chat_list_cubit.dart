import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/api_result_status.dart';
import '../../../model/conversation_list_item.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/auth_repo.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListState());

  void init() {
    emit(ChatListState(userModel: preferences.getUserModel()));
    _getChatList();
  }

  void changeProps({
    ApiResultStatus? getConversationsApiResult,
    UserModel? userModel,
    List<ConversationListItem>? conversationList,
  }) {
    emit(
      state.copyWith(
        getConversationsApiResult:
            getConversationsApiResult ?? state.getConversationsApiResult,
        userModel: userModel ?? state.userModel,
        conversationList: conversationList ?? state.conversationList,
      ),
    );
  }

  StreamSubscription? conversationSubscription;

  void _getChatList() {
    if ((state.userModel?.uid ?? "").isNotEmpty) {
      conversationSubscription?.cancel();
      conversationSubscription = AuthRepo.instance.userCollection
          .doc(state.userModel!.uid)
          .collection("conversations")
          .snapshots()
          .listen((event) {
            if (event.docs.isNotEmpty) {
              changeProps(
                conversationList: event.docs
                    .map((e) => ConversationListItem.fromJson(e))
                    .toList(),
              );
            }
          });
    }
  }
}
