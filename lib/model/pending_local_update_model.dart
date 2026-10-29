import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing an offline or queued update waiting to sync (Screens 67 & 68).
/// Conforms to V2 Specification (Zero data loss on save error, idempotent IDs).
class PendingLocalUpdateModel {
  final String id;
  final String type; // 'sleep', 'tantrum', 'mood', 'health', 'note'
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final String status; // 'pending', 'syncing', 'synced', 'failed'
  final String? childId;

  const PendingLocalUpdateModel({
    required this.id,
    required this.type,
    required this.payload,
    required this.timestamp,
    this.status = 'pending',
    this.childId,
  });

  String get clientUpdateId => id;
  String get updateType => type;

  static dynamic _sanitizeValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toUtc().toIso8601String();
    } else if (value is DateTime) {
      return value.toUtc().toIso8601String();
    } else if (value is FieldValue) {
      return DateTime.now().toUtc().toIso8601String();
    } else if (value is Map) {
      return value.map(
        (dynamic k, dynamic v) =>
            MapEntry<String, dynamic>(k.toString(), _sanitizeValue(v)),
      );
    } else if (value is List) {
      return value.map(_sanitizeValue).toList();
    }
    return value;
  }

  static Map<String, dynamic> _sanitizeForJson(Map<String, dynamic> map) {
    return Map<String, dynamic>.from(_sanitizeValue(map) as Map);
  }

  factory PendingLocalUpdateModel.create({
    required String clientUpdateId,
    required String updateType,
    required Map<String, dynamic> payload,
    String? timestamp,
    String status = 'pending',
    String? childId,
  }) {
    return PendingLocalUpdateModel(
      id: clientUpdateId,
      type: updateType,
      payload: _sanitizeForJson(payload),
      timestamp: timestamp != null
          ? DateTime.tryParse(timestamp) ?? DateTime.now()
          : DateTime.now(),
      status: status,
      childId: childId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'payload': _sanitizeForJson(payload),
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'child_id': childId,
    };
  }

  factory PendingLocalUpdateModel.fromJson(Map<String, dynamic> json) {
    return PendingLocalUpdateModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'note',
      payload: Map<String, dynamic>.from(
        json['payload'] as Map? ?? <String, dynamic>{},
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      childId: json['child_id']?.toString(),
    );
  }

  PendingLocalUpdateModel copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? payload,
    DateTime? timestamp,
    String? status,
    String? childId,
  }) {
    return PendingLocalUpdateModel(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      childId: childId ?? this.childId,
    );
  }
}
