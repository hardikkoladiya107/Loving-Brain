import 'package:cloud_firestore/cloud_firestore.dart';

class SharedEventModel {
  SharedEventModel({
    String? createdBy,
    String? assignedTo,
    String? children,
    String? note,
    String? title,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? requiredApproval,
    String? status,
  }) {
    _createdBy = createdBy;
    _assignedTo = assignedTo;
    _children = children;
    _note = note;
    _title = title;
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _location = location;
    _requiredApproval = requiredApproval;
    _status = status;
  }

  SharedEventModel.fromJson(dynamic jsonObject, {bool fromConvert = false}) {
    _createdBy = jsonObject['created_by'];
    _assignedTo = jsonObject['assigned_to'];
    _children = jsonObject['children'];
    _note = jsonObject['note'];
    _title = jsonObject['title'];
    _location = jsonObject['location'];
    _requiredApproval = jsonObject['required_approval'];
    _status = jsonObject['status'];

    try {
      if (fromConvert) {
        if (jsonObject['date'] != null) {
          _date = DateTime.parse(jsonObject['date']);
        }
      } else {
        if (jsonObject['date'] != null) {
          _date = (jsonObject['date'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (fromConvert) {
        if (jsonObject['start_time'] != null) {
          _startTime = DateTime.parse(jsonObject['start_time']);
        }
      } else {
        if (jsonObject['start_time'] != null) {
          _startTime = (jsonObject['start_time'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (fromConvert) {
        if (jsonObject['end_time'] != null) {
          _endTime = DateTime.parse(jsonObject['end_time']);
        }
      } else {
        if (jsonObject['end_time'] != null) {
          _endTime = (jsonObject['end_time'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
  }

  String? _createdBy;
  String? _assignedTo;
  String? _children;
  String? _note;
  String? _title;
  DateTime? _date;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _location;
  bool? _requiredApproval;
  String? _status;

  SharedEventModel copyWith({
    String? createdBy,
    String? assignedTo,
    String? children,
    String? note,
    String? title,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? requiredApproval,
    String? status,
  }) => SharedEventModel(
    createdBy: createdBy ?? _createdBy,
    assignedTo: assignedTo ?? _assignedTo,
    children: children ?? _children,
    note: note ?? _note,
    title: title ?? _title,
    date: date ?? _date,
    startTime: startTime ?? _startTime,
    endTime: endTime ?? _endTime,
    location: location ?? _location,
    requiredApproval: requiredApproval ?? _requiredApproval,
    status: status ?? _status,
  );

  String? get createdBy => _createdBy;

  String? get assignedTo => _assignedTo;

  String? get children => _children;

  String? get note => _note;

  String? get title => _title;

  DateTime? get date => _date;

  DateTime? get startTime => _startTime;

  DateTime? get endTime => _endTime;

  String? get location => _location;

  bool? get requiredApproval => _requiredApproval;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_by'] = _createdBy;
    map['assigned_to'] = _assignedTo;
    map['children'] = _children;
    map['note'] = _note;
    map['title'] = _title;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['location'] = _location;
    map['required_approval'] = _requiredApproval;
    map['status'] = _status;
    return map;
  }
}
