import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/user_model.dart';

part 'ai_chat_state.freezed.dart';

@freezed
abstract class AiChatState with _$AiChatState {
  const factory AiChatState({
    UserModel? userModel,
    @Default("") String chatText,
  }) = _AiChatState;
}
