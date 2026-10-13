import 'package:cloud_firestore/cloud_firestore.dart';

/// HealthLogModel stores non-diagnostic health context under `children/{childId}/health_logs`.
class HealthLogModel {
  final String? id;
  final DocumentReference? ref;
  final List<String>
  issues; // e.g. ["Fever", "Teething", "Medication", "Low appetite", "Illness", "Rash"]
  final String notes; // Freeform notes
  final DateTime timestamp;
  final String? userId;
  final String? childId;
  final DateTime? createdAt;

  HealthLogModel({
    this.id,
    this.ref,
    required this.issues,
    required this.notes,
    required this.timestamp,
    this.userId,
    this.childId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'issues': issues,
    'notes': notes,
    'timestamp': Timestamp.fromDate(timestamp.toUtc()),
    'userId': userId,
    'childId': childId,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory HealthLogModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return HealthLogModel.fromMap(data, id: doc.id, ref: doc.reference);
  }

  factory HealthLogModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
    DocumentReference? ref,
  }) {
    final dynamic rawTime = map['timestamp'];
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

    final List<dynamic>? rawIssues = map['issues'] as List<dynamic>?;
    final List<String> parsedIssues =
        rawIssues?.map((dynamic e) => e.toString()).toList() ?? <String>[];

    return HealthLogModel(
      id: id,
      ref: ref,
      issues: parsedIssues,
      notes: (map['notes'] as String?) ?? '',
      timestamp: parsedTime,
      userId: map['userId'] as String?,
      childId: map['childId'] as String?,
      createdAt: parsedCreatedAt,
    );
  }
}
