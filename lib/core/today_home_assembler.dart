import 'package:intl/intl.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';

/// Assembled Today home output from Energy Bridge sleep + behaviour engines.
/// Widgets render these fields; they do not invent copy.
class TodayHomeSnapshot {
  const TodayHomeSnapshot({
    required this.mode,
    required this.sleepForecastStart,
    required this.sleepForecastEnd,
    required this.bedtimeEstimate,
    required this.forecastSubtitle,
    required this.confidenceLevel,
    required this.confidenceDots,
    required this.sleepForecastReason,
    required this.hasSleepLogs,
    required this.hasMultiDayPatterns,
    required this.hasAnyLogs,
    required this.loggedDaysCount,
    required this.showHealthHeadsUp,
    required this.healthHeadsUpTitle,
    required this.healthHeadsUpSubtitle,
    required this.showBehaviourHeadsUp,
    required this.headsUpHeadline,
    required this.headsUpReason,
    required this.headsUpWindowStart,
    required this.headsUpWindowEnd,
    required this.showNiceWork,
    required this.niceWorkTitle,
    required this.niceWorkSubtitle,
    required this.showNoticed,
    required this.noticedTitle,
    required this.noticedDestination,
    required this.showSupportOffer,
    required this.supportInconsistentDays,
    required this.onboardingFocusLine,
    required this.prioritiseSleepFirst,
  });

  final TodayMode mode;
  final String sleepForecastStart;
  final String sleepForecastEnd;
  final String bedtimeEstimate;
  final String forecastSubtitle;
  final String confidenceLevel;
  final int confidenceDots;
  final String sleepForecastReason;
  final bool hasSleepLogs;
  final bool hasMultiDayPatterns;
  final bool hasAnyLogs;
  final int loggedDaysCount;

  final bool showHealthHeadsUp;
  final String healthHeadsUpTitle;
  final String healthHeadsUpSubtitle;

  final bool showBehaviourHeadsUp;
  final String headsUpHeadline;
  final String headsUpReason;
  final String headsUpWindowStart;
  final String headsUpWindowEnd;

  final bool showNiceWork;
  final String niceWorkTitle;
  final String niceWorkSubtitle;

  final bool showNoticed;
  final String noticedTitle;
  final TodayNoticedDestination noticedDestination;

  final bool showSupportOffer;
  final int supportInconsistentDays;

  final String onboardingFocusLine;
  final bool prioritiseSleepFirst;

  Map<String, dynamic> toCacheMap() {
    return <String, dynamic>{
      'mode': mode.name,
      'sleepForecastStart': sleepForecastStart,
      'sleepForecastEnd': sleepForecastEnd,
      'bedtimeEstimate': bedtimeEstimate,
      'forecastSubtitle': forecastSubtitle,
      'confidenceLevel': confidenceLevel,
      'confidenceDots': confidenceDots,
      'sleepForecastReason': sleepForecastReason,
      'hasSleepLogs': hasSleepLogs,
      'hasMultiDayPatterns': hasMultiDayPatterns,
      'hasAnyLogs': hasAnyLogs,
      'loggedDaysCount': loggedDaysCount,
      'showHealthHeadsUp': showHealthHeadsUp,
      'healthHeadsUpTitle': healthHeadsUpTitle,
      'healthHeadsUpSubtitle': healthHeadsUpSubtitle,
      'showBehaviourHeadsUp': showBehaviourHeadsUp,
      'headsUpHeadline': headsUpHeadline,
      'headsUpReason': headsUpReason,
      'headsUpWindowStart': headsUpWindowStart,
      'headsUpWindowEnd': headsUpWindowEnd,
      'showNiceWork': showNiceWork,
      'niceWorkTitle': niceWorkTitle,
      'niceWorkSubtitle': niceWorkSubtitle,
      'showNoticed': showNoticed,
      'noticedTitle': noticedTitle,
      'noticedDestination': noticedDestination.name,
      'showSupportOffer': showSupportOffer,
      'supportInconsistentDays': supportInconsistentDays,
      'onboardingFocusLine': onboardingFocusLine,
      'prioritiseSleepFirst': prioritiseSleepFirst,
    };
  }

