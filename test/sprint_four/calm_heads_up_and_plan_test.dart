import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/ui/after_reflection/bloc/after_reflection_cubit.dart';
import 'package:loving_brain/ui/behaviour_pattern/bloc/behaviour_pattern_cubit.dart';
import 'package:loving_brain/ui/calm_heads_up/bloc/calm_heads_up_cubit.dart';
import 'package:loving_brain/ui/calm_plan/bloc/calm_plan_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 4 — Calm Heads-Up & Calm Plan Cubits Tests', () {
    test(
      'CalmHeadsUpCubit initializes and updates state via changeProps correctly',
      () {
        final CalmHeadsUpCubit cubit = CalmHeadsUpCubit();
        expect(cubit.state.isLoading, isFalse);

        cubit.changeProps(
          childName: 'Aria',
          headline: 'A harder window may be more likely',
          confidenceDots: 3,
          confidenceLabel: 'Confidence: high',
          windowStart: '5:00 PM',
          windowEnd: '6:30 PM',
          contributingSignals: <String>['short nap', 'fussy mood'],
        );

        expect(cubit.state.childName, 'Aria');
        expect(cubit.state.confidenceDots, 3);
        expect(cubit.state.confidenceLabel, 'Confidence: high');
        expect(cubit.state.windowStart, '5:00 PM');
        expect(cubit.state.contributingSignals.length, 2);
      },
    );

    test(
      'CalmPlanCubit handles custom forecast and toggles audio guide in place',
      () {
        final CalmPlanCubit cubit = CalmPlanCubit();

        const BehaviourForecastResult forecast = BehaviourForecastResult(
          riskLevel: BehaviourRiskLevel.moderate,
          confidenceTier: ConfidenceTier.moderate,
          confidenceLabel: 'Confidence: moderate',
          confidenceDots: 2,
          windowStart: '5:30 PM',
          windowEnd: '7:00 PM',
          headline: 'A harder window may be more likely',
          reason:
              'Between 5:30 and 7:00 PM — sensory load and transition today.',
          contributingSignals: <String>['sensory load', 'transition'],
          actions: <CalmPlanAction>[
            CalmPlanAction(
              stepNumber: '1',
              title: 'Lower stimulation now',
              description: 'Dim the room, turn off background noise',
            ),
            CalmPlanAction(
              stepNumber: '2',
              title: 'Offer a quiet, familiar activity',
              description: 'Something Aria knows well',
            ),
            CalmPlanAction(
              stepNumber: '3',
              title: 'Stay close and steady',
              description: 'Your calm is the strongest signal',
            ),
          ],
          avoidInstructionTitle: "Don't introduce a new demand right now",
          avoidInstructionSubtitle:
              'Requests and choices can wait until settled.',
          childName: 'Aria',
          childAgeMonths: 24,
          hasPersonalLogs: true,
        );

        cubit.init(forecast: forecast);

        expect(cubit.state.actions.length, 3);
        expect(cubit.state.childName, 'Aria');
        expect(cubit.state.isAudioPlaying, isFalse);

        // In-place audio toggle
        cubit.toggleAudio();
        expect(cubit.state.isAudioPlaying, isTrue);

        cubit.toggleAudio();
        expect(cubit.state.isAudioPlaying, isFalse);
      },
    );

    test(
      'BehaviourPatternCubit initializes and aggregates tantrum statistics',
      () {
        final BehaviourPatternCubit cubit = BehaviourPatternCubit();

        final BehaviourPatternSummary summary =
            EnergyBridgeBehaviourCalculator.aggregatePattern(
              logs: <TantrumLogModel>[
                TantrumLogModel(
                  whatHappened: 'Transition crying',
                  timestamp: DateTime.now(),
                  triggers: <String>['Transitions', 'Tiredness'],
                  whatHelped: 'Quiet space',
                  intensity: 0.7,
                ),
              ],
              childName: 'Ira',
            );

        cubit.changeProps(
          summary: summary,
          totalTantrums: summary.totalTantrums,
          topTriggers: summary.topTriggers,
          topHelpedStrategies: summary.topHelpedStrategies,
        );

        expect(cubit.state.totalTantrums, 1);
        expect(cubit.state.topTriggers, contains('Transitions'));
        expect(cubit.state.topHelpedStrategies, contains('Quiet space'));
      },
    );

    test(
      'AfterReflectionCubit updates fields and persists reflection',
      () async {
        final AfterReflectionCubit cubit = AfterReflectionCubit();
        cubit.init();

        cubit.setBeforeEvent('Putting on winter jacket');
        cubit.setDuration('15 minutes');
        cubit.setIntensity(0.8);
        cubit.setHelped('Waiting it out');
        cubit.setFeeling('Calm');

        expect(cubit.state.beforeEvent, 'Putting on winter jacket');
        expect(cubit.state.durationText, '15 minutes');
        expect(cubit.state.intensityValue, 0.8);
        expect(cubit.state.selectedHelped, 'Waiting it out');
        expect(cubit.state.selectedFeeling, 'Calm');

        final bool saved = await cubit.saveReflection();
        expect(saved, isTrue);
        expect(cubit.state.isLoading, isFalse);
      },
    );
  });
}
