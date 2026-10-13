import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';

void main() {
  group('Sprint 4 — Energy Bridge Behaviour Calculator Tests', () {
    test('Zero tantrum logs yields ConfidenceTier.none, 0 dots, and general guide copy', () {
      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(childName: 'Ira', childAge: '2 years'),
        tantrumLogs: <TantrumLogModel>[],
        sleepLogs: <SleepLogModel>[],
        moodLogs: <MoodLogModel>[],
        healthLogs: <HealthLogModel>[],
      );

      expect(result.confidenceTier, ConfidenceTier.none);
      expect(result.confidenceDots, 0);
      expect(result.confidenceLabel, 'General guide');
      expect(result.childName, 'Ira');
      expect(result.headline, 'A harder window may be more likely');
      expect(result.actions.length, 3);
      expect(result.hasPersonalLogs, isFalse);
    });

    test('1-2 tantrum logs yields ConfidenceTier.low with 1 dot', () {
      final List<TantrumLogModel> logs = <TantrumLogModel>[
        TantrumLogModel(
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          durationMinutes: 10,
          intensity: 0.6,
          triggers: <String>['Tiredness'],
        ),
      ];

      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(childName: 'Ira'),
        tantrumLogs: logs,
        sleepLogs: <SleepLogModel>[],
        moodLogs: <MoodLogModel>[],
        healthLogs: <HealthLogModel>[],
      );

      expect(result.confidenceTier, ConfidenceTier.low);
      expect(result.confidenceDots, 1);
      expect(result.confidenceLabel, 'Confidence: low');
      expect(result.hasPersonalLogs, isTrue);
    });

    test('3-9 tantrum logs yields ConfidenceTier.moderate with 2 dots', () {
      final List<TantrumLogModel> logs = List<TantrumLogModel>.generate(
        5,
        (int i) => TantrumLogModel(
          timestamp: DateTime.now().subtract(Duration(days: i)),
          triggers: <String>['Hunger'],
        ),
      );

      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(childName: 'Ira'),
        tantrumLogs: logs,
        sleepLogs: <SleepLogModel>[],
        moodLogs: <MoodLogModel>[],
        healthLogs: <HealthLogModel>[],
      );

      expect(result.confidenceTier, ConfidenceTier.moderate);
      expect(result.confidenceDots, 2);
    });

    test('10+ tantrum logs yields ConfidenceTier.high with 3 dots', () {
      final List<TantrumLogModel> logs = List<TantrumLogModel>.generate(
        11,
        (int i) => TantrumLogModel(
          timestamp: DateTime.now().subtract(Duration(days: i)),
          triggers: <String>['Transitions'],
        ),
      );

      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(childName: 'Ira'),
        tantrumLogs: logs,
        sleepLogs: <SleepLogModel>[],
        moodLogs: <MoodLogModel>[],
        healthLogs: <HealthLogModel>[],
      );

      expect(result.confidenceTier, ConfidenceTier.high);
      expect(result.confidenceDots, 3);
    });

    test('Short nap and fussy mood escalate contributing signals and risk level', () {
      final List<SleepLogModel> sleepLogs = <SleepLogModel>[
        SleepLogModel(
          durationMinutes: 30, // short nap (<45 min)
          timestamp: DateTime.now(),
        ),
      ];
      final List<MoodLogModel> moodLogs = <MoodLogModel>[
        MoodLogModel(
          childMoodIndex: 1, // very fussy
          timestamp: DateTime.now(),
        ),
      ];

      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(
          childName: 'Leo',
          difficultTimes: <String>['Evening', 'Late afternoon'],
        ),
        tantrumLogs: <TantrumLogModel>[
          TantrumLogModel(timestamp: DateTime.now(), triggers: <String>['Tiredness']),
        ],
        sleepLogs: sleepLogs,
        moodLogs: moodLogs,
        healthLogs: <HealthLogModel>[],
      );

      expect(result.contributingSignals.contains('a short nap'), isTrue);
      expect(result.contributingSignals.contains('fussy emotional state'), isTrue);
      expect(result.riskLevel, isNot(BehaviourRiskLevel.none));
      expect(result.reason, contains('Between'));
    });

    test('Recent health disruption downgrades confidence and attaches caveat', () {
      final List<TantrumLogModel> logs = List<TantrumLogModel>.generate(
        10,
        (int i) => TantrumLogModel(triggers: <String>['Tiredness']),
      );
      final List<HealthLogModel> healthLogs = <HealthLogModel>[
        HealthLogModel(
          timestamp: DateTime.now(),
          issues: <String>['Teething', 'Mild fever'],
        ),
      ];

      final BehaviourForecastResult result = EnergyBridgeBehaviourCalculator.calculate(
        childModel: ChildModel(childName: 'Ira'),
        tantrumLogs: logs,
        sleepLogs: <SleepLogModel>[],
        moodLogs: <MoodLogModel>[],
        healthLogs: healthLogs,
      );

      // Originally high (10 logs), downgraded to moderate by recent health disruption
      expect(result.confidenceTier, ConfidenceTier.moderate);
      expect(result.confidenceDots, 2);
      expect(result.healthCaveat, isNotNull);
      expect(result.healthCaveat, contains('Teething'));
    });

    test('BehaviourPatternSummary aggregates top triggers and strategies correctly', () {
      final List<TantrumLogModel> logs = <TantrumLogModel>[
        TantrumLogModel(
          triggers: <String>['Tiredness', 'Hunger'],
          whatHelped: 'Lowering stimulation',
          intensity: 0.8,
        ),
        TantrumLogModel(
          triggers: <String>['Tiredness'],
          whatHelped: 'Lowering stimulation',
          intensity: 0.6,
        ),
        TantrumLogModel(
          triggers: <String>['Transitions'],
          whatHelped: 'Quiet hug',
          intensity: 0.4,
        ),
      ];

      final BehaviourPatternSummary summary = EnergyBridgeBehaviourCalculator.aggregatePattern(
        logs: logs,
        childName: 'Ira',
      );

      expect(summary.totalTantrums, 3);
      expect(summary.topTriggers.first, 'Tiredness');
      expect(summary.topHelpedStrategies.first, 'Lowering stimulation');
      expect(summary.averageIntensity, closeTo(0.6, 0.01));
      expect(summary.insightText, contains('Ira'));
    });
  });
}