  factory TodayHomeSnapshot.fromCacheMap(Map<String, dynamic> map) {
    final String modeName =
        (map['mode'] as String?) ?? TodayMode.newParent.name;
    final TodayMode mode = TodayMode.values.firstWhere(
      (TodayMode m) => m.name == modeName,
      orElse: () => TodayMode.newParent,
    );
    final String destName =
        (map['noticedDestination'] as String?) ??
        TodayNoticedDestination.none.name;
    final TodayNoticedDestination dest = TodayNoticedDestination.values
        .firstWhere(
          (TodayNoticedDestination d) => d.name == destName,
          orElse: () => TodayNoticedDestination.none,
        );
    return TodayHomeSnapshot(
      mode: mode,
      sleepForecastStart: (map['sleepForecastStart'] as String?) ?? '--:--',
      sleepForecastEnd: (map['sleepForecastEnd'] as String?) ?? '--:--',
      bedtimeEstimate: (map['bedtimeEstimate'] as String?) ?? '--:--',
      forecastSubtitle: (map['forecastSubtitle'] as String?) ?? '',
      confidenceLevel: (map['confidenceLevel'] as String?) ?? 'none',
      confidenceDots: (map['confidenceDots'] as int?) ?? 0,
      sleepForecastReason: (map['sleepForecastReason'] as String?) ?? '',
      hasSleepLogs: (map['hasSleepLogs'] as bool?) ?? false,
      hasMultiDayPatterns: (map['hasMultiDayPatterns'] as bool?) ?? false,
      hasAnyLogs: (map['hasAnyLogs'] as bool?) ?? false,
      loggedDaysCount: (map['loggedDaysCount'] as int?) ?? 0,
      showHealthHeadsUp: (map['showHealthHeadsUp'] as bool?) ?? false,
      healthHeadsUpTitle: (map['healthHeadsUpTitle'] as String?) ?? '',
      healthHeadsUpSubtitle: (map['healthHeadsUpSubtitle'] as String?) ?? '',
      showBehaviourHeadsUp: (map['showBehaviourHeadsUp'] as bool?) ?? false,
      headsUpHeadline: (map['headsUpHeadline'] as String?) ?? '',
      headsUpReason: (map['headsUpReason'] as String?) ?? '',
      headsUpWindowStart: (map['headsUpWindowStart'] as String?) ?? '',
      headsUpWindowEnd: (map['headsUpWindowEnd'] as String?) ?? '',
      showNiceWork: (map['showNiceWork'] as bool?) ?? false,
      niceWorkTitle: (map['niceWorkTitle'] as String?) ?? '',
      niceWorkSubtitle: (map['niceWorkSubtitle'] as String?) ?? '',
      showNoticed: (map['showNoticed'] as bool?) ?? false,
      noticedTitle: (map['noticedTitle'] as String?) ?? '',
      noticedDestination: dest,
      showSupportOffer: (map['showSupportOffer'] as bool?) ?? false,
      supportInconsistentDays: (map['supportInconsistentDays'] as int?) ?? 0,
      onboardingFocusLine: (map['onboardingFocusLine'] as String?) ?? '',
      prioritiseSleepFirst: (map['prioritiseSleepFirst'] as bool?) ?? true,
    );
  }
}

/// Builds the Today home from sleep + behaviour engines (screens 12–15).
class TodayHomeAssembler {
  TodayHomeAssembler._();

  static const int supportCoolingOffDays = 7;
  static const int bedtimeSpreadThresholdMinutes = 75;
  static const int easierBedtimeToleranceMinutes = 30;
  static const int napShorteningThresholdMinutes = 15;

