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
    test(
      'Default guides catalogue contains vetted guides with expected data',
      () {
        final List<GuideProfileModel> guides = MentorshipRepo.defaultGuides;
        expect(guides.length, greaterThanOrEqualTo(3));

        final GuideProfileModel elena = guides.firstWhere(
          (GuideProfileModel g) => g.id == 'guide_elena_01',
        );
        expect(elena.name, 'Elena Rostova');
        expect(elena.isVerified, isTrue);
        expect(elena.languages, contains('English'));
        expect(elena.supportAreas, contains('Sleep'));

        final GuideProfileModel marcus = MentorshipRepo.instance.getGuideById(
          'guide_marcus_02',
        );
        expect(marcus.name, 'Dr. Marcus Vance');
        expect(marcus.supportAreas, contains('Behaviour'));

        final GuideProfileModel fallback = MentorshipRepo.instance.getGuideById(
          'non_existent_id',
        );
        expect(fallback.id, 'guide_elena_01');
      },
    );

    test('Support areas catalogue has expected focus areas', () {
      final List<String> areas = MentorshipRepo.availableSupportAreas;
      expect(areas.length, greaterThanOrEqualTo(4));
      expect(areas, contains('Sleep'));
      expect(areas, contains('Behaviour'));
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

    test('GuideProfileCubit matches guide by id or support area correctly', () {
      final GuideProfileCubit cubit = GuideProfileCubit();

      cubit.init(guideId: 'guide_marcus_02');
      expect(cubit.state.guide?.name, 'Dr. Marcus Vance');

      cubit.init(supportArea: 'Sleep');
      expect(cubit.state.guide?.name, 'Elena Rostova');

      cubit.close();
    });

    test(
      'RequestSessionCubit updates input and submits mentorship request',
      () async {
        final RequestSessionCubit cubit = RequestSessionCubit();
        cubit.init(initialConcern: 'Bedtime refusal');

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
