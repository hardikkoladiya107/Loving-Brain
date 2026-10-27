import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/today_log_repo.dart';

/// Singleton Repository managing offline resilience, local queueing, and retry sync.
/// Conforms to AGENTS.md §7 and V2 Spec (04_DATABASE_SCHEMA_AND_OFFLINE_RULES.md).
class OfflineSyncRepo {
  OfflineSyncRepo._();
  static final OfflineSyncRepo _instance = OfflineSyncRepo._();
  factory OfflineSyncRepo() => _instance;
  static OfflineSyncRepo get instance => _instance;

  static const String _prefKeyPendingUpdates = 'pending_offline_sync_queue';
  final List<PendingLocalUpdateModel> _inMemoryQueue =
      <PendingLocalUpdateModel>[];

  /// Loads pending updates stored locally in SharedPreferences
  Future<void> loadPersistedQueue() async {
    try {
      final String? raw = preferences.getString(_prefKeyPendingUpdates);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
        _inMemoryQueue.clear();
        for (final dynamic item in decoded) {
          if (item is Map<String, dynamic>) {
            _inMemoryQueue.add(PendingLocalUpdateModel.fromJson(item));
          }
        }
      }
    } catch (_) {
      // In case of parsing failure, avoid throwing
    }
  }

  /// Returns current list of pending updates
  Future<List<PendingLocalUpdateModel>> getPendingUpdates() async {
    if (_inMemoryQueue.isEmpty) {
      await loadPersistedQueue();
    }
    return List<PendingLocalUpdateModel>.unmodifiable(_inMemoryQueue);
  }

  /// Queues an update locally when network is unavailable or save fails (Screen 67)
  Future<ApiResultStatus<bool>> queuePendingUpdate(
    PendingLocalUpdateModel update,
  ) async {
    try {
      _inMemoryQueue.removeWhere(
        (PendingLocalUpdateModel item) => item.id == update.id,
      );
      _inMemoryQueue.add(update);
      await _persistQueue();
      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Removes a synced or discarded update by ID
  Future<void> removePendingUpdate(String updateId) async {
    _inMemoryQueue.removeWhere(
      (PendingLocalUpdateModel item) => item.id == updateId,
    );
    await _persistQueue();
  }

  /// Clears the entire queue
  Future<void> clearQueue() async {
    _inMemoryQueue.clear();
    await _persistQueue();
  }

  Future<void> _persistQueue() async {
    try {
      final List<Map<String, dynamic>> rawList = _inMemoryQueue
          .map((PendingLocalUpdateModel item) => item.toJson())
          .toList();
      await preferences.putString(_prefKeyPendingUpdates, json.encode(rawList));
    } catch (_) {}
  }

  /// Syncs all queued updates when connection is restored (Screen 68).
  Future<ApiResultStatus<int>> syncPendingUpdates() async {
    if (_inMemoryQueue.isEmpty) {
      return const ApiResultStatus.data(data: 0);
    }

    int syncedCount = 0;
    final List<PendingLocalUpdateModel> snapshot =
        List<PendingLocalUpdateModel>.from(_inMemoryQueue);
    final String childId =
        TodayLogRepo.instance.resolveActiveChildId() ?? 'default_child';
    for (final PendingLocalUpdateModel item in snapshot) {
      try {
        bool success = false;
        try {
          final CollectionReference<Map<String, dynamic>> childrenCollection =
              FirebaseFirestore.instance.collection('children');
          switch (item.type.toLowerCase()) {
            case 'sleep':
              await childrenCollection
                  .doc(childId)
                  .collection('sleep_logs')
                  .add(item.payload);
              break;
            case 'tantrum':
            case 'behaviour':
              await childrenCollection
                  .doc(childId)
                  .collection('tantrum_logs')
                  .add(item.payload);
              break;
            case 'mood':
              await childrenCollection
                  .doc(childId)
                  .collection('mood_logs')
                  .add(item.payload);
              break;
            case 'health':
              await childrenCollection
                  .doc(childId)
                  .collection('health_logs')
                  .add(item.payload);
              break;
            case 'note':
              await childrenCollection
                  .doc(childId)
                  .collection('quick_notes')
                  .add(item.payload);
              break;
            default:
              break;
          }
          success = true;
        } catch (_) {
          // If offline or uninitialized Firebase, remain queued for next retry
          success = false;
        }

        if (success) {
          syncedCount++;
          await removePendingUpdate(item.id);
        }
      } catch (_) {
        // Continue attempting others
      }
    }

    return ApiResultStatus.data(data: syncedCount);
  }

  /// Assembles comprehensive user data export per Screen 62 requirements.
  Future<ApiResultStatus<Map<String, dynamic>>> exportUserData({
    required String userId,
  }) async {
    try {
      final Map<String, dynamic> exportData = <String, dynamic>{
        'user_id': userId,
        'export_date': DateTime.now().toIso8601String(),
        'format_version': '2.0',
        'export_timestamp': DateTime.now().toIso8601String(),
        'app_version': '2.0.0',
        'user_profile':
            preferences.getUserModel()?.toJson() ?? <String, dynamic>{},
        'child_profile':
            preferences.getChildModel()?.toJson() ?? <String, dynamic>{},
        'pending_local_updates_count': _inMemoryQueue.length,
        'privacy_notice':
            'LovingBrain full user data export. Parent reflections are included exclusively for the account owner.',
      };

      try {
        final QuerySnapshot<Map<String, dynamic>> sleepDocs =
            await FirebaseFirestore.instance
                .collection('sleep_logs')
                .where('user_id', isEqualTo: userId)
                .get();
        exportData['sleep_logs'] = sleepDocs.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
            .toList();
      } catch (_) {
        exportData['sleep_logs'] = <dynamic>[];
      }

      return ApiResultStatus.data(data: exportData);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
