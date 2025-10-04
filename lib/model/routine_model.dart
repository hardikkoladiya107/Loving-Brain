import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineModel {
  RoutineModel({DateTime? timeStamp, String? description, String? type}) {
    _timeStamp = timeStamp;
    _description = description;
    _type = type;
  }

  RoutineModel.fromJson(
    Map<String, dynamic> jsonObject, {
    bool fromConvert = false,
  }) {
    _description = jsonObject['description'];
    _type = jsonObject['type'];
    try {
      if (fromConvert) {
        if (jsonObject['time_stamp'] != null) {
          _timeStamp = DateTime.parse(jsonObject['time_stamp']);
        }
      } else {
        if (jsonObject['time_stamp'] != null) {
          _timeStamp = (jsonObject['time_stamp'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
  }

  DateTime? _timeStamp;
  String? _description;
  String? _type;

  RoutineModel copyWith({
    DateTime? timeStamp,
    String? description,
    String? type,
  }) => RoutineModel(
    timeStamp: timeStamp ?? _timeStamp,
    description: description ?? _description,
    type: type ?? _type,
  );

  DateTime? get timeStamp => _timeStamp;

  String? get description => _description;

  String? get type => _type;

  Map<String, dynamic> toJson({bool forConvert = false}) {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['type'] = _type;
    try {
      if (forConvert) {
        if (_timeStamp != null) {
          Timestamp ts = Timestamp.fromDate(_timeStamp!);
          map['time_stamp'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_timeStamp != null) {
          Timestamp ts = Timestamp.fromDate(_timeStamp!);
          map['time_stamp'] = ts;
        }
      }
    } catch (e) {
      e;
    }
    return map;
  }
}
