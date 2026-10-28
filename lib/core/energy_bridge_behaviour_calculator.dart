import 'package:intl/intl.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';

/// Tantrum / Behaviour risk level (internal engine score).
enum BehaviourRiskLevel { none, low, moderate, high }

/// A structured action step in a Calm Plan (Screen 29).
class CalmPlanAction {
  final String stepNumber;
  final String title;
  final String description;

  const CalmPlanAction({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'stepNumber': stepNumber,
    'title': title,
    'description': description,
  };
}

/// The complete calculated output from Energy Bridge for Calm Heads-Up & Behaviour (Screens 28–30).
class BehaviourForecastResult {
  final BehaviourRiskLevel riskLevel;
  final ConfidenceTier confidenceTier;
  final String confidenceLabel; // "General guide", "Low", "Moderate", "High"
  final int confidenceDots; // 0, 1, 2, 3
  final String windowStart; // e.g. "5:30 PM"
  final String windowEnd; // e.g. "7:00 PM"
  final String headline; // "A harder window may be more likely"
  final String
  reason; // "Between 5:30 and 7:00 PM — a skipped nap and late afternoon fatigue today."
  final List<String> contributingSignals;
  final List<CalmPlanAction> actions;
  final String avoidInstructionTitle;
  final String avoidInstructionSubtitle;
  final String childName;
  final int childAgeMonths;
  final String? healthCaveat;
  final bool hasPersonalLogs;

  /// Returns true only when at least 2 real signals support a push notification (Doc 03 §3, Doc 04 §4).
  bool get isPushWorthy =>
      riskLevel == BehaviourRiskLevel.moderate ||
      riskLevel == BehaviourRiskLevel.high;

  const BehaviourForecastResult({
    required this.riskLevel,
    required this.confidenceTier,
    required this.confidenceLabel,
    required this.confidenceDots,
    required this.windowStart,
    required this.windowEnd,
    required this.headline,
    required this.reason,
    required this.contributingSignals,
    required this.actions,
    required this.avoidInstructionTitle,
    required this.avoidInstructionSubtitle,
    required this.childName,
    required this.childAgeMonths,
    this.healthCaveat,
    required this.hasPersonalLogs,
  });
}

/// Behaviour pattern summary calculated from historical tantrum logs (Screen 30).
class BehaviourPatternSummary {
  final int totalTantrums;
  final String mostCommonTimeWindow;
  final List<String> topTriggers;
  final List<String> topHelpedStrategies;
  final double averageIntensity;
  final String insightText;

  const BehaviourPatternSummary({
    required this.totalTantrums,
    required this.mostCommonTimeWindow,
    required this.topTriggers,
    required this.topHelpedStrategies,
    required this.averageIntensity,
    required this.insightText,
  });
}

/// Energy Bridge Behaviour Engine
///
/// Implements transparent, rule-based behavioral risk scoring and Calm Heads-Up
/// predictions according to V2 specifications:
/// - 04_ENERGY_BRIDGE_PREDICTION_LOGIC.md (§4, §6)
/// - 02_SCREEN_CONNECTION_FLOW.md (§7)
/// - 05_APP_CONTENT_COPY_MASTER.md (§6)
class EnergyBridgeBehaviourCalculator {
  EnergyBridgeBehaviourCalculator._();

  static final DateFormat _timeFormat = DateFormat('h:mm a');

