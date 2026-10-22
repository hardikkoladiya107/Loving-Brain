import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class MoodLogModel {
  final String? id;
  final DocumentReference? ref;
  final String childMood;
  final int childMoodIndex;
  final String parentMood;
  final DateTime logTime;
  final String? userId;
  final String? childId;
  final DateTime? createdAt;

  MoodLogModel({
    this.id,
    this.ref,
    required this.childMood,
    this.childMoodIndex = -1,
    required this.parentMood,
    required this.logTime,
    this.userId,
    this.childId,
    this.createdAt,
  });

  factory MoodLogModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
    DocumentReference? ref,
  }) {
    final dynamic rawTime = map['log_time'] ?? map['logTime'];
    DateTime parsedTime = DateTime.now();
    if (rawTime is Timestamp) {
      parsedTime = rawTime.toDate().toLocal();
    } else if (rawTime is DateTime) {
      parsedTime = rawTime;
    } else if (rawTime is String) {
      parsedTime = DateTime.tryParse(rawTime) ?? DateTime.now();
    }

    final dynamic rawCreatedAt = map['createdAt'];
    DateTime? parsedCreatedAt;
    if (rawCreatedAt is Timestamp) {
      parsedCreatedAt = rawCreatedAt.toDate().toLocal();
    } else if (rawCreatedAt is DateTime) {
      parsedCreatedAt = rawCreatedAt;
    }

    return MoodLogModel(
      id: id,
      ref: ref,
      childMood: (map['child_mood'] ?? map['childMood'] ?? '') as String,
      childMoodIndex:
          (map['child_mood_index'] ?? map['childMoodIndex'] ?? -1) as int,
      parentMood: (map['parent_mood'] ?? map['parentMood'] ?? '') as String,
      logTime: parsedTime,
      userId: map['userId'] as String?,
      childId: map['childId'] as String?,
      createdAt: parsedCreatedAt,
    );
  }

  factory MoodLogModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return MoodLogModel.fromMap(data, id: doc.id, ref: doc.reference);
  }

  Map<String, dynamic> toMap() {
    return {
      'child_mood': childMood,
      'childMood': childMood,
      'child_mood_index': childMoodIndex,
      'childMoodIndex': childMoodIndex,
      'parent_mood': parentMood,
      'parentMood': parentMood,
      'log_time': Timestamp.fromDate(logTime.toUtc()),
      'logTime': Timestamp.fromDate(logTime.toUtc()),
      'userId': userId,
      'childId': childId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

class WeekRange {
  final DateTime start; // Sunday
  final DateTime end; // Saturday

  WeekRange(this.start, this.end);

  String get label => "${_fmt(start)} - ${_fmt(end)}"; // For dropdown display

  String _fmt(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }

  String get getFormattedRange {
    final DateFormat fmt = DateFormat('MMM d'); // Example: May 6
    return "${fmt.format(start)} - ${fmt.format(end)}";
  }
}
