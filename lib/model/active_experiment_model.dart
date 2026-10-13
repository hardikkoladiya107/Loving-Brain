import 'package:cloud_firestore/cloud_firestore.dart';

/// ActiveExperimentModel tracks an active 1-week habit or routine experiment
/// initiated from the Weekly Family Review.
class ActiveExperimentModel {
  final String id;
  final String childId;
  final String changeTitle;
  final String observeTarget;
  final DateTime startDate;
  final int targetDays;
  final DateTime reviewDate;
  final String status; // 'active', 'completed', 'ended_early'
  final String? resultNote;
  final DateTime? createdAt;

  ActiveExperimentModel({
    required this.id,
    required this.childId,
    required this.changeTitle,
    required this.observeTarget,
    required this.startDate,
    this.targetDays = 7,
    required this.reviewDate,
    this.status = 'active',
    this.resultNote,
    this.createdAt,
  });

  int get currentDayNumber {
    final DateTime now = DateTime.now();
    final int diff = now.difference(startDate).inDays + 1;
    return diff.clamp(1, targetDays);
  }

  double get progressFraction {
    if (targetDays <= 0) return 0.0;
    return (currentDayNumber / targetDays).clamp(0.0, 1.0);
  }

  bool get isDueForReview {
    return DateTime.now().isAfter(reviewDate);
  }

  ActiveExperimentModel copyWith({
    String? id,
    String? childId,
    String? changeTitle,
    String? observeTarget,
    DateTime? startDate,
    int? targetDays,
    DateTime? reviewDate,
    String? status,
    String? resultNote,
    DateTime? createdAt,
  }) {
    return ActiveExperimentModel(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      changeTitle: changeTitle ?? this.changeTitle,
      observeTarget: observeTarget ?? this.observeTarget,
      startDate: startDate ?? this.startDate,
      targetDays: targetDays ?? this.targetDays,
      reviewDate: reviewDate ?? this.reviewDate,
      status: status ?? this.status,
      resultNote: resultNote ?? this.resultNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'childId': childId,
    'changeTitle': changeTitle,
    'observeTarget': observeTarget,
    'startDate': Timestamp.fromDate(startDate.toUtc()),
    'targetDays': targetDays,
    'reviewDate': Timestamp.fromDate(reviewDate.toUtc()),
    'status': status,
    'resultNote': resultNote,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory ActiveExperimentModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return ActiveExperimentModel.fromMap(data, id: doc.id);
  }

  factory ActiveExperimentModel.fromMap(
    Map<String, dynamic> map, {
    String id = '',
  }) {
    DateTime readDate(dynamic val, DateTime fallback) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return fallback;
    }

    final DateTime start = readDate(map['startDate'], DateTime.now());
    final int days = (map['targetDays'] as int?) ?? 7;
    final DateTime review = readDate(
      map['reviewDate'],
      start.add(Duration(days: days)),
    );

    return ActiveExperimentModel(
      id: id.isNotEmpty ? id : ((map['id'] as String?) ?? ''),
      childId: (map['childId'] as String?) ?? '',
      changeTitle: (map['changeTitle'] as String?) ?? '',
      observeTarget: (map['observeTarget'] as String?) ?? '',
      startDate: start,
      targetDays: days,
      reviewDate: review,
      status: (map['status'] as String?) ?? 'active',
      resultNote: map['resultNote'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
