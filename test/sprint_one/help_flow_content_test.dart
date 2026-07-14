import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/content/help_guidance_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HelpGuidanceContent.resetCacheForTests();
  });

  group('HelpGuidanceContent', () {
    test('crying 0-6 months returns 3 suggestions', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'crying',
            ageInMonths: 3,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
      expect(suggestions.first.contextLine, contains('Ava'));
      expect(suggestions.first.steps.length, 2);
    });

    test('too_fussy falls back to crying 0-6 content', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'too_fussy',
            ageInMonths: 24,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
      expect(suggestions.first.primaryAction, isNotEmpty);
    });

    test('feeding_issue maps to wont_eat 6-18 content', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'feeding_issue',
            ageInMonths: 10,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
      expect(suggestions.first.contextLine, contains('developmental'));
    });

    test('crying 6-18 months returns 3 suggestions', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'crying',
            ageInMonths: 12,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
      expect(suggestions.first.contextLine, isNotEmpty);
    });

    test('wont_sleep 6-18 months returns 3 suggestions', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'wont_sleep',
            ageInMonths: 10,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
    });

    test('feeding_issue 18-36 months returns 3 suggestions', () async {
      final List<HelpGuidanceSuggestion> suggestions =
          await HelpGuidanceContent.suggestionsFor(
            appProblemKey: 'feeding_issue',
            ageInMonths: 28,
            childName: 'Ava',
          );
      expect(suggestions.length, 3);
    });

    test('ageBandKey resolves bands correctly', () {
      expect(HelpGuidanceContent.ageBandKey(3), '0_6');
      expect(HelpGuidanceContent.ageBandKey(10), '6_18');
      expect(HelpGuidanceContent.ageBandKey(24), '18_36');
    });
  });
}
