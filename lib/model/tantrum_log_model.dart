import 'package:cloud_firestore/cloud_firestore.dart';

/// TantrumLogModel stores meltdown/tantrum records under `children/{childId}/tantrum_logs`.
class TantrumLogModel {
  final String? id;
  final DocumentReference? ref;
  final String whatHappened;
  final String? time; // display time string, e.g. "05:20 PM"
  final DateTime timestamp; // actual event timestamp
  final double intensity; // 0.0 (Mild) to 1.0 (Intense)
  final List<String> triggers; // e.g. ["Hunger", "Tiredness", "Transition"]
  final String whatHelped; // e.g. "Holding her close"
  final String? userId;
  final String? childId;
  final DateTime? createdAt;

  TantrumLogModel({
    this.id,
    this.ref,
    required this.whatHappened,
    this.time,
    required this.timestamp,
    required this.intensity,
    required this.triggers,
    required this.whatHelped,
    this.userId,
    this.childId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'whatHappened': whatHappened,
    'time': time,
    'timestamp': Timestamp.fromDate(timestamp.toUtc()),
    'intensity': intensity,
    'triggers': triggers,
    'whatHelped': whatHelped,
    'userId': userId,
    'childId': childId,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory TantrumLogModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    return TantrumLogModel.fromMap(data, id: doc.id, ref: doc.reference);
  }

  factory TantrumLogModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
    DocumentReference? ref,
  }) {
    final dynamic rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp = DateTime.now();
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate().toLocal();
    } else if (rawTimestamp is DateTime) {
      parsedTimestamp = rawTimestamp;
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    }

    final dynamic rawCreatedAt = map['createdAt'];
    DateTime? parsedCreatedAt;
    if (rawCreatedAt is Timestamp) {
      parsedCreatedAt = rawCreatedAt.toDate().toLocal();
    } else if (rawCreatedAt is DateTime) {
      parsedCreatedAt = rawCreatedAt;
    }

    final List<dynamic>? rawTriggers = map['triggers'] as List<dynamic>?;
    final List<String> parsedTriggers =
        rawTriggers?.map((dynamic e) => e.toString()).toList() ?? <String>[];

    final double parsedIntensity =
        (map['intensity'] as num?)?.toDouble() ?? 0.5;

    return TantrumLogModel(
      id: id,
      ref: ref,
      whatHappened: (map['whatHappened'] as String?) ?? '',
      time: map['time'] as String?,
      timestamp: parsedTimestamp,
      intensity: parsedIntensity,
      triggers: parsedTriggers,
      whatHelped: (map['whatHelped'] as String?) ?? '',
      userId: map['userId'] as String?,
      childId: map['childId'] as String?,
      createdAt: parsedCreatedAt,
    );
  }
}
