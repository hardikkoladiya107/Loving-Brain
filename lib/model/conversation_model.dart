class ConversationModel {
  ConversationModel({
    String? object,
    List<ConversationItem>? data,
    String? firstId,
    bool? hasMore,
    String? lastId,
  }) {
    _object = object;
    _data = data;
    _firstId = firstId;
    _hasMore = hasMore;
    _lastId = lastId;
  }

  ConversationModel.fromJson(dynamic json) {
    _object = json['object'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ConversationItem.fromJson(v));
      });
    }
    _firstId = json['first_id'];
    _hasMore = json['has_more'];
    _lastId = json['last_id'];
  }

  String? _object;
  List<ConversationItem>? _data;
  String? _firstId;
  bool? _hasMore;
  String? _lastId;

  ConversationModel copyWith({
    String? object,
    List<ConversationItem>? data,
    String? firstId,
    bool? hasMore,
    String? lastId,
  }) => ConversationModel(
    object: object ?? _object,
    data: data ?? _data,
    firstId: firstId ?? _firstId,
    hasMore: hasMore ?? _hasMore,
    lastId: lastId ?? _lastId,
  );

  String? get object => _object;

  List<ConversationItem>? get data => _data;

  String? get firstId => _firstId;

  bool? get hasMore => _hasMore;

  String? get lastId => _lastId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['object'] = _object;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['first_id'] = _firstId;
    map['has_more'] = _hasMore;
    map['last_id'] = _lastId;
    return map;
  }
}

class ConversationItem {
  ConversationItem({
    String? id,
    String? type,
    String? status,
    List<AIContent>? content,
    String? role,
  }) {
    _id = id;
    _type = type;
    _status = status;
    _content = content;
    _role = role;
  }

  ConversationItem.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _status = json['status'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(AIContent.fromJson(v));
      });
    }
    _role = json['role'];
  }

  String? _id;
  String? _type;
  String? _status;
  List<AIContent>? _content;
  String? _role;

  ConversationItem copyWith({
    String? id,
    String? type,
    String? status,
    List<AIContent>? content,
    String? role,
  }) => ConversationItem(
    id: id ?? _id,
    type: type ?? _type,
    status: status ?? _status,
    content: content ?? _content,
    role: role ?? _role,
  );

  String? get id => _id;

  String? get type => _type;

  String? get status => _status;

  List<AIContent>? get content => _content;

  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['status'] = _status;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    map['role'] = _role;
    return map;
  }
}

class AIContent {
  AIContent({String? type, String? text}) {
    _type = type;
    _text = text;
  }

  AIContent.fromJson(dynamic json) {
    _type = json['type'];
    _text = json['text'];
  }

  String? _type;
  String? _text;

  AIContent copyWith({String? type, String? text}) =>
      AIContent(type: type ?? _type, text: text ?? _text);

  String? get type => _type;
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['text'] = _text;
    return map;
  }
}
