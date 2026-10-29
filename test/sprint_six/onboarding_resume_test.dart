import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/ui/onboarding/bloc/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 6 / V2 QA Audit o1: Onboarding Resumption on Interruption', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await SharedPreference.init();
    });

    test(
      'OnboardingCubit restores saved page and answers from draft on init',
      () async {
        // 1. Simulate saving an interrupted draft at page 3
        final Map<String, dynamic> draft = <String, dynamic>{
          'currentPage': 3,
          'parentName': 'Sarah Connor',
          'parentRole': 'Mother',
          'preferredLanguage': 'English',
          'location': 'New York, USA',
          'primaryConcern': 'Sleep resistance',
          'concerns': <String>['Sleep resistance', 'Night wakings'],
          'isMoreThanOneSelected': true,
          'successGoal': 'Better family evenings',
          'childName': 'John',
          'dateOfBirth': '12 January 2024',
          'childDob': '2024-01-12T00:00:00.000',
          'childGender': 'Boy',
          'usualWakeTime': '07:00 AM',
          'usualBedtime': '07:30 PM',
          'usualNaps': 2,
          'nightWakings': '1-2',
          'difficultTimes': <String>['Bedtime'],
          'possibleTriggers': <String>['Tiredness'],
        };

        await preferences.saveOnboardingDraft(draft);

        // 2. Initialize cubit and verify it resumes from page 3 with saved draft
        final OnboardingCubit cubit = OnboardingCubit();
        cubit.init();

        expect(cubit.state.currentPage, 3);
        expect(cubit.state.parentName, 'Sarah Connor');
        expect(cubit.state.parentRole, 'Mother');
        expect(cubit.state.preferredLanguage, 'English');
        expect(cubit.state.primaryConcern, 'Sleep resistance');
        expect(cubit.state.concerns, contains('Sleep resistance'));
        expect(cubit.state.isMoreThanOneSelected, isTrue);
        expect(cubit.state.successGoal, 'Better family evenings');
        expect(cubit.state.childName, 'John');
        expect(cubit.state.dateOfBirth, '12 January 2024');
        expect(cubit.state.childGender, 'Boy');
        expect(cubit.state.usualWakeTime, '07:00 AM');
        expect(cubit.state.usualBedtime, '07:30 PM');
        expect(cubit.state.usualNaps, 2);
        expect(cubit.state.nightWakings, '1-2');
        expect(cubit.state.difficultTimes, contains('Bedtime'));
        expect(cubit.state.possibleTriggers, contains('Tiredness'));

        cubit.close();
      },
    );

    test('Onboarding draft clears upon clearing draft helper', () async {
      await preferences.saveOnboardingDraft(<String, dynamic>{
        'currentPage': 2,
        'parentName': 'Alex',
      });
      expect(preferences.getOnboardingDraft(), isNotNull);

      await preferences.clearOnboardingDraft();
      expect(preferences.getOnboardingDraft(), isNull);
    });

    test(
      'Logout and clearUser completely wipe onboarding drafts and prevent cross-account leakage',
      () async {
        // User A logs in and fills onboarding up to page 4
        await preferences.saveOnboardingDraft(<String, dynamic>{
          'uid': 'user_a',
          'currentPage': 4,
          'parentName': 'Parent A',
          'childName': 'Child A',
        }, uid: 'user_a');

        expect(preferences.getOnboardingDraft(uid: 'user_a'), isNotNull);

        // User A logs out (clearUser is called)
        await preferences.clearUser();

        // All onboarding drafts must be completely purged
        expect(preferences.getOnboardingDraft(uid: 'user_a'), isNull);
        expect(preferences.getOnboardingDraft(), isNull);

        // When User B logs in, no draft is found
        expect(preferences.getOnboardingDraft(uid: 'user_b'), isNull);

        // OnboardingCubit initializes cleanly for User B at page 0
        final OnboardingCubit cubitB = OnboardingCubit();
        cubitB.init();
        expect(cubitB.state.currentPage, 0);
        expect(cubitB.state.childName, isEmpty);
        expect(cubitB.state.parentName, isEmpty);
        cubitB.close();
      },
    );

    test(
      'OnboardingCubit rejects draft belonging to a different UID and starts fresh',
      () async {
        // Stored draft belongs to user_a
        await preferences.saveOnboardingDraft(<String, dynamic>{
          'uid': 'user_a',
          'currentPage': 5,
          'parentName': 'Parent A',
          'childName': 'Child A',
        });

        // User B is the active user
        final OnboardingCubit cubit = OnboardingCubit();
        cubit.init();

        // Cubit must reject user_a's draft and start at page 0
        expect(cubit.state.currentPage, 0);
        cubit.close();
      },
    );
  });
}
