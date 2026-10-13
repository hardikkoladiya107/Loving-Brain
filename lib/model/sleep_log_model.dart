import 'package:cloud_firestore/cloud_firestore.dart';

/// SleepLogModel stores a sleep session under `children/{childId}/sleep_logs`.
class SleepLogModel {
  final String? id;
  final DocumentReference? ref;
  final DateTime date; // date only (midnight)
  final DateTime bedTime; // full DateTime (can be before/after midnight)
  final DateTime wakeTime; // full DateTime (can be next day)
  final String? notes;
  final String? fellAsleepTime; // display time string, e.g. "01:30 PM"
  final String? wokeUpTime; // display time string, e.g. "03:00 PM"
  final bool isNightWaking;
  final int sleepQualityIndex; // 0..4 (1 to 5 stars)
  final int? durationMinutes;
  final String? userId;
  final String? childId;
  final DateTime? createdAt;

  SleepLogModel({
    required this.id,
    this.ref,
    required this.date,
    required this.bedTime,
    required this.wakeTime,
    this.notes,
    this.fellAsleepTime,
    this.wokeUpTime,
    this.isNightWaking = false,
    this.sleepQualityIndex = 3,
    this.durationMinutes,
    this.userId,
    this.childId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
    'bedTime': Timestamp.fromDate(bedTime.toUtc()),
    'wakeTime': Timestamp.fromDate(wakeTime.toUtc()),
    'notes': notes,
    'fellAsleepTime': fellAsleepTime,
    'wokeUpTime': wokeUpTime,
    'isNightWaking': isNightWaking,
    'sleepQualityIndex': sleepQualityIndex,
    'durationMinutes':
        durationMinutes ?? wakeTime.difference(bedTime).inMinutes,
    'userId': userId,
    'childId': childId,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory SleepLogModel.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data =
        (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Timestamp? dateTs = data['date'] as Timestamp?;
    final Timestamp? bedTs = data['bedTime'] as Timestamp?;
    final Timestamp? wakeTs = data['wakeTime'] as Timestamp?;
    final Timestamp? createdTs = data['createdAt'] as Timestamp?;

    final DateTime parsedDate = dateTs != null
        ? dateTs.toDate().toLocal()
        : DateTime.now();
    final DateTime parsedBed = bedTs != null
        ? bedTs.toDate().toLocal()
        : DateTime.now();
    final DateTime parsedWake = wakeTs != null
        ? wakeTs.toDate().toLocal()
        : DateTime.now();

    return SleepLogModel(
      id: doc.id,
      ref: doc.reference,
      date: parsedDate,
      bedTime: parsedBed,
      wakeTime: parsedWake,
      notes: data['notes'] as String?,
      fellAsleepTime: data['fellAsleepTime'] as String?,
      wokeUpTime: data['wokeUpTime'] as String?,
      isNightWaking: (data['isNightWaking'] as bool?) ?? false,
      sleepQualityIndex: (data['sleepQualityIndex'] as int?) ?? 3,
      durationMinutes: data['durationMinutes'] as int?,
      userId: data['userId'] as String?,
      childId: data['childId'] as String?,
      createdAt: createdTs?.toDate().toLocal(),
    );
  }
}
