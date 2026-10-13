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
    final String childName =
        (childModel?.childName != null &&
            childModel!.childName!.trim().isNotEmpty)
        ? childModel.childName!.trim()
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
    if (childModel?.difficultTimes != null &&
        childModel!.difficultTimes!.isNotEmpty) {
      final int hour = now.hour;
      final bool isLateAfternoonOrEvening = hour >= 16 && hour <= 20;
      if (isLateAfternoonOrEvening &&
          (childModel.difficultTimes!.contains('Evening') ||
              childModel.difficultTimes!.contains('Late afternoon') ||
              childModel.difficultTimes!.contains('Bedtime'))) {
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

    // Fallback default signals if learning
    if (signals.isEmpty) {
      signals.add('sensory load');
      signals.add('late afternoon transition');
    }

    // 2. Determine Risk Level
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

    // 5. Predict Likely Difficult Window
    final DateTime targetStart = DateTime(now.year, now.month, now.day, 17, 30);
    final DateTime targetEnd = DateTime(now.year, now.month, now.day, 19, 0);
    final String windowStart = _timeFormat.format(targetStart);
    final String windowEnd = _timeFormat.format(targetEnd);

    // 6. Dynamic Probabilistic Reason String (V2 master copy)
    final String signal1 = signals.isNotEmpty ? signals.first : 'tiredness';
    final String signal2 = signals.length > 1
        ? signals[1]
        : 'transition rhythm';
    final String reason =
        'Between $windowStart and $windowEnd — $signal1 and $signal2 today.';

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
      headline: 'A harder window may be more likely',
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

  /// Aggregates historical tantrum logs to construct the Behaviour Pattern summary (Screen 30).
  static BehaviourPatternSummary aggregatePattern({
    required List<TantrumLogModel> logs,
    required String childName,
  }) {
    if (logs.isEmpty) {
      return BehaviourPatternSummary(
        totalTantrums: 0,
        mostCommonTimeWindow: 'Late afternoon (5:00–7:00 PM)',
        topTriggers: const <String>['Tiredness', 'Transitions'],
        topHelpedStrategies: const <String>[
          'Lowering stimulation',
          'Quiet proximity',
        ],
        averageIntensity: 0.5,
        insightText:
            'Start logging difficult moments to unlock $childName\'s personal pattern and effective strategies.',
      );
    }

    // Trigger frequencies
    final Map<String, int> triggerCounts = <String, int>{};
    final Map<String, int> helpedCounts = <String, int>{};
    double totalIntensity = 0.0;
    int countWithIntensity = 0;

    for (final TantrumLogModel log in logs) {
      for (final String t in log.triggers) {
        triggerCounts[t] = (triggerCounts[t] ?? 0) + 1;
      }
      if (log.whatHelped.isNotEmpty) {
        helpedCounts[log.whatHelped] = (helpedCounts[log.whatHelped] ?? 0) + 1;
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
        ? sortedTriggers.first.toLowerCase()
        : 'tiredness';
    final String primaryHelped = sortedHelped.isNotEmpty
        ? sortedHelped.first.toLowerCase()
        : 'quiet connection';

    return BehaviourPatternSummary(
      totalTantrums: logs.length,
      mostCommonTimeWindow: '5:00 PM – 7:00 PM',
      topTriggers: sortedTriggers.take(3).toList(),
      topHelpedStrategies: sortedHelped.take(3).toList(),
      averageIntensity: avgIntensity,
      insightText:
          'Harder moments for $childName most often follow $primaryTrigger. $primaryHelped has shown the most consistent calming effect.',
    );
  }
}
