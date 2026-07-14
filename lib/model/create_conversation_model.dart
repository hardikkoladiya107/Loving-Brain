class CreateConversationModel {
  CreateConversationModel({
    String? id,
    String? object,
    num? createdAt,
    Metadata? metadata,
  }) {
    _id = id;
    _object = object;
    _createdAt = createdAt;
    _metadata = metadata;
  }

  CreateConversationModel.fromJson(dynamic json) {
    _id = json['id'];
    _object = json['object'];
    _createdAt = json['created_at'];
    _metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
  }

  String? _id;
  String? _object;
  num? _createdAt;
  Metadata? _metadata;

  CreateConversationModel copyWith({
    String? id,
    String? object,
    num? createdAt,
    Metadata? metadata,
  }) => CreateConversationModel(
    id: id ?? _id,
    object: object ?? _object,
    createdAt: createdAt ?? _createdAt,
    metadata: metadata ?? _metadata,
  );

  String? get id => _id;

  String? get object => _object;

  num? get createdAt => _createdAt;

  Metadata? get metadata => _metadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['object'] = _object;
    map['created_at'] = _createdAt;
    if (_metadata != null) {
      map['metadata'] = _metadata?.toJson();
    }
    return map;
  }
}

class Metadata {
  Metadata({String? topic}) {
    _topic = topic;
  }

  Metadata.fromJson(dynamic json) {
    _topic = json['topic'];
  }

  String? _topic;

  Metadata copyWith({String? topic}) => Metadata(topic: topic ?? _topic);

  String? get topic => _topic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['topic'] = _topic;
    return map;
  }
}
