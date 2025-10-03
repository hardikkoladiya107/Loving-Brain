import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
/// child_age : ""
/// child_name : ""
/// relationship_to_child : ""

ChildModel childModelFromJson(String str) => ChildModel.fromJson(json.decode(str));
String childModelToJson(ChildModel data) => json.encode(data.toJson());
class ChildModel {
  ChildModel({
      String? childAge, 
      String? childName, 
      String? relationshipToChild,}){
    _childAge = childAge;
    _childName = childName;
    _relationshipToChild = relationshipToChild;
}

  ChildModel.fromJson(Map<String, dynamic> jsonObject ) {
    _childAge = jsonObject['child_age'];
    _childName = jsonObject['child_name'];
    _relationshipToChild = jsonObject['relationship_to_child'];
  }
  String? _childAge;
  String? _childName;
  String? _relationshipToChild;
ChildModel copyWith({  String? childAge,
  String? childName,
  String? relationshipToChild,
}) => ChildModel(  childAge: childAge ?? _childAge,
  childName: childName ?? _childName,
  relationshipToChild: relationshipToChild ?? _relationshipToChild,
);
  String? get childAge => _childAge;
  String? get childName => _childName;
  String? get relationshipToChild => _relationshipToChild;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['child_age'] = _childAge;
    map['child_name'] = _childName;
    map['relationship_to_child'] = _relationshipToChild;
    return map;
  }

}