import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';

/// Confidence tiers defined in V2 specification (04_ENERGY_BRIDGE_PREDICTION_LOGIC.md §3).
enum ConfidenceTier {
  none, // General age guide / 0 logs
  low, // 1–2 logs or disruptive context
  moderate, // 3–9 logs with pattern
  high, // 10+ consistent logs
}

/// A structured step in Tonight's Plan (Screen 25).
class TonightPlanStep {
  final String title;
  final String subtitle;
  final DateTime scheduledTime;
  final String timeLabel;

  const TonightPlanStep({
    required this.title,
    required this.subtitle,
    required this.scheduledTime,
    required this.timeLabel,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'subtitle': subtitle,
    'scheduledTime': scheduledTime.toIso8601String(),
    'timeLabel': timeLabel,
  };
}

/// The complete calculated output from Energy Bridge for Sleep Forecasting.
class SleepForecastResult {
  final String windowStart; // e.g. "07:30 PM"
  final String windowEnd; // e.g. "08:00 PM"
  final String bedtimeEstimate; // e.g. "07:45 PM"
  final DateTime bedtimeEstimateDateTime;
  final ConfidenceTier confidenceTier;
  final String confidenceLabel; // "Learning", "Low", "Moderate", "High"
  final int confidenceDots; // 0, 1, 2, 3
  final String reason;
  final String subtitle;
  final String childName;
  final int childAgeMonths;
  final List<TonightPlanStep> planSteps;
  final SleepLogModel? latestSleepLog;
  final bool hasPersonalLogs;
  final String? healthCaveat;

  const SleepForecastResult({
    required this.windowStart,
    required this.windowEnd,
    required this.bedtimeEstimate,
    required this.bedtimeEstimateDateTime,
    required this.confidenceTier,
    required this.confidenceLabel,
    required this.confidenceDots,
    required this.reason,
    required this.subtitle,
    required this.childName,
    required this.childAgeMonths,
    required this.planSteps,
    this.latestSleepLog,
    required this.hasPersonalLogs,
    this.healthCaveat,
  });

  factory SleepForecastResult.initial({String childName = 'your child'}) {
    final DateTime now = DateTime.now();
    final DateTime defaultBedtime = DateTime(
      now.year,
      now.month,
      now.day,
      20,
      0,
    );
    return SleepForecastResult(
      windowStart: '07:30 PM',
      windowEnd: '08:30 PM',
      bedtimeEstimate: '08:00 PM',
      bedtimeEstimateDateTime: defaultBedtime,
      confidenceTier: ConfidenceTier.none,
      confidenceLabel: 'Learning',
      confidenceDots: 0,
      reason:
          "This is a general guide, not $childName's own pattern. One update starts personalising it.",
      subtitle: 'General age guide. Log a sleep update to personalise.',
      childName: childName,
      childAgeMonths: 12,
      planSteps: <TonightPlanStep>[
        TonightPlanStep(
          title: 'Wind-down starts',
          subtitle: 'About 20 minutes',
          scheduledTime: defaultBedtime.subtract(const Duration(minutes: 40)),
          timeLabel: '07:20 PM',
        ),
        TonightPlanStep(
          title: 'Book in the bedroom',
          subtitle: 'About 20 minutes',
          scheduledTime: defaultBedtime.subtract(const Duration(minutes: 20)),
          timeLabel: '07:40 PM',
        ),
        TonightPlanStep(
          title: 'Lights out',
          subtitle: 'Inside recommended window',
          scheduledTime: defaultBedtime,
          timeLabel: '08:00 PM',
        ),
      ],
      hasPersonalLogs: false,
    );
  }
}

/// The Energy Bridge calculation engine for Sleep Forecasting.
///
/// Implements transparent, rule-based product logic from:
/// `v2-doc/04_ENERGY_BRIDGE_PREDICTION_LOGIC.md` and `05_APP_CONTENT_COPY_MASTER.md`.
class EnergyBridgeSleepCalculator {
  EnergyBridgeSleepCalculator._();

