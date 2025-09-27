import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/api_result_status.dart';
import '../../../model/conversation_model.dart';

part 'chat_detail_state.freezed.dart';

@freezed
abstract class ChatDetailState with _$ChatDetailState {
  const factory ChatDetailState({
    @Default("") String chatText,
    String? conversationId,
    @Default(ApiResultStatus.initial()) ApiResultStatus createConversationApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus getAllConversationApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus createResponseApiResult,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveConversationResponseApiResult,
    @Default([]) List<ConversationItem> conversationList
  }) = _ChatDetailState;
}
