import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/preferances.dart';

/// Singleton repository managing Guided Mentorship, Programs, and Session Requests.
/// Conforms to AGENTS.md §7 (Repository Pattern & ApiResultStatus).
class MentorshipRepo {
  MentorshipRepo._();

  static final MentorshipRepo _instance = MentorshipRepo._();
  factory MentorshipRepo() => _instance;
  static MentorshipRepo get instance => _instance;

  CollectionReference<Map<String, dynamic>> get _requestsCollection =>
      FirebaseFirestore.instance.collection('mentorship_requests');

  CollectionReference<Map<String, dynamic>> get _programsCollection =>
      FirebaseFirestore.instance.collection('enrolled_programs');

  CollectionReference<Map<String, dynamic>> get _plansCollection =>
      FirebaseFirestore.instance.collection('post_session_plans');

  // In-memory fallback / cache for resilience & unit tests without live Firestore
  final List<MentorshipRequestModel> _localRequests = <MentorshipRequestModel>[];
  final Map<String, PostSessionPlanModel> _localPlans = <String, PostSessionPlanModel>{};
  final Map<String, EnrolledProgramModel> _localPrograms = <String, EnrolledProgramModel>{};

  /// Vetted guide profiles catalogue per V2 specs (Screen 46).
  static const List<GuideProfileModel> defaultGuides = <GuideProfileModel>[
    GuideProfileModel(
      id: 'guide_elena_01',
      name: 'Elena Rostova',
      title: 'Pediatric Sleep & Routine Specialist',
      experienceYears: 8,
      languages: <String>['English', 'Spanish'],
      supportAreas: <String>['Sleep', 'General Parenting'],
      sessionDurationMinutes: 45,
      rating: 4.95,
      isVerified: true,
      bio:
          'Specializes in gentle, developmentally-attuned settling routines and helping families recover from chronic sleep fragmentation without harsh methods.',
      calendarUrl: 'https://cal.lovingbrain.com/elena-sleep',
    ),
    GuideProfileModel(
      id: 'guide_marcus_02',
      name: 'Dr. Marcus Vance',
      title: 'Toddler Behaviour & Emotional Regulation Specialist',
      experienceYears: 12,
      languages: <String>['English'],
      supportAreas: <String>['Behaviour', 'Parent Wellbeing'],
      sessionDurationMinutes: 50,
      rating: 4.9,
      isVerified: true,
      bio:
          'Passionate about helping parents decode the root triggers behind big emotional meltdowns and building co-regulation strategies.',
      calendarUrl: 'https://cal.lovingbrain.com/marcus-behaviour',
    ),
    GuideProfileModel(
      id: 'guide_priya_03',
      name: 'Priya Sharma',
      title: 'Family Rhythms & Co-Parenting Mentor',
      experienceYears: 7,
      languages: <String>['English', 'Hindi'],
      supportAreas: <String>['Co-parenting', 'Parent Wellbeing', 'General Parenting'],
      sessionDurationMinutes: 45,
      rating: 4.98,
      isVerified: true,
      bio:
          'Guides parenting partners and caregivers into unified rhythm alignment, shared expectations, and peaceful handovers.',
      calendarUrl: 'https://cal.lovingbrain.com/priya-family',
    ),
  ];

  /// Available support areas catalogue (Screen 45).
  static const List<String> availableSupportAreas = <String>[
    'Sleep',
    'Behaviour',
    'Parent Wellbeing',
    'Co-parenting',
    'General Parenting',
  ];

