
class ConversationListItem {
  ConversationListItem({String? conversationId, String? firstMessage}) {
    _conversationId = conversationId;
    _firstMessage = firstMessage;
  }

  ConversationListItem.fromJson(Map<String,dynamic> json) {
    _conversationId = json['conversation_id'];
    _firstMessage = json['first_message'];
  }

  String? _conversationId;
  String? _firstMessage;

  ConversationListItem copyWith({
    String? conversationId,
    String? firstMessage,
  }) => ConversationListItem(
    conversationId: conversationId ?? _conversationId,
    firstMessage: firstMessage ?? _firstMessage,
  );

  String? get conversationId => _conversationId;

  String? get firstMessage => _firstMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    map['first_message'] = _firstMessage;
    return map;
  }
}
