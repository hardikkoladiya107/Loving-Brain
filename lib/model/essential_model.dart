class EssentialModel {
  List<EssentialNote>? _notes;
  List<String>? _attachments;

  EssentialModel({List<EssentialNote>? notes, List<String>? attachments}) {
    _notes = notes;
    _attachments = attachments;
  }

  EssentialModel.fromJson(Map<String, dynamic> json) {
    if (json['notes'] != null) {
      _notes = (json['notes'] as List)
          .map((e) => EssentialNote.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    if (json['attachments'] != null) {
      _attachments = List<String>.from(json['attachments']);
    }
  }

  // Getters
  List<EssentialNote>? get notes => _notes;
  List<String>? get attachments => _attachments;

  // CopyWith
  EssentialModel copyWith({
    List<EssentialNote>? notes,
    List<String>? attachments,
  }) => EssentialModel(
    notes: notes ?? _notes,
    attachments: attachments ?? _attachments,
  );

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_notes != null) {
      map['notes'] = _notes!.map((e) => e.toJson()).toList();
    }

    if (_attachments != null) {
      map['attachments'] = _attachments;
    }

    return map;
  }
}

class EssentialNote {
  String? title;
  String? description;

  EssentialNote({this.title, this.description});

  EssentialNote.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      description = json['description'];

  Map<String, dynamic> toJson() => {'title': title, 'description': description};
}
