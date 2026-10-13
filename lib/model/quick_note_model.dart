import 'package:cloud_firestore/cloud_firestore.dart';

/// QuickNoteModel stores free-form parent notes and context under `children/{childId}/quick_notes`.
class QuickNoteModel {
  final String? id;
  final DocumentReference? ref;
  final String note;
  final DateTime timestamp;
  final String? userId;
  final String? childId;
  final DateTime? createdAt;

  QuickNoteModel({
    this.id,
    this.ref,
    required this.note,
    required this.timestamp,
    this.userId,
    this.childId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'note': note,
    'timestamp': Timestamp.fromDate(timestamp.toUtc()),
    'userId': userId,
    'childId': childId,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory QuickNoteModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return QuickNoteModel.fromMap(data, id: doc.id, ref: doc.reference);
  }

  factory QuickNoteModel.fromMap(
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

    return QuickNoteModel(
      id: id,
      ref: ref,
      note: (map['note'] as String?) ?? '',
      timestamp: parsedTime,
      userId: map['userId'] as String?,
      childId: map['childId'] as String?,
      createdAt: parsedCreatedAt,
    );
  }
}