  /// Resolves the baseline wake window duration in minutes based on child age in months.
  static int baselineWakeWindowMinutes(int ageInMonths) {
    if (ageInMonths <= 3) {
      return 75; // 1h 15m
    } else if (ageInMonths <= 6) {
      return 120; // 2h 00m
    } else if (ageInMonths <= 9) {
      return 150; // 2h 30m
    } else if (ageInMonths <= 12) {
      return 210; // 3h 30m
    } else if (ageInMonths <= 18) {
      return 240; // 4h 00m
    } else if (ageInMonths <= 36) {
      return 300; // 5h 00m
    } else {
      return 330; // 5h 30m
    }
  }

  /// Calculates the complete Sleep Forecast given the child profile, real sleep logs,
  /// and any health flags logged today.
  static SleepForecastResult calculate({
    required ChildModel? child,
    required List<SleepLogModel> sleepLogs,
    HealthLogModel? todayHealthLog,
    DateTime? referenceNow,
  }) {
    final DateTime now = referenceNow ?? DateTime.now();
    final String? childName = child?.childName?.trim();
    final String cName = (childName != null && childName.isNotEmpty)
        ? childName
        : 'your child';

    // 1. Resolve child age in months
    final int ageMonths = AgeUtils.resolvedAgeInMonths(
      dob: child?.childDob,
      legacyAgeText: child?.childAge ?? '',
    );
    final int effectiveAgeMonths = ageMonths > 0 ? ageMonths : 12;

    // 2. Check if any personal logs exist
    if (sleepLogs.isEmpty) {
      final DateTime defaultBedtime = _resolveBaselineBedtime(
        now: now,
        child: child,
        effectiveAgeMonths: effectiveAgeMonths,
      );
      final DateFormat timeFormat = DateFormat('h:mm a');
      final String ageLabel = AgeUtils.ageLabelFromMonths(effectiveAgeMonths);
      final String ageQualifier = ageLabel.isNotEmpty ? 'for $ageLabel' : '';
      final String bedtimeFormatted = timeFormat.format(defaultBedtime);
      final DateTime windowStartDt = defaultBedtime.subtract(
        const Duration(minutes: 30),
      );
      final DateTime windowEndDt = defaultBedtime.add(
        const Duration(minutes: 30),
      );

      final bool hasFever =
          todayHealthLog != null &&
          todayHealthLog.issues.any(
            (String issue) =>
                issue.toLowerCase().contains("fever") ||
                issue.toLowerCase().contains("breath") ||
                issue.toLowerCase().contains("illness"),
          );

      final String subtitle = hasFever
          ? 'Fever logged today. Rest and comfort matter most right now.'
          : 'Typical $ageQualifier: bedtime around $bedtimeFormatted. Log a sleep update to personalise.';
      final String reason = hasFever
          ? 'Health context noted: Rest and comfort matter most right now.'
          : "This is a general guide, not $cName's own pattern. One update starts personalising it.";

      return SleepForecastResult(
        windowStart: timeFormat.format(windowStartDt),
        windowEnd: timeFormat.format(windowEndDt),
        bedtimeEstimate: bedtimeFormatted,
        bedtimeEstimateDateTime: defaultBedtime,
        confidenceTier: ConfidenceTier.none,
        confidenceLabel: 'Learning',
        confidenceDots: 0,
        reason: reason,
        subtitle: subtitle,
        childName: cName,
        childAgeMonths: effectiveAgeMonths,
        planSteps: _buildPlanSteps(defaultBedtime),
        hasPersonalLogs: false,
        healthCaveat: hasFever
            ? 'Health context noted: adjusted because ${todayHealthLog.issues.join(", ")} was logged today.'
            : null,
      );
    }

    // 3. Find latest sleep log and today's logs
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateTime todayMidnight = DateTime(now.year, now.month, now.day);

    // Sort logs descending by wakeTime
    final List<SleepLogModel> sortedLogs = List<SleepLogModel>.from(sleepLogs)
      ..sort(
        (SleepLogModel a, SleepLogModel b) => b.wakeTime.compareTo(a.wakeTime),
      );

    final SleepLogModel latestLog = sortedLogs.first;

    // Identify if there is a nap logged today
    SleepLogModel? todayNap;
    for (final SleepLogModel log in sortedLogs) {
      if (log.wakeTime.isAfter(todayMidnight)) {
        // Daytime sleep session (nap): ended before 6:30 PM and was not marked as overnight waking
        final int wakeHour = log.wakeTime.hour;
        if (wakeHour >= 9 && wakeHour <= 18) {
          todayNap = log;
          break;
        }
      }
    }

    // 4. Calculate anchor time & wake window shift
    final int baseWakeWindow = baselineWakeWindowMinutes(effectiveAgeMonths);
    int adjustedWakeWindow = baseWakeWindow;
    DateTime anchorTime;
    String reasonText;
    int shortNapDiff = 0;

    if (todayNap != null) {
      anchorTime = todayNap.wakeTime;
      final int napDuration =
          todayNap.durationMinutes ??
          todayNap.wakeTime.difference(todayNap.bedTime).inMinutes;

      // Expected nap for age is ~90 minutes
      const int expectedNapMinutes = 90;
      if (napDuration < 45) {
        // Short nap: tiredness builds earlier -> shift window 25 mins earlier
        shortNapDiff = expectedNapMinutes - napDuration;
        adjustedWakeWindow = (baseWakeWindow - 25).clamp(60, 600);
        reasonText =
            "$cName woke at ${timeFormat.format(anchorTime)} and today's nap ran about $shortNapDiff minutes short, so tiredness is building a little earlier than usual.";
      } else if (napDuration > 120) {
        // Long nap: evening pushed later -> shift window 25 mins later
        adjustedWakeWindow = baseWakeWindow + 25;
        reasonText =
            "$cName woke at ${timeFormat.format(anchorTime)} from a longer nap, so the evening settling window is pushed a little later.";
      } else {
        // Normal nap
        reasonText =
            "$cName woke at ${timeFormat.format(anchorTime)} from rest. Evening settling window follows natural wake pressure.";
      }
    } else {
      // No nap today yet: use latest log or morning wake
      anchorTime = latestLog.wakeTime;
      final bool wokeToday = anchorTime.isAfter(todayMidnight);
      if (wokeToday) {
        reasonText =
            "$cName woke at ${timeFormat.format(anchorTime)}. Evening bedtime reflects today's wake rhythm.";
      } else {
        // Anchored to baseline morning wake (7:00 AM today)
        anchorTime = DateTime(now.year, now.month, now.day, 7, 0);
        reasonText =
            "Based on $cName's recent sleep pattern over the last ${sortedLogs.length} logged sessions.";
      }
    }

    // 5. Compute target bedtime estimate
    DateTime targetBedtime;
    if (todayNap != null) {
      targetBedtime = anchorTime.add(Duration(minutes: adjustedWakeWindow));
    } else {
      // When no nap has occurred today, estimate bedtime using recent night sleep logs or baseline bedtime
      final List<SleepLogModel> nightLogs = sortedLogs
          .where((SleepLogModel l) => !l.isNap)
          .take(5)
          .toList();
      if (nightLogs.isNotEmpty) {
        int totalMinutes = 0;
        for (final SleepLogModel l in nightLogs) {
          totalMinutes += l.bedTime.hour * 60 + l.bedTime.minute;
        }
        final int avgMinutes = (totalMinutes / nightLogs.length).round();
        targetBedtime = DateTime(
          now.year,
          now.month,
          now.day,
          avgMinutes ~/ 60,
          avgMinutes % 60,
        );
      } else {
        targetBedtime = _resolveBaselineBedtime(
          now: now,
          child: child,
          effectiveAgeMonths: effectiveAgeMonths,
        );
      }
    }

    // If the anchored estimate is outside a sensible evening range, fall back
    // to the child's usual bedtime and keep confidence honest (Doc 04 §2).
    final DateTime softMinBedtime = DateTime(
      now.year,
      now.month,
      now.day,
      17,
      0,
    );
    final DateTime softMaxBedtime = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      0,
    );
    bool usedFallbackBedtime = false;
    if (targetBedtime.isBefore(softMinBedtime) ||
        targetBedtime.isAfter(softMaxBedtime)) {
      targetBedtime = _resolveBaselineBedtime(
        now: now,
        child: child,
        effectiveAgeMonths: effectiveAgeMonths,
      );
      usedFallbackBedtime = true;
      if (shortNapDiff > 0) {
        reasonText =
            "$cName's nap ran about $shortNapDiff minutes short, so tonight's estimate is still wide. Using $cName's usual bedtime as a guide rather than a precise early window.";
      } else {
        reasonText =
            "Tonight's estimate is still wide — recent wake timing sits outside a typical evening window, so we are using $cName's usual bedtime as a guide.";
      }
    }

