import 'package:cloud_firestore/cloud_firestore.dart';

/// Request status enumeration per V2 specification.
enum MentorshipRequestStatus { pending, confirmed, completed, cancelled }

/// Model representing a parent's request for a human mentor session (Screens 47, 48, 51).
class MentorshipRequestModel {
  final String id;
  final String userId;
  final String childId;
  final String childName;
  final String childAge;
  final String mainConcern;
  final String preferredDays;
  final String preferredLanguage;
  final String? guideId;
  final String? guideName;
  final bool shareRecentSummary;
  final MentorshipRequestStatus status;
  final DateTime createdAt;
  final DateTime? confirmedTime;

  const MentorshipRequestModel({
    required this.id,
    required this.userId,
    required this.childId,
    required this.childName,
    required this.childAge,
    required this.mainConcern,
    required this.preferredDays,
    required this.preferredLanguage,
    this.guideId,
    this.guideName,
    this.shareRecentSummary = false,
    this.status = MentorshipRequestStatus.pending,
    required this.createdAt,
    this.confirmedTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'childId': childId,
      'childName': childName,
      'childAge': childAge,
      'mainConcern': mainConcern,
      'preferredDays': preferredDays,
      'preferredLanguage': preferredLanguage,
      'guideId': guideId,
      'guideName': guideName,
      'shareRecentSummary': shareRecentSummary,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'confirmedTime': confirmedTime != null
          ? Timestamp.fromDate(confirmedTime!)
          : null,
    };
  }

  factory MentorshipRequestModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    DateTime parsedDate = DateTime.now();
    final dynamic rawCreated = map['createdAt'];
    if (rawCreated is Timestamp) {
      parsedDate = rawCreated.toDate();
    } else if (rawCreated is String) {
      parsedDate = DateTime.tryParse(rawCreated) ?? DateTime.now();
    }

    DateTime? parsedConfirmedTime;
    final dynamic rawConfirmed = map['confirmedTime'];
    if (rawConfirmed is Timestamp) {
      parsedConfirmedTime = rawConfirmed.toDate();
    } else if (rawConfirmed is String) {
      parsedConfirmedTime = DateTime.tryParse(rawConfirmed);
    }

    MentorshipRequestStatus parsedStatus = MentorshipRequestStatus.pending;
    final String? statusStr = map['status']?.toString();
    if (statusStr != null) {
      for (final MentorshipRequestStatus s in MentorshipRequestStatus.values) {
        if (s.name == statusStr) {
          parsedStatus = s;
          break;
        }
      }
    }

    return MentorshipRequestModel(
      id: id ?? map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      childId: map['childId']?.toString() ?? '',
      childName: map['childName']?.toString() ?? 'your child',
      childAge: map['childAge']?.toString() ?? '',
      mainConcern: map['mainConcern']?.toString() ?? 'General parenting',
      preferredDays: map['preferredDays']?.toString() ?? 'Weekdays',
      preferredLanguage: map['preferredLanguage']?.toString() ?? 'English',
      guideId: map['guideId']?.toString(),
      guideName: map['guideName']?.toString(),
      shareRecentSummary: map['shareRecentSummary'] == true,
      status: parsedStatus,
      createdAt: parsedDate,
      confirmedTime: parsedConfirmedTime,
    );
  }

  MentorshipRequestModel copyWith({
    String? id,
    String? userId,
    String? childId,
    String? childName,
    String? childAge,
    String? mainConcern,
    String? preferredDays,
    String? preferredLanguage,
    String? guideId,
    String? guideName,
    bool? shareRecentSummary,
    MentorshipRequestStatus? status,
    DateTime? createdAt,
    DateTime? confirmedTime,
  }) {
    return MentorshipRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      mainConcern: mainConcern ?? this.mainConcern,
      preferredDays: preferredDays ?? this.preferredDays,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      guideId: guideId ?? this.guideId,
      guideName: guideName ?? this.guideName,
      shareRecentSummary: shareRecentSummary ?? this.shareRecentSummary,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedTime: confirmedTime ?? this.confirmedTime,
    );
  }
}

/// Model for human mentors/guides (Screen 46).
class GuideProfileModel {
  final String id;
  final String name;
  final String title;
  final int experienceYears;
  final List<String> languages;
  final List<String> supportAreas;
  final int sessionDurationMinutes;
  final double rating;
  final bool isVerified;
  final bool isActive;
  final bool isAvailable;
  final int sortOrder;
  final String bio;
  final String? calendarUrl;

