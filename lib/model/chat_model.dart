

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({String? text, String? role, DateTime? timeStamp}) {
    _text = text;
    _role = role;
    _timeStamp = timeStamp;
  }

  ChatModel.fromJson(dynamic json, {bool fromConvert = false}) {
    _text = json['text'];
    _role = json['role'];

    try {
      if (fromConvert) {
        if (json['time_stamp'] != null) {
          _timeStamp = DateTime.parse(json['time_stamp']);
        }
      } else {
        if (json['time_stamp'] != null) {
          _timeStamp = (json['time_stamp'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
  }

  String? _text;
  String? _role;
  DateTime? _timeStamp;

  ChatModel copyWith({String? text, String? role, DateTime? timeStamp}) =>
      ChatModel(
        text: text ?? _text,
        timeStamp: timeStamp ?? _timeStamp,
        role: role ?? _role,
      );

  String? get text => _text;

  String? get role => _role;

  DateTime? get timeStamp => _timeStamp;

  Map<String, dynamic> toJson({bool forConvert = false}) {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['role'] = _role;
    map['time_stamp'] = _timeStamp;

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
