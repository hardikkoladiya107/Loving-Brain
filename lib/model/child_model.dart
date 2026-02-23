import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/model/routine_model.dart';

// Make sure you import your models
// import 'essential_model.dart';
// import 'routine_model.dart';

class ChildModel {
  ChildModel({
    String? childAge,
    String? childName,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    List<EssentialNote>? essentials,
    List<String>? documents,
    List<String>? parentReferenceIds,
    DocumentReference<Object?>? reference,
  }) {
    _childAge = childAge;
    _childName = childName;
    _relationshipToChild = relationshipToChild;
    _routinesList = routinesList;
    _essentialList = essentials;
    _documents = documents;
    _parentReferenceIds = parentReferenceIds;
    _reference = reference;
  }

  ChildModel.fromJson(
    Map<String, dynamic> jsonObject,
    DocumentReference<Object?> reference,
  ) {
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
    if (jsonObject['documents'] is List<dynamic>) {
      _documents = [];
      _documents?.addAll(
        (jsonObject['documents'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
      );
    }
    if (jsonObject['essentials'] is List<dynamic>) {
      _essentialList = [];
      _essentialList?.addAll(
        (jsonObject['essentials'] as List<dynamic>)
            .map((e) => EssentialNote.fromJson(e))
            .toList(),
      );
    }
    if (jsonObject['parent_reference_ids'] is List<dynamic>) {
      _parentReferenceIds = (jsonObject['parent_reference_ids'] as List<dynamic>)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
  }

  String? _childAge;
  String? _childName;
  String? _relationshipToChild;
  List<RoutineModel>? _routinesList;
  List<EssentialNote>? _essentialList;
  List<String>? _documents;
  List<String>? _parentReferenceIds;
  DocumentReference<Object?>? _reference;

  // Getters
  String? get childAge => _childAge;
  String? get childName => _childName;
  String? get relationshipToChild => _relationshipToChild;
  List<RoutineModel>? get routinesList => _routinesList;
  List<EssentialNote>? get essentials => _essentialList;
  List<String>? get documents => _documents;
  List<String>? get parentReferenceIds => _parentReferenceIds;
  DocumentReference<Object?>? get reference => _reference;

  // CopyWith method
  ChildModel copyWith({
    String? childAge,
    String? childName,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    List<EssentialNote>? essentials,
    List<String>? documents,
    List<String>? parentReferenceIds,
    DocumentReference<Object?>? reference,
  }) =>
      ChildModel(
        childAge: childAge ?? _childAge,
        childName: childName ?? _childName,
        relationshipToChild: relationshipToChild ?? _relationshipToChild,
        routinesList: routinesList ?? _routinesList,
        essentials: essentials ?? _essentialList,
        documents: documents ?? _documents,
        parentReferenceIds: parentReferenceIds ?? _parentReferenceIds,
        reference: reference ?? _reference,
      );

  // Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['child_age'] = _childAge;
    map['child_name'] = _childName;
    map['relationship_to_child'] = _relationshipToChild;
    map['routines'] = _routinesList?.map((e) => e.toJson()).toList();
    map['essentials'] = _essentialList?.map((e) => e.toJson()).toList();
    map['documents'] = _documents?.map((e) => e.toString()).toList();
    map['parent_reference_ids'] = _parentReferenceIds;
    return map;
  }
}