    // 6. Evaluate confidence level and health caveats
    final int logCount = sortedLogs.length;
    ConfidenceTier confidence;
    int confidenceDots;

    if (logCount < 3) {
      confidence = ConfidenceTier.low;
      confidenceDots = 1;
    } else if (logCount < 10) {
      confidence = ConfidenceTier.moderate;
      confidenceDots = 2;
    } else {
      confidence = ConfidenceTier.high;
      confidenceDots = 3;
    }

    if (usedFallbackBedtime && confidence == ConfidenceTier.high) {
      confidence = ConfidenceTier.moderate;
      confidenceDots = 2;
    } else if (usedFallbackBedtime && confidence == ConfidenceTier.moderate) {
      confidence = ConfidenceTier.low;
      confidenceDots = 1;
    }

    // Health context downgrade: illness/teething reduces confidence and widens window
    String? healthCaveat;
    if (todayHealthLog != null && todayHealthLog.issues.isNotEmpty) {
      final String issuesList = todayHealthLog.issues.join(', ');
      healthCaveat =
          'Health context noted: adjusted because $issuesList was logged today.';

      if (confidence == ConfidenceTier.high) {
        confidence = ConfidenceTier.moderate;
        confidenceDots = 2;
      } else if (confidence == ConfidenceTier.moderate) {
        confidence = ConfidenceTier.low;
        confidenceDots = 1;
      }
    }

