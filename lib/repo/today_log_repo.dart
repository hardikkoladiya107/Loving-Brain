import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/other/family_membership_helpers.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';

/// Fell-asleep and wake times placed on real calendar dates.
class ResolvedSleepInterval {
  const ResolvedSleepInterval({required this.bedTime, required this.wakeTime});

  final DateTime bedTime;
  final DateTime wakeTime;
}

/// Singleton repository managing the 5 Quick Update event writes and history queries
/// for TodayScreen according to V2 architecture rules.
class TodayLogRepo {
  TodayLogRepo._();
  static final TodayLogRepo _instance = TodayLogRepo._();
  factory TodayLogRepo() => _instance;
  static TodayLogRepo get instance => _instance;

  Future<bool> _isOffline() async {
    try {
      final List<ConnectivityResult> connectivity = await Connectivity()
          .checkConnectivity();
      return connectivity.isEmpty ||
          connectivity.every(
            (ConnectivityResult c) => c == ConnectivityResult.none,
          );
    } catch (_) {
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> get _childrenCollection =>
      FirebaseFirestore.instance.collection('children');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      FirebaseFirestore.instance.collection('users');

  /// True when today already has a sleep, health, or tantrum log, including
  /// one still waiting in the offline queue. A failed lookup returns true so
  /// a check-in is not scheduled on top of a log we could not read.
  Future<bool> hasUsefulLogToday(String childId) async {
    if (childId.isEmpty) {
      return false;
    }
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    try {
      final QuerySnapshot<Map<String, dynamic>> sleep =
          await _childrenCollection
              .doc(childId)
              .collection('sleep_logs')
              .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
              .limit(1)
              .get();
      if (sleep.docs.isNotEmpty) {
        return true;
      }
      for (final String name in <String>['health_logs', 'tantrum_logs']) {
        final QuerySnapshot<Map<String, dynamic>> snap =
            await _childrenCollection
                .doc(childId)
                .collection(name)
                .where(
                  'timestamp',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(start),
                )
                .where(
                  'timestamp',
                  isLessThanOrEqualTo: Timestamp.fromDate(end),
                )
                .limit(1)
                .get();
        if (snap.docs.isNotEmpty) {
          return true;
        }
      }
    } catch (_) {
      return true;
    }
    try {
      final List<PendingLocalUpdateModel> pending = await OfflineSyncRepo
          .instance
          .getPendingUpdates();
      for (final PendingLocalUpdateModel item in pending) {
        if (item.childId != childId) {
          continue;
        }
        final String type = item.updateType;
        final bool useful =
            type == 'sleep' || type == 'health' || type == 'tantrum';
        if (!useful) {
          continue;
        }
        if (item.timestamp.year == now.year &&
            item.timestamp.month == now.month &&
            item.timestamp.day == now.day) {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  /// Resolves the currently active child ID from SharedPreferences or Firebase user.
  String? resolveActiveChildId() {
    final ChildModel? child = preferences.getChildModel();
    final String? childId = child?.reference?.id;
    if (childId != null && childId.isNotEmpty) {
      return childId;
    }
    final UserModel? user = preferences.getUserModel();
    final String? defaultChildId = user?.defaultChild?.id;
    if (defaultChildId != null && defaultChildId.isNotEmpty) {
      return defaultChildId;
    }
    return null;
  }

  /// Parses a display time string (e.g., "01:30 PM" or "5:20 PM") into a full DateTime
  /// anchored to the given [referenceDate] (defaults to DateTime.now()).
  static DateTime parseTimeString(String timeStr, {DateTime? referenceDate}) {
    final DateTime base = referenceDate ?? DateTime.now();
    try {
      final String trimmed = timeStr.trim();
      final DateFormat format12 = DateFormat('hh:mm a');
      final DateFormat format12NoPad = DateFormat('h:mm a');
      final DateFormat format24 = DateFormat('HH:mm');

      DateTime parsed;
      try {
        parsed = format12.parse(trimmed);
      } catch (_) {
        try {
          parsed = format12NoPad.parse(trimmed);
        } catch (_) {
          parsed = format24.parse(trimmed);
        }
      }

      return DateTime(
        base.year,
        base.month,
        base.day,
        parsed.hour,
        parsed.minute,
      );
    } catch (_) {
      return base;
    }
  }

  /// Places a fell-asleep and wake clock time on real dates.
  ///
  /// Fell asleep is the latest time that is not still ahead of [now].
  /// Wake is the next time after that. A wake time later than [now] is kept,
  /// because a child who is asleep now wakes up later.
  static ResolvedSleepInterval resolveSleepInterval({
    required String bedTimeText,
    required String wakeTimeText,
    required DateTime now,
  }) {
    DateTime bedTime = parseTimeString(bedTimeText, referenceDate: now);
    if (bedTime.isAfter(now)) {
      bedTime = bedTime.subtract(const Duration(days: 1));
    }
    DateTime wakeTime = parseTimeString(wakeTimeText, referenceDate: bedTime);
    if (!wakeTime.isAfter(bedTime)) {
      wakeTime = wakeTime.add(const Duration(days: 1));
    }
    return ResolvedSleepInterval(bedTime: bedTime, wakeTime: wakeTime);
  }

  // =========================================================================
  // 1. SLEEP LOG
  // =========================================================================

  Future<ApiResultStatus<String>> addSleepLog({
    required String childId,
    required SleepLogModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      if (await _isOffline()) {
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
            updateType: 'sleep',
            timestamp: DateTime.now().toIso8601String(),
            payload: log.toMap(),
            childId: childId,
          ),
        );
        return const ApiResultStatus.data(data: 'offline_queued');
      }

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('sleep_logs')
              .add(log.toMap())
              .timeout(const Duration(seconds: 4));

      // Also record to child timeline events for unified journey view
      final int durationMins =
          log.durationMinutes ?? log.wakeTime.difference(log.bedTime).inMinutes;
      final String qualityText = log.sleepQualityIndex >= 0
          ? '${log.sleepQualityIndex + 1}/5'
          : 'not rated';

      await _childrenCollection
          .doc(childId)
          .collection('events')
          .add({
            'type': 'sleep_log',
            'timestamp': Timestamp.fromDate(log.wakeTime.toUtc()),
            'title': 'Sleep update',
            'subtitle':
                '${TimelineEventModel.formatSleepDuration(durationMins)} • Quality: $qualityText${log.isNightWaking ? " • Night waking" : ""}',
            'createdAt': FieldValue.serverTimestamp(),
            'userId': log.userId,
            'childId': childId,
            'sleepLogId': docRef.id,
          })
          .timeout(const Duration(seconds: 4));

      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      await OfflineSyncRepo.instance.queuePendingUpdate(
        PendingLocalUpdateModel.create(
          clientUpdateId: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
          updateType: 'sleep',
          timestamp: DateTime.now().toIso8601String(),
          payload: log.toMap(),
          childId: childId,
        ),
      );
      return const ApiResultStatus.data(data: 'offline_queued');
    }
  }

  Future<ApiResultStatus<bool>> updateSleepLog({
    required String childId,
    required String logId,
    required SleepLogModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      await _childrenCollection
          .doc(childId)
          .collection('sleep_logs')
          .doc(logId)
          .update(log.toMap());

      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  // =========================================================================
  // 2. TANTRUM / MELTDOWN LOG
  // =========================================================================

  Future<ApiResultStatus<String>> addTantrumLog({
    required String childId,
    required TantrumLogModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      if (await _isOffline()) {
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'tantrum_${DateTime.now().millisecondsSinceEpoch}',
            updateType: 'tantrum',
            timestamp: DateTime.now().toIso8601String(),
            payload: log.toMap(),
            childId: childId,
          ),
        );
        return const ApiResultStatus.data(data: 'offline_queued');
      }

      // Save to structured tantrum_logs collection
      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('tantrum_logs')
              .add(log.toMap())
              .timeout(const Duration(seconds: 4));

      // Save compatible entry in behaviours collection for older screens
      try {
        await _childrenCollection
            .doc(childId)
            .collection('behaviours')
            .add({
              'behaviour': log.whatHappened,
              'note':
                  'Triggers: ${log.triggers.join(", ")} | Helped: ${log.whatHelped}',
              'time_stamp': Timestamp.fromDate(log.timestamp.toUtc()),
              'intensity': log.intensity,
              'triggers': log.triggers,
              'whatHelped': log.whatHelped,
              'userId': log.userId,
              'childId': childId,
              'createdAt': FieldValue.serverTimestamp(),
            })
            .timeout(const Duration(seconds: 4));
      } catch (_) {}

      // Write to unified events timeline
      final String triggersStr = log.triggers.isNotEmpty
          ? ' (${log.triggers.join(", ")})'
          : '';
      await _childrenCollection
          .doc(childId)
          .collection('events')
          .add({
            'type': 'tantrum_log',
            'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
            'title': 'Tantrum update',
            'subtitle':
                '${log.whatHappened}$triggersStr • Helped: ${log.whatHelped}',
            'createdAt': FieldValue.serverTimestamp(),
            'userId': log.userId,
            'childId': childId,
            'tantrumLogId': docRef.id,
          })
          .timeout(const Duration(seconds: 4));

      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      await OfflineSyncRepo.instance.queuePendingUpdate(
        PendingLocalUpdateModel.create(
          clientUpdateId: 'tantrum_${DateTime.now().millisecondsSinceEpoch}',
          updateType: 'tantrum',
          timestamp: DateTime.now().toIso8601String(),
          payload: log.toMap(),
          childId: childId,
        ),
      );
      return const ApiResultStatus.data(data: 'offline_queued');
    }
  }

  // =========================================================================
  // 3. MOOD CHECK-IN LOG
  // =========================================================================

  Future<ApiResultStatus<String>> addMoodLog({
    required String childId,
    required MoodLogModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      if (await _isOffline()) {
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'mood_${DateTime.now().millisecondsSinceEpoch}',
            updateType: 'mood',
            timestamp: DateTime.now().toIso8601String(),
            payload: log.toMap(),
            childId: childId,
          ),
        );
        return const ApiResultStatus.data(data: 'offline_queued');
      }

      // Save under child's mood_logs collection
      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('mood_logs')
              .add(log.toMap())
              .timeout(const Duration(seconds: 4));

      // Also sync to user's daily mood collection if userId is provided
      final String uid =
          log.userId ??
          preferences.getUserModel()?.uid ??
          FirebaseAuth.instance.currentUser?.uid ??
          '';
      if (uid.isNotEmpty) {
        try {
          final String dateKey = DateFormat('yyyy-MM-dd').format(log.logTime);
          await _usersCollection
              .doc(uid)
              .collection('mood')
              .doc(dateKey)
              .set(log.toMap(), SetOptions(merge: true))
              .timeout(const Duration(seconds: 4));
        } catch (_) {}
      }

      // Write to unified events timeline
      final String parentPart = log.parentMood.isNotEmpty
          ? ' • Parent: ${log.parentMood}'
          : '';
      await _childrenCollection
          .doc(childId)
          .collection('events')
          .add({
            'type': 'mood_log',
            'timestamp': Timestamp.fromDate(log.logTime.toUtc()),
            'title': 'Mood check-in',
            'subtitle': 'Child: ${log.childMood}$parentPart',
            'createdAt': FieldValue.serverTimestamp(),
            'userId': uid,
            'childId': childId,
            'moodLogId': docRef.id,
          })
          .timeout(const Duration(seconds: 4));

      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      await OfflineSyncRepo.instance.queuePendingUpdate(
        PendingLocalUpdateModel.create(
          clientUpdateId: 'mood_${DateTime.now().millisecondsSinceEpoch}',
          updateType: 'mood',
          timestamp: DateTime.now().toIso8601String(),
          payload: log.toMap(),
          childId: childId,
        ),
      );
      return const ApiResultStatus.data(data: 'offline_queued');
    }
  }

  // =========================================================================
  // 4. HEALTH UPDATE LOG
  // =========================================================================

  Future<ApiResultStatus<String>> addHealthLog({
    required String childId,
    required HealthLogModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      if (await _isOffline()) {
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'health_${DateTime.now().millisecondsSinceEpoch}',
            updateType: 'health',
            timestamp: DateTime.now().toIso8601String(),
            payload: log.toMap(),
            childId: childId,
          ),
        );
        return const ApiResultStatus.data(data: 'offline_queued');
      }

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('health_logs')
              .add(log.toMap())
              .timeout(const Duration(seconds: 4));

      // Write to unified events timeline
      final String notesPart = log.notes.trim().isNotEmpty
          ? ' • ${log.notes.trim()}'
          : '';
      await _childrenCollection
          .doc(childId)
          .collection('events')
          .add({
            'type': 'health_log',
            'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
            'title': 'Health update',
            'subtitle': '${log.issues.join(", ")}$notesPart',
            'createdAt': FieldValue.serverTimestamp(),
            'userId': log.userId,
            'childId': childId,
            'healthLogId': docRef.id,
          })
          .timeout(const Duration(seconds: 4));

      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      await OfflineSyncRepo.instance.queuePendingUpdate(
        PendingLocalUpdateModel.create(
          clientUpdateId: 'health_${DateTime.now().millisecondsSinceEpoch}',
          updateType: 'health',
          timestamp: DateTime.now().toIso8601String(),
          payload: log.toMap(),
          childId: childId,
        ),
      );
      return const ApiResultStatus.data(data: 'offline_queued');
    }
  }

