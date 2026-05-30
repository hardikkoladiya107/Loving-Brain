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
    ApiResultStatus? deleteConversationsApiResult,
  }) {
    emit(
      state.copyWith(
        getConversationsApiResult:
            getConversationsApiResult ?? ApiResultStatus.initial(),
        userModel: userModel ?? state.userModel,
        deleteConversationsApiResult:
            deleteConversationsApiResult ?? ApiResultStatus.initial(),
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
                    .map((e) => ConversationListItem.fromJson(e.data()))
                    .toList(),
              );
            } else {
              changeProps(conversationList: []);
            }
          });
    }
  }

  Future<void> deleteChat(String conversationId) async {
    changeProps(getConversationsApiResult: ApiResultStatus.loading());
    var response = await AuthRepo.instance.deleteConversation(
      conversationId: conversationId,
    );
    changeProps(getConversationsApiResult: response);
  }
}