    // Inconsistent night routine detection (Doc 04 §2, Doc 06 §3)
    bool isInconsistentPattern = false;
    if (sortedLogs.length >= 3) {
      final List<int> recentBedMinutes = <int>[];
      for (final SleepLogModel log in sortedLogs.take(5)) {
        recentBedMinutes.add(log.bedTime.hour * 60 + log.bedTime.minute);
      }
      final int minBed = recentBedMinutes.reduce(
        (int a, int b) => a < b ? a : b,
      );
      final int maxBed = recentBedMinutes.reduce(
        (int a, int b) => a > b ? a : b,
      );
      if ((maxBed - minBed) >= 75) {
        isInconsistentPattern = true;
        if (confidence == ConfidenceTier.high) {
          confidence = ConfidenceTier.moderate;
          confidenceDots = 2;
        } else if (confidence == ConfidenceTier.moderate) {
          confidence = ConfidenceTier.low;
          confidenceDots = 1;
        }
      }
    }

    // 7. Calculate window spread based on confidence tier
    int halfSpreadMinutes;
    switch (confidence) {
      case ConfidenceTier.high:
        halfSpreadMinutes = 15; // 30 min window
        break;
      case ConfidenceTier.moderate:
        halfSpreadMinutes = 20; // 40 min window
        break;
      case ConfidenceTier.low:
      case ConfidenceTier.none:
        halfSpreadMinutes = 30; // 60 min window
        break;
    }

    // Illness, travel, or scattered sleep widens the window (Doc 04 §2, Doc 06 §3)
    if (healthCaveat != null || isInconsistentPattern) {
      halfSpreadMinutes += 15;
    }

