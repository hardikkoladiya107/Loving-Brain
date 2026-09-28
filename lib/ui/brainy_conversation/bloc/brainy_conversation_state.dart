import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainy_conversation_state.freezed.dart';

enum MessageType { user, aiInfo, aiAction }

class BrainyMessage {
  final String? id;
  final MessageType type;
  final String chipTitle;
  final String headline;
  final String? subtext;
  final String? imageLocalPath;
  final String? imageNetworkPath;
  final String? audioLocalPath;
  final String? audioNetworkPath;
  final bool isSaved;

  BrainyMessage({
    this.id,
    required this.type,
    required this.chipTitle,
    required this.headline,
    this.subtext,
    this.imageLocalPath,
    this.imageNetworkPath,
    this.audioLocalPath,
    this.audioNetworkPath,
    this.isSaved = false,
  });

  BrainyMessage copyWith({
    String? id,
    MessageType? type,
    String? chipTitle,
    String? headline,
    String? subtext,
    String? imageLocalPath,
    String? imageNetworkPath,
    String? audioLocalPath,
    String? audioNetworkPath,
    bool? isSaved,
  }) {
    return BrainyMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      chipTitle: chipTitle ?? this.chipTitle,
      headline: headline ?? this.headline,
      subtext: subtext ?? this.subtext,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      imageNetworkPath: imageNetworkPath ?? this.imageNetworkPath,
      audioLocalPath: audioLocalPath ?? this.audioLocalPath,
      audioNetworkPath: audioNetworkPath ?? this.audioNetworkPath,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

@freezed
abstract class BrainyConversationState with _$BrainyConversationState {
  const factory BrainyConversationState({
    @Default([]) List<BrainyMessage> messages,
    @Default(false) bool isTyping,
    String? conversationId,
    String? topic,
    String? selectedImagePath,
    String? playingMessageId,
    @Default(false) bool isAudioPlaying,
  }) = _BrainyConversationState;
}
