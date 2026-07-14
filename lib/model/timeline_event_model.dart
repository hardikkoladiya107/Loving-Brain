import 'package:cloud_firestore/cloud_firestore.dart';

/// Normalized timeline row from `children/{id}/events` and state updates.
class TimelineEventModel {
  TimelineEventModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.title,
    required this.subtitle,
    this.iconKey,
  });

  final String id;
  final String type;
  final DateTime timestamp;
  final String title;
  final String subtitle;
  final String? iconKey;

  static TimelineEventModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final String type = (data['type'] as String?) ?? 'unknown';
    final DateTime timestamp = _readTimestamp(data['timestamp']);
    return TimelineEventModel(
      id: doc.id,
      type: type,
      timestamp: timestamp,
      title: _titleFor(type, data),
      subtitle: _subtitleFor(type, data),
      iconKey: type,
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

  static String _titleFor(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'smart_moment':
        return 'Smart Moment';
      case 'help_flow':
        return 'Help guidance';
      case 'feed':
        return 'Feed logged';
      case 'sleep_start':
        return 'Sleep started';
      case 'sleep_end':
        return 'Sleep ended';
      case 'state_update':
        return 'State updated';
      case 'milestone':
        return (data['title'] as String?) ?? 'Milestone saved';
      default:
        return 'Activity';
    }
  }

  static String _subtitleFor(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'smart_moment':
        final String state = (data['state_at_time'] as String?) ?? '';
        return state.isEmpty ? 'Connection activity completed' : state;
      case 'help_flow':
        return (data['problem_type'] as String?) ?? 'Help used';
      case 'feed':
        return 'Feed recorded';
      case 'sleep_start':
        return 'Wind-down started';
      case 'sleep_end':
        final int? minutes = data['duration_minutes'] as int?;
        if (minutes != null) {
          return '$minutes min sleep';
        }
        return 'Sleep session ended';
      case 'state_update':
        return (data['state_id'] as String?) ?? '';
      case 'milestone':
        final int? chapter = data['chapter'] as int?;
        if (chapter != null) {
          return 'Chapter $chapter';
        }
        return 'Memory saved';
      default:
        return '';
    }
  }
}
