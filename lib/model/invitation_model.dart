/// Firestore document for `co-parent-invitation` collection.
///
/// [children] is a comma-separated list of child document ids.
/// [status] is `REQUESTED` until the invited co-parent accepts.
class InvitationModel {
  InvitationModel({
    bool? calenderEvents,
    bool? childsEssentials,
    String? fromParent,
    String? toParent,
    String? children,
    String? status,
  }) {
    _calenderEvents = calenderEvents;
    _childsEssentials = childsEssentials;
    _fromParent = fromParent;
    _toParent = toParent;
    _children = children;
    _status = status;
  }

  InvitationModel.fromJson(dynamic json) {
    _calenderEvents = json['calender_events'];
    _childsEssentials = json['childs_essentials'];
    _fromParent = json['from_parent'];
    _toParent = json['to_parent'];
    _children = json['children'];
    _status = json['status'];
  }

  bool? _calenderEvents;
  bool? _childsEssentials;
  String? _fromParent;
  String? _toParent;
  String? _children;
  String? _status;

  InvitationModel copyWith({
    bool? calenderEvents,
    bool? childsEssentials,
    String? fromParent,
    String? toParent,
    String? children,
    String? status,
  }) => InvitationModel(
    calenderEvents: calenderEvents ?? _calenderEvents,
    childsEssentials: childsEssentials ?? _childsEssentials,
    fromParent: fromParent ?? _fromParent,
    toParent: toParent ?? _toParent,
    children: children ?? _children,
    status: status ?? _status,
  );

  bool? get calenderEvents => _calenderEvents;

  bool? get childsEssentials => _childsEssentials;

  String? get fromParent => _fromParent;

  String? get toParent => _toParent;

  String? get children => _children;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['calender_events'] = _calenderEvents;
    map['childs_essentials'] = _childsEssentials;
    map['from_parent'] = _fromParent;
    map['to_parent'] = _toParent;
    map['children'] = _children;
    map['status'] = _status;
    return map;
  }
}
