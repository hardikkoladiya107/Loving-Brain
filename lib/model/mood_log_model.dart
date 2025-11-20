import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

class MoodLogModel {
  final String childMood;
  final String parentMood;
  final DateTime logTime;

  MoodLogModel({
    required this.childMood,
    required this.parentMood,
    required this.logTime,
  });

  factory MoodLogModel.fromMap(Map<String, dynamic> map) {
    return MoodLogModel(
      childMood: map['child_mood'] ?? "",
      parentMood: map['parent_mood'] ?? "",
      logTime: (map['log_time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'child_mood': childMood,
      'parent_mood': parentMood,
      'log_time': logTime,
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
    final fmt = DateFormat('MMM d'); // Example: May 6
    return "${fmt.format(start)} - ${fmt.format(end)}";
  }
}
