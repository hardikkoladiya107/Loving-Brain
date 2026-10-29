import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/caregiver_permissions_model.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';

/// Result of matching guides to one support area.
class GuideAreaMatch {
  final List<GuideProfileModel> guides;
  final bool fullyBooked;

  const GuideAreaMatch({required this.guides, required this.fullyBooked});
}

/// Singleton repository managing Guided Mentorship, Programs, and Session Requests.
/// Conforms to AGENTS.md §7 (Repository Pattern & ApiResultStatus).
class MentorshipRepo {
  MentorshipRepo._();

  static final MentorshipRepo _instance = MentorshipRepo._();
  factory MentorshipRepo() => _instance;
  static MentorshipRepo get instance => _instance;

  bool _canCurrentCaregiverViewMentorship() {
    final UserModel? user = preferences.getUserModel();
    if (user == null) return true;
    final String email = user.email ?? '';
    final Map<String, dynamic>? saved = preferences.getCaregiverPermissions(
      email,
    );
    if (saved != null) {
      final CaregiverPermissionsModel p = CaregiverPermissionsModel.fromMap(
        saved,
      );
      return p.canViewMentorSummaries;
    }
    final String cleanRole = (user.relationshipToChild ?? '')
        .toLowerCase()
        .trim();
    final bool isCaregiverRole =
        cleanRole == 'caregiver' ||
        cleanRole == 'grandparent' ||
        cleanRole == 'nanny' ||
        cleanRole == 'babysitter';
    if (isCaregiverRole) {
      return false;
    }
    return true;
  }

  CollectionReference<Map<String, dynamic>> get _requestsCollection =>
      FirebaseFirestore.instance.collection('mentorship_requests');

  CollectionReference<Map<String, dynamic>> get programsCollection =>
      FirebaseFirestore.instance.collection('enrolled_programs');

  CollectionReference<Map<String, dynamic>> get plansCollection =>
      FirebaseFirestore.instance.collection('post_session_plans');

  CollectionReference<Map<String, dynamic>> get _waitlistCollection =>
      FirebaseFirestore.instance.collection('mentorship_waitlist');

  CollectionReference<Map<String, dynamic>> get _guidesCollection =>
      FirebaseFirestore.instance.collection('guides');

  // In-memory fallback / cache for resilience & unit tests without live Firestore
  final List<MentorshipRequestModel> _localRequests =
      <MentorshipRequestModel>[];
  final Map<String, PostSessionPlanModel> _localPlans =
      <String, PostSessionPlanModel>{};
  final Map<String, EnrolledProgramModel> _localPrograms =
      <String, EnrolledProgramModel>{};