  /// Calculates the current Calm Heads-Up forecast based on real inputs.
  static BehaviourForecastResult calculate({
    required ChildModel? childModel,
    required List<TantrumLogModel> tantrumLogs,
    required List<SleepLogModel> sleepLogs,
    required List<MoodLogModel> moodLogs,
    required List<HealthLogModel> healthLogs,
    DateTime? referenceTime,
  }) {
    final DateTime now = referenceTime ?? DateTime.now();
    final String? rawName = childModel?.childName?.trim();
    final String childName = (rawName != null && rawName.isNotEmpty)
        ? rawName
        : 'your child';

    final int childAgeMonths = AgeUtils.resolvedAgeInMonths(
      dob: childModel?.childDob,
      legacyAgeText: childModel?.childAge ?? '',
    );

    final bool hasPersonalLogs = tantrumLogs.isNotEmpty;

    // 1. Evaluate contributing signals (transparent & inspectable)
    final List<String> signals = <String>[];

    // Signal A: Sleep pressure (short nap or long wake window)
    if (sleepLogs.isNotEmpty) {
      final SleepLogModel latestSleep = sleepLogs.first;
      final int? dur = latestSleep.durationMinutes;
      if (dur != null && dur > 0 && dur < 45) {
        signals.add('a short nap');
      } else {
        final DateTime wakeDate = latestSleep.wakeTime;
        final int hoursAwake = now.difference(wakeDate).inHours;
        if (hoursAwake >= 4) {
          signals.add('extended wake window');
        }
      }
    }

    // Signal B: Mood context (fussy / dysregulated / sad)
    if (moodLogs.isNotEmpty) {
      final MoodLogModel latestMood = moodLogs.first;
      if (latestMood.childMoodIndex <= 2) {
        signals.add('fussy emotional state');
      }
    }

    // Signal C: Historical difficult times matching current time of day
    final List<String>? diffTimes = childModel?.difficultTimes;
    if (diffTimes != null && diffTimes.isNotEmpty) {
      final int hour = now.hour;
      final bool isLateAfternoonOrEvening = hour >= 16 && hour <= 20;
      if (isLateAfternoonOrEvening &&
          (diffTimes.contains('Evening') ||
              diffTimes.contains('Late afternoon') ||
              diffTimes.contains('Bedtime'))) {
        signals.add('late afternoon transition rhythm');
      }
    }

    // Signal D: Repeated historical tantrum clustering
    if (tantrumLogs.isNotEmpty) {
      int eveningTantrumCount = 0;
      for (final TantrumLogModel log in tantrumLogs) {
        final int h = log.timestamp.hour;
        if (h >= 16 && h <= 20) {
          eveningTantrumCount++;
        }
      }
      if (eveningTantrumCount >= 2 &&
          !signals.contains('late afternoon transition rhythm')) {
        signals.add('recurring afternoon pattern');
      }
    }

    // Signal E: Real hunger context (only if recorded in recent logs, Doc 04 §1 & §5)
    if (tantrumLogs.isNotEmpty) {
      final TantrumLogModel latestTantrum = tantrumLogs.first;
      if (now.difference(latestTantrum.timestamp).inHours < 12 &&
          latestTantrum.triggers.contains('Hunger')) {
        signals.add('hunger context');
      }
    }

    // 2. Determine Risk Level (Honest scoring: Doc 04 §4, Doc 03 §3)
    final BehaviourRiskLevel riskLevel;
    if (signals.length >= 3) {
      riskLevel = BehaviourRiskLevel.high;
    } else if (signals.length == 2) {
      riskLevel = BehaviourRiskLevel.moderate;
    } else if (signals.length == 1) {
      riskLevel = BehaviourRiskLevel.low;
    } else {
      riskLevel = BehaviourRiskLevel.none;
    }

    // 3. Determine Confidence Tier
    ConfidenceTier confidenceTier;
    int confidenceDots;
    String confidenceLabel;

    if (!hasPersonalLogs) {
      confidenceTier = ConfidenceTier.none;
      confidenceDots = 0;
      confidenceLabel = 'General guide';
    } else if (tantrumLogs.length <= 2) {
      confidenceTier = ConfidenceTier.low;
      confidenceDots = 1;
      confidenceLabel = 'Confidence: low';
    } else if (tantrumLogs.length < 10) {
      confidenceTier = ConfidenceTier.moderate;
      confidenceDots = 2;
      confidenceLabel = 'Confidence: moderate';
    } else {
      confidenceTier = ConfidenceTier.high;
      confidenceDots = 3;
      confidenceLabel = 'Confidence: high';
    }

    // 4. Health log caveats (safety boundary)
    String? healthCaveat;
    if (healthLogs.isNotEmpty) {
      final HealthLogModel latestHealth = healthLogs.first;
      final bool isRecentHealth =
          now.difference(latestHealth.timestamp).inHours < 48;
      if (isRecentHealth) {
        healthCaveat =
            'Recent health symptoms noted (${latestHealth.issues.join(", ")}). Behaviour predictions are less predictable during illness.';
        // Downgrade confidence tier by 1
        if (confidenceTier == ConfidenceTier.high) {
          confidenceTier = ConfidenceTier.moderate;
          confidenceDots = 2;
          confidenceLabel = 'Confidence: moderate';
        } else if (confidenceTier == ConfidenceTier.moderate) {
          confidenceTier = ConfidenceTier.low;
          confidenceDots = 1;
          confidenceLabel = 'Confidence: low';
        }
      }
    }

    // 5. Predict Likely Difficult Window dynamically from child patterns
    final DateTime targetStart = _computeDifficultWindowStart(
      now: now,
      tantrumLogs: tantrumLogs,
      sleepLogs: sleepLogs,
      diffTimes: diffTimes,
    );
    final DateTime targetEnd = targetStart.add(
      const Duration(hours: 1, minutes: 30),
    );
    final String windowStart = _timeFormat.format(targetStart);
    final String windowEnd = _timeFormat.format(targetEnd);

    // 6. Dynamic Probabilistic Reason String & Headline (V2 master copy)
    final String headline;
    final String reason;
    if (signals.length >= 2) {
      headline = 'A harder window may be more likely';
      reason =
          'Between $windowStart and $windowEnd — ${signals[0]} and ${signals[1]} today.';
    } else if (signals.length == 1) {
      headline = 'Still learning $childName\'s pattern';
      reason =
          'One context signal noted (${signals.first}), but not enough combined patterns for a predictive heads-up.';
    } else {
      headline = hasPersonalLogs
          ? 'Still learning $childName\'s pattern'
          : 'General guide for $childName';
      reason =
          'Not enough recent updates to identify a harder window today. Log updates when difficult moments happen to personalise.';
    }

    // 7. Generate Tailored Calm Plan Actions
    final List<CalmPlanAction> actions = <CalmPlanAction>[
      const CalmPlanAction(
        stepNumber: '1',
        title: 'Lower stimulation now',
        description:
            'Dim the room, turn off background noise, and pause high-energy play.',
      ),
      CalmPlanAction(
        stepNumber: '2',
        title: 'Offer a quiet, familiar activity',
        description:
            'Choose something $childName already knows well — soft books or gentle stacking.',
      ),
      CalmPlanAction(
        stepNumber: '3',
        title: 'Stay close and steady',
        description:
            'Your calm physical presence is the clearest safety signal $childName can borrow.',
      ),
    ];

    const String avoidTitle = "Don't introduce a new demand right now";
    final String avoidSubtitle =
        'Requests, transitions, and boundary debates can wait until $childName has completely settled.';

    return BehaviourForecastResult(
      riskLevel: riskLevel,
      confidenceTier: confidenceTier,
      confidenceLabel: confidenceLabel,
      confidenceDots: confidenceDots,
      windowStart: windowStart,
      windowEnd: windowEnd,
      headline: headline,
      reason: reason,
      contributingSignals: signals,
      actions: actions,
      avoidInstructionTitle: avoidTitle,
      avoidInstructionSubtitle: avoidSubtitle,
      childName: childName,
      childAgeMonths: childAgeMonths,
      healthCaveat: healthCaveat,
      hasPersonalLogs: hasPersonalLogs,
    );
  }

