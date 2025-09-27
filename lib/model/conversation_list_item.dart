import 'dart:convert';
/// conversation_id : ""

ConversationListItem conversationListItemFromJson(String str) => ConversationListItem.fromJson(json.decode(str));
String conversationListItemToJson(ConversationListItem data) => json.encode(data.toJson());
class ConversationListItem {
  ConversationListItem({
      String? conversationId,}){
    _conversationId = conversationId;
}

  ConversationListItem.fromJson(dynamic json) {
    _conversationId = json['conversation_id'];
  }
  String? _conversationId;
ConversationListItem copyWith({  String? conversationId,
}) => ConversationListItem(  conversationId: conversationId ?? _conversationId,
);
  String? get conversationId => _conversationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    return map;
  }

}