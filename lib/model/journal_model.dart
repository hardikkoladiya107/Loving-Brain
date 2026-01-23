import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  JournalModel({
    String? thoughtText,
    DateTime? logTime,
    String? imageUrl,
    String? prompt,
    String? hint1,
    String? hint2,
  }) {
    _thoughtText = thoughtText;
    _logTime = logTime;
    _imageUrl = imageUrl;
    _prompt = prompt;
    _hint1 = hint1;
    _hint2 = hint2;
  }

  JournalModel.fromJson(dynamic jsonObject, {bool fromConvert = false}) {
    _thoughtText = jsonObject['thought_text'];
    _imageUrl = jsonObject['image_url'];
    _prompt = jsonObject['prompt'];
    _hint1 = jsonObject['hint1'];
    _hint2 = jsonObject['hint2'];
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
  String? _imageUrl;
  String? _prompt;
  String? _hint1;
  String? _hint2;

  JournalModel copyWith({
    String? thoughtText,
    DateTime? logTime,
    String? imageUrl,
    String? prompt,
    String? hint1,
    String? hint2,
  }) =>
      JournalModel(
        thoughtText: thoughtText ?? _thoughtText,
        logTime: logTime ?? _logTime,
        imageUrl: imageUrl ?? _imageUrl,
        prompt: prompt ?? _prompt,
        hint1: hint1 ?? _hint1,
        hint2: hint2 ?? _hint2,
      );

  String? get thoughtText => _thoughtText;
  DateTime? get logTime => _logTime;
  String? get imageUrl => _imageUrl;
  String? get prompt => _prompt;
  String? get hint1 => _hint1;
  String? get hint2 => _hint2;

  Map<String, dynamic> toJson({
    bool forConvert = false,
    bool updateFreeTaskTime = true,
  }) {
    final map = <String, dynamic>{};
    map['thought_text'] = _thoughtText;
    map['image_url'] = _imageUrl;
    map['prompt'] = _prompt;
    map['hint1'] = _hint1;
    map['hint2'] = _hint2;
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
