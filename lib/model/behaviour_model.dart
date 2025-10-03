import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviourModel {
  BehaviourModel({String? behaviour, String? note, DateTime? timeStamp}) {
    _behaviour = behaviour;
    _note = note;
    _timeStamp = timeStamp;
  }

  BehaviourModel.fromJson(
    Map<String, dynamic> jsonObject, {
    bool fromConvert = false,
  }) {
    _behaviour = jsonObject['behaviour'];
    _note = jsonObject['note'];

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

  String? _behaviour;
  String? _note;
  DateTime? _timeStamp;

  BehaviourModel copyWith({
    String? behaviour,
    String? note,
    DateTime? timeStamp,
  }) => BehaviourModel(
    behaviour: behaviour ?? _behaviour,
    note: note ?? _note,
    timeStamp: timeStamp ?? _timeStamp,
  );

  String? get behaviour => _behaviour;

  String? get note => _note;

  DateTime? get timeStamp => _timeStamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['behaviour'] = _behaviour;
    map['note'] = _note;
    map['time_stamp'] = _timeStamp;
    return map;
  }
}