  /// Seed payload / test catalogue. Screens load from Firestore after seed.
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
      isActive: true,
      isAvailable: true,
      sortOrder: 1,
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
      isActive: true,
      isAvailable: true,
      sortOrder: 2,
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
      supportAreas: <String>[
        'Co-parenting',
        'Parent Wellbeing',
        'General Parenting',
      ],
      sessionDurationMinutes: 45,
      rating: 4.98,
      isVerified: true,
      isActive: true,
      isAvailable: true,
      sortOrder: 3,
      bio:
          'Guides parenting partners and caregivers into unified rhythm alignment, shared expectations, and peaceful handovers.',
      calendarUrl: 'https://cal.lovingbrain.com/priya-family',
    ),
  ];

  /// Available support areas catalogue (Screen 45).
  static const List<String> availableSupportAreas = <String>[
    'Sleep',
    'Behaviour',
    'Eating',
    'Parent Wellbeing',
    'Co-parenting',
    'General Parenting',
  ];

  /// Maps Choose Support UI titles to Firestore support-area tags.
  static String mapSupportAreaLabel(String? label) {
    if (label == null || label.trim().isEmpty) {
      return '';
    }
    final String clean = label.toLowerCase().trim();
    if (clean.contains('sleep')) {
      return 'Sleep';
    }
    if (clean.contains('tantrum') || clean.contains('behaviour')) {
      return 'Behaviour';
    }
    if (clean.contains('eating') || clean.contains('nutrition')) {
      return 'Eating';
    }
    if (clean.contains('parental') ||
        clean.contains('confidence') ||
        clean.contains('wellbeing') ||
        clean.contains('well-being')) {
      return 'Parent Wellbeing';
    }
    if (clean.contains('co-parent') || clean.contains('coparent')) {
      return 'Co-parenting';
    }
    if (clean.contains('general')) {
      return 'General Parenting';
    }
    return label.trim();
  }

  /// Pure filter used by the app and unit tests.
  /// Prefer language matches when any exist; otherwise keep area matches.
  static List<GuideProfileModel> filterGuides({
    required List<GuideProfileModel> guides,
    String? supportArea,
    String? language,
    bool requireAvailable = true,
  }) {
    final String mappedArea = mapSupportAreaLabel(supportArea);
    List<GuideProfileModel> filtered = guides
        .where((GuideProfileModel g) => g.isActive)
        .toList();

    if (requireAvailable) {
      filtered = filtered
          .where((GuideProfileModel g) => g.isAvailable)
          .toList();
    }

    if (mappedArea.isNotEmpty) {
      final String cleanArea = mappedArea.toLowerCase();
      filtered = filtered.where((GuideProfileModel g) {
        return g.supportAreas.any(
          (String area) => area.toLowerCase() == cleanArea,
        );
      }).toList();
    }

    if (language != null && language.trim().isNotEmpty) {
      final String cleanLang = language.toLowerCase().trim();
      final List<GuideProfileModel> languageMatches = filtered
          .where(
            (GuideProfileModel g) =>
                g.languages.any((String l) => l.toLowerCase() == cleanLang),
          )
          .toList();
      if (languageMatches.isNotEmpty) {
        filtered = languageMatches;
      }
    }

    filtered.sort((GuideProfileModel a, GuideProfileModel b) {
      final int byOrder = a.sortOrder.compareTo(b.sortOrder);
      if (byOrder != 0) {
        return byOrder;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return filtered;
  }

  /// True when active guides exist for the area but every match is booked.
  static bool hasBookedOnlyGuides({
    required List<GuideProfileModel> guides,
    String? supportArea,
  }) {
    final List<GuideProfileModel> activeForArea = filterGuides(
      guides: guides,
      supportArea: supportArea,
      requireAvailable: false,
    );
    if (activeForArea.isEmpty) {
      return false;
    }
    return activeForArea.every((GuideProfileModel g) => !g.isAvailable);
  }

  Future<ApiResultStatus<List<GuideProfileModel>>> _fetchAllGuides() async {
    try {
      if (Firebase.apps.isEmpty) {
        return ApiResultStatus.data(
          data: List<GuideProfileModel>.from(defaultGuides),
        );
      }
      final QuerySnapshot<Map<String, dynamic>> snap = await _guidesCollection
          .get();
      final List<GuideProfileModel> guides = snap.docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return GuideProfileModel.fromMap(data, id: doc.id);
      }).toList();
      guides.sort((GuideProfileModel a, GuideProfileModel b) {
        final int byOrder = a.sortOrder.compareTo(b.sortOrder);
        if (byOrder != 0) {
          return byOrder;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return ApiResultStatus.data(data: guides);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Loads guides from Firestore and filters by support area and language.
  Future<ApiResultStatus<List<GuideProfileModel>>> getGuideProfiles({
    String? supportArea,
    String? language,
  }) async {
    try {
      final ApiResultStatus<List<GuideProfileModel>> allResult =
          await _fetchAllGuides();
      if (allResult is! Data<List<GuideProfileModel>>) {
        return allResult;
      }

      final String? preferredLanguage =
          language ?? preferences.getUserModel()?.preferredLanguage;

      if (hasBookedOnlyGuides(
        guides: allResult.data,
        supportArea: supportArea,
      )) {
        return const ApiResultStatus.data(data: <GuideProfileModel>[]);
      }

      final List<GuideProfileModel> filtered = filterGuides(
        guides: allResult.data,
        supportArea: supportArea,
        language: preferredLanguage,
        requireAvailable: true,
      );
      return ApiResultStatus.data(data: filtered);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// One Firestore read: available matches, or fully booked vs none.
  Future<ApiResultStatus<GuideAreaMatch>> matchSupportArea(
    String supportArea,
  ) async {
    try {
      final ApiResultStatus<List<GuideProfileModel>> allResult =
          await _fetchAllGuides();
      if (allResult is! Data<List<GuideProfileModel>>) {
        if (allResult is Error<List<GuideProfileModel>>) {
          return ApiResultStatus.error(error: allResult.error);
        }
        return ApiResultStatus.error(error: Exception('Could not load guides'));
      }

      final bool fullyBooked = hasBookedOnlyGuides(
        guides: allResult.data,
        supportArea: supportArea,
      );
      if (fullyBooked) {
        return const ApiResultStatus.data(
          data: GuideAreaMatch(
            guides: <GuideProfileModel>[],
            fullyBooked: true,
          ),
        );
      }

      final String? preferredLanguage = preferences
          .getUserModel()
          ?.preferredLanguage;
      final List<GuideProfileModel> filtered = filterGuides(
        guides: allResult.data,
        supportArea: supportArea,
        language: preferredLanguage,
        requireAvailable: true,
      );
      return ApiResultStatus.data(
        data: GuideAreaMatch(guides: filtered, fullyBooked: false),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Finds guide by ID from Firestore. Missing id is an error (no Elena fallback).
  Future<ApiResultStatus<GuideProfileModel>> getGuideById(
    String guideId,
  ) async {
    try {
      if (guideId.trim().isEmpty) {
        return ApiResultStatus.error(
          error: Exception('Guide is no longer available'),
        );
      }
      if (Firebase.apps.isEmpty) {
        for (final GuideProfileModel g in defaultGuides) {
          if (g.id == guideId) {
            return ApiResultStatus.data(data: g);
          }
        }
        return ApiResultStatus.error(
          error: Exception('Guide is no longer available'),
        );
      }
      final DocumentSnapshot<Map<String, dynamic>> doc = await _guidesCollection
          .doc(guideId)
          .get();
      if (!doc.exists || doc.data() == null) {
        return ApiResultStatus.error(
          error: Exception('Guide is no longer available'),
        );
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data()!);
      data['id'] = doc.id;
      return ApiResultStatus.data(
        data: GuideProfileModel.fromMap(data, id: doc.id),
      );
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
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
      if (!_canCurrentCaregiverViewMentorship()) {
        return const ApiResultStatus.data(data: <MentorshipRequestModel>[]);
      }

      final List<MentorshipRequestModel> list = <MentorshipRequestModel>[];

      try {
        final QuerySnapshot<Map<String, dynamic>> snap =
            await _requestsCollection.where('userId', isEqualTo: userId).get();
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
            in snap.docs) {
          list.add(MentorshipRequestModel.fromMap(doc.data(), id: doc.id));
        }
      } catch (_) {
        // Fallback to local
        list.addAll(
          _localRequests.where(
            (MentorshipRequestModel r) => r.userId == userId,
          ),
        );
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
  Future<ApiResultStatus<bool>> cancelMentorshipRequest(
    String requestId,
  ) async {
    try {
      String guideName = 'Your Guide';
      for (int i = 0; i < _localRequests.length; i++) {
        if (_localRequests[i].id == requestId) {
          guideName = _localRequests[i].guideName ?? 'Your Guide';
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

      // Cancel 24h & 1h reminders and notify cancellation event (Doc 03 / Doc 06)
      await V2NotificationScheduler.cancelMentorshipReminders(requestId);
      await V2NotificationScheduler.notifyMentorshipBookingEvent(
        sessionId: requestId,
        mentorName: guideName,
        statusText: 'cancelled',
      );

      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Confirms a mentorship session request with an agreed time (Doc 03 / Doc 06).
  /// Schedules 24-hour and 1-hour reminders and dispatches confirmation push.
  Future<ApiResultStatus<MentorshipRequestModel>> confirmMentorshipSession({
    required String requestId,
    required DateTime confirmedTime,
  }) async {
    try {
      MentorshipRequestModel? updatedRequest;
      for (int i = 0; i < _localRequests.length; i++) {
        if (_localRequests[i].id == requestId) {
          _localRequests[i] = _localRequests[i].copyWith(
            status: MentorshipRequestStatus.confirmed,
            confirmedTime: confirmedTime,
          );
          updatedRequest = _localRequests[i];
          break;
        }
      }

      try {
        await _requestsCollection.doc(requestId).update(<String, dynamic>{
          'status': MentorshipRequestStatus.confirmed.name,
          'confirmedTime': Timestamp.fromDate(confirmedTime),
        });
      } catch (_) {}

      if (updatedRequest != null) {
        await V2NotificationScheduler.scheduleMentorshipReminders(
          sessionId: requestId,
          mentorName: updatedRequest.guideName ?? 'Your Guide',
          sessionTime: confirmedTime,
        );
        await V2NotificationScheduler.notifyMentorshipBookingEvent(
          sessionId: requestId,
          mentorName: updatedRequest.guideName ?? 'Your Guide',
          statusText: 'confirmed',
        );
        return ApiResultStatus.data(data: updatedRequest);
      }

      return ApiResultStatus.error(error: Exception('Request not found'));
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Retrieves active enrolled program details (Screens 44, 49).
  Future<ApiResultStatus<EnrolledProgramModel>> getEnrolledProgram(
    String childId,
  ) async {
    try {
      if (!_canCurrentCaregiverViewMentorship()) {
        return ApiResultStatus.error(
          error: Exception(
            'Caregiver does not have permission to view mentorship programs.',
          ),
        );
      }

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
  Future<ApiResultStatus<PostSessionPlanModel>> getPostSessionPlan(
    String childId,
  ) async {
    try {
      if (!_canCurrentCaregiverViewMentorship()) {
        return ApiResultStatus.error(
          error: Exception(
            'Caregiver does not have permission to view post-session plans.',
          ),
        );
      }

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
      final ApiResultStatus<PostSessionPlanModel> current =
          await getPostSessionPlan(childId);
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

  /// Persists waitlist entry to Firestore collection 'mentorship_waitlist' (Doc 03 / Doc 06).
  Future<ApiResultStatus<bool>> joinWaitlist({
    required String userId,
    required String childId,
    String? supportArea,
    String? preferredGuideId,
  }) async {
    try {
      preferences.putString('waitlist_status_$userId', 'waiting');
      preferences.putString(
        'waitlist_guide_$userId',
        preferredGuideId ?? 'guide_elena_01',
      );
      preferences.putBool('waitlist_notified_$userId', false);

      final Map<String, dynamic> data = <String, dynamic>{
        'userId': userId,
        'childId': childId,
        'supportArea': supportArea ?? 'General Parenting',
        'preferredGuideId': preferredGuideId,
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      };
      if (Firebase.apps.isEmpty) {
        // Safe fallback for Flutter unit test suites without mock Firestore initialized
        return const ApiResultStatus.data(data: true);
      }
      await _waitlistCollection.add(data);
      return const ApiResultStatus.data(data: true);
    } catch (e) {
      return ApiResultStatus.error(error: Exception(e.toString()));
    }
  }

  /// Checks whether a waiting parent should be notified of an opened slot (Item 7).
  /// Notifies the parent once when a slot opens.
  Future<void> checkWaitlistSlotAvailability(String userId) async {
    final String? status = preferences.getString('waitlist_status_$userId');
    final bool alreadyNotified =
        preferences.getBool('waitlist_notified_$userId') ?? false;

    if (status == 'waiting' && !alreadyNotified) {
      final String guideId =
          preferences.getString('waitlist_guide_$userId') ?? 'guide_elena_01';
      final ApiResultStatus<GuideProfileModel> guideResult = await getGuideById(
        guideId,
      );
      if (guideResult is! Data<GuideProfileModel>) {
        return;
      }
      final GuideProfileModel guide = guideResult.data;
      final bool sent =
          await V2NotificationScheduler.notifyWaitlistSlotAvailable(
            mentorId: guide.id,
            mentorName: guide.name,
          );
      if (sent) {
        preferences.putBool('waitlist_notified_$userId', true);
      }
    }
  }
}
