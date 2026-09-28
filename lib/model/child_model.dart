import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/model/routine_model.dart';

class ChildModel {
  ChildModel({
    String? childAge,
    DateTime? childDob,
    String? childName,
    String? childGender,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    List<EssentialNote>? essentials,
    List<String>? documents,
    List<String>? parentReferenceIds,
    DocumentReference<Object?>? reference,
    ChildState? childState,
    DateTime? stateUpdatedAt,
    List<String>? concerns,
    String? primaryConcern,
    String? successGoal,
    String? usualWakeTime,
    String? usualBedtime,
    String? usualNaps,
    String? nightWakings,
    List<String>? difficultTimes,
    List<String>? possibleTriggers,
    String? location,
    List<String>? conditions,
  }) {
    _childAge = childAge;
    _childDob = childDob;
    _childName = childName;
    _childGender = childGender;
    _relationshipToChild = relationshipToChild;
    _routinesList = routinesList;
    _essentialList = essentials;
    _documents = documents;
    _parentReferenceIds = parentReferenceIds;
    _reference = reference;
    _childState = childState;
    _stateUpdatedAt = stateUpdatedAt;
    _concerns = concerns;
    _primaryConcern = primaryConcern;
    _successGoal = successGoal;
    _usualWakeTime = usualWakeTime;
    _usualBedtime = usualBedtime;
    _usualNaps = usualNaps;
    _nightWakings = nightWakings;
    _difficultTimes = difficultTimes;
    _possibleTriggers = possibleTriggers;
    _location = location;
    _conditions = conditions;
  }

