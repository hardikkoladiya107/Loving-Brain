import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';

/// Singleton repository managing the 5 Quick Update event writes and history queries
/// for TodayScreen according to V2 architecture rules.
class TodayLogRepo {
  TodayLogRepo._();
  static final TodayLogRepo _instance = TodayLogRepo._();
  factory TodayLogRepo() => _instance;
  static TodayLogRepo get instance => _instance;

  final CollectionReference<Map<String, dynamic>> _childrenCollection =
      FirebaseFirestore.instance.collection('children');

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// Resolves the currently active child ID from SharedPreferences or Firebase user.
  String? resolveActiveChildId() {
    final ChildModel? child = preferences.getChildModel();
    if (child?.reference?.id != null && child!.reference!.id.isNotEmpty) {
      return child.reference!.id;
    }
    final UserModel? user = preferences.getUserModel();
    if (user?.defaultChild?.id != null && user!.defaultChild!.id.isNotEmpty) {
      return user.defaultChild!.id;
    }
    return null;
  }

  /// Parses a display time string (e.g., "01:30 PM" or "5:20 PM") into a full DateTime
  /// anchored to the given [referenceDate] (defaults to DateTime.now()).
  static DateTime parseTimeString(
    String timeStr, {
    DateTime? referenceDate,
  }) {
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

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('sleep_logs')
              .add(log.toMap());

      // Also record to child timeline events for unified journey view
      final int durationMins =
          log.durationMinutes ?? log.wakeTime.difference(log.bedTime).inMinutes;
      final String qualityText = '${log.sleepQualityIndex + 1}/5';

      await _childrenCollection.doc(childId).collection('events').add({
        'type': 'sleep_log',
        'timestamp': Timestamp.fromDate(log.wakeTime.toUtc()),
        'title': LocaleKeys.sleepLogSaved.tr(),
        'subtitle':
            '$durationMins min sleep • Quality: $qualityText${log.isNightWaking ? " • Night waking" : ""}',
        'createdAt': FieldValue.serverTimestamp(),
        'userId': log.userId,
        'childId': childId,
        'sleepLogId': docRef.id,
      });

      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
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

      // Save to structured tantrum_logs collection
      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('tantrum_logs')
              .add(log.toMap());

      // Save compatible entry in behaviours collection for older screens
      try {
        await _childrenCollection.doc(childId).collection('behaviours').add({
          'behaviour': log.whatHappened,
          'note': 'Triggers: ${log.triggers.join(", ")} | Helped: ${log.whatHelped}',
          'time_stamp': Timestamp.fromDate(log.timestamp.toUtc()),
          'intensity': log.intensity,
          'triggers': log.triggers,
          'whatHelped': log.whatHelped,
          'userId': log.userId,
          'childId': childId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}

      // Write to unified events timeline
      final String triggersStr =
          log.triggers.isNotEmpty ? ' (${log.triggers.join(", ")})' : '';
      await _childrenCollection.doc(childId).collection('events').add({
        'type': 'tantrum_log',
        'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
        'title': LocaleKeys.tantrumLogSaved.tr(),
        'subtitle': '${log.whatHappened}$triggersStr • Helped: ${log.whatHelped}',
        'createdAt': FieldValue.serverTimestamp(),
        'userId': log.userId,
        'childId': childId,
        'tantrumLogId': docRef.id,
      });

      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
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

      // Save under child's mood_logs collection
      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('mood_logs')
              .add(log.toMap());

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
              .set(log.toMap(), SetOptions(merge: true));
        } catch (_) {}
      }

      // Write to unified events timeline
      final String parentPart =
          log.parentMood.isNotEmpty ? ' • Parent: ${log.parentMood}' : '';
      await _childrenCollection.doc(childId).collection('events').add({
        'type': 'mood_log',
        'timestamp': Timestamp.fromDate(log.logTime.toUtc()),
        'title': LocaleKeys.moodLogSaved.tr(),
        'subtitle': 'Child: ${log.childMood}$parentPart',
        'createdAt': FieldValue.serverTimestamp(),
        'userId': uid,
        'childId': childId,
        'moodLogId': docRef.id,
      });

      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
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

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('health_logs')
              .add(log.toMap());

      // Write to unified events timeline
      final String notesPart =
          log.notes.trim().isNotEmpty ? ' • ${log.notes.trim()}' : '';
      await _childrenCollection.doc(childId).collection('events').add({
        'type': 'health_log',
        'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
        'title': LocaleKeys.healthLogSaved.tr(),
        'subtitle': '${log.issues.join(", ")}$notesPart',
        'createdAt': FieldValue.serverTimestamp(),
        'userId': log.userId,
        'childId': childId,
        'healthLogId': docRef.id,
      });

      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
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

      final DocumentReference<Map<String, dynamic>> docRef =
          await _childrenCollection
              .doc(childId)
              .collection('quick_notes')
              .add(log.toMap());

      // Write to unified events timeline
      await _childrenCollection.doc(childId).collection('events').add({
        'type': 'quick_note',
        'timestamp': Timestamp.fromDate(log.timestamp.toUtc()),
        'title': LocaleKeys.noteSaved.tr(),
        'subtitle': log.note.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'userId': log.userId,
        'childId': childId,
        'noteId': docRef.id,
      });

      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(e.message ?? LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
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

      final List<SleepLogModel> list =
          snap.docs.map(SleepLogModel.fromDoc).toList();
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

      final List<TantrumLogModel> list =
          snap.docs.map(TantrumLogModel.fromDoc).toList();
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

      final List<MoodLogModel> list =
          snap.docs.map(MoodLogModel.fromDoc).toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  Future<ApiResultStatus<List<HealthLogModel>>> getRecentHealthLogs(
    String childId, {
    int limit = 10,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _childrenCollection
          .doc(childId)
          .collection('health_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<HealthLogModel> list =
          snap.docs.map(HealthLogModel.fromDoc).toList();
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

      final List<QuickNoteModel> list =
          snap.docs.map(QuickNoteModel.fromDoc).toList();
      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