  /// Dynamically computes the difficult window start time based on child logs and onboarding rhythm.
  static DateTime _computeDifficultWindowStart({
    required DateTime now,
    required List<TantrumLogModel> tantrumLogs,
    required List<SleepLogModel> sleepLogs,
    required List<String>? diffTimes,
  }) {
    // 1. Clustering from repeated tantrum logs
    if (tantrumLogs.isNotEmpty) {
      final Map<int, int> hourCounts = <int, int>{};
      for (final TantrumLogModel log in tantrumLogs) {
        final int h = log.timestamp.hour;
        hourCounts[h] = (hourCounts[h] ?? 0) + 1;
      }
      int maxHour = -1;
      int maxCount = 0;
      hourCounts.forEach((int h, int count) {
        if (count > maxCount) {
          maxCount = count;
          maxHour = h;
        }
      });
      if (maxCount >= 2 && maxHour >= 6 && maxHour <= 22) {
        return DateTime(now.year, now.month, now.day, maxHour, 0);
      }
    }

    // 2. Daytime nap wake time in sleep logs -> wakefulness pressure (~3.5h later)
    if (sleepLogs.isNotEmpty) {
      for (final SleepLogModel s in sleepLogs) {
        final int wakeHour = s.wakeTime.hour;
        if (wakeHour >= 11 && wakeHour <= 16) {
          final DateTime predictedPeak = s.wakeTime.add(
            const Duration(hours: 3, minutes: 30),
          );
          return DateTime(
            now.year,
            now.month,
            now.day,
            predictedPeak.hour,
            predictedPeak.minute < 30 ? 0 : 30,
          );
        }
      }
    }

    // 3. Difficult times specified in onboarding
    if (diffTimes != null && diffTimes.isNotEmpty) {
      if (diffTimes.contains('Morning')) {
        return DateTime(now.year, now.month, now.day, 10, 0);
      } else if (diffTimes.contains('Afternoon')) {
        return DateTime(now.year, now.month, now.day, 14, 30);
      } else if (diffTimes.contains('Late afternoon')) {
        return DateTime(now.year, now.month, now.day, 16, 30);
      } else if (diffTimes.contains('Evening')) {
        return DateTime(now.year, now.month, now.day, 18, 0);
      } else if (diffTimes.contains('Bedtime')) {
        return DateTime(now.year, now.month, now.day, 19, 0);
      }
    }

    // Default baseline afternoon window (5:30 PM)
    return DateTime(now.year, now.month, now.day, 17, 30);
  }

