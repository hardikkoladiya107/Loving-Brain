import 'dart:convert';
/// calender_events : ""
/// childs_essentials : ""
/// from_parent : ""
/// to_parent : ""
/// children : ""
/// status : "REQUESTED"

InvitationModel invitationModelFromJson(String str) => InvitationModel.fromJson(json.decode(str));
String invitationModelToJson(InvitationModel data) => json.encode(data.toJson());
class InvitationModel {
  InvitationModel({
      String? calenderEvents, 
      String? childsEssentials, 
      String? fromParent, 
      String? toParent, 
      String? children, 
      String? status,}){
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
  String? _calenderEvents;
  String? _childsEssentials;
  String? _fromParent;
  String? _toParent;
  String? _children;
  String? _status;
InvitationModel copyWith({  String? calenderEvents,
  String? childsEssentials,
  String? fromParent,
  String? toParent,
  String? children,
  String? status,
}) => InvitationModel(  calenderEvents: calenderEvents ?? _calenderEvents,
  childsEssentials: childsEssentials ?? _childsEssentials,
  fromParent: fromParent ?? _fromParent,
  toParent: toParent ?? _toParent,
  children: children ?? _children,
  status: status ?? _status,
);
  String? get calenderEvents => _calenderEvents;
  String? get childsEssentials => _childsEssentials;
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