  const GuideProfileModel({
    required this.id,
    required this.name,
    required this.title,
    required this.experienceYears,
    required this.languages,
    required this.supportAreas,
    this.sessionDurationMinutes = 45,
    this.rating = 4.9,
    this.isVerified = true,
    this.isActive = true,
    this.isAvailable = true,
    this.sortOrder = 0,
    required this.bio,
    this.calendarUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'title': title,
      'experienceYears': experienceYears,
      'languages': languages,
      'supportAreas': supportAreas,
      'sessionDurationMinutes': sessionDurationMinutes,
      'rating': rating,
      'isVerified': isVerified,
      'isActive': isActive,
      'isAvailable': isAvailable,
      'sortOrder': sortOrder,
      'bio': bio,
      'calendarUrl': calendarUrl,
    };
  }

  factory GuideProfileModel.fromMap(Map<String, dynamic> map, {String? id}) {
    final int experienceYears = _readInt(map['experienceYears'], 5);
    final int sessionDurationMinutes = _readInt(
      map['sessionDurationMinutes'],
      45,
    );
    final double rating = _readDouble(map['rating'], 4.9);
    final int sortOrder = _readInt(map['sortOrder'], 0);

    return GuideProfileModel(
      id: id ?? map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Parenting Guide',
      experienceYears: experienceYears,
      languages:
          (map['languages'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          <String>['English'],
      supportAreas:
          (map['supportAreas'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          <String>['Sleep'],
      sessionDurationMinutes: sessionDurationMinutes,
      rating: rating,
      isVerified: map['isVerified'] != false,
      isActive: map['isActive'] != false,
      isAvailable: map['isAvailable'] != false,
      sortOrder: sortOrder,
      bio: map['bio']?.toString() ?? '',
      calendarUrl: map['calendarUrl']?.toString(),
    );
  }

  static int _readInt(dynamic value, int fallback) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  static double _readDouble(dynamic value, double fallback) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }
}

/// Model for an active structured program enrollment (Screens 44, 49).
class EnrolledProgramModel {
  final String programId;
  final String title;
  final int currentWeek;
  final int totalWeeks;
  final String thisWeekFocus;
  final String focusDescription;
  final String nextSessionDate;
  final String mentorNote;
  final String recordedModuleTitle;
  final bool isModuleCompleted;

  const EnrolledProgramModel({
    String? id,
    String? programId,
    required this.title,
    required this.currentWeek,
    this.totalWeeks = 6,
    String? thisWeekFocus,
    String? currentFocus,
    String? focusDescription,
    String? nextSessionDate,
    String? mentorNote,
    String? guideName,
    String? recentQuote,
    String? quoteAuthorAndTime,
    String? recordedModuleTitle,
    String? recordedModuleDuration,
    this.isModuleCompleted = false,
  }) : programId = programId ?? id ?? 'sleep_reset_6w',
       thisWeekFocus =
           thisWeekFocus ?? currentFocus ?? 'Anchor bedtime 15m earlier',
       focusDescription =
           focusDescription ??
           'Start quiet bedtime cues at 7:15 PM and hold consistent for 4 nights.',
       nextSessionDate = nextSessionDate ?? 'Thursday, 10:00 AM',
       mentorNote =
           mentorNote ??
           recentQuote ??
           'Priya S.: "Great first week keep the nap timing steady."',
       recordedModuleTitle =
           recordedModuleTitle ?? 'Module 2: Managing Evening Cortisol Surges';

  String get id => programId;
  String get currentFocus => thisWeekFocus;
  String get guideName => mentorNote.contains(':')
      ? mentorNote.split(':').first.replaceAll('"', '').trim()
      : 'Priya S.';
  String get recentQuote => mentorNote;
  String get quoteAuthorAndTime => '$guideName · 2 days ago';
  String get recordedModuleDuration => '12 min';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'programId': programId,
      'title': title,
      'currentWeek': currentWeek,
      'totalWeeks': totalWeeks,
      'thisWeekFocus': thisWeekFocus,
      'focusDescription': focusDescription,
      'nextSessionDate': nextSessionDate,
      'mentorNote': mentorNote,
      'recordedModuleTitle': recordedModuleTitle,
      'isModuleCompleted': isModuleCompleted,
    };
  }

  factory EnrolledProgramModel.fromMap(Map<String, dynamic> map) {
    return EnrolledProgramModel(
      programId: map['programId']?.toString() ?? 'sleep_reset_6w',
      title: map['title']?.toString() ?? '6-Week Sleep Reset Journey',
      currentWeek: (map['currentWeek'] as num?)?.toInt() ?? 2,
      totalWeeks: (map['totalWeeks'] as num?)?.toInt() ?? 6,
      thisWeekFocus:
          map['thisWeekFocus']?.toString() ?? 'Shifting bedtime by 15m',
      focusDescription:
          map['focusDescription']?.toString() ??
          'Anchor evening wind-down at 7:15 PM and hold consistent for 4 nights.',
      nextSessionDate:
          map['nextSessionDate']?.toString() ?? 'Thursday, 10:00 AM',
      mentorNote:
          map['mentorNote']?.toString() ??
          'Great consistency on bedtime cues this week! Keep holding the 15m shift steady.',
      recordedModuleTitle:
          map['recordedModuleTitle']?.toString() ??
          'Module 2: Managing Evening Cortisol Surges',
      isModuleCompleted: map['isModuleCompleted'] == true,
    );
  }

  EnrolledProgramModel copyWith({
    String? programId,
    String? title,
    int? currentWeek,
    int? totalWeeks,
    String? thisWeekFocus,
    String? focusDescription,
    String? nextSessionDate,
    String? mentorNote,
    String? recordedModuleTitle,
    bool? isModuleCompleted,
  }) {
    return EnrolledProgramModel(
      programId: programId ?? this.programId,
      title: title ?? this.title,
      currentWeek: currentWeek ?? this.currentWeek,
      totalWeeks: totalWeeks ?? this.totalWeeks,
      thisWeekFocus: thisWeekFocus ?? this.thisWeekFocus,
      focusDescription: focusDescription ?? this.focusDescription,
      nextSessionDate: nextSessionDate ?? this.nextSessionDate,
      mentorNote: mentorNote ?? this.mentorNote,
      recordedModuleTitle: recordedModuleTitle ?? this.recordedModuleTitle,
      isModuleCompleted: isModuleCompleted ?? this.isModuleCompleted,
    );
  }
}

/// Action step in post-session plan (Screen 50).
class PlanTaskItem {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;

