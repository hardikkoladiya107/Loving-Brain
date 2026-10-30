import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/energy_bridge_behaviour_calculator.dart';
import 'package:loving_brain/core/energy_bridge_sleep_calculator.dart';
import 'package:loving_brain/core/today_home_assembler.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_state.dart';

void main() {
  final DateTime now = DateTime(2026, 10, 30, 16, 0);

  ChildModel child({String concern = 'Sleep'}) {
    return ChildModel(
      childName: 'Emma',
      childAge: '2 years',
      usualBedtime: '7:30 PM',
      primaryConcern: concern,
    );
  }

  SleepLogModel night({
    required DateTime bed,
    required DateTime wake,
    bool nightWaking = false,
  }) {
    return SleepLogModel(
      id: 'n-${bed.millisecondsSinceEpoch}',
      date: DateTime(bed.year, bed.month, bed.day),
      bedTime: bed,
      wakeTime: wake,
      fellAsleepTime: '7:30 PM',
      wokeUpTime: '6:30 AM',
      isNightWaking: nightWaking,
      sleepQualityIndex: 3,
      durationMinutes: wake.difference(bed).inMinutes,
    );
  }

  SleepLogModel nap({required DateTime start, required DateTime end}) {
    return SleepLogModel(
      id: 'nap-${start.millisecondsSinceEpoch}',
      date: DateTime(start.year, start.month, start.day),
      bedTime: start,
      wakeTime: end,
      fellAsleepTime: '1:00 PM',
      wokeUpTime: '2:00 PM',
      isNightWaking: false,
      sleepQualityIndex: -1,
      durationMinutes: end.difference(start).inMinutes,
    );
  }

  TantrumLogModel tantrum({
    required DateTime at,
    List<String> triggers = const <String>['Tiredness'],
  }) {
    return TantrumLogModel(
      whatHappened: 'Hard moment',
      time: '5:30 PM',
      timestamp: at,
      intensity: 0.6,
      triggers: triggers,
      whatHelped: 'Quiet time',
      userId: 'u1',
      childId: 'c1',
      createdAt: at,
    );
  }

  test('no sleep logs keeps learning mode', () {
    final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
      child: child(),
      sleepLogs: <SleepLogModel>[],
      referenceNow: now,
    );
    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child(),
          tantrumLogs: <TantrumLogModel>[],
          sleepLogs: <SleepLogModel>[],
          moodLogs: const [],
          healthLogs: const [],
          referenceTime: now,
        );

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child(),
      sleepForecast: sleep,
      behaviourForecast: behaviour,
      sleepLogs: <SleepLogModel>[],
      tantrumLogs: <TantrumLogModel>[],
      referenceNow: now,
    );

    expect(snapshot.mode, TodayMode.newParent);
    expect(snapshot.showBehaviourHeadsUp, isFalse);
    expect(snapshot.showNiceWork, isFalse);
    expect(snapshot.prioritiseSleepFirst, isTrue);
    expect(snapshot.onboardingFocusLine, contains('Sleep'));
  });

  test('one tantrum alone does not replace the home with heads-up', () {
    final List<SleepLogModel> sleeps = <SleepLogModel>[
      night(
        bed: DateTime(2026, 10, 28, 19, 30),
        wake: DateTime(2026, 10, 29, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 29, 19, 30),
        wake: DateTime(2026, 10, 30, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 27, 19, 30),
        wake: DateTime(2026, 10, 28, 6, 30),
      ),
    ];
    final List<TantrumLogModel> tantrums = <TantrumLogModel>[
      tantrum(at: DateTime(2026, 10, 30, 15, 0)),
    ];

    final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
      child: child(),
      sleepLogs: sleeps,
      referenceNow: now,
    );
    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child(),
          tantrumLogs: tantrums,
          sleepLogs: sleeps,
          moodLogs: const [],
          healthLogs: const [],
          referenceTime: now,
        );

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child(),
      sleepForecast: sleep,
      behaviourForecast: behaviour,
      sleepLogs: sleeps,
      tantrumLogs: tantrums,
      referenceNow: now,
    );

    expect(snapshot.hasSleepLogs, isTrue);
    expect(snapshot.mode, isNot(TodayMode.importantHeadsUp));
    expect(snapshot.showBehaviourHeadsUp, isFalse);
  });

  test(
    'teething with three sleep days does not become harder-evening heads-up',
    () {
      final List<SleepLogModel> sleeps = <SleepLogModel>[
        night(
          bed: DateTime(2026, 10, 28, 19, 30),
          wake: DateTime(2026, 10, 29, 6, 30),
        ),
        night(
          bed: DateTime(2026, 10, 29, 19, 30),
          wake: DateTime(2026, 10, 30, 6, 30),
        ),
        night(
          bed: DateTime(2026, 10, 27, 19, 30),
          wake: DateTime(2026, 10, 28, 6, 30),
        ),
      ];
      final HealthLogModel health = HealthLogModel(
        issues: <String>['Teething'],
        notes: 'Sore gums',
        timestamp: now,
        userId: 'u1',
        childId: 'c1',
        createdAt: now,
      );

      final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
        child: child(),
        sleepLogs: sleeps,
        todayHealthLog: health,
        referenceNow: now,
      );
      final BehaviourForecastResult behaviour =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: child(),
            tantrumLogs: <TantrumLogModel>[],
            sleepLogs: sleeps,
            moodLogs: const [],
            healthLogs: <HealthLogModel>[health],
            referenceTime: now,
          );

      final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
        child: child(),
        sleepForecast: sleep,
        behaviourForecast: behaviour,
        sleepLogs: sleeps,
        tantrumLogs: <TantrumLogModel>[],
        todayHealthLog: health,
        referenceNow: now,
      );

      expect(snapshot.showBehaviourHeadsUp, isFalse);
      expect(snapshot.showHealthHeadsUp, isFalse);
      expect(snapshot.mode, TodayMode.normal);
    },
  );

  test('fever health note shows health card on learning home', () {
    final HealthLogModel health = HealthLogModel(
      issues: <String>['Fever'],
      notes: '',
      timestamp: now,
      userId: 'u1',
      childId: 'c1',
      createdAt: now,
    );
    final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
      child: child(),
      sleepLogs: <SleepLogModel>[],
      todayHealthLog: health,
      referenceNow: now,
    );
    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child(),
          tantrumLogs: <TantrumLogModel>[],
          sleepLogs: <SleepLogModel>[],
          moodLogs: const [],
          healthLogs: <HealthLogModel>[health],
          referenceTime: now,
        );

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child(),
      sleepForecast: sleep,
      behaviourForecast: behaviour,
      sleepLogs: <SleepLogModel>[],
      tantrumLogs: <TantrumLogModel>[],
      todayHealthLog: health,
      referenceNow: now,
    );

    expect(snapshot.mode, TodayMode.newParent);
    expect(snapshot.showHealthHeadsUp, isTrue);
    expect(snapshot.healthHeadsUpTitle, 'Health check-in noted');
  });

  test('three easier nights unlocks nice work', () {
    final List<SleepLogModel> sleeps = <SleepLogModel>[
      night(
        bed: DateTime(2026, 10, 28, 19, 30),
        wake: DateTime(2026, 10, 29, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 29, 19, 35),
        wake: DateTime(2026, 10, 30, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 30, 19, 25),
        wake: DateTime(2026, 10, 31, 6, 30),
      ),
    ];

    final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
      child: child(),
      sleepLogs: sleeps,
      referenceNow: now,
    );
    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child(),
          tantrumLogs: <TantrumLogModel>[],
          sleepLogs: sleeps,
          moodLogs: const [],
          healthLogs: const [],
          referenceTime: now,
        );

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child(),
      sleepForecast: sleep,
      behaviourForecast: behaviour,
      sleepLogs: sleeps,
      tantrumLogs: <TantrumLogModel>[],
      referenceNow: now,
    );

    expect(snapshot.hasMultiDayPatterns, isTrue);
    expect(snapshot.showNiceWork, isTrue);
    expect(snapshot.niceWorkTitle, contains('Three nights'));
  });

  test('shorter naps this week unlocks noticed nap insight', () {
    final List<SleepLogModel> sleeps = <SleepLogModel>[
      night(
        bed: DateTime(2026, 10, 28, 19, 30),
        wake: DateTime(2026, 10, 29, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 29, 19, 30),
        wake: DateTime(2026, 10, 30, 6, 30),
      ),
      night(
        bed: DateTime(2026, 10, 27, 19, 30),
        wake: DateTime(2026, 10, 28, 6, 30),
      ),
      nap(
        start: DateTime(2026, 10, 20, 13, 0),
        end: DateTime(2026, 10, 20, 14, 30),
      ),
      nap(
        start: DateTime(2026, 10, 21, 13, 0),
        end: DateTime(2026, 10, 21, 14, 30),
      ),
      nap(
        start: DateTime(2026, 10, 28, 13, 0),
        end: DateTime(2026, 10, 28, 13, 45),
      ),
      nap(
        start: DateTime(2026, 10, 29, 13, 0),
        end: DateTime(2026, 10, 29, 13, 40),
      ),
    ];

    final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
      child: child(),
      sleepLogs: sleeps,
      referenceNow: now,
    );
    final BehaviourForecastResult behaviour =
        EnergyBridgeBehaviourCalculator.calculate(
          childModel: child(),
          tantrumLogs: <TantrumLogModel>[],
          sleepLogs: sleeps,
          moodLogs: const [],
          healthLogs: const [],
          referenceTime: now,
        );

    final TodayHomeSnapshot snapshot = TodayHomeAssembler.assemble(
      child: child(),
      sleepForecast: sleep,
      behaviourForecast: behaviour,
      sleepLogs: sleeps,
      tantrumLogs: <TantrumLogModel>[],
      referenceNow: now,
    );

    expect(snapshot.showNoticed, isTrue);
    expect(snapshot.noticedTitle.toLowerCase(), contains('shorter'));
    expect(snapshot.noticedDestination, TodayNoticedDestination.sleepPattern);
  });

  test(
    'support offer appears for inconsistent bedtimes and respects dismissal',
    () {
      final List<SleepLogModel> sleeps = <SleepLogModel>[
        night(
          bed: DateTime(2026, 10, 26, 18, 30),
          wake: DateTime(2026, 10, 27, 6, 0),
        ),
        night(
          bed: DateTime(2026, 10, 27, 20, 45),
          wake: DateTime(2026, 10, 28, 7, 0),
        ),
        night(
          bed: DateTime(2026, 10, 28, 19, 0),
          wake: DateTime(2026, 10, 29, 6, 30),
        ),
        night(
          bed: DateTime(2026, 10, 29, 21, 0),
          wake: DateTime(2026, 10, 30, 7, 30),
        ),
      ];

      final SleepForecastResult sleep = EnergyBridgeSleepCalculator.calculate(
        child: child(),
        sleepLogs: sleeps,
        referenceNow: now,
      );
      final BehaviourForecastResult behaviour =
          EnergyBridgeBehaviourCalculator.calculate(
            childModel: child(),
            tantrumLogs: <TantrumLogModel>[],
            sleepLogs: sleeps,
            moodLogs: const [],
            healthLogs: const [],
            referenceTime: now,
          );

      final TodayHomeSnapshot open = TodayHomeAssembler.assemble(
        child: child(),
        sleepForecast: sleep,
        behaviourForecast: behaviour,
        sleepLogs: sleeps,
        tantrumLogs: <TantrumLogModel>[],
        referenceNow: now,
      );
      expect(open.showSupportOffer, isTrue);
      expect(open.supportInconsistentDays, greaterThanOrEqualTo(3));

      final TodayHomeSnapshot dismissed = TodayHomeAssembler.assemble(
        child: child(),
        sleepForecast: sleep,
        behaviourForecast: behaviour,
        sleepLogs: sleeps,
        tantrumLogs: <TantrumLogModel>[],
        supportDismissedAt: now.subtract(const Duration(days: 1)),
        referenceNow: now,
      );
      expect(dismissed.showSupportOffer, isFalse);
    },
  );

  test('cache round-trip preserves assembled home fields', () {
    final TodayHomeSnapshot original = TodayHomeSnapshot(
      mode: TodayMode.normal,
      sleepForecastStart: '7:30 PM',
      sleepForecastEnd: '8:00 PM',
      bedtimeEstimate: '7:45 PM',
      forecastSubtitle: 'Bedtime estimate 7:45 PM.',
      confidenceLevel: 'moderate',
      confidenceDots: 2,
      sleepForecastReason: 'Based on recent sleep.',
      hasSleepLogs: true,
      hasMultiDayPatterns: true,
      hasAnyLogs: true,
      loggedDaysCount: 4,
      showHealthHeadsUp: false,
      healthHeadsUpTitle: '',
      healthHeadsUpSubtitle: '',
      showBehaviourHeadsUp: false,
      headsUpHeadline: '',
      headsUpReason: '',
      headsUpWindowStart: '',
      headsUpWindowEnd: '',
      showNiceWork: true,
      niceWorkTitle: 'Three nights of easier bedtime in a row',
      niceWorkSubtitle: 'Nice work — this is a pattern worth noticing.',
      showNoticed: false,
      noticedTitle: '',
      noticedDestination: TodayNoticedDestination.none,
      showSupportOffer: false,
      supportInconsistentDays: 0,
      onboardingFocusLine: '',
      prioritiseSleepFirst: true,
    );

    final TodayHomeSnapshot restored = TodayHomeSnapshot.fromCacheMap(
      original.toCacheMap(),
    );
    expect(restored.mode, TodayMode.normal);
    expect(restored.showNiceWork, isTrue);
    expect(restored.bedtimeEstimate, '7:45 PM');
    expect(restored.loggedDaysCount, 4);
  });
}