  static TodayHomeSnapshot assemble({
    required ChildModel? child,
    required SleepForecastResult sleepForecast,
    required BehaviourForecastResult behaviourForecast,
    required List<SleepLogModel> sleepLogs,
    required List<TantrumLogModel> tantrumLogs,
    HealthLogModel? todayHealthLog,
    DateTime? referenceNow,
    DateTime? supportDismissedAt,
  }) {
    final DateTime now = referenceNow ?? DateTime.now();
    final Set<String> loggedDates = <String>{};
    for (final SleepLogModel log in sleepLogs) {
      final DateTime d = log.date;
      loggedDates.add('${d.year}-${d.month}-${d.day}');
    }
    final int loggedDaysCount = loggedDates.length;
    final bool hasMultiDayPatterns = loggedDaysCount >= 3;
    final bool hasSleepLogs = sleepForecast.hasPersonalLogs;
    final bool hasAnyLogs =
        sleepLogs.isNotEmpty ||
        tantrumLogs.isNotEmpty ||
        todayHealthLog != null;

    final bool showHealthHeadsUp = _isNotableHealth(todayHealthLog);
    final String healthTitle = showHealthHeadsUp ? 'Health check-in noted' : '';
    final String healthSubtitle = showHealthHeadsUp
        ? 'Symptoms logged today. Rest and comfort matter most right now.'
        : '';

    final bool windowStillAhead = _isBehaviourWindowStillAhead(
      behaviourForecast: behaviourForecast,
      now: now,
    );
    final bool showBehaviourHeadsUp =
        behaviourForecast.isPushWorthy && windowStillAhead;

    final TodayMode mode;
    if (!hasSleepLogs) {
      mode = TodayMode.newParent;
    } else if (showBehaviourHeadsUp) {
      mode = TodayMode.importantHeadsUp;
    } else {
      mode = TodayMode.normal;
    }

    final _NiceWorkResult niceWork = _computeNiceWork(
      sleepLogs: sleepLogs,
      child: child,
      now: now,
      hasMultiDayPatterns: hasMultiDayPatterns,
    );
    final _NoticedResult noticed = _computeNoticed(
      sleepLogs: sleepLogs,
      tantrumLogs: tantrumLogs,
      hasMultiDayPatterns: hasMultiDayPatterns,
      now: now,
    );

    final _SupportResult support = _computeSupportOffer(
      sleepLogs: sleepLogs,
      loggedDaysCount: loggedDaysCount,
      supportDismissedAt: supportDismissedAt,
      now: now,
    );

    final String concern = (child?.primaryConcern ?? '').trim().toLowerCase();
    final bool prioritiseSleepFirst =
        concern.isEmpty ||
        concern.contains('sleep') ||
        concern.contains('bedtime') ||
        concern.contains('night');
    final String focusLine = !hasSleepLogs && concern.isNotEmpty
        ? 'Focusing on ${child!.primaryConcern!.trim()} first.'
        : '';

    return TodayHomeSnapshot(
      mode: mode,
      sleepForecastStart: sleepForecast.windowStart,
      sleepForecastEnd: sleepForecast.windowEnd,
      bedtimeEstimate: sleepForecast.bedtimeEstimate,
      forecastSubtitle: sleepForecast.subtitle,
      confidenceLevel: sleepForecast.confidenceLabel.toLowerCase(),
      confidenceDots: sleepForecast.confidenceDots,
      sleepForecastReason: sleepForecast.reason,
      hasSleepLogs: hasSleepLogs,
      hasMultiDayPatterns: hasMultiDayPatterns,
      hasAnyLogs: hasAnyLogs,
      loggedDaysCount: loggedDaysCount,
      showHealthHeadsUp: showHealthHeadsUp,
      healthHeadsUpTitle: healthTitle,
      healthHeadsUpSubtitle: healthSubtitle,
      showBehaviourHeadsUp: showBehaviourHeadsUp,
      headsUpHeadline: showBehaviourHeadsUp ? behaviourForecast.headline : '',
      headsUpReason: showBehaviourHeadsUp ? behaviourForecast.reason : '',
      headsUpWindowStart: showBehaviourHeadsUp
          ? behaviourForecast.windowStart
          : '',
      headsUpWindowEnd: showBehaviourHeadsUp ? behaviourForecast.windowEnd : '',
      showNiceWork: niceWork.show,
      niceWorkTitle: niceWork.title,
      niceWorkSubtitle: niceWork.subtitle,
      showNoticed: noticed.show,
      noticedTitle: noticed.title,
      noticedDestination: noticed.destination,
      showSupportOffer: support.show,
      supportInconsistentDays: support.inconsistentDays,
      onboardingFocusLine: focusLine,
      prioritiseSleepFirst: prioritiseSleepFirst,
    );
  }

  static bool _isNotableHealth(HealthLogModel? health) {
    if (health == null || health.issues.isEmpty) {
      return false;
    }
    return health.issues.any((String issue) {
      final String lower = issue.toLowerCase();
      return lower.contains('fever') ||
          lower.contains('breath') ||
          lower.contains('illness');
    });
  }

