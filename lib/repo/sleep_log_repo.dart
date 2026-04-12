import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';

class SleepLogRepo {
  SleepLogRepo._();

  static final SleepLogRepo _instance = SleepLogRepo._();

  factory SleepLogRepo() {
    return _instance;
  }

  static SleepLogRepo get instance => _instance;

  var childrenCollection = FirebaseFirestore.instance.collection('children');

  CollectionReference _childSleepCollection(String childId) =>
      childrenCollection.doc(childId).collection('sleep_logs');

  Future<ApiResultStatus> addSleepLog(
    String childReferenceId,
    SleepLogModel log,
  ) async {
    try {
      final col = _childSleepCollection(childReferenceId);
      final docRef = await col.add(log.toMap());
      return ApiResultStatus.data(data: docRef.id);
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus<void>> editSleepLog(
    ChildModel child,
    SleepLogModel log,
  ) async {
    try {
      if ((log.id ?? "").isEmpty) {
        return ApiResultStatus.error(
          error: Exception('log.id required for edit'),
        );
      }
      await child.reference?.update(log.toMap());
      return ApiResultStatus.data(data: null);
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  // ---------- Delete ----------
  Future<ApiResultStatus<void>> deleteSleepLog({
    required ChildModel child,
    required String sleepLogId,
  }) async {
    try {
      if (child.reference?.id == null) {
        return ApiResultStatus.error(error: Exception('Child ID required'));
      }
      await _childSleepCollection(child.reference!.id).doc(sleepLogId).delete();
      return ApiResultStatus.data(data: null);
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus<List<SleepLogModel>>> getSleepLogsForChild(
    String childReferenceId, {
    DateTime? fromInclusive,
    DateTime? toInclusive,
  }) async {
    try {
      Query colQuery = _childSleepCollection(
        childReferenceId,
      ).orderBy('date', descending: false);

      if (fromInclusive != null) {
        final fromTs = Timestamp.fromDate(
          DateTime(fromInclusive.year, fromInclusive.month, fromInclusive.day),
        );
        colQuery = colQuery.where('date', isGreaterThanOrEqualTo: fromTs);
      }
      if (toInclusive != null) {
        final toTs = Timestamp.fromDate(
          DateTime(
            toInclusive.year,
            toInclusive.month,
            toInclusive.day,
            23,
            59,
            59,
          ),
        );
        colQuery = colQuery.where('date', isLessThanOrEqualTo: toTs);
      }

      final snap = await colQuery.get();
      if (snap.docs.isEmpty) {
        return ApiResultStatus.data(data: <SleepLogModel>[]);
      }

      final logs = snap.docs.map((d) => SleepLogModel.fromDoc(d)).toList();
      return ApiResultStatus.data(data: logs);
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  List<WeekRange> getWeeksWithLogsOffline(List<SleepLogModel> logs) {
    final Set<DateTime> weekStarts = {};

    for (final log in logs) {
      // normalize to date-only
      final dateOnly = DateTime(log.date.year, log.date.month, log.date.day);
      final sunday = _weekStartSunday(dateOnly);
      weekStarts.add(DateTime(sunday.year, sunday.month, sunday.day));
    }

    final weeks = weekStarts.toList()..sort((a, b) => a.compareTo(b));
    return weeks
        .map((sunday) => WeekRange(sunday, sunday.add(const Duration(days: 6))))
        .toList();
  }

  /// Returns total sleep hours for each weekday (Sun..Sat) for the given [week],
  /// computed from [logs] (offline). Rounds each hour value to 2 decimals.
  List<double> getWeeklySleepHoursOffline(
    List<SleepLogModel> logs,
    WeekRange week,
  ) {
    // Normalized week start date-only
    final weekStart = DateTime(
      week.start.year,
      week.start.month,
      week.start.day,
    );
    final weekEnd = DateTime(week.end.year, week.end.month, week.end.day);

    final List<double> hours = List<double>.filled(7, 0.0);

    for (final log in logs) {
      // normalize log date to date-only
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);

      if (logDate.isBefore(weekStart) || logDate.isAfter(weekEnd)) continue;

      final dayIndex = logDate.difference(weekStart).inDays;
      if (dayIndex < 0 || dayIndex > 6) continue;

      DateTime bt = log.bedTime;
      DateTime wt = log.wakeTime;

      // If wake is not after bed, assume wake happened next day
      if (!wt.isAfter(bt)) {
        wt = wt.add(const Duration(days: 1));
      }

      final duration = wt.difference(bt);
      final hoursValue = duration.inMinutes / 60.0;
      hours[dayIndex] += hoursValue;
    }

    // Round to 2 decimals
    return hours.map((h) => double.parse(h.toStringAsFixed(2))).toList();
  }

  /// Optional: ApiResultStatus wrappers for compatibility with your service pattern.
  /// These simply call the offline functions and wrap the result. Remove if you don't use ApiResultStatus.
  Future<ApiResultStatus<List<WeekRange>>> getWeeksWithLogsOffline_Result(
    List<SleepLogModel> logs,
  ) async {
    try {
      final weeks = getWeeksWithLogsOffline(logs);
      return ApiResultStatus.data(data: weeks);
    } catch (e) {
      return ApiResultStatus.error(error: Exception('Something went wrong'));
    }
  }

  Future<ApiResultStatus<List<double>>> getWeeklySleepHoursOffline_Result(
    List<SleepLogModel> logs,
    WeekRange week,
  ) async {
    try {
      final hours = getWeeklySleepHoursOffline(logs, week);
      return ApiResultStatus.data(data: hours);
    } catch (e) {
      return ApiResultStatus.error(error: Exception('Something went wrong'));
    }
  }

  /// Helper: returns the Sunday (date-only) for a given date.
  DateTime _weekStartSunday(DateTime anyDate) {
    // ensure date-only
    final dt = DateTime(anyDate.year, anyDate.month, anyDate.day);
    // Dart weekday: Mon=1 ... Sun=7
    final weekday = dt.weekday;
    final daysToSubtract = (weekday % 7); // Sunday -> 0, Monday -> 1, ...
    final sunday = dt.subtract(Duration(days: daysToSubtract));
    return DateTime(sunday.year, sunday.month, sunday.day);
  }
}