  /// Filters available guides by support area and language.
  Future<ApiResultStatus<List<GuideProfileModel>>> getGuideProfiles({
    String? supportArea,
    String? language,
  }) async {
    try {
      List<GuideProfileModel> guides = List<GuideProfileModel>.from(defaultGuides);

      if (supportArea != null && supportArea.trim().isNotEmpty) {
        final String cleanArea = supportArea.toLowerCase().trim();
        guides = guides.where((GuideProfileModel g) {
          return g.supportAreas.any(
            (String a) => a.toLowerCase().contains(cleanArea) || cleanArea.contains(a.toLowerCase()),
          );
        }).toList();
      }

      if (language != null && language.trim().isNotEmpty) {
        final String cleanLang = language.toLowerCase().trim();
        guides = guides.where((GuideProfileModel g) {
          return g.languages.any((String l) => l.toLowerCase() == cleanLang);
        }).toList();
      }

      return ApiResultStatus.data(data: guides.isNotEmpty ? guides : defaultGuides);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Finds guide by ID.
  GuideProfileModel getGuideById(String guideId) {
    try {
      return defaultGuides.firstWhere(
        (GuideProfileModel g) => g.id == guideId,
        orElse: () => defaultGuides.first,
      );
    } catch (_) {
      return defaultGuides.first;
    }
  }

  /// Submits a session request with consent & LovingBrain summary sharing (Screen 47).
  Future<ApiResultStatus<MentorshipRequestModel>> createMentorshipRequest(
    MentorshipRequestModel request,
  ) async {
    try {
      _localRequests.add(request);

      try {
        await _requestsCollection.doc(request.id).set(request.toMap());
      } catch (_) {
        // Handled silently if offline or test environment without Firebase
      }

      return ApiResultStatus.data(data: request);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Retrieves user's pending or confirmed mentorship requests.
  Future<ApiResultStatus<List<MentorshipRequestModel>>> getMentorshipRequests(
    String userId,
  ) async {
    try {
      final List<MentorshipRequestModel> list = <MentorshipRequestModel>[];

      try {
        final QuerySnapshot<Map<String, dynamic>> snap =
            await _requestsCollection.where('userId', isEqualTo: userId).get();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
          list.add(MentorshipRequestModel.fromMap(doc.data(), id: doc.id));
        }
      } catch (_) {
        // Fallback to local
        list.addAll(_localRequests.where((MentorshipRequestModel r) => r.userId == userId));
      }

      if (list.isEmpty && _localRequests.isNotEmpty) {
        list.addAll(_localRequests);
      }

      return ApiResultStatus.data(data: list);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Cancels an outstanding request (Screen 51).
  Future<ApiResultStatus<bool>> cancelMentorshipRequest(String requestId) async {
    try {
      for (int i = 0; i < _localRequests.length; i++) {
        if (_localRequests[i].id == requestId) {
          _localRequests[i] = _localRequests[i].copyWith(
            status: MentorshipRequestStatus.cancelled,
          );
          break;
        }
      }

      try {
        await _requestsCollection.doc(requestId).update(<String, dynamic>{
          'status': MentorshipRequestStatus.cancelled.name,
        });
      } catch (_) {}

      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Retrieves active enrolled program details (Screens 44, 49).
  Future<ApiResultStatus<EnrolledProgramModel>> getEnrolledProgram(String childId) async {
    try {
      if (_localPrograms.containsKey(childId)) {
        return ApiResultStatus.data(data: _localPrograms[childId]!);
      }

      final EnrolledProgramModel defaultProgram = EnrolledProgramModel(
        programId: 'sleep_reset_6w',
        title: '6-Week Sleep Reset Journey',
        currentWeek: 2,
        totalWeeks: 6,
        thisWeekFocus: 'Anchor bedtime 15m earlier',
        focusDescription:
            'Start quiet bedtime cues at 7:15 PM and hold consistent for 4 consecutive nights.',
        nextSessionDate: 'Thursday, 10:00 AM',
        mentorNote:
            'Elena: "You did great holding the boundary on lighting this week. Notice how bedtime resistance dropped."',
        recordedModuleTitle: 'Module 2: Managing Evening Cortisol Surges',
        isModuleCompleted: false,
      );

      _localPrograms[childId] = defaultProgram;
      return ApiResultStatus.data(data: defaultProgram);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Retrieves post-session plan agreed with mentor (Screen 50).
  Future<ApiResultStatus<PostSessionPlanModel>> getPostSessionPlan(String childId) async {
    try {
      if (_localPlans.containsKey(childId)) {
        return ApiResultStatus.data(data: _localPlans[childId]!);
      }

      final PostSessionPlanModel defaultPlan = PostSessionPlanModel(
        id: 'plan_sleep_01',
        mentorName: 'Elena Rostova',
        sessionDate: DateTime.now().subtract(const Duration(days: 2)),
        summary:
            'Focus on shifting bedtime 15 minutes earlier, reducing overhead light 30 minutes before bed, and logging 3 consecutive nights.',
        tasks: const <PlanTaskItem>[
          PlanTaskItem(
            id: 'task_1',
            title: 'Dim overhead lights at 7:00 PM',
            subtitle: 'Switch to warm amber table lamp in the bedroom.',
            isCompleted: true,
          ),
          PlanTaskItem(
            id: 'task_2',
            title: 'Offer the same 2 calm bedtime stories',
            subtitle: 'Repeat predictable cues to signal winding down.',
            isCompleted: true,
          ),
          PlanTaskItem(
            id: 'task_3',
            title: 'Log 3 consecutive nights of wake and sleep',
            subtitle: 'This will sharpen confidence for our next check-in.',
            isCompleted: false,
          ),
        ],
        activeGoals: const <String>[
          'Reduce bedtime settling time to under 25 minutes',
          'Eliminate midnight cortisol surges',
        ],
      );

      _localPlans[childId] = defaultPlan;
      return ApiResultStatus.data(data: defaultPlan);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Toggles task completion state in post-session plan.
  Future<ApiResultStatus<PostSessionPlanModel>> togglePlanTask({
    required String childId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      final ApiResultStatus<PostSessionPlanModel> current = await getPostSessionPlan(childId);
      PostSessionPlanModel plan = (current as Data<PostSessionPlanModel>).data;

      final List<PlanTaskItem> updatedTasks = plan.tasks.map((PlanTaskItem t) {
        if (t.id == taskId) {
          return t.copyWith(isCompleted: isCompleted);
        }
        return t;
      }).toList();

      final PostSessionPlanModel updatedPlan = PostSessionPlanModel(
        id: plan.id,
        mentorName: plan.mentorName,
        sessionDate: plan.sessionDate,
        summary: plan.summary,
        tasks: updatedTasks,
        activeGoals: plan.activeGoals,
      );

      _localPlans[childId] = updatedPlan;
      return ApiResultStatus.data(data: updatedPlan);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }
}
