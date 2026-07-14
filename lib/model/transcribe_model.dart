import 'dart:convert';

/// text : "you"
/// usage : {"type":"duration","seconds":18}

TranscribeModel transcribeModelFromJson(String str) =>
    TranscribeModel.fromJson(json.decode(str));
String transcribeModelToJson(TranscribeModel data) =>
    json.encode(data.toJson());

class TranscribeModel {
  TranscribeModel({String? text, Usage? usage}) {
    _text = text;
    _usage = usage;
  }

  TranscribeModel.fromJson(dynamic json) {
    _text = json['text'];
    _usage = json['usage'] != null ? Usage.fromJson(json['usage']) : null;
  }
  String? _text;
  Usage? _usage;
  TranscribeModel copyWith({String? text, Usage? usage}) =>
      TranscribeModel(text: text ?? _text, usage: usage ?? _usage);
  String? get text => _text;
  Usage? get usage => _usage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    if (_usage != null) {
      map['usage'] = _usage?.toJson();
    }
    return map;
  }
}

/// type : "duration"
/// seconds : 18

Usage usageFromJson(String str) => Usage.fromJson(json.decode(str));
String usageToJson(Usage data) => json.encode(data.toJson());

class Usage {
  Usage({String? type, num? seconds}) {
    _type = type;
    _seconds = seconds;
  }

  Usage.fromJson(dynamic json) {
    _type = json['type'];
    _seconds = json['seconds'];
  }
  String? _type;
  num? _seconds;
  Usage copyWith({String? type, num? seconds}) =>
      Usage(type: type ?? _type, seconds: seconds ?? _seconds);
  String? get type => _type;
  num? get seconds => _seconds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['seconds'] = _seconds;
    return map;
  }
}
