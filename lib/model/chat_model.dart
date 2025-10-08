import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    String? text,
    String? networkImage,
    String? role,
    DateTime? timeStamp,
    String? audioUrl,
  }) {
    _text = text;
    _role = role;
    _timeStamp = timeStamp;
    _networkImage = networkImage;
    _audioUrl = audioUrl;
  }

  ChatModel.fromJson(dynamic json, {bool fromConvert = false}) {
    _text = json['text'];
    _role = json['role'];
    _networkImage = json['network_image'];
    _audioUrl = json['audio_url'];
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
  String? _networkImage;
  String? _audioUrl;
  DateTime? _timeStamp;

  ChatModel copyWith({
    String? text,
    String? role,
    String? networkImage,
    DateTime? timeStamp,
    String? audioUrl,
  }) => ChatModel(
    text: text ?? _text,
    timeStamp: timeStamp ?? _timeStamp,
    role: role ?? _role,
    networkImage: networkImage ?? _networkImage,
    audioUrl: audioUrl ?? _audioUrl,
  );

  String? get text => _text;

  String? get role => _role;

  String? get networkImage => _networkImage;

  String? get audioUrl => _audioUrl;

  DateTime? get timeStamp => _timeStamp;

  Map<String, dynamic> toJson({bool forConvert = false}) {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['role'] = _role;
    map['network_image'] = _networkImage;
    map['time_stamp'] = _timeStamp;
    map['audio_url'] = _audioUrl;

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
