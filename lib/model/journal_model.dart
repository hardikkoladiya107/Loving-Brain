import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  JournalModel({
    String? id,
    String? thoughtText,
    DateTime? logTime,
    String? imageUrl,
    String? prompt,
    String? hint1,
    String? hint2,
    double? x,
    double? y,
    int? colorValue,
  }) {
    _id = id;
    _thoughtText = thoughtText;
    _logTime = logTime;
    _imageUrl = imageUrl;
    _prompt = prompt;
    _hint1 = hint1;
    _hint2 = hint2;
    _x = x ?? 1000.0;
    _y = y ?? 1000.0;
    _colorValue = colorValue ?? 0xFFFFFFFF;
  }

  JournalModel.fromJson(
    dynamic jsonObject, {
    bool fromConvert = false,
    String? docId,
  }) {
    _id = docId;
    _thoughtText = jsonObject['thought_text'];
    _imageUrl = jsonObject['image_url'];
    _prompt = jsonObject['prompt'];
    _hint1 = jsonObject['hint1'];
    _hint2 = jsonObject['hint2'];
    _x = (jsonObject['x'] as num?)?.toDouble() ?? 1000.0;
    _y = (jsonObject['y'] as num?)?.toDouble() ?? 1000.0;
    _colorValue = (jsonObject['color_value'] as num?)?.toInt() ?? 0xFFFFFFFF;
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

  String? _id;
  String? _thoughtText;
  DateTime? _logTime;
  String? _imageUrl;
  String? _prompt;
  String? _hint1;
  String? _hint2;
  double? _x;
  double? _y;
  int? _colorValue;

  JournalModel copyWith({
    String? id,
    String? thoughtText,
    DateTime? logTime,
    String? imageUrl,
    String? prompt,
    String? hint1,
    String? hint2,
    double? x,
    double? y,
    int? colorValue,
  }) => JournalModel(
    id: id ?? _id,
    thoughtText: thoughtText ?? _thoughtText,
    logTime: logTime ?? _logTime,
    imageUrl: imageUrl ?? _imageUrl,
    prompt: prompt ?? _prompt,
    hint1: hint1 ?? _hint1,
    hint2: hint2 ?? _hint2,
    x: x ?? _x,
    y: y ?? _y,
    colorValue: colorValue ?? _colorValue,
  );

  String? get id => _id;
  String? get thoughtText => _thoughtText;
  DateTime? get logTime => _logTime;
  String? get imageUrl => _imageUrl;
  String? get prompt => _prompt;
  String? get hint1 => _hint1;
  String? get hint2 => _hint2;
  double? get x => _x;
  double? get y => _y;
  int? get colorValue => _colorValue;

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
    map['x'] = _x;
    map['y'] = _y;
    map['color_value'] = _colorValue;
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