  static bool _isBehaviourWindowStillAhead({
    required BehaviourForecastResult behaviourForecast,
    required DateTime now,
  }) {
    if (!behaviourForecast.isPushWorthy) {
      return false;
    }
    try {
      final DateFormat format12 = DateFormat('h:mm a');
      final DateTime endParsed = format12.parse(
        behaviourForecast.windowEnd.trim(),
      );
      final DateTime end = DateTime(
        now.year,
        now.month,
        now.day,
        endParsed.hour,
        endParsed.minute,
      );
      return end.isAfter(now);
    } catch (_) {
      return true;
    }
  }

  static _NiceWorkResult _computeNiceWork({
    required List<SleepLogModel> sleepLogs,
    required ChildModel? child,
    required DateTime now,
    required bool hasMultiDayPatterns,
  }) {
    if (!hasMultiDayPatterns) {
      return const _NiceWorkResult(show: false, title: '', subtitle: '');
    }

    final List<SleepLogModel> nights =
        sleepLogs.where((SleepLogModel l) => !l.isNap).toList()..sort(
          (SleepLogModel a, SleepLogModel b) => b.bedTime.compareTo(a.bedTime),
        );

    if (nights.length < 3) {
      return const _NiceWorkResult(show: false, title: '', subtitle: '');
    }

    final int targetMinutes = _resolveUsualBedtimeMinutes(
      child: child,
      nights: nights,
    );

    int streak = 0;
    DateTime? previousNightDate;
    for (final SleepLogModel night in nights) {
      final DateTime nightDay = DateTime(
        night.bedTime.year,
        night.bedTime.month,
        night.bedTime.day,
      );
      if (previousNightDate != null) {
        final int gap = previousNightDate.difference(nightDay).inDays;
        if (gap != 1) {
          break;
        }
      }
      previousNightDate = nightDay;

      final int bedMinutes = night.bedTime.hour * 60 + night.bedTime.minute;
      final int delta = (bedMinutes - targetMinutes).abs();
      final bool easier =
          !night.isNightWaking && delta <= easierBedtimeToleranceMinutes;
      if (!easier) {
        break;
      }
      streak++;
      if (streak >= 3) {
        break;
      }
    }

    if (streak < 3) {
      return const _NiceWorkResult(show: false, title: '', subtitle: '');
    }

    return const _NiceWorkResult(
      show: true,
      title: 'Three nights of easier bedtime in a row',
      subtitle: 'Nice work — this is a pattern worth noticing.',
    );
  }

  static int _resolveUsualBedtimeMinutes({
    required ChildModel? child,
    required List<SleepLogModel> nights,
  }) {
    final String? usual = child?.usualBedtime?.trim();
    if (usual != null && usual.isNotEmpty) {
      try {
        final DateFormat fmt12 = DateFormat('h:mm a');
        final DateTime parsed = fmt12.parse(usual);
        return parsed.hour * 60 + parsed.minute;
      } catch (_) {
        try {
          final DateFormat fmt24 = DateFormat('HH:mm');
          final DateTime parsed = fmt24.parse(usual);
          return parsed.hour * 60 + parsed.minute;
        } catch (_) {}
      }
    }

    final List<int> minutes =
        nights
            .take(7)
            .map((SleepLogModel n) => n.bedTime.hour * 60 + n.bedTime.minute)
            .toList()
          ..sort();
    if (minutes.isEmpty) {
      return 19 * 60 + 30;
    }
    return minutes[minutes.length ~/ 2];
  }