    final DateTime windowStartTime = targetBedtime.subtract(
      Duration(minutes: halfSpreadMinutes),
    );
    final DateTime windowEndTime = targetBedtime.add(
      Duration(minutes: halfSpreadMinutes),
    );

    final String confidenceLabelText = switch (confidence) {
      ConfidenceTier.high => 'High',
      ConfidenceTier.moderate => 'Moderate',
      ConfidenceTier.low => 'Low',
      ConfidenceTier.none => 'Learning',
    };

    final String bedtimeStr = timeFormat.format(targetBedtime);
    final String startStr = timeFormat.format(windowStartTime);
    final String endStr = timeFormat.format(windowEndTime);

    final String subtitleText = shortNapDiff > 0
        ? "Bedtime estimate $bedtimeStr. Today's nap ran about $shortNapDiff minutes short."
        : 'Bedtime estimate $bedtimeStr. $confidenceLabelText confidence.';

    return SleepForecastResult(
      windowStart: startStr,
      windowEnd: endStr,
      bedtimeEstimate: bedtimeStr,
      bedtimeEstimateDateTime: targetBedtime,
      confidenceTier: confidence,
      confidenceLabel: confidenceLabelText,
      confidenceDots: confidenceDots,
      reason: reasonText,
      subtitle: subtitleText,
      childName: cName,
      childAgeMonths: effectiveAgeMonths,
      planSteps: _buildPlanSteps(targetBedtime),
      latestSleepLog: latestLog,
      hasPersonalLogs: true,
      healthCaveat: healthCaveat,
    );
  }

  /// Resolves the baseline bedtime from child onboarding values or age band norms.
  static DateTime _resolveBaselineBedtime({
    required DateTime now,
    required ChildModel? child,
    required int effectiveAgeMonths,
  }) {
    final String? usualBed = child?.usualBedtime?.trim();
    if (usualBed != null && usualBed.isNotEmpty) {
      try {
        final DateFormat fmt12 = DateFormat('h:mm a');
        final DateTime parsed = fmt12.parse(usualBed);
        return DateTime(
          now.year,
          now.month,
          now.day,
          parsed.hour,
          parsed.minute,
        );
      } catch (_) {
        try {
          final DateFormat fmt24 = DateFormat('HH:mm');
          final DateTime parsed = fmt24.parse(usualBed);
          return DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
          );
        } catch (_) {}
      }
    }

    // Age band baseline (Doc 04 §2)
    if (effectiveAgeMonths <= 3) {
      return DateTime(now.year, now.month, now.day, 20, 30); // 8:30 PM
    } else if (effectiveAgeMonths <= 11) {
      return DateTime(now.year, now.month, now.day, 19, 15); // 7:15 PM
    } else if (effectiveAgeMonths <= 24) {
      return DateTime(now.year, now.month, now.day, 19, 30); // 7:30 PM
    } else if (effectiveAgeMonths <= 48) {
      return DateTime(now.year, now.month, now.day, 19, 45); // 7:45 PM
    } else {
      return DateTime(now.year, now.month, now.day, 20, 0); // 8:00 PM
    }
  }

  /// Generates the standard 3-step pre-sleep sequence for Tonight's Plan (Screen 25).
  static List<TonightPlanStep> _buildPlanSteps(DateTime bedtime) {
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateTime step1Time = bedtime.subtract(const Duration(minutes: 40));
    final DateTime step2Time = bedtime.subtract(const Duration(minutes: 20));

    return <TonightPlanStep>[
      TonightPlanStep(
        title: 'Wind-down starts',
        subtitle: 'About 20 minutes',
        scheduledTime: step1Time,
        timeLabel: timeFormat.format(step1Time),
      ),
      TonightPlanStep(
        title: 'Book in the bedroom',
        subtitle: 'About 20 minutes',
        scheduledTime: step2Time,
        timeLabel: timeFormat.format(step2Time),
      ),
      TonightPlanStep(
        title: 'Lights out',
        subtitle: 'Inside recommended window',
        scheduledTime: bedtime,
        timeLabel: timeFormat.format(bedtime),
      ),
    ];
  }
}
