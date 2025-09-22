import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  JournalModel({String? thoughtText, DateTime? logTime}) {
    _thoughtText = thoughtText;
    _logTime = logTime;
  }

  JournalModel.fromJson(dynamic jsonObject, {bool fromConvert = false}) {
    _thoughtText = jsonObject['thought_text'];
    try {
      if (fromConvert) {
        if (jsonObject['log_time'] != null) {
          _logTime = DateTime.parse(jsonObject['log_time']);
        }
      } else {
        if (jsonObject['log_time'] != null) {
          _logTime = (jsonObject['log_time'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
  }

  String? _thoughtText;
  DateTime? _logTime;

  JournalModel copyWith({String? thoughtText, DateTime? logTime}) =>
      JournalModel(
        thoughtText: thoughtText ?? _thoughtText,
        logTime: logTime ?? _logTime,
      );

  String? get thoughtText => _thoughtText;

  DateTime? get logTime => _logTime;

  Map<String, dynamic> toJson({
    bool forConvert = false,
    bool updateFreeTaskTime = true,
  }) {
    final map = <String, dynamic>{};
    map['thought_text'] = _thoughtText;
    try {
      if (forConvert) {
        if (_logTime != null) {
          Timestamp ts = Timestamp.fromDate(_logTime!);
          map['log_time'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_logTime != null) {
          Timestamp ts = Timestamp.fromDate(_logTime!);
          map['log_time'] = ts;
        }
      }
    } catch (e) {
      e;
    }
    return map;
  }
}
