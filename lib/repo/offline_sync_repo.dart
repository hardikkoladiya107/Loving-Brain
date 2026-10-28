import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/model/user_model.dart';
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
      final UserModel? user = preferences.getUserModel();
      final ChildModel? child = preferences.getChildModel();
      final String activeChildId =
          TodayLogRepo.instance.resolveActiveChildId() ??
          child?.reference?.id ??
          'default_child';

      final Map<String, dynamic> exportData = <String, dynamic>{
        'app': 'LovingBrain',
        'format_version': '2.0',
        'export_version': '2.0',
        'export_date': DateTime.now().toIso8601String(),
        'export_timestamp': DateTime.now().toIso8601String(),
        'app_version': '2.0.0',
        'user_id': userId,
        'user_profile': user?.toJson() ?? <String, dynamic>{},
        'child_profile': child?.toJson() ?? <String, dynamic>{},
        'pending_local_updates_count': _inMemoryQueue.length,
        'privacy_notice':
            'LovingBrain comprehensive personal data export. Includes child baseline, sleep logs, mood, health notes, and parental routines exclusively for the authorized account holder.',
      };

      CollectionReference<Map<String, dynamic>>? childrenCollection;
      try {
        childrenCollection = FirebaseFirestore.instance.collection('children');
      } catch (_) {
        childrenCollection = null;
      }

      // 1. Sleep logs
      try {
        if (childrenCollection != null) {
          final QuerySnapshot<Map<String, dynamic>> sleepDocs =
              await childrenCollection
                  .doc(activeChildId)
                  .collection('sleep_logs')
                  .get();
          exportData['sleep_logs'] = sleepDocs.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
              .toList();
        } else {
          exportData['sleep_logs'] = <dynamic>[];
        }
      } catch (_) {
        exportData['sleep_logs'] = <dynamic>[];
      }

      // 2. Tantrum & behaviour logs
      try {
        if (childrenCollection != null) {
          final QuerySnapshot<Map<String, dynamic>> tantrumDocs =
              await childrenCollection
                  .doc(activeChildId)
                  .collection('tantrum_logs')
                  .get();
          exportData['tantrum_logs'] = tantrumDocs.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
              .toList();
        } else {
          exportData['tantrum_logs'] = <dynamic>[];
        }
      } catch (_) {
        exportData['tantrum_logs'] = <dynamic>[];
      }

      // 3. Mood logs
      try {
        if (childrenCollection != null) {
          final QuerySnapshot<Map<String, dynamic>> moodDocs =
              await childrenCollection
                  .doc(activeChildId)
                  .collection('mood_logs')
                  .get();
          exportData['mood_logs'] = moodDocs.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
              .toList();
        } else {
          exportData['mood_logs'] = <dynamic>[];
        }
      } catch (_) {
        exportData['mood_logs'] = <dynamic>[];
      }

      // 4. Health logs
      try {
        if (childrenCollection != null) {
          final QuerySnapshot<Map<String, dynamic>> healthDocs =
              await childrenCollection
                  .doc(activeChildId)
                  .collection('health_logs')
                  .get();
          exportData['health_logs'] = healthDocs.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
              .toList();
        } else {
          exportData['health_logs'] = <dynamic>[];
        }
      } catch (_) {
        exportData['health_logs'] = <dynamic>[];
      }

      // 5. Quick notes
      try {
        if (childrenCollection != null) {
          final QuerySnapshot<Map<String, dynamic>> noteDocs =
              await childrenCollection
                  .doc(activeChildId)
                  .collection('quick_notes')
                  .get();
          exportData['quick_notes'] = noteDocs.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.data())
              .toList();
        } else {
          exportData['quick_notes'] = <dynamic>[];
        }
      } catch (_) {
        exportData['quick_notes'] = <dynamic>[];
      }

      return ApiResultStatus.data(data: exportData);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Imports and restores a LovingBrain backup JSON payload into the app.
  Future<ApiResultStatus<int>> importUserData({
    required Map<String, dynamic> payload,
  }) async {
    try {
      int importedCount = 0;
      final ChildModel? child = preferences.getChildModel();
      final String activeChildId =
          TodayLogRepo.instance.resolveActiveChildId() ??
          child?.reference?.id ??
          'default_child';

      // 1. Restore Child Profile if present
      final dynamic rawChild = payload['child_profile'];
      if (rawChild is Map<String, dynamic> && rawChild.isNotEmpty) {
        try {
          final ChildModel importedChild = ChildModel.fromJson(rawChild);
          await preferences.saveChildModel(importedChild);
          importedCount++;
        } catch (_) {}
      }

      // 2. Restore User Profile if present
      final dynamic rawUser = payload['user_profile'];
      if (rawUser is Map<String, dynamic> && rawUser.isNotEmpty) {
        try {
          final UserModel importedUser = UserModel.fromJson(rawUser);
          await preferences.saveUserModel(importedUser);
          importedCount++;
        } catch (_) {}
      }

      CollectionReference<Map<String, dynamic>>? childrenCollection;
      try {
        childrenCollection = FirebaseFirestore.instance.collection('children');
      } catch (_) {
        childrenCollection = null;
      }

      // 3. Restore Sleep Logs
      final dynamic sleepLogs = payload['sleep_logs'];
      if (sleepLogs is List) {
        for (final dynamic item in sleepLogs) {
          if (item is Map<String, dynamic>) {
            try {
              if (childrenCollection != null) {
                await childrenCollection
                    .doc(activeChildId)
                    .collection('sleep_logs')
                    .add(item);
                importedCount++;
              } else {
                throw Exception('Firestore offline');
              }
            } catch (_) {
              await queuePendingUpdate(
                PendingLocalUpdateModel(
                  id: 'import_sleep_${DateTime.now().microsecondsSinceEpoch}_$importedCount',
                  type: 'sleep',
                  timestamp: DateTime.now(),
                  payload: item,
                ),
              );
              importedCount++;
            }
          }
        }
      }

      // 4. Restore Tantrum Logs
      final dynamic tantrumLogs = payload['tantrum_logs'];
      if (tantrumLogs is List) {
        for (final dynamic item in tantrumLogs) {
          if (item is Map<String, dynamic>) {
            try {
              if (childrenCollection != null) {
                await childrenCollection
                    .doc(activeChildId)
                    .collection('tantrum_logs')
                    .add(item);
                importedCount++;
              } else {
                throw Exception('Firestore offline');
              }
            } catch (_) {
              await queuePendingUpdate(
                PendingLocalUpdateModel(
                  id: 'import_tantrum_${DateTime.now().microsecondsSinceEpoch}_$importedCount',
                  type: 'tantrum',
                  timestamp: DateTime.now(),
                  payload: item,
                ),
              );
              importedCount++;
            }
          }
        }
      }

      // 5. Restore Mood Logs
      final dynamic moodLogs = payload['mood_logs'];
      if (moodLogs is List) {
        for (final dynamic item in moodLogs) {
          if (item is Map<String, dynamic>) {
            try {
              if (childrenCollection != null) {
                await childrenCollection
                    .doc(activeChildId)
                    .collection('mood_logs')
                    .add(item);
                importedCount++;
              } else {
                throw Exception('Firestore offline');
              }
            } catch (_) {
              await queuePendingUpdate(
                PendingLocalUpdateModel(
                  id: 'import_mood_${DateTime.now().microsecondsSinceEpoch}_$importedCount',
                  type: 'mood',
                  timestamp: DateTime.now(),
                  payload: item,
                ),
              );
              importedCount++;
            }
          }
        }
      }

      // 6. Restore Health Logs
      final dynamic healthLogs = payload['health_logs'];
      if (healthLogs is List) {
        for (final dynamic item in healthLogs) {
          if (item is Map<String, dynamic>) {
            try {
              if (childrenCollection != null) {
                await childrenCollection
                    .doc(activeChildId)
                    .collection('health_logs')
                    .add(item);
                importedCount++;
              } else {
                throw Exception('Firestore offline');
              }
            } catch (_) {
              await queuePendingUpdate(
                PendingLocalUpdateModel(
                  id: 'import_health_${DateTime.now().microsecondsSinceEpoch}_$importedCount',
                  type: 'health',
                  timestamp: DateTime.now(),
                  payload: item,
                ),
              );
              importedCount++;
            }
          }
        }
      }

      // 7. Restore Quick Notes
      final dynamic noteLogs = payload['quick_notes'];
      if (noteLogs is List) {
        for (final dynamic item in noteLogs) {
          if (item is Map<String, dynamic>) {
            try {
              if (childrenCollection != null) {
                await childrenCollection
                    .doc(activeChildId)
                    .collection('quick_notes')
                    .add(item);
                importedCount++;
              } else {
                throw Exception('Firestore offline');
              }
            } catch (_) {
              await queuePendingUpdate(
                PendingLocalUpdateModel(
                  id: 'import_note_${DateTime.now().microsecondsSinceEpoch}_$importedCount',
                  type: 'note',
                  timestamp: DateTime.now(),
                  payload: item,
                ),
              );
              importedCount++;
            }
          }
        }
      }

      return ApiResultStatus.data(data: importedCount);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
