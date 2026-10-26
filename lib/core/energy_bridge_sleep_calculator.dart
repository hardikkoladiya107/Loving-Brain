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
      final DateTime defaultBedtime = DateTime(
        now.year,
        now.month,
        now.day,
        20,
        0,
      );
      final String ageLabel = AgeUtils.ageLabelFromMonths(effectiveAgeMonths);
      final String ageQualifier = ageLabel.isNotEmpty ? 'for $ageLabel' : '';

      return SleepForecastResult(
        windowStart: '07:30 PM',
        windowEnd: '08:30 PM',
        bedtimeEstimate: '08:00 PM',
        bedtimeEstimateDateTime: defaultBedtime,
        confidenceTier: ConfidenceTier.none,
        confidenceLabel: 'Learning',
        confidenceDots: 0,
        reason:
            "This is a general guide, not $cName's own pattern. One update starts personalising it.",
        subtitle:
            'Typical $ageQualifier: bedtime around 8 PM. Log a sleep update to personalise.',
        childName: cName,
        childAgeMonths: effectiveAgeMonths,
        planSteps: _buildPlanSteps(defaultBedtime),
        hasPersonalLogs: false,
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
    // Anchor to today's evening: anchorTime + adjustedWakeWindow
    DateTime targetBedtime = anchorTime.add(
      Duration(minutes: adjustedWakeWindow),
    );

    // Normalize bedtime to be between 6:30 PM and 9:30 PM today
    final DateTime minBedtime = DateTime(now.year, now.month, now.day, 18, 30);
    final DateTime maxBedtime = DateTime(now.year, now.month, now.day, 21, 30);
    if (targetBedtime.isBefore(minBedtime)) {
      targetBedtime = minBedtime;
    } else if (targetBedtime.isAfter(maxBedtime)) {
      targetBedtime = maxBedtime;
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