  static _NoticedResult _computeNoticed({
    required List<SleepLogModel> sleepLogs,
    required List<TantrumLogModel> tantrumLogs,
    required bool hasMultiDayPatterns,
    required DateTime now,
  }) {
    if (!hasMultiDayPatterns) {
      return const _NoticedResult(
        show: false,
        title: '',
        destination: TodayNoticedDestination.none,
      );
    }

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime thisWeekStart = today.subtract(const Duration(days: 6));
    final DateTime lastWeekStart = today.subtract(const Duration(days: 13));
    final DateTime lastWeekEnd = today.subtract(const Duration(days: 7));

    final List<SleepLogModel> thisWeekNaps = sleepLogs.where((SleepLogModel l) {
      if (!l.isNap) {
        return false;
      }
      final DateTime d = DateTime(l.date.year, l.date.month, l.date.day);
      return !d.isBefore(thisWeekStart) && !d.isAfter(today);
    }).toList();

    final List<SleepLogModel> lastWeekNaps = sleepLogs.where((SleepLogModel l) {
      if (!l.isNap) {
        return false;
      }
      final DateTime d = DateTime(l.date.year, l.date.month, l.date.day);
      return !d.isBefore(lastWeekStart) && !d.isAfter(lastWeekEnd);
    }).toList();

    if (thisWeekNaps.isNotEmpty && lastWeekNaps.isNotEmpty) {
      final double thisAvg = _averageDurationMinutes(thisWeekNaps);
      final double lastAvg = _averageDurationMinutes(lastWeekNaps);
      final int shortening = (lastAvg - thisAvg).round();
      if (shortening >= napShorteningThresholdMinutes) {
        return _NoticedResult(
          show: true,
          title: 'Naps have been $shortening minutes shorter this week',
          destination: TodayNoticedDestination.sleepPattern,
        );
      }
    }

    if (tantrumLogs.length >= 3) {
      final BehaviourPatternSummary summary =
          EnergyBridgeBehaviourCalculator.aggregatePattern(
            logs: tantrumLogs,
            childName: 'your child',
          );
      if (summary.insightText.trim().isNotEmpty) {
        return _NoticedResult(
          show: true,
          title: summary.insightText,
          destination: TodayNoticedDestination.behaviourPattern,
        );
      }
    }

    return const _NoticedResult(
      show: false,
      title: '',
      destination: TodayNoticedDestination.none,
    );
  }

  static double _averageDurationMinutes(List<SleepLogModel> logs) {
    if (logs.isEmpty) {
      return 0;
    }
    int total = 0;
    for (final SleepLogModel log in logs) {
      total +=
          log.durationMinutes ?? log.wakeTime.difference(log.bedTime).inMinutes;
    }
    return total / logs.length;
  }

  static _SupportResult _computeSupportOffer({
    required List<SleepLogModel> sleepLogs,
    required int loggedDaysCount,
    required DateTime? supportDismissedAt,
    required DateTime now,
  }) {
    if (loggedDaysCount < 3) {
      return const _SupportResult(show: false, inconsistentDays: 0);
    }
    if (supportDismissedAt != null) {
      final Duration since = now.difference(supportDismissedAt);
      if (since.inDays < supportCoolingOffDays) {
        return const _SupportResult(show: false, inconsistentDays: 0);
      }
    }

    final List<SleepLogModel> nights = sleepLogs
        .where((SleepLogModel l) => !l.isNap)
        .toList();
    if (nights.length < 3) {
      return const _SupportResult(show: false, inconsistentDays: 0);
    }

    final List<int> bedMinutes = <int>[];
    final Set<String> nightDates = <String>{};
    for (final SleepLogModel night in nights.take(7)) {
      bedMinutes.add(night.bedTime.hour * 60 + night.bedTime.minute);
      nightDates.add(
        '${night.date.year}-${night.date.month}-${night.date.day}',
      );
    }
    if (bedMinutes.length < 3) {
      return const _SupportResult(show: false, inconsistentDays: 0);
    }
    final int minBed = bedMinutes.reduce((int a, int b) => a < b ? a : b);
    final int maxBed = bedMinutes.reduce((int a, int b) => a > b ? a : b);
    if ((maxBed - minBed) < bedtimeSpreadThresholdMinutes) {
      return const _SupportResult(show: false, inconsistentDays: 0);
    }

    return _SupportResult(
      show: true,
      inconsistentDays: nightDates.length.clamp(3, 14),
    );
  }

  static String supportDismissalKey(String childId) {
    return 'today_support_dismissed_$childId';
  }

  static String homeCacheKey(String childId) {
    return 'today_home_snapshot_$childId';
  }
}

class _NiceWorkResult {
  const _NiceWorkResult({
    required this.show,
    required this.title,
    required this.subtitle,
  });

  final bool show;
  final String title;
  final String subtitle;
}

class _NoticedResult {
  const _NoticedResult({
    required this.show,
    required this.title,
    required this.destination,
  });

  final bool show;
  final String title;
  final TodayNoticedDestination destination;
}

class _SupportResult {
  const _SupportResult({required this.show, required this.inconsistentDays});

  final bool show;
  final int inconsistentDays;
}