  /// Aggregates historical tantrum logs to construct the Behaviour Pattern summary (Screen 30).
  static BehaviourPatternSummary aggregatePattern({
    required List<TantrumLogModel> logs,
    required String childName,
  }) {
    if (logs.isEmpty) {
      return BehaviourPatternSummary(
        totalTantrums: 0,
        mostCommonTimeWindow: 'Still learning',
        topTriggers: const <String>[],
        topHelpedStrategies: const <String>[],
        averageIntensity: 0.0,
        insightText:
            'Start logging difficult moments to uncover $childName\'s personal pattern and effective strategies.',
      );
    }

    // Trigger frequencies (filtering out invalid placeholder/free-text junk)
    final Map<String, int> triggerCounts = <String, int>{};
    final Map<String, int> helpedCounts = <String, int>{};
    double totalIntensity = 0.0;
    int countWithIntensity = 0;

    for (final TantrumLogModel log in logs) {
      for (final String t in log.triggers) {
        final String clean = t.trim();
        if (clean.isNotEmpty &&
            clean.toLowerCase() != 'other' &&
            clean.toLowerCase() != 'placeholder' &&
            clean.length < 40) {
          triggerCounts[clean] = (triggerCounts[clean] ?? 0) + 1;
        }
      }
      final String cleanHelped = log.whatHelped.trim();
      if (cleanHelped.isNotEmpty &&
          cleanHelped.toLowerCase() != 'other' &&
          cleanHelped.length < 40) {
        helpedCounts[cleanHelped] = (helpedCounts[cleanHelped] ?? 0) + 1;
      }
      totalIntensity += log.intensity;
      countWithIntensity++;
    }

    final List<String> sortedTriggers = triggerCounts.keys.toList()
      ..sort(
        (String a, String b) =>
            (triggerCounts[b] ?? 0).compareTo(triggerCounts[a] ?? 0),
      );

    final List<String> sortedHelped = helpedCounts.keys.toList()
      ..sort(
        (String a, String b) =>
            (helpedCounts[b] ?? 0).compareTo(helpedCounts[a] ?? 0),
      );

    final double avgIntensity = countWithIntensity > 0
        ? (totalIntensity / countWithIntensity)
        : 0.5;

    final String primaryTrigger = sortedTriggers.isNotEmpty
        ? sortedTriggers.first
        : 'tiredness';
    final String primaryHelped = sortedHelped.isNotEmpty
        ? sortedHelped.first
        : 'calm presence';

    // Calculate time window from actual logged timestamps
    String resolvedTimeWindow = 'Still learning';
    if (logs.isNotEmpty) {
      final List<int> hours = logs.map((l) => l.timestamp.hour).toList();
      hours.sort();
      final int medianHour = hours[hours.length ~/ 2];
      final int startHour = medianHour;
      final int endHour = (medianHour + 2) % 24;
      final String startAmPm = startHour >= 12 ? 'PM' : 'AM';
      final String endAmPm = endHour >= 12 ? 'PM' : 'AM';
      final int startH12 = startHour % 12 == 0 ? 12 : startHour % 12;
      final int endH12 = endHour % 12 == 0 ? 12 : endHour % 12;
      resolvedTimeWindow = '$startH12:00 $startAmPm – $endH12:00 $endAmPm';
    }

    final String insight;
    if (logs.length < 3) {
      insight =
          'Early observation: based on ${logs.length} logged ${logs.length == 1 ? 'event' : 'events'}, $childName was affected by ${primaryTrigger.toLowerCase()}. Log a few more moments to establish clearer patterns.';
    } else {
      insight =
          'Harder moments for $childName most often follow ${primaryTrigger.toLowerCase()}. ${primaryHelped.toLowerCase()} has shown the most consistent calming effect.';
    }

    return BehaviourPatternSummary(
      totalTantrums: logs.length,
      mostCommonTimeWindow: resolvedTimeWindow,
      topTriggers: sortedTriggers.take(3).toList(),
      topHelpedStrategies: sortedHelped.take(3).toList(),
      averageIntensity: avgIntensity,
      insightText: insight,
    );
  }
}
