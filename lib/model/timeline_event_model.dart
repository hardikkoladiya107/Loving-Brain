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
    this.audioLocalPath,
    this.audioDurationSeconds,
    this.authorName,
  });

  final String id;
  final String type;
  final DateTime timestamp;
  final String title;
  final String subtitle;
  final String? iconKey;
  final String? audioLocalPath;
  final int? audioDurationSeconds;
  final String? authorName;

  static TimelineEventModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return fromMap(doc.data() ?? <String, dynamic>{}, id: doc.id);
  }

  static TimelineEventModel fromMap(
    Map<String, dynamic> data, {
    String id = '',
  }) {
    final String type = (data['type'] as String?) ?? 'unknown';
    final DateTime timestamp = _readTimestamp(data['timestamp']);
    return TimelineEventModel(
      id: id,
      type: type,
      timestamp: timestamp,
      title: _titleFor(type, data),
      subtitle: _subtitleFor(type, data),
      iconKey: type,
      audioLocalPath: (data['audioLocalPath'] as String?)?.isNotEmpty == true
          ? (data['audioLocalPath'] as String)
          : null,
      audioDurationSeconds: data['audioDurationSeconds'] is int
          ? data['audioDurationSeconds'] as int
          : (data['audioDurationSeconds'] as num?)?.toInt(),
      authorName:
          (data['authorName'] as String?) ?? (data['userName'] as String?),
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

  static String formatSleepDuration(int minutes) {
    if (minutes < 60) return '$minutes min sleep';
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    if (m == 0) return '${h}h sleep';
    return '${h}h ${m}m sleep';
  }

  static String _cleanSubtitle(String sub) {
    return sub.replaceAllMapped(RegExp(r'(\d+)\s*min sleep'), (Match m) {
      final int mins = int.tryParse(m.group(1) ?? '') ?? 0;
      return formatSleepDuration(mins);
    });
  }

  static String _cleanTitle(String? raw, String fallback) {
    if (raw == null || raw.trim().isEmpty) return fallback;
    final String trimmed = raw.trim();
    if (trimmed.toLowerCase().contains('saved')) {
      if (trimmed.toLowerCase().contains('sleep')) return 'Sleep update';
      if (trimmed.toLowerCase().contains('tantrum')) return 'Tantrum update';
      if (trimmed.toLowerCase().contains('mood')) return 'Mood check-in';
      if (trimmed.toLowerCase().contains('health')) return 'Health update';
      if (trimmed.toLowerCase().contains('note')) return 'Quick note';
      return fallback;
    }
    return trimmed;
  }

  static String _titleFor(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'smart_moment':
        return 'Smart Moment';
      case 'help_flow':
        return 'Calm guidance';
      case 'feed':
        return 'Nutrition & feeding';
      case 'sleep_start':
        return 'Bedtime started';
      case 'sleep_end':
        return 'Morning wake-up';
      case 'state_update':
        return 'State check-in';
      case 'milestone':
        return _cleanTitle(data['title'] as String?, 'Milestone');
      case 'sleep_log':
        return _cleanTitle(data['title'] as String?, 'Sleep update');
      case 'tantrum_log':
        return _cleanTitle(data['title'] as String?, 'Tantrum update');
      case 'mood_log':
        return _cleanTitle(data['title'] as String?, 'Mood check-in');
      case 'health_log':
        return _cleanTitle(data['title'] as String?, 'Health update');
      case 'quick_note':
        return _cleanTitle(data['title'] as String?, 'Quick note');
      default:
        return _cleanTitle(data['title'] as String?, 'Activity');
    }
  }

  static String _subtitleFor(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'smart_moment':
        final String state = (data['state_at_time'] as String?) ?? '';
        return state.isEmpty ? 'Connection activity completed' : state;
      case 'help_flow':
        return (data['problem_type'] as String?) ?? 'Guidance used';
      case 'feed':
        return 'Feed recorded';
      case 'sleep_start':
        return 'Wind-down started';
      case 'sleep_end':
        final int? minutes = data['duration_minutes'] as int?;
        if (minutes != null) {
          return formatSleepDuration(minutes);
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
      case 'sleep_log':
      case 'tantrum_log':
      case 'mood_log':
      case 'health_log':
      case 'quick_note':
        final String sub = (data['subtitle'] as String?) ?? '';
        return _cleanSubtitle(sub);
      default:
        final String sub = (data['subtitle'] as String?) ?? '';
        return _cleanSubtitle(sub);
    }
  }
}
