import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/core/readiness_score.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/ui/family_timeline/bloc/family_timeline_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_state.dart';

void main() {
  group('Sprint 3: JourneyInsightsEngine tests', () {
    final DateTime refSunday = DateTime(2026, 5, 17); // Sunday
    final ChildModel sampleChild = ChildModel(
      childName: 'Maya',
      childGender: 'Female',
    );

    test('generates expected date range and defaults for sparse data', () {
      final WeeklyInsightsResult result = JourneyInsightsEngine.calculate(
        referenceDate: refSunday,
        child: sampleChild,
      );

      expect(result.dateRangeLabel, contains('Sunday 17 May'));
      expect(result.dateRangeLabel, contains('Saturday 23 May'));
      expect(result.daysCheckedIn, greaterThanOrEqualTo(1));
      expect(result.isHarderWeek, isFalse);
      expect(result.positiveTitle, isNotEmpty);
      expect(result.difficultyTitle, isNotEmpty);
      expect(
        result.patternTitle,
        contains('Maya sleeps better after active days'),
      );
      expect(result.recommendedChange, 'An earlier, shorter afternoon nap');
    });

    test('detects harder week when travel health issue is logged', () {
      final HealthLogModel travelLog = HealthLogModel(
        issues: <String>['Travel', 'Jetlag'],
        notes: 'Family trip away from home',
        timestamp: DateTime(2026, 5, 18, 14, 0),
      );

      final WeeklyInsightsResult result = JourneyInsightsEngine.calculate(
        referenceDate: refSunday,
        child: sampleChild,
        healthLogs: <HealthLogModel>[travelLog],
      );

      expect(result.isHarderWeek, isTrue);
      expect(result.harderHeadline, 'This week was harder');
      expect(
        result.harderExplanation,
        contains('Travel disrupted the routine'),
      );
    });

    test('detects harder week when illness is logged in health issue', () {
      final HealthLogModel illnessLog = HealthLogModel(
        issues: <String>['Fever', 'Illness'],
        notes: 'Low energy and high temperature',
        timestamp: DateTime(2026, 5, 19, 10, 0),
      );

      final WeeklyInsightsResult result = JourneyInsightsEngine.calculate(
        referenceDate: refSunday,
        child: sampleChild,
        healthLogs: <HealthLogModel>[illnessLog],
      );

      expect(result.isHarderWeek, isTrue);
      expect(result.harderExplanation, contains('Illness disrupted sleep'));
    });

    test('detects harder week when multiple late bedtimes occur', () {
      final List<SleepLogModel> lateLogs = <SleepLogModel>[
        SleepLogModel(
          id: '1',
          date: DateTime(2026, 5, 17),
          bedTime: DateTime(2026, 5, 17, 21, 30),
          wakeTime: DateTime(2026, 5, 18, 6, 30),
        ),
        SleepLogModel(
          id: '2',
          date: DateTime(2026, 5, 18),
          bedTime: DateTime(2026, 5, 18, 21, 45),
          wakeTime: DateTime(2026, 5, 19, 6, 45),
        ),
        SleepLogModel(
          id: '3',
          date: DateTime(2026, 5, 19),
          bedTime: DateTime(2026, 5, 19, 22, 0),
          wakeTime: DateTime(2026, 5, 20, 7, 0),
        ),
      ];

      final WeeklyInsightsResult result = JourneyInsightsEngine.calculate(
        referenceDate: refSunday,
        child: sampleChild,
        sleepLogs: lateLogs,
      );

      expect(result.isHarderWeek, isTrue);
    });

    test(
      'counts distinct check-in days correctly across multiple categories',
      () {
        final List<SleepLogModel> sleep = <SleepLogModel>[
          SleepLogModel(
            id: '1',
            date: DateTime(2026, 5, 17),
            bedTime: DateTime(2026, 5, 17, 20, 0),
            wakeTime: DateTime(2026, 5, 18, 7, 0),
          ),
          SleepLogModel(
            id: '2',
            date: DateTime(2026, 5, 18),
            bedTime: DateTime(2026, 5, 18, 20, 0),
            wakeTime: DateTime(2026, 5, 19, 7, 0),
          ),
        ];

        final List<TantrumLogModel> tantrums = <TantrumLogModel>[
          TantrumLogModel(
            whatHappened: 'Tiredness after park',
            timestamp: DateTime(2026, 5, 19, 17, 30),
            intensity: 0.5,
            triggers: <String>['Tiredness'],
            whatHelped: 'Quiet cuddle',
          ),
        ];

        final List<QuickNoteModel> notes = <QuickNoteModel>[
          QuickNoteModel(
            id: 'n1',
            note: 'Loved playground today',
            timestamp: DateTime(2026, 5, 20, 15, 0),
          ),
        ];

        final WeeklyInsightsResult result = JourneyInsightsEngine.calculate(
          referenceDate: refSunday,
          child: sampleChild,
          sleepLogs: sleep,
          tantrumLogs: tantrums,
          quickNotes: notes,
        );

        // May 17, 18, 19, 20 -> 4 distinct check-in days
        expect(result.daysCheckedIn, 4);
      },
    );
  });

  group('Sprint 3: ActiveExperimentModel tests', () {
    test('calculates currentDayNumber and progressFraction correctly', () {
      final DateTime start = DateTime.now().subtract(const Duration(days: 2));
      final ActiveExperimentModel exp = ActiveExperimentModel(
        id: 'test_exp',
        childId: 'child_123',
        changeTitle: 'An earlier afternoon nap',
        observeTarget: 'Evening mood',
        startDate: start,
        targetDays: 7,
        reviewDate: start.add(const Duration(days: 7)),
      );

      expect(exp.currentDayNumber, 3);
      expect(exp.progressFraction, closeTo(3 / 7, 0.05));
      expect(exp.isDueForReview, isFalse);
    });

    test('serializes and deserializes accurately', () {
      final DateTime start = DateTime(2026, 5, 10);
      final DateTime review = DateTime(2026, 5, 17);
      final ActiveExperimentModel original = ActiveExperimentModel(
        id: 'exp_abc',
        childId: 'child_xyz',
        changeTitle: 'Quiet bedtime wind-down',
        observeTarget: 'Settling speed',
        startDate: start,
        targetDays: 7,
        reviewDate: review,
        status: 'active',
      );

      final Map<String, dynamic> map = original.toMap();
      final ActiveExperimentModel reconstituted = ActiveExperimentModel.fromMap(
        map,
        id: 'exp_abc',
      );

      expect(reconstituted.id, original.id);
      expect(reconstituted.childId, original.childId);
      expect(reconstituted.changeTitle, original.changeTitle);
      expect(reconstituted.observeTarget, original.observeTarget);
      expect(reconstituted.targetDays, original.targetDays);
      expect(reconstituted.status, original.status);
    });
  });

  group('Sprint 3: ExperimentRepo tests', () {
    setUp(() {
      ExperimentRepo.instance.clearCache();
    });

    test('starts, retrieves, and ends experiment early', () async {
      final DateTime now = DateTime.now();
      final ActiveExperimentModel exp = ActiveExperimentModel(
        id: 'repo_exp_1',
        childId: 'child_99',
        changeTitle: 'Morning sunlight walk',
        observeTarget: 'Wake alertness',
        startDate: now,
        targetDays: 7,
        reviewDate: now.add(const Duration(days: 7)),
      );

      final ApiResultStatus<String> startRes = await ExperimentRepo.instance
          .startExperiment(childId: 'child_99', experiment: exp);
      expect(startRes is Data<String>, isTrue);

      final ApiResultStatus<ActiveExperimentModel?> getRes =
          await ExperimentRepo.instance.getActiveExperiment(
            childId: 'child_99',
          );
      expect(getRes is Data<ActiveExperimentModel?>, isTrue);
      final ActiveExperimentModel? retrieved =
          (getRes as Data<ActiveExperimentModel?>).data;
      expect(retrieved, isNotNull);
      expect(retrieved!.changeTitle, 'Morning sunlight walk');

      final ApiResultStatus<bool> endRes = await ExperimentRepo.instance
          .finishExperimentEarly(
            childId: 'child_99',
            experimentId: 'repo_exp_1',
            reason: 'Adjusting plan',
          );
      expect(endRes is Data<bool>, isTrue);
      expect((endRes as Data<bool>).data, isTrue);
    });
  });

  group('Sprint 3: FamilyTimelineCubit filter tests', () {
    test('filters events by category correctly', () {
      final FamilyTimelineCubit cubit = FamilyTimelineCubit();
      final List<TimelineEventModel> events = <TimelineEventModel>[
        TimelineEventModel(
          id: '1',
          type: 'sleep_log',
          title: 'Night sleep',
          subtitle: '8 hours',
          timestamp: DateTime.now(),
        ),
        TimelineEventModel(
          id: '2',
          type: 'tantrum_log',
          title: 'Meltdown',
          subtitle: 'Transition',
          timestamp: DateTime.now(),
        ),
        TimelineEventModel(
          id: '3',
          type: 'mentorship',
          title: 'Guide session',
          subtitle: 'With Priya',
          timestamp: DateTime.now(),
        ),
        TimelineEventModel(
          id: '4',
          type: 'quick_note',
          title: 'Quick note',
          subtitle: 'Took 10 minutes to settle',
          timestamp: DateTime.now(),
        ),
      ];

      cubit.changeProps(allEvents: events, filteredEvents: events);

      cubit.setFilter('Sleep');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.type, 'sleep_log');

      cubit.setFilter('Behaviour');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.type, 'tantrum_log');

      cubit.setFilter('Notes');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.type, 'quick_note');

      cubit.setFilter('Mentorship');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.type, 'mentorship');

      cubit.setFilter('All');
      expect(cubit.state.filteredEvents.length, 4);

      cubit.close();
    });
  });

  group('Sprint 3: JourneyCubit mode cycling', () {
    test('cycles correctly between normal, harder, and trying modes', () {
      final JourneyCubit cubit = JourneyCubit();
      expect(cubit.state.mode, JourneyMode.normal);

      cubit.cycleMode();
      expect(cubit.state.mode, JourneyMode.harder);

      cubit.cycleMode();
      expect(cubit.state.mode, JourneyMode.trying);

      cubit.cycleMode();
      expect(cubit.state.mode, JourneyMode.normal);

      cubit.close();
    });
  });

  group('Sprint 3: ReadinessScore calculation tests', () {
    test('high mood, calm state, and good sleep yields ready now', () {
      final int score = ReadinessScore.calculate(
        moodLoggedToday: true,
        sleepHoursLastNight: 8.5,
        childState: ChildState.calm,
      );

      expect(score, greaterThanOrEqualTo(75));

      final bool isReady = ReadinessScore.isReadyNow(
        score: score,
        childState: ChildState.calm,
        sleepHoursLastNight: 8.5,
      );

      expect(isReady, isTrue);
    });

    test('fussy state or low sleep prevents ready now', () {
      final int score = ReadinessScore.calculate(
        moodLoggedToday: true,
        sleepHoursLastNight: 5.0,
        childState: ChildState.fussy,
      );

      expect(score, lessThan(75));

      final bool isReady = ReadinessScore.isReadyNow(
        score: score,
        childState: ChildState.fussy,
        sleepHoursLastNight: 5.0,
      );

      expect(isReady, isFalse);
    });
  });
}
