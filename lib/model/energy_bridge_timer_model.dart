import 'package:cloud_firestore/cloud_firestore.dart';

class EnergyBridgeTimerModel {
  EnergyBridgeTimerModel({
    required this.childId,
    required this.isActive,
    required this.durationMinutes,
    required this.fired,
    this.startedAt,
    this.fireAt,
    this.firedAt,
    this.lastResetAt,
    this.resetReason,
    this.updatedBy,
    this.updatedAt,
  });

  final String childId;
  final bool isActive;
  final int durationMinutes;
  final bool fired;
  final DateTime? startedAt;
  final DateTime? fireAt;
  final DateTime? firedAt;
  final DateTime? lastResetAt;
  final String? resetReason;
  final String? updatedBy;
  final DateTime? updatedAt;

  factory EnergyBridgeTimerModel.fromJson(
    Map<String, dynamic> json, {
    required String childId,
  }) {
    DateTime? toDateTime(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    final DateTime? startedAt = toDateTime(json['started_at']);
    final int durationMinutes = (json['duration_minutes'] as int?) ?? 105;
    final DateTime? fireAt =
        toDateTime(json['fire_at']) ??
        startedAt?.add(Duration(minutes: durationMinutes));

    return EnergyBridgeTimerModel(
      childId: childId,
      isActive: (json['is_active'] as bool?) ?? false,
      durationMinutes: durationMinutes,
      fired: (json['fired'] as bool?) ?? false,
      startedAt: startedAt,
      fireAt: fireAt,
      firedAt: toDateTime(json['fired_at']),
      lastResetAt: toDateTime(json['last_reset_at']),
      resetReason: json['reset_reason'] as String?,
      updatedBy: json['updated_by'] as String?,
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'is_active': isActive,
      'duration_minutes': durationMinutes,
      'fired': fired,
      'started_at': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'fire_at': fireAt != null ? Timestamp.fromDate(fireAt!) : null,
      'fired_at': firedAt != null ? Timestamp.fromDate(firedAt!) : null,
      'last_reset_at': lastResetAt != null
          ? Timestamp.fromDate(lastResetAt!)
          : null,
      'reset_reason': resetReason,
      'updated_by': updatedBy,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
