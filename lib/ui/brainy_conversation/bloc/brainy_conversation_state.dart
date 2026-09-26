import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_conversation_state.freezed.dart';

enum MessageType { user, aiInfo, aiAction }

class BrainyMessage {
  final MessageType type;
  final String chipTitle;
  final String headline;
  final String? subtext;

  BrainyMessage({
    required this.type,
    required this.chipTitle,
    required this.headline,
    this.subtext,
  });
}

@freezed
abstract class BrainyConversationState with _$BrainyConversationState {
  const factory BrainyConversationState({
    @Default([]) List<BrainyMessage> messages,
    @Default(false) bool isTyping,
  }) = _BrainyConversationState;
}