  const PlanTaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
    };
  }

  factory PlanTaskItem.fromMap(Map<String, dynamic> map) {
    return PlanTaskItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      isCompleted: map['isCompleted'] == true,
    );
  }

  PlanTaskItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isCompleted,
  }) {
    return PlanTaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Post-session plan agreed with mentor (Screen 50).
class PostSessionPlanModel {
  final String id;
  final String mentorName;
  final DateTime? sessionDate;
  final String summary;
  final List<PlanTaskItem> tasks;
  final List<String> activeGoals;

  const PostSessionPlanModel({
    required this.id,
    String? mentorName,
    String? guideName,
    this.sessionDate,
    this.summary = 'Focus on shifting bedtime 15 minutes earlier.',
    required this.tasks,
    this.activeGoals = const <String>[],
    String? negativeGuidanceTitle,
    String? negativeGuidanceSubtitle,
  }) : mentorName = mentorName ?? guideName ?? 'Priya';

  String get guideName => mentorName;
  String get negativeGuidanceTitle => 'No screen time before bed';
  String get negativeGuidanceSubtitle => 'Just while the nap change settles.';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mentorName': mentorName,
      'sessionDate': sessionDate != null
          ? Timestamp.fromDate(sessionDate!)
          : null,
      'summary': summary,
      'tasks': tasks.map((PlanTaskItem t) => t.toMap()).toList(),
      'activeGoals': activeGoals,
    };
  }

  factory PostSessionPlanModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();
    final dynamic rawDate = map['sessionDate'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    final List<dynamic>? rawTasks = map['tasks'] as List<dynamic>?;
    final List<PlanTaskItem> taskList = rawTasks != null
        ? rawTasks
              .whereType<Map<String, dynamic>>()
              .map((Map<String, dynamic> m) => PlanTaskItem.fromMap(m))
              .toList()
        : <PlanTaskItem>[];

    final List<dynamic>? rawGoals = map['activeGoals'] as List<dynamic>?;
    final List<String> goalList = rawGoals != null
        ? rawGoals.map((dynamic g) => g.toString()).toList()
        : <String>[];

    return PostSessionPlanModel(
      id: map['id']?.toString() ?? 'plan_default',
      mentorName: map['mentorName']?.toString() ?? 'Elena Rostova',
      sessionDate: parsedDate,
      summary:
          map['summary']?.toString() ??
          'Focus on moving bedtime 15 minutes earlier and protecting quiet wind-down routines.',
      tasks: taskList,
      activeGoals: goalList,
    );
  }
}
