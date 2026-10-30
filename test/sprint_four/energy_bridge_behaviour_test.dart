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
    test(
      'Zero tantrum logs yields ConfidenceTier.none, 0 dots, and general guide copy',
      () {
        final BehaviourForecastResult result =
            EnergyBridgeBehaviourCalculator.calculate(
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
        expect(result.headline, 'General guide for Ira');
        expect(result.actions.length, 3);
        expect(result.hasPersonalLogs, isFalse);
      },
    );

    test('1-2 tantrum logs yields ConfidenceTier.low with 1 dot', () {
      final List<TantrumLogModel> logs = <TantrumLogModel>[
        TantrumLogModel(
          whatHappened: 'Meltdown during transition',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          intensity: 0.6,
          triggers: <String>['Tiredness'],
          whatHelped: 'Holding close',
        ),
      ];

      final BehaviourForecastResult result =
          EnergyBridgeBehaviourCalculator.calculate(
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
          whatHappened: 'Tantrum $i',
          timestamp: DateTime.now().subtract(Duration(days: i)),
          intensity: 0.5,
          triggers: <String>['Hunger'],
          whatHelped: 'Snack',
        ),
      );

      final BehaviourForecastResult result =
          EnergyBridgeBehaviourCalculator.calculate(
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
          whatHappened: 'Tantrum $i',
          timestamp: DateTime.now().subtract(Duration(days: i)),
          intensity: 0.7,
          triggers: <String>['Transitions'],
          whatHelped: 'Quiet hugs',
        ),
      );

      final BehaviourForecastResult result =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: ChildModel(childName: 'Ira'),
            tantrumLogs: logs,
            sleepLogs: <SleepLogModel>[],
            moodLogs: <MoodLogModel>[],
            healthLogs: <HealthLogModel>[],
          );

      expect(result.confidenceTier, ConfidenceTier.high);
      expect(result.confidenceDots, 3);
    });

    test(
      'Short nap and fussy mood escalate contributing signals and risk level',
      () {
        final List<SleepLogModel> sleepLogs = <SleepLogModel>[
          SleepLogModel(
            id: 'sleep_1',
            date: DateTime.now(),
            bedTime: DateTime.now().subtract(const Duration(minutes: 30)),
            wakeTime: DateTime.now(),
            durationMinutes: 30, // short nap (<45 min)
          ),
        ];
        final List<MoodLogModel> moodLogs = <MoodLogModel>[
          MoodLogModel(
            childMood: 'Fussy',
            childMoodIndex: 1, // very fussy
            parentMood: 'Tired',
            logTime: DateTime.now(),
          ),
        ];

        final BehaviourForecastResult result =
            EnergyBridgeBehaviourCalculator.calculate(
              childModel: ChildModel(
                childName: 'Leo',
                difficultTimes: <String>['Evening', 'Late afternoon'],
              ),
              tantrumLogs: <TantrumLogModel>[
                TantrumLogModel(
                  whatHappened: 'Crying',
                  timestamp: DateTime.now(),
                  intensity: 0.5,
                  triggers: <String>['Tiredness'],
                  whatHelped: 'Deep breath',
                ),
              ],
              sleepLogs: sleepLogs,
              moodLogs: moodLogs,
              healthLogs: <HealthLogModel>[],
            );

        expect(result.contributingSignals.contains('a short nap'), isTrue);
        expect(
          result.contributingSignals.contains('fussy emotional state'),
          isTrue,
        );
        expect(result.riskLevel, isNot(BehaviourRiskLevel.none));
        expect(result.reason, contains('Between'));
      },
    );

    test(
      'Recent health disruption downgrades confidence and attaches caveat',
      () {
        final List<TantrumLogModel> logs = List<TantrumLogModel>.generate(
          10,
          (int i) => TantrumLogModel(
            whatHappened: 'Tantrum $i',
            timestamp: DateTime.now().subtract(Duration(days: i)),
            intensity: 0.5,
            triggers: <String>['Tiredness'],
            whatHelped: 'Rest',
          ),
        );
        final List<HealthLogModel> healthLogs = <HealthLogModel>[
          HealthLogModel(
            timestamp: DateTime.now(),
            issues: <String>['Teething', 'Mild fever'],
            notes: 'Poor appetite',
          ),
        ];

        final BehaviourForecastResult result =
            EnergyBridgeBehaviourCalculator.calculate(
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
      },
    );

    test('Mood plus onboarding difficult time alone is not push-worthy', () {
      final BehaviourForecastResult result =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: ChildModel(
              childName: 'Leo',
              difficultTimes: <String>['Evening', 'Late afternoon'],
            ),
            tantrumLogs: <TantrumLogModel>[],
            sleepLogs: <SleepLogModel>[],
            moodLogs: <MoodLogModel>[
              MoodLogModel(
                childMood: 'Sad',
                childMoodIndex: 2,
                parentMood: 'Okay',
                logTime: DateTime(2026, 10, 30, 17, 0),
              ),
            ],
            healthLogs: <HealthLogModel>[],
            referenceTime: DateTime(2026, 10, 30, 17, 0),
          );

      expect(result.hasPrimaryRiskSignal, isFalse);
      expect(result.isPushWorthy, isFalse);
      expect(result.riskLevel, BehaviourRiskLevel.low);
      expect(
        result.contributingSignals.contains('fussy emotional state'),
        isTrue,
      );
    });

    test('Short nap plus known evening difficulty is push-worthy', () {
      final BehaviourForecastResult result =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: ChildModel(
              childName: 'Leo',
              difficultTimes: <String>['Evening'],
            ),
            tantrumLogs: <TantrumLogModel>[],
            sleepLogs: <SleepLogModel>[
              SleepLogModel(
                id: 'nap_1',
                date: DateTime(2026, 10, 30),
                bedTime: DateTime(2026, 10, 30, 13, 0),
                wakeTime: DateTime(2026, 10, 30, 13, 25),
                durationMinutes: 25,
              ),
            ],
            moodLogs: <MoodLogModel>[],
            healthLogs: <HealthLogModel>[],
            referenceTime: DateTime(2026, 10, 30, 17, 0),
          );

      expect(result.hasPrimaryRiskSignal, isTrue);
      expect(result.contributingSignals.contains('a short nap'), isTrue);
      expect(result.isPushWorthy, isTrue);
      expect(
        result.riskLevel == BehaviourRiskLevel.moderate ||
            result.riskLevel == BehaviourRiskLevel.high,
        isTrue,
      );
    });

    test(
      'BehaviourPatternSummary aggregates top triggers and strategies correctly',
      () {
        final List<TantrumLogModel> logs = <TantrumLogModel>[
          TantrumLogModel(
            whatHappened: 'Tantrum 1',
            timestamp: DateTime.now(),
            triggers: <String>['Tiredness', 'Hunger'],
            whatHelped: 'Lowering stimulation',
            intensity: 0.8,
          ),
          TantrumLogModel(
            whatHappened: 'Tantrum 2',
            timestamp: DateTime.now(),
            triggers: <String>['Tiredness'],
            whatHelped: 'Lowering stimulation',
            intensity: 0.6,
          ),
          TantrumLogModel(
            whatHappened: 'Tantrum 3',
            timestamp: DateTime.now(),
            triggers: <String>['Transitions'],
            whatHelped: 'Quiet hug',
            intensity: 0.4,
          ),
        ];

        final BehaviourPatternSummary summary =
            EnergyBridgeBehaviourCalculator.aggregatePattern(
              logs: logs,
              childName: 'Ira',
            );

        expect(summary.totalTantrums, 3);
        expect(summary.topTriggers.first, 'Tiredness');
        expect(summary.topHelpedStrategies.first, 'Lowering stimulation');
        expect(summary.averageIntensity, closeTo(0.6, 0.01));
        expect(summary.insightText, contains('Ira'));
      },
    );
  });
}
