import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    String? text,
    String? imageNetworkPath,
    String? role,
    DateTime? timeStamp,
    String? audioNetworkPath,
    String? imageLocalPath,
    String? audioLocalPath,
  }) {
    _text = text;
    _role = role;
    _timeStamp = timeStamp;
    _imageNetworkPath = imageNetworkPath;
    _audioNetworkPath = audioNetworkPath;
    _imageLocalPath = imageLocalPath;
    _audioLocalPath = audioLocalPath;
  }

  ChatModel.fromJson(dynamic json, {bool fromConvert = false}) {
    _text = json['text'];
    _role = json['role'];
    _imageNetworkPath = json['image_network_path'];
    _audioNetworkPath = json['audio_network_path'];
    _imageLocalPath = json['image_local_path'];
    _audioLocalPath = json['audio_local_path'];

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
  String? _imageNetworkPath;
  String? _audioNetworkPath;
  DateTime? _timeStamp;
  String? _imageLocalPath;
  String? _audioLocalPath;

  ChatModel copyWith({
    String? text,
    String? role,
    String? networkImage,
    DateTime? timeStamp,
    String? audioUrl,
    String? imageLocalPath,
    String? audioLocalPath,
  }) => ChatModel(
    text: text ?? _text,
    timeStamp: timeStamp ?? _timeStamp,
    role: role ?? _role,
    imageNetworkPath: networkImage ?? _imageNetworkPath,
    audioNetworkPath: audioUrl ?? _audioNetworkPath,
    imageLocalPath: imageLocalPath ?? _imageLocalPath,
    audioLocalPath: audioLocalPath ?? _audioLocalPath,
  );

  String? get text => _text;

  String? get role => _role;

  String? get imageNetworkPath => _imageNetworkPath;

  String? get audioNetworkPath => _audioNetworkPath;

  String? get imageLocalPath => _imageLocalPath;

  String? get audioLocalPath => _audioLocalPath;

  DateTime? get timeStamp => _timeStamp;

  Map<String, dynamic> toJson({bool forConvert = false}) {
    final map = <String, dynamic>{};
    map['text'] = _text;
    map['role'] = _role;
    map['image_network_path'] = _imageNetworkPath;
    map['audio_network_path'] = _audioNetworkPath;
    map['time_stamp'] = _timeStamp;
    map['image_local_path'] = _imageLocalPath;
    map['audio_local_path'] = _audioLocalPath;

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