  // =========================================================================
  // 5. QUICK NOTE
  // =========================================================================

  Future<ApiResultStatus<String>> addQuickNote({
    required String childId,
    required QuickNoteModel log,
  }) async {
    try {
      if (childId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.pleaseSelectChildFirst.tr()),
        );
      }

      if (await _isOffline()) {
        await OfflineSyncRepo.instance.queuePendingUpdate(
          PendingLocalUpdateModel.create(
            clientUpdateId: 'note_${DateTime.now().millisecondsSinceEpoch}',
            updateType: 'note',
            timestamp: DateTime.now().toIso8601String(),
            payload: log.toMap(),
            childId: childId,
          ),
        );
        return const ApiResultStatus.data(data: 'offline_queued');
      }

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('quick_notes')
              .add(log.toMap())
              .timeout(const Duration(seconds: 4));

      // Write to unified events timeline
      final String author =
          preferences.getUserModel()?.parentName?.trim() ??
          preferences.getUserModel()?.displayName?.trim() ??
          '';
      await _childrenCollection
          .doc(childId)
          .collection('events')
          .add({
            'type': 'quick_note',
            'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
            'title': 'Quick note',
            'subtitle': log.note.trim().isNotEmpty
                ? log.note.trim()
                : 'Voice note',
            if (author.isNotEmpty) 'authorName': author,
            if (log.audioLocalPath != null)
              'audioLocalPath': log.audioLocalPath,
            if (log.audioDurationSeconds != null)
              'audioDurationSeconds': log.audioDurationSeconds,
            'createdAt': FieldValue.serverTimestamp(),
            'userId': log.userId,
            'childId': childId,
            'noteId': docRef.id,
          })
          .timeout(const Duration(seconds: 4));

      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      await OfflineSyncRepo.instance.queuePendingUpdate(
        PendingLocalUpdateModel.create(
          clientUpdateId: 'note_${DateTime.now().millisecondsSinceEpoch}',
          updateType: 'note',
          timestamp: DateTime.now().toIso8601String(),
          payload: log.toMap(),
          childId: childId,
        ),
      );
      return const ApiResultStatus.data(data: 'offline_queued');
    }
  }

  // =========================================================================
  // RECENT LOG QUERIES (FOR JOURNEY & AUDITING)
  // =========================================================================

  Future<ApiResultStatus<List<SleepLogModel>>> getRecentSleepLogs(
    String childId, {
    int limit = 10,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('sleep_logs')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      final List<SleepLogModel> list = snap.docs
          .map(SleepLogModel.fromDoc)
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<List<TantrumLogModel>>> getRecentTantrumLogs(
    String childId, {
    int limit = 10,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('tantrum_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<TantrumLogModel> list = snap.docs
          .map(TantrumLogModel.fromDoc)
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<List<MoodLogModel>>> getRecentMoodLogs(
    String childId, {
    int limit = 10,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('mood_logs')
          .orderBy('log_time', descending: true)
          .limit(limit)
          .get();

      final List<MoodLogModel> list = snap.docs
          .map(MoodLogModel.fromDoc)
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Resolves caregiver permissions for current user context (Screen 58, Doc 01 §15).
  bool canCurrentCaregiverViewHealth() {
    final UserModel? user = preferences.getUserModel();
    if (user == null) return false;
    final ChildModel? child = preferences.getChildModel();
    final String currentUid = user.uid ?? '';

    // If there is no active child or child has no parent IDs, deny health access
    if (child == null ||
        child.parentReferenceIds == null ||
        child.parentReferenceIds!.isEmpty) {
      return false;
    }

    final String ownerUid = child.parentReferenceIds!.first;
    // Primary parent and creator always has full access to health notes
    if (currentUid.isNotEmpty && currentUid == ownerUid) {
      return true;
    }

    // Unlinked user cannot view health notes
    if (!child.parentReferenceIds!.contains(currentUid)) {
      return false;
    }

    // Secondary caregivers (including Partner): check explicit permissions
    final String email = user.email?.trim() ?? '';
    Map<String, dynamic>? saved;
    if (email.isNotEmpty) {
      saved = preferences.getCaregiverPermissions(email);
    }
    if (saved == null && currentUid.isNotEmpty) {
      saved = preferences.getCaregiverPermissions(currentUid);
    }

    if (saved != null) {
      final CaregiverPermissionsModel p = CaregiverPermissionsModel.fromMap(
        saved,
      );
      return p.canViewHealthNotes;
    }

    // By default per V2 spec, Health notes are strictly private for secondary caregivers
    return false;
  }

  Future<ApiResultStatus<List<HealthLogModel>>> getRecentHealthLogs(
    String childId, {
    int limit = 10,
  }) async {
    try {
      if (!canCurrentCaregiverViewHealth()) {
        return const ApiResultStatus.data(data: <HealthLogModel>[]);
      }

      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('health_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<HealthLogModel> list = snap.docs
          .map(HealthLogModel.fromDoc)
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<List<QuickNoteModel>>> getRecentQuickNotes(
    String childId, {
    int limit = 10,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('quick_notes')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<QuickNoteModel> list = snap.docs
          .map(QuickNoteModel.fromDoc)
          .toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<List<TimelineEventModel>>> getTimelineEvents(
    String childId, {
    int limit = 50,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('events')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<TimelineEventModel> list =
          FamilyMembershipHelpers.filterHealthTimelineEvents<
            TimelineEventModel
          >(
            events: snap.docs.map(TimelineEventModel.fromFirestore).toList(),
            canViewHealth: canCurrentCaregiverViewHealth(),
            typeOf: (TimelineEventModel event) => event.type,
          );

      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<String>> addTimelineEvent({
    required String childId,
    required String type,
    required String title,
    required String subtitle,
    DateTime? timestamp,
  }) async {
    try {
      final DateTime now = timestamp ?? DateTime.now();
      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('events')
              .add(<String, dynamic>{
                'type': type,
                'title': title,
                'subtitle': subtitle,
                'timestamp': Timestamp.fromDate(now.toUtc()),
                'createdAt': FieldValue.serverTimestamp(),
              });
      return ApiResultStatus.data(data: docRef.id);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
