import 'package:cloud_firestore/cloud_firestore.dart';

/// Saved milestone memory in top-level `milestones/{id}` collection.
class MilestoneModel {
  MilestoneModel({
    required this.id,
    required this.childId,
    required this.milestoneKey,
    required this.title,
    required this.whatThisMeans,
    required this.storyText,
    required this.chapter,
    required this.ageInMonths,
    required this.loggedBy,
    required this.timestamp,
  });

  final String id;
  final String childId;
  final String milestoneKey;
  final String title;
  final String whatThisMeans;
  final String storyText;
  final int chapter;
  final int ageInMonths;
  final String loggedBy;
  final DateTime timestamp;

  static MilestoneModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    return MilestoneModel(
      id: doc.id,
      childId: (data['child_id'] as String?) ?? '',
      milestoneKey: (data['milestone_key'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      whatThisMeans: (data['what_this_means'] as String?) ?? '',
      storyText: (data['story_text'] as String?) ?? '',
      chapter: (data['chapter'] as int?) ?? 1,
      ageInMonths: (data['age_in_months'] as int?) ?? 0,
      loggedBy: (data['logged_by'] as String?) ?? '',
      timestamp: _readTimestamp(data['timestamp']),
    );
  }

  static DateTime _readTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
