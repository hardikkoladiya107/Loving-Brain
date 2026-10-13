import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/ui/sleep_details/bloc/sleep_details_cubit.dart';
import 'package:loving_brain/ui/sleep_forecast/bloc/sleep_forecast_cubit.dart';
import 'package:loving_brain/ui/sleep_pattern/bloc/sleep_pattern_cubit.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/tonights_plan/bloc/tonights_plan_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 2 — Energy Bridge Baseline Wake Window Tests', () {
    test('Resolves correct wake windows for every age band', () {
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(2),
        equals(75),
      ); // 0-3m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(5),
        equals(120),
      ); // 4-6m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(8),
        equals(150),
      ); // 7-9m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(11),
        equals(210),
      ); // 10-12m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(16),
        equals(240),
      ); // 13-18m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(24),
        equals(300),
      ); // 19-36m
      expect(
        EnergyBridgeSleepCalculator.baselineWakeWindowMinutes(40),
        equals(330),
      ); // 36m+
    });
  });

  group('Sprint 2 — Energy Bridge Prediction Engine Tests', () {
    final DateTime refNow = DateTime(2026, 10, 13, 16, 0);

    test(
      'Zero sleep logs produces ConfidenceTier.none, 0 dots and honest baseline copy',
      () {
        final ChildModel child = ChildModel(
          childName: 'Ira',
          childAge: '14 Months',
        );

        final SleepForecastResult result =
            EnergyBridgeSleepCalculator.calculate(
              child: child,
              sleepLogs: const <SleepLogModel>[],
              referenceNow: refNow,
            );

        expect(result.confidenceTier, equals(ConfidenceTier.none));
        expect(result.confidenceDots, equals(0));
        expect(result.confidenceLabel, equals('Learning'));
        expect(result.hasPersonalLogs, isFalse);
        expect(result.reason, contains('general guide'));
        expect(result.reason, contains('Ira'));
        expect(result.planSteps.length, equals(3));
      },
    );

    test('1-2 sleep logs produces ConfidenceTier.low and 1 dot', () {
      final ChildModel child = ChildModel(
        childName: 'Ira',
        childAge: '14 Months',
      );

      final List<SleepLogModel> logs = <SleepLogModel>[
        SleepLogModel(
          id: 'log_1',
          date: DateTime(2026, 10, 13),
          bedTime: DateTime(2026, 10, 13, 12, 30),
          wakeTime: DateTime(2026, 10, 13, 14, 0),
          durationMinutes: 90,
        ),
      ];

      final SleepForecastResult result = EnergyBridgeSleepCalculator.calculate(
        child: child,
        sleepLogs: logs,
        referenceNow: refNow,
      );

      expect(result.confidenceTier, equals(ConfidenceTier.low));
      expect(result.confidenceDots, equals(1));
      expect(result.confidenceLabel, equals('Low'));
      expect(result.hasPersonalLogs, isTrue);
      expect(result.planSteps.length, equals(3));
    });

    test('3-9 sleep logs produces ConfidenceTier.moderate and 2 dots', () {
      final ChildModel child = ChildModel(
        childName: 'Ira',
        childAge: '14 Months',
      );

      final List<SleepLogModel> logs = List.generate(
        4,
        (int i) => SleepLogModel(
          id: 'log_$i',
          date: DateTime(2026, 10, 13).subtract(Duration(days: i)),
          bedTime: DateTime(2026, 10, 13, 12, 30).subtract(Duration(days: i)),
          wakeTime: DateTime(2026, 10, 13, 14, 0).subtract(Duration(days: i)),
          durationMinutes: 90,
        ),
      );

      final SleepForecastResult result = EnergyBridgeSleepCalculator.calculate(
        child: child,
        sleepLogs: logs,
        referenceNow: refNow,
      );

      expect(result.confidenceTier, equals(ConfidenceTier.moderate));
      expect(result.confidenceDots, equals(2));
      expect(result.confidenceLabel, equals('Moderate'));
    });

    test('10+ sleep logs produces ConfidenceTier.high and 3 dots', () {
      final ChildModel child = ChildModel(
        childName: 'Ira',
        childAge: '14 Months',
      );

      final List<SleepLogModel> logs = List.generate(
        11,
        (int i) => SleepLogModel(
          id: 'log_$i',
          date: DateTime(2026, 10, 13).subtract(Duration(days: i)),
          bedTime: DateTime(2026, 10, 13, 12, 30).subtract(Duration(days: i)),
          wakeTime: DateTime(2026, 10, 13, 14, 0).subtract(Duration(days: i)),
          durationMinutes: 90,
        ),
      );

      final SleepForecastResult result = EnergyBridgeSleepCalculator.calculate(
        child: child,
        sleepLogs: logs,
        referenceNow: refNow,
      );

      expect(result.confidenceTier, equals(ConfidenceTier.high));
      expect(result.confidenceDots, equals(3));
      expect(result.confidenceLabel, equals('High'));
    });

    test('Short nap (<45 min) reduces wake window and explains in reason', () {
      final ChildModel child = ChildModel(
        childName: 'Ira',
        childAge: '14 Months',
      );

      // Nap of only 25 minutes ending today at 13:00
      final List<SleepLogModel> logs = <SleepLogModel>[
        SleepLogModel(
          id: 'nap_short',
          date: DateTime(2026, 10, 13),
          bedTime: DateTime(2026, 10, 13, 12, 35),
          wakeTime: DateTime(2026, 10, 13, 13, 0),
          wokeUpTime: '01:00 PM',
          durationMinutes: 25,
        ),
      ];

      final SleepForecastResult result = EnergyBridgeSleepCalculator.calculate(
        child: child,
        sleepLogs: logs,
        referenceNow: refNow,
      );

      expect(result.reason, contains('short'));
      expect(result.reason, contains('Ira'));
      expect(result.reason, contains('tiredness is building a little earlier'));
      expect(result.subtitle, contains('minutes short'));
    });

    test(
      'Health log lowers confidence by 1 tier and attaches honest caveat',
      () {
        final ChildModel child = ChildModel(
          childName: 'Ira',
          childAge: '14 Months',
        );

        // 4 logs normally gives Moderate (2 dots)
        final List<SleepLogModel> logs = List.generate(
          4,
          (int i) => SleepLogModel(
            id: 'log_$i',
            date: DateTime(2026, 10, 13).subtract(Duration(days: i)),
            bedTime: DateTime(2026, 10, 13, 12, 30).subtract(Duration(days: i)),
            wakeTime: DateTime(2026, 10, 13, 14, 0).subtract(Duration(days: i)),
            durationMinutes: 90,
          ),
        );

        final HealthLogModel health = HealthLogModel(
          issues: <String>['Teething', 'Fever'],
          notes: 'Very fussy this afternoon',
          timestamp: DateTime(2026, 10, 13, 15, 0),
        );

        final SleepForecastResult result =
            EnergyBridgeSleepCalculator.calculate(
              child: child,
              sleepLogs: logs,
              todayHealthLog: health,
              referenceNow: refNow,
            );

        // Downgraded from Moderate (2 dots) to Low (1 dot)
        expect(result.confidenceTier, equals(ConfidenceTier.low));
        expect(result.confidenceDots, equals(1));
        expect(result.confidenceLabel, equals('Low'));
        expect(result.healthCaveat, isNotNull);
        expect(result.healthCaveat, contains('Health context noted'));
        expect(result.healthCaveat, contains('Teething, Fever'));
      },
    );

    test("Tonight's Plan steps are anchored to computed bedtime estimate", () {
      final ChildModel child = ChildModel(
        childName: 'Ira',
        childAge: '14 Months',
      );

      final SleepForecastResult result = EnergyBridgeSleepCalculator.calculate(
        child: child,
        sleepLogs: const <SleepLogModel>[],
        referenceNow: refNow,
      );

      expect(result.planSteps.length, equals(3));
      expect(result.planSteps[0].title, equals('Wind-down starts'));
      expect(result.planSteps[1].title, equals('Book in the bedroom'));
      expect(result.planSteps[2].title, equals('Lights out'));

      // Wind-down starts 40 mins before bedtime
      expect(
        result.planSteps[0].scheduledTime,
        equals(
          result.bedtimeEstimateDateTime.subtract(const Duration(minutes: 40)),
        ),
      );
      // Book starts 20 mins before bedtime
      expect(
        result.planSteps[1].scheduledTime,
        equals(
          result.bedtimeEstimateDateTime.subtract(const Duration(minutes: 20)),
        ),
      );
      // Lights out at bedtime
      expect(
        result.planSteps[2].scheduledTime,
        equals(result.bedtimeEstimateDateTime),
      );
    });
  });

  group('Sprint 2 — Cubits & States Clean Architecture Tests', () {
    test(
      'TodayCubit updates dynamic sleep forecast fields through changeProps',
      () {
        final TodayCubit cubit = TodayCubit();

        cubit.changeProps(
          sleepForecastStart: '07:15 PM',
          sleepForecastEnd: '07:45 PM',
          bedtimeEstimate: '07:30 PM',
          confidenceDots: 3,
          confidenceLevel: 'high',
          sleepForecastReason: 'Pattern is very stable',
          hasSleepLogs: true,
        );

        expect(cubit.state.sleepForecastStart, equals('07:15 PM'));
        expect(cubit.state.sleepForecastEnd, equals('07:45 PM'));
        expect(cubit.state.bedtimeEstimate, equals('07:30 PM'));
        expect(cubit.state.confidenceDots, equals(3));
        expect(cubit.state.confidenceLevel, equals('high'));
        expect(
          cubit.state.sleepForecastReason,
          equals('Pattern is very stable'),
        );
        expect(cubit.state.hasSleepLogs, isTrue);

        cubit.close();
      },
    );

    test('SleepForecastCubit updates state and selects days', () {
      final SleepForecastCubit cubit = SleepForecastCubit();

      cubit.changeProps(
        parentName: 'SARAH',
        childName: 'Ira',
        windowStart: '07:00 PM',
        windowEnd: '07:30 PM',
        bedtimeEstimate: '07:15 PM',
        confidenceDots: 2,
        confidenceLevel: 'Moderate',
      );

      expect(cubit.state.parentName, equals('SARAH'));
      expect(cubit.state.childName, equals('Ira'));
      expect(cubit.state.confidenceDots, equals(2));

      cubit.selectDay(2);
      expect(cubit.state.selectedDayIndex, equals(2));

      cubit.close();
    });

    test('SleepDetailsCubit updates last sleep info and metrics', () {
      final SleepDetailsCubit cubit = SleepDetailsCubit();

      cubit.changeProps(
        timeInSleep: '8h 15m',
        wakeUpTime: '06:45 AM',
        wentToBed: '10:30 PM',
        sleepQuality: '5/5',
        confidenceDots: 3,
        confidenceLabel: 'High',
        hasRealLogs: true,
      );

      expect(cubit.state.timeInSleep, equals('8h 15m'));
      expect(cubit.state.wakeUpTime, equals('06:45 AM'));
      expect(cubit.state.wentToBed, equals('10:30 PM'));
      expect(cubit.state.sleepQuality, equals('5/5'));
      expect(cubit.state.confidenceDots, equals(3));
      expect(cubit.state.confidenceLabel, equals('High'));
      expect(cubit.state.hasRealLogs, isTrue);

      cubit.close();
    });

    test(
      'TonightsPlanCubit toggles plan start and audio in-place without page jumping',
      () {
        final TonightsPlanCubit cubit = TonightsPlanCubit();

        expect(cubit.state.isPlanStarted, isFalse);
        expect(cubit.state.isAudioPlaying, isFalse);

        cubit.startPlan();
        expect(cubit.state.isPlanStarted, isTrue);

        cubit.startPlan();
        expect(cubit.state.isPlanStarted, isFalse);

        cubit.toggleAudio();
        expect(cubit.state.isAudioPlaying, isTrue);

        cubit.toggleAudio();
        expect(cubit.state.isAudioPlaying, isFalse);

        cubit.close();
      },
    );

    test(
      'SleepPatternCubit updates weekly sleep spots, consistency and insights',
      () {
        final SleepPatternCubit cubit = SleepPatternCubit();

        cubit.changeProps(
          childName: 'Ira',
          averageSleepHours: 9.8,
          consistencyScore: 92,
          patternInsight: 'Naps have been shorter this week.',
          dailySleepHours: <double>[5.0, 5.0, 4.0, 5.0, 3.0, 6.0],
          hasData: true,
        );

        expect(cubit.state.childName, equals('Ira'));
        expect(cubit.state.averageSleepHours, equals(9.8));
        expect(cubit.state.consistencyScore, equals(92));
        expect(cubit.state.dailySleepHours.length, equals(6));
        expect(cubit.state.hasData, isTrue);

        cubit.setToggleIndex(0);
        expect(cubit.state.selectedToggleIndex, equals(0));

        cubit.close();
      },
    );
  });
}
