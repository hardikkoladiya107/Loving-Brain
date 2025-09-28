import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_state.freezed.dart';

@freezed
abstract class AiChatState with _$AiChatState {
  const factory AiChatState({@Default("") String chatText}) =
      _AiChatState;
}
