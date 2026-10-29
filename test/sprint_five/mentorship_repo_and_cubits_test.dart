import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';
import 'package:loving_brain/ui/choose_support_area/bloc/choose_support_area_cubit.dart';
import 'package:loving_brain/ui/enrolled_journey_home/bloc/enrolled_journey_home_cubit.dart';
import 'package:loving_brain/ui/guide_profile/bloc/guide_profile_cubit.dart';
import 'package:loving_brain/ui/mentorship_landing/bloc/mentorship_landing_cubit.dart';
import 'package:loving_brain/ui/parent_success_guide/bloc/parent_success_guide_cubit.dart';
import 'package:loving_brain/ui/post_session_plan/bloc/post_session_plan_cubit.dart';
import 'package:loving_brain/ui/request_session/bloc/request_session_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 5: MentorshipRepo Core Catalogue & Operations', () {
    test('Seed catalogue contains vetted guides with expected data', () {
      final List<GuideProfileModel> guides = MentorshipRepo.defaultGuides;
      expect(guides.length, greaterThanOrEqualTo(3));

      final GuideProfileModel elena = guides.firstWhere(
        (GuideProfileModel g) => g.id == 'guide_elena_01',
      );
      expect(elena.name, 'Elena Rostova');
      expect(elena.isVerified, isTrue);
      expect(elena.isActive, isTrue);
      expect(elena.isAvailable, isTrue);
      expect(elena.languages, contains('English'));
      expect(elena.supportAreas, contains('Sleep'));
    });

    test(
      'GuideProfileModel.fromMap fills missing booleans and bad numbers',
      () {
        final GuideProfileModel guide =
            GuideProfileModel.fromMap(<String, dynamic>{
              'name': 'Test Guide',
              'bio': 'Bio text',
              'experienceYears': 'not-a-number',
              'sessionDurationMinutes': 'abc',
              'rating': 'xyz',
              'sortOrder': 'oops',
            }, id: 'guide_test');

        expect(guide.id, 'guide_test');
        expect(guide.experienceYears, 5);
        expect(guide.sessionDurationMinutes, 45);
        expect(guide.rating, 4.9);
        expect(guide.sortOrder, 0);
        expect(guide.isActive, isTrue);
        expect(guide.isAvailable, isTrue);
        expect(guide.isVerified, isTrue);
      },
    );

    test(
      'filterGuides maps areas, excludes inactive/booked, keeps sort order',
      () {
        final GuideProfileModel seedElena = MentorshipRepo.defaultGuides.first;
        final GuideProfileModel seedMarcus = MentorshipRepo.defaultGuides[1];
        final GuideProfileModel inactiveElena = GuideProfileModel(
          id: seedElena.id,
          name: seedElena.name,
          title: seedElena.title,
          experienceYears: seedElena.experienceYears,
          languages: seedElena.languages,
          supportAreas: seedElena.supportAreas,
          sessionDurationMinutes: seedElena.sessionDurationMinutes,
          rating: seedElena.rating,
          isVerified: seedElena.isVerified,
          isActive: false,
          isAvailable: seedElena.isAvailable,
          sortOrder: seedElena.sortOrder,
          bio: seedElena.bio,
          calendarUrl: seedElena.calendarUrl,
        );
        final GuideProfileModel bookedMarcus = GuideProfileModel(
          id: seedMarcus.id,
          name: seedMarcus.name,
          title: seedMarcus.title,
          experienceYears: seedMarcus.experienceYears,
          languages: seedMarcus.languages,
          supportAreas: seedMarcus.supportAreas,
          sessionDurationMinutes: seedMarcus.sessionDurationMinutes,
          rating: seedMarcus.rating,
          isVerified: seedMarcus.isVerified,
          isActive: true,
          isAvailable: false,
          sortOrder: seedMarcus.sortOrder,
          bio: seedMarcus.bio,
          calendarUrl: seedMarcus.calendarUrl,
        );
        final GuideProfileModel secondSleep = GuideProfileModel(
          id: 'guide_sleep_02',
          name: 'Second Sleep Guide',
          title: 'Sleep Mentor',
          experienceYears: 4,
          languages: <String>['English'],
          supportAreas: <String>['Sleep'],
          sortOrder: 0,
          bio: 'Another sleep guide',
        );
        final List<GuideProfileModel> catalogue = <GuideProfileModel>[
          inactiveElena,
          bookedMarcus,
          MentorshipRepo.defaultGuides[2],
          secondSleep,
          MentorshipRepo.defaultGuides.first,
        ];

        final List<GuideProfileModel> sleepGuides = MentorshipRepo.filterGuides(
          guides: catalogue,
          supportArea: 'Sleep guidance',
        );
        expect(
          sleepGuides.map((GuideProfileModel g) => g.id).toList(),
          <String>['guide_sleep_02', 'guide_elena_01'],
        );

        final List<GuideProfileModel> behaviourGuides =
            MentorshipRepo.filterGuides(
              guides: catalogue,
              supportArea: 'Tantrum & behaviour',
            );
        expect(behaviourGuides, isEmpty);

        final List<GuideProfileModel> coParentingGuides =
            MentorshipRepo.filterGuides(
              guides: catalogue,
              supportArea: 'Co-parenting',
            );
        expect(coParentingGuides.first.id, 'guide_priya_03');

        final List<GuideProfileModel> eatingGuides =
            MentorshipRepo.filterGuides(
              guides: catalogue,
              supportArea: 'Eating & nutrition',
            );
        expect(eatingGuides, isEmpty);

        expect(
          MentorshipRepo.hasBookedOnlyGuides(
            guides: catalogue,
            supportArea: 'Tantrum & behaviour',
          ),
          isTrue,
        );
      },
    );

    test(
      'Language preference prefers matches then falls back to area list',
      () {
        final List<GuideProfileModel> englishMatches =
            MentorshipRepo.filterGuides(
              guides: MentorshipRepo.defaultGuides,
              supportArea: 'Sleep guidance',
              language: 'English',
            );
        expect(englishMatches.first.name, 'Elena Rostova');

        final List<GuideProfileModel> fallbackArea =
            MentorshipRepo.filterGuides(
              guides: MentorshipRepo.defaultGuides,
              supportArea: 'Sleep guidance',
              language: 'French',
            );
        expect(fallbackArea.first.name, 'Elena Rostova');
      },
    );

    test('getGuideById returns guide or unknown-id error', () async {
      final ApiResultStatus<GuideProfileModel> marcus = await MentorshipRepo
          .instance
          .getGuideById('guide_marcus_02');
      expect(marcus, isA<Data<GuideProfileModel>>());
      expect((marcus as Data<GuideProfileModel>).data.name, 'Dr. Marcus Vance');

      final ApiResultStatus<GuideProfileModel> missing = await MentorshipRepo
          .instance
          .getGuideById('non_existent_id');
      expect(missing, isA<Error<GuideProfileModel>>());
    });

    test('Support areas catalogue has expected focus areas', () {
      final List<String> areas = MentorshipRepo.availableSupportAreas;
      expect(areas.length, greaterThanOrEqualTo(4));
      expect(areas, contains('Sleep'));
      expect(areas, contains('Behaviour'));
      expect(areas, contains('Eating'));
      expect(areas, contains('Co-parenting'));
    });

    test(
      'Mentorship session request creation, retrieval, and cancellation flow',
      () async {
        final MentorshipRepo repo = MentorshipRepo.instance;
        final String testUserId =
            'test_user_${DateTime.now().millisecondsSinceEpoch}';

        final MentorshipRequestModel request = MentorshipRequestModel(
          id: 'req_123',
          userId: testUserId,
          childId: 'child_123',
          childName: 'Leo',
          childAge: '18 months',
          mainConcern: 'Waking 3 times a night',
          preferredDays: 'Tuesdays, Thursdays',
          preferredLanguage: 'English',
          guideId: 'guide_elena_01',
          guideName: 'Elena Rostova',
          shareRecentSummary: true,
          status: MentorshipRequestStatus.pending,
          createdAt: DateTime.now(),
        );

        final ApiResultStatus<MentorshipRequestModel> createRes = await repo
            .createMentorshipRequest(request);
        expect(createRes, isA<Data<MentorshipRequestModel>>());
        final MentorshipRequestModel saved =
            (createRes as Data<MentorshipRequestModel>).data;
        expect(saved.id, 'req_123');
        expect(saved.status, MentorshipRequestStatus.pending);

        final ApiResultStatus<List<MentorshipRequestModel>> fetchRes =
            await repo.getMentorshipRequests(testUserId);
        expect(fetchRes, isA<Data<List<MentorshipRequestModel>>>());
        final List<MentorshipRequestModel> list =
            (fetchRes as Data<List<MentorshipRequestModel>>).data;
        expect(
          list.any((MentorshipRequestModel r) => r.id == 'req_123'),
          isTrue,
        );

        final ApiResultStatus<bool> cancelRes = await repo
            .cancelMentorshipRequest('req_123');
        expect(cancelRes, isA<Data<bool>>());

        final ApiResultStatus<List<MentorshipRequestModel>> afterCancelRes =
            await repo.getMentorshipRequests(testUserId);
        final MentorshipRequestModel cancelledItem =
            (afterCancelRes as Data<List<MentorshipRequestModel>>).data
                .firstWhere((MentorshipRequestModel r) => r.id == 'req_123');
        expect(cancelledItem.status, MentorshipRequestStatus.cancelled);
      },
    );

    test(
      'EnrolledProgramModel and PostSessionPlanModel task toggle operations',
      () async {
        final MentorshipRepo repo = MentorshipRepo.instance;
        const String childId = 'child_test_456';

        final ApiResultStatus<EnrolledProgramModel> progRes = await repo
            .getEnrolledProgram(childId);
        expect(progRes, isA<Data<EnrolledProgramModel>>());
        final EnrolledProgramModel program =
            (progRes as Data<EnrolledProgramModel>).data;
        expect(program.currentWeek, 2);
        expect(program.totalWeeks, 6);

        final ApiResultStatus<PostSessionPlanModel> planRes = await repo
            .getPostSessionPlan(childId);
        expect(planRes, isA<Data<PostSessionPlanModel>>());
        final PostSessionPlanModel plan =
            (planRes as Data<PostSessionPlanModel>).data;
        expect(plan.tasks.length, greaterThanOrEqualTo(2));

        final PlanTaskItem secondTask = plan.tasks[1];
        final bool initialStatus = secondTask.isCompleted;

        final ApiResultStatus<PostSessionPlanModel> toggledRes = await repo
            .togglePlanTask(
              childId: childId,
              taskId: secondTask.id,
              isCompleted: !initialStatus,
            );
        expect(toggledRes, isA<Data<PostSessionPlanModel>>());
        final PostSessionPlanModel updatedPlan =
            (toggledRes as Data<PostSessionPlanModel>).data;
        final PlanTaskItem updatedTask = updatedPlan.tasks.firstWhere(
          (PlanTaskItem t) => t.id == secondTask.id,
        );
        expect(updatedTask.isCompleted, !initialStatus);
      },
    );
  });

  group('Sprint 5: Mentorship Cubits State Flow', () {
    test(
      'MentorshipLandingCubit loads support areas and toggles availability',
      () {
        final MentorshipLandingCubit cubit = MentorshipLandingCubit();
        cubit.init();

        expect(cubit.state.supportAreas.length, greaterThanOrEqualTo(4));
        expect(cubit.state.isAvailable, isTrue);

        cubit.toggleAvailability();
        expect(cubit.state.isAvailable, isFalse);

        cubit.close();
      },
    );

    test('ChooseSupportAreaCubit selects area and handles initial area', () {
      final ChooseSupportAreaCubit cubit = ChooseSupportAreaCubit();
      cubit.init(initialArea: 'Tantrum & behaviour');

      expect(cubit.state.selectedIndex, 1);

      cubit.selectArea(3);
      expect(cubit.state.selectedIndex, 3);

      cubit.close();
    });

    test('Choose Support card index matches the visible cards', () {
      expect(ChooseSupportAreaCubit.indexForLabel('Sleep guidance'), 0);
      expect(ChooseSupportAreaCubit.indexForLabel('Behaviour'), 1);
      expect(ChooseSupportAreaCubit.indexForLabel('Tantrum & behaviour'), 1);
      expect(ChooseSupportAreaCubit.indexForLabel('Eating & nutrition'), 2);
      expect(ChooseSupportAreaCubit.indexForLabel('Parent Wellbeing'), 3);
      expect(ChooseSupportAreaCubit.indexForLabel('Parental confidence'), 3);
      expect(ChooseSupportAreaCubit.indexForLabel('Co-parenting'), 4);
      expect(ChooseSupportAreaCubit.indexForLabel('General Parenting'), -1);
      expect(ChooseSupportAreaCubit.optionTitles[3], 'Parental confidence');
      expect(ChooseSupportAreaCubit.optionTitles[4], 'Co-parenting');
    });

    test(
      'Support area match is exact and separates booked from empty',
      () async {
        final GuideProfileModel generalOnly = GuideProfileModel(
          id: 'guide_general',
          name: 'General Only',
          title: 'General mentor',
          experienceYears: 3,
          languages: <String>['English'],
          supportAreas: <String>['General Parenting'],
          bio: 'General support',
        );
        final List<GuideProfileModel> sleepMatches =
            MentorshipRepo.filterGuides(
              guides: <GuideProfileModel>[
                generalOnly,
                MentorshipRepo.defaultGuides.first,
              ],
              supportArea: 'Sleep guidance',
            );
        expect(sleepMatches.map((GuideProfileModel g) => g.id), <String>[
          'guide_elena_01',
        ]);

        final GuideProfileModel shortTag = GuideProfileModel(
          id: 'guide_short',
          name: 'Short Tag',
          title: 'Nope',
          experienceYears: 1,
          languages: <String>['English'],
          supportAreas: <String>['a'],
          bio: 'Should not match Sleep',
        );
        expect(
          MentorshipRepo.filterGuides(
            guides: <GuideProfileModel>[shortTag],
            supportArea: 'Sleep',
          ),
          isEmpty,
        );

        final ApiResultStatus<GuideAreaMatch> eating = await MentorshipRepo
            .instance
            .matchSupportArea('Eating & nutrition');
        expect(eating, isA<Data<GuideAreaMatch>>());
        final GuideAreaMatch eatingMatch =
            (eating as Data<GuideAreaMatch>).data;
        expect(eatingMatch.guides, isEmpty);
        expect(eatingMatch.fullyBooked, isFalse);

        final ApiResultStatus<GuideAreaMatch> sleep = await MentorshipRepo
            .instance
            .matchSupportArea('Sleep guidance');
        expect(sleep, isA<Data<GuideAreaMatch>>());
        final GuideAreaMatch sleepMatch = (sleep as Data<GuideAreaMatch>).data;
        expect(sleepMatch.fullyBooked, isFalse);
        expect(sleepMatch.guides.first.id, 'guide_elena_01');
      },
    );

    test('fromMap keeps explicit false flags and numeric strings', () {
      final GuideProfileModel guide =
          GuideProfileModel.fromMap(<String, dynamic>{
            'name': 'Hidden',
            'bio': 'Hidden bio',
            'experienceYears': '12',
            'sessionDurationMinutes': '50',
            'rating': '4.95',
            'sortOrder': '2',
            'isVerified': false,
            'isActive': false,
            'isAvailable': false,
          }, id: 'guide_hidden');
      expect(guide.experienceYears, 12);
      expect(guide.sessionDurationMinutes, 50);
      expect(guide.rating, 4.95);
      expect(guide.sortOrder, 2);
      expect(guide.isVerified, isFalse);
      expect(guide.isActive, isFalse);
      expect(guide.isAvailable, isFalse);
    });

    test(
      'GuideProfileCubit matches guide by id or support area correctly',
      () async {
        final GuideProfileCubit cubit = GuideProfileCubit();

        await cubit.init(guideId: 'guide_marcus_02');
        expect(cubit.state.guide?.name, 'Dr. Marcus Vance');

        await cubit.init(supportArea: 'Sleep');
        expect(cubit.state.guide?.name, 'Elena Rostova');

        await cubit.init(guideId: 'non_existent_id');
        expect(cubit.state.guide, isNull);
        expect(cubit.state.fetchStatus, isA<Error<dynamic>>());

        cubit.close();
      },
    );

    test(
      'RequestSessionCubit updates input and submits mentorship request',
      () async {
        final RequestSessionCubit cubit = RequestSessionCubit();
        cubit.init(
          guide: MentorshipRepo.defaultGuides.first,
          initialConcern: 'Bedtime refusal',
        );

        cubit.updateMainConcern('Difficulty falling asleep after 8 PM');
        cubit.updateChildAge('24 months');
        cubit.updatePreferredDays('Weekends only');
        cubit.updatePreferredLanguage('English & Spanish');
        cubit.toggleShareSummary(false);

        expect(cubit.state.mainConcern, 'Difficulty falling asleep after 8 PM');
        expect(cubit.state.childAge, '24 months');
        expect(cubit.state.preferredDays, 'Weekends only');
        expect(cubit.state.preferredLanguage, 'English & Spanish');
        expect(cubit.state.shareSummary, isFalse);

        final bool success = await cubit.submitRequest();
        expect(success, isTrue);
        expect(cubit.state.isSubmitting, isFalse);
        expect(cubit.state.saveStatus, isA<Data<MentorshipRequestModel>>());

        cubit.close();
      },
    );

    test(
      'EnrolledJourneyHomeCubit initializes and toggles module completion',
      () async {
        final EnrolledJourneyHomeCubit cubit = EnrolledJourneyHomeCubit();
        await cubit.init(childId: 'child_test_journey');

        expect(cubit.state.program?.title, '6-Week Sleep Reset Journey');
        expect(cubit.state.program?.currentWeek, 2);

        final bool initialStatus = cubit.state.program!.isModuleCompleted;
        cubit.toggleModuleCompleted();
        expect(cubit.state.program?.isModuleCompleted, !initialStatus);

        cubit.close();
      },
    );

    test('PostSessionPlanCubit toggles tasks properly', () async {
      final PostSessionPlanCubit cubit = PostSessionPlanCubit();
      await cubit.init(childId: 'child_plan_test');

      expect(cubit.state.plan?.tasks.isNotEmpty, isTrue);
      final PlanTaskItem firstTask = cubit.state.plan!.tasks.first;
      final bool statusBefore = firstTask.isCompleted;

      await cubit.toggleTask(firstTask.id);
      final PlanTaskItem toggledFirst = cubit.state.plan!.tasks.firstWhere(
        (PlanTaskItem t) => t.id == firstTask.id,
      );
      expect(toggledFirst.isCompleted, !statusBefore);

      cubit.close();
    });

    test('ParentSuccessGuideCubit cancels mentorship request', () async {
      final ParentSuccessGuideCubit cubit = ParentSuccessGuideCubit();
      await cubit.init();

      expect(cubit.state.guide?.name, isNotNull);
      expect(cubit.state.activeGoals, isEmpty);

      // Create a temporary request in repo
      final MentorshipRequestModel req = MentorshipRequestModel(
        id: 'req_cancel_test',
        userId: 'user_local',
        childId: 'child_local',
        childName: 'Emma',
        childAge: '2 years',
        mainConcern: 'Night waking',
        preferredDays: 'Mondays',
        preferredLanguage: 'English',
        guideId: 'guide_elena_01',
        guideName: 'Elena Rostova',
        shareRecentSummary: true,
        status: MentorshipRequestStatus.pending,
        createdAt: DateTime.now(),
      );
      await MentorshipRepo.instance.createMentorshipRequest(req);

      await cubit.init();
      expect(
        cubit.state.pendingRequests.any(
          (MentorshipRequestModel r) => r.id == 'req_cancel_test',
        ),
        isTrue,
      );

      await cubit.cancelRequest('req_cancel_test');
      final MentorshipRequestModel target = cubit.state.pendingRequests
          .firstWhere((MentorshipRequestModel r) => r.id == 'req_cancel_test');
      expect(target.status, MentorshipRequestStatus.cancelled);

      cubit.close();
    });
  });
}
