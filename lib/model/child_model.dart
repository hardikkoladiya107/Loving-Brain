import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/routine_model.dart';

class ChildModel {
  ChildModel({
    String? childAge,
    String? childName,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    DocumentReference<Object?>? reference,
  }) {
    _childAge = childAge;
    _childName = childName;
    _relationshipToChild = relationshipToChild;
    _routinesList = routinesList;
    _reference = reference;
  }

  ChildModel.fromJson(Map<String, dynamic> jsonObject, DocumentReference<Object?> reference,  ) {
    _reference = reference;
    _childAge = jsonObject['child_age'];
    _childName = jsonObject['child_name'];
    _relationshipToChild = jsonObject['relationship_to_child'];
    if (jsonObject['routines'] is List<dynamic>) {
      _routinesList = [];
      _routinesList?.addAll(
        (jsonObject['routines'] as List<dynamic>)
            .map((e) => RoutineModel.fromJson(e))
            .toList(),
      );
    }
  }

  String? _childAge;
  String? _childName;
  String? _relationshipToChild;
  List<RoutineModel>? _routinesList;
  DocumentReference<Object?>? _reference;

  ChildModel copyWith({
    String? childAge,
    String? childName,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    DocumentReference<Object?>? reference
  }) => ChildModel(
    childAge: childAge ?? _childAge,
    childName: childName ?? _childName,
    routinesList: routinesList ?? _routinesList,
    relationshipToChild: relationshipToChild ?? _relationshipToChild,
    reference: reference ?? _reference,
  );

  String? get childAge => _childAge;

  String? get childName => _childName;

  List<RoutineModel>? get routinesList => _routinesList;

  String? get relationshipToChild => _relationshipToChild;
  DocumentReference<Object?>? get reference => _reference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['child_age'] = _childAge;
    map['child_name'] = _childName;
    map['relationship_to_child'] = _relationshipToChild;
    map['routines'] = _routinesList?.map((e) => e.toJson()).toList();
    return map;
  }
}
