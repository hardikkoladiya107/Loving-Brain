import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/core/brainy_entry_context.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreference.init();
  });

  group('BrainyEntryContext', () {
    test('fromHeadsUp attaches forecast facts and topic', () {
      final Map<String, dynamic> extras = BrainyEntryContext.fromHeadsUp(
        headline: 'A harder window may be more likely',
        reason: 'Skipped nap and late fatigue',
        windowStart: '5:30 PM',
        windowEnd: '7:00 PM',
        confidenceLabel: 'moderate',
        contributingSignals: <String>['short nap', 'late afternoon'],
        healthCaveat: 'Mild cold noted',
        childName: 'Aria',
      );

      expect(extras['topic'], 'Calm Heads-Up');
      expect(extras['initialChat'], contains('5:30 PM'));
      expect(extras['initialChat'], contains('Aria'));
      final String attached = extras['attachedContext'] as String;
      expect(attached, contains('Headline:'));
      expect(attached, contains('Skipped nap'));
      expect(attached, contains('short nap'));
      expect(attached, contains('Mild cold noted'));
      expect(attached.trim().isNotEmpty, isTrue);
    });

    test('fromCalmPlan attaches plan steps', () {
      final Map<String, dynamic> extras = BrainyEntryContext.fromCalmPlan(
        childName: 'Johnny',
        planSteps: <String>[
          '1. Pause: Sit together',
          '2. Soft voice: Name the feeling',
        ],
        windowLabel: '5:30–7:00 PM',
      );

      expect(extras['topic'], 'Calm Plan');
      final String attached = extras['attachedContext'] as String;
      expect(attached, contains('Harder window: 5:30–7:00 PM'));
      expect(attached, contains('Pause: Sit together'));
      expect(extras['initialChat'], contains('Johnny'));
    });

    test('fromProgrammeDetail attaches programme and sleep routine', () {
      final Map<String, dynamic> extras =
          BrainyEntryContext.fromProgrammeDetail(
            programmeName: '6-Week Sleep Journey',
            child: ChildModel(
              childName: 'Mia',
              childAge: '18m',
              usualBedtime: '7:00 PM',
              usualWakeTime: '6:30 AM',
              usualNaps: '1 nap',
              nightWakings: '1-2',
              primaryConcern: 'Night wakings',
            ),
          );

      expect(extras['topic'], 'Sleep Journey');
      expect(extras['initialChat'], contains('6-Week Sleep Journey'));
      final String attached = extras['attachedContext'] as String;
      expect(attached, contains('Programme: 6-Week Sleep Journey'));
      expect(attached, contains('Mia'));
      expect(attached, contains('Bedtime 7:00 PM'));
      expect(attached, contains('Night wakings'));
    });

    test('fromMentorshipUnavailable uses support concern', () {
      final Map<String, dynamic> extras =
          BrainyEntryContext.fromMentorshipUnavailable(
            supportConcern: 'evening tantrums after nursery',
          );

      expect(extras['topic'], 'Support');
      expect(extras['initialChat'], contains('evening tantrums'));
      expect(
        extras['attachedContext'] as String,
        contains('Mentorship unavailable'),
      );
    });

    test(
      'fromWeeklyReview and fromHarderWeek keep prompts and attach summary',
      () {
        final Map<String, dynamic> weekly = BrainyEntryContext.fromWeeklyReview(
          prompt: 'Review this week please',
          attachedSummary: 'Positive: earlier bedtime',
        );
        expect(weekly['topic'], 'Weekly Review');
        expect(weekly['initialChat'], 'Review this week please');
        expect(weekly['attachedContext'], contains('earlier bedtime'));

        final Map<String, dynamic> harder = BrainyEntryContext.fromHarderWeek(
          prompt: 'Harder week help',
          attachedSummary: 'Travel disrupted naps',
        );
        expect(harder['topic'], 'Harder Week Support');
        expect(harder['attachedContext'], contains('Travel'));
      },
    );

    test('gettingStarted includes starter attached context', () {
      final Map<String, dynamic> extras = BrainyEntryContext.gettingStarted();
      expect(extras['topic'], 'Getting Started');
      expect((extras['attachedContext'] as String).trim().isNotEmpty, isTrue);
    });
  });
}