  ChildModel.fromJson(
    Map<String, dynamic> jsonObject, [
    DocumentReference<Object?>? reference,
  ]) {
    if (reference != null) {
      _reference = reference;
    } else {
      final String? refPath = jsonObject['reference_path']?.toString();
      if (refPath != null && refPath.trim().isNotEmpty && refPath != 'null') {
        try {
          _reference = FirebaseFirestore.instance.doc(refPath.trim());
        } catch (_) {}
      }
    }
    _childAge = jsonObject['child_age']?.toString();
    final dynamic rawChildDob = jsonObject['child_dob'];
    if (rawChildDob is Timestamp) {
      _childDob = rawChildDob.toDate();
    } else if (rawChildDob is DateTime) {
      _childDob = rawChildDob;
    } else if (rawChildDob is String) {
      _childDob = DateTime.tryParse(rawChildDob);
    }
    _childName = jsonObject['child_name']?.toString();
    _childGender = jsonObject['child_gender']?.toString();
    _relationshipToChild = jsonObject['relationship_to_child']?.toString();
    _childState = ChildStateExtension.fromKey(jsonObject['child_state']);
    final dynamic rawStateTime = jsonObject['state_updated_at'];
    if (rawStateTime is Timestamp) {
      _stateUpdatedAt = rawStateTime.toDate();
    } else if (rawStateTime is DateTime) {
      _stateUpdatedAt = rawStateTime;
    } else if (rawStateTime is String) {
      _stateUpdatedAt = DateTime.tryParse(rawStateTime);
    }
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
      _parentReferenceIds =
          (jsonObject['parent_reference_ids'] as List<dynamic>)
              .map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
    }
    if (jsonObject['concerns'] is List<dynamic>) {
      _concerns = (jsonObject['concerns'] as List<dynamic>)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    _primaryConcern = jsonObject['primary_concern']?.toString();
    _successGoal = jsonObject['success_goal']?.toString();
    _usualWakeTime = jsonObject['usual_wake_time']?.toString();
    _usualBedtime = jsonObject['usual_bedtime']?.toString();
    _usualNaps = jsonObject['usual_naps']?.toString();
    _nightWakings = jsonObject['night_wakings']?.toString();
    if (jsonObject['difficult_times'] is List<dynamic>) {
      _difficultTimes = (jsonObject['difficult_times'] as List<dynamic>)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (jsonObject['possible_triggers'] is List<dynamic>) {
      _possibleTriggers = (jsonObject['possible_triggers'] as List<dynamic>)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    _location = jsonObject['location']?.toString();
    if (jsonObject['conditions'] is List<dynamic>) {
      _conditions = (jsonObject['conditions'] as List<dynamic>)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
  }

  String? _childAge;
  DateTime? _childDob;
  String? _childName;
  String? _childGender;
  String? _relationshipToChild;
  List<RoutineModel>? _routinesList;
  List<EssentialNote>? _essentialList;
  List<String>? _documents;
  List<String>? _parentReferenceIds;
  DocumentReference<Object?>? _reference;
  ChildState? _childState;
  DateTime? _stateUpdatedAt;
  List<String>? _concerns;
  String? _primaryConcern;
  String? _successGoal;
  String? _usualWakeTime;
  String? _usualBedtime;
  String? _usualNaps;
  String? _nightWakings;
  List<String>? _difficultTimes;
  List<String>? _possibleTriggers;
  String? _location;
  List<String>? _conditions;

  // Getters
  String? get childAge => _childAge;
  DateTime? get childDob => _childDob;
  String? get childName => _childName;
  String? get childGender => _childGender;
  String? get relationshipToChild => _relationshipToChild;
  List<RoutineModel>? get routinesList => _routinesList;
  List<EssentialNote>? get essentials => _essentialList;
  List<String>? get documents => _documents;
  List<String>? get parentReferenceIds => _parentReferenceIds;
  DocumentReference<Object?>? get reference => _reference;
  ChildState? get childState => _childState;
  DateTime? get stateUpdatedAt => _stateUpdatedAt;
  List<String>? get concerns => _concerns;
  String? get primaryConcern => _primaryConcern;
  String? get successGoal => _successGoal;
  String? get usualWakeTime => _usualWakeTime;
  String? get usualBedtime => _usualBedtime;
  String? get usualNaps => _usualNaps;
  String? get nightWakings => _nightWakings;
  List<String>? get difficultTimes => _difficultTimes;
  List<String>? get possibleTriggers => _possibleTriggers;
  String? get location => _location;
  List<String>? get conditions => _conditions;

  // CopyWith method
  ChildModel copyWith({
    String? childAge,
    DateTime? childDob,
    String? childName,
    String? childGender,
    String? relationshipToChild,
    List<RoutineModel>? routinesList,
    List<EssentialNote>? essentials,
    List<String>? documents,
    List<String>? parentReferenceIds,
    DocumentReference<Object?>? reference,
    ChildState? childState,
    DateTime? stateUpdatedAt,
    List<String>? concerns,
    String? primaryConcern,
    String? successGoal,
    String? usualWakeTime,
    String? usualBedtime,
    String? usualNaps,
    String? nightWakings,
    List<String>? difficultTimes,
    List<String>? possibleTriggers,
    String? location,
    List<String>? conditions,
  }) => ChildModel(
    childAge: childAge ?? _childAge,
    childDob: childDob ?? _childDob,
    childName: childName ?? _childName,
    childGender: childGender ?? _childGender,
    relationshipToChild: relationshipToChild ?? _relationshipToChild,
    routinesList: routinesList ?? _routinesList,
    essentials: essentials ?? _essentialList,
    documents: documents ?? _documents,
    parentReferenceIds: parentReferenceIds ?? _parentReferenceIds,
    reference: reference ?? _reference,
    childState: childState ?? _childState,
    stateUpdatedAt: stateUpdatedAt ?? _stateUpdatedAt,
    concerns: concerns ?? _concerns,
    primaryConcern: primaryConcern ?? _primaryConcern,
    successGoal: successGoal ?? _successGoal,
    usualWakeTime: usualWakeTime ?? _usualWakeTime,
    usualBedtime: usualBedtime ?? _usualBedtime,
    usualNaps: usualNaps ?? _usualNaps,
    nightWakings: nightWakings ?? _nightWakings,
    difficultTimes: difficultTimes ?? _difficultTimes,
    possibleTriggers: possibleTriggers ?? _possibleTriggers,
    location: location ?? _location,
    conditions: conditions ?? _conditions,
  );

  // Convert to JSON (for Firestore / local storage)
  Map<String, dynamic> toJson({bool forConvert = false}) {
    final map = <String, dynamic>{};
    map['child_age'] = _childAge;

    if (forConvert) {
      map['child_dob'] = _childDob != null
          ? _childDob!.toIso8601String()
          : null;
      map['state_updated_at'] = _stateUpdatedAt != null
          ? _stateUpdatedAt!.toIso8601String()
          : null;
      map['reference_path'] = _reference?.path;
    } else {
      map['child_dob'] = _childDob != null
          ? Timestamp.fromDate(_childDob!)
          : null;
      map['state_updated_at'] = _stateUpdatedAt != null
          ? Timestamp.fromDate(_stateUpdatedAt!)
          : null;
    }

    map['child_name'] = _childName;
    map['child_gender'] = _childGender;
    map['relationship_to_child'] = _relationshipToChild;
    map['routines'] = _routinesList
        ?.map((e) => e.toJson(forConvert: forConvert))
        .toList();
    map['essentials'] = _essentialList?.map((e) => e.toJson()).toList();
    map['documents'] = _documents?.map((e) => e.toString()).toList();
    map['parent_reference_ids'] = _parentReferenceIds;
    map['child_state'] = _childState?.key;
    map['concerns'] = _concerns;
    map['primary_concern'] = _primaryConcern;
    map['success_goal'] = _successGoal;
    map['usual_wake_time'] = _usualWakeTime;
    map['usual_bedtime'] = _usualBedtime;
    map['usual_naps'] = _usualNaps;
    map['night_wakings'] = _nightWakings;
    map['difficult_times'] = _difficultTimes;
    map['possible_triggers'] = _possibleTriggers;
    map['location'] = _location;
    map['conditions'] = _conditions;
    return map;
  }
}
