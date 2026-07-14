import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/conversation_list_item.dart';
import '../../../model/user_model.dart';

part 'chat_list_state.freezed.dart';

@freezed
abstract class ChatListState with _$ChatListState {
  const factory ChatListState({
    @Default("") String message,
    UserModel? userModel,
    @Default(ApiResultStatus.initial())
    ApiResultStatus getConversationsApiResult,
    @Default(ApiResultStatus.initial())
    ApiResultStatus deleteConversationsApiResult,
    @Default([]) List<ConversationListItem> conversationList,
  }) = _ChatListState;
}
