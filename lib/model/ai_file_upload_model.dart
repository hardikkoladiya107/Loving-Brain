import 'dart:convert';


 class AiFileUploadModel {
  AiFileUploadModel({
      String? object, 
      String? id, 
      String? purpose, 
      String? filename, 
      num? bytes, 
      num? createdAt, 
      dynamic expiresAt, 
      String? status, 
      dynamic statusDetails,}){
    _object = object;
    _id = id;
    _purpose = purpose;
    _filename = filename;
    _bytes = bytes;
    _createdAt = createdAt;
    _expiresAt = expiresAt;
    _status = status;
    _statusDetails = statusDetails;
}

  AiFileUploadModel.fromJson(dynamic json) {
    _object = json['object'];
    _id = json['id'];
    _purpose = json['purpose'];
    _filename = json['filename'];
    _bytes = json['bytes'];
    _createdAt = json['created_at'];
    _expiresAt = json['expires_at'];
    _status = json['status'];
    _statusDetails = json['status_details'];
  }
  String? _object;
  String? _id;
  String? _purpose;
  String? _filename;
  num? _bytes;
  num? _createdAt;
  dynamic _expiresAt;
  String? _status;
  dynamic _statusDetails;
AiFileUploadModel copyWith({  String? object,
  String? id,
  String? purpose,
  String? filename,
  num? bytes,
  num? createdAt,
  dynamic expiresAt,
  String? status,
  dynamic statusDetails,
}) => AiFileUploadModel(  object: object ?? _object,
  id: id ?? _id,
  purpose: purpose ?? _purpose,
  filename: filename ?? _filename,
  bytes: bytes ?? _bytes,
  createdAt: createdAt ?? _createdAt,
  expiresAt: expiresAt ?? _expiresAt,
  status: status ?? _status,
  statusDetails: statusDetails ?? _statusDetails,
);
  String? get object => _object;
  String? get id => _id;
  String? get purpose => _purpose;
  String? get filename => _filename;
  num? get bytes => _bytes;
  num? get createdAt => _createdAt;
  dynamic get expiresAt => _expiresAt;
  String? get status => _status;
  dynamic get statusDetails => _statusDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['object'] = _object;
    map['id'] = _id;
    map['purpose'] = _purpose;
    map['filename'] = _filename;
    map['bytes'] = _bytes;
    map['created_at'] = _createdAt;
    map['expires_at'] = _expiresAt;
    map['status'] = _status;
    map['status_details'] = _statusDetails;
    return map;
  }

}