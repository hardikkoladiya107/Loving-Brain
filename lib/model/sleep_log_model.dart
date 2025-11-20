import 'package:cloud_firestore/cloud_firestore.dart';

/// SleepLogModel stores a reference to the child document in `childRef`.
class SleepLogModel {
  final String? id;
  final DocumentReference? ref;
  final DateTime date; // date only (midnight)
  final DateTime bedTime; // full DateTime (can be before/after midnight)
  final DateTime wakeTime; // full DateTime (can be next day)
  final String? notes;

  SleepLogModel({
    required this.id,
    this.ref,
    required this.date,
    required this.bedTime,
    required this.wakeTime,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
    'bedTime': Timestamp.fromDate(bedTime.toUtc()),
    'wakeTime': Timestamp.fromDate(wakeTime.toUtc()),
    'notes': notes,
  };

  factory SleepLogModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    Timestamp dateTs = data['date'] as Timestamp;
    Timestamp bedTs = data['bedTime'] as Timestamp;
    Timestamp wakeTs = data['wakeTime'] as Timestamp;

    return SleepLogModel(
      id: doc.id,
      ref: doc.reference,
      date: DateTime.fromMillisecondsSinceEpoch(
        dateTs.millisecondsSinceEpoch,
      ).toLocal(),
      bedTime: DateTime.fromMillisecondsSinceEpoch(
        bedTs.millisecondsSinceEpoch,
      ).toLocal(),
      wakeTime: DateTime.fromMillisecondsSinceEpoch(
        wakeTs.millisecondsSinceEpoch,
      ).toLocal(),
      notes: data['notes'] as String?,
    );
  }
}
