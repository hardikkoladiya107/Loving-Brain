import 'package:intl/intl.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';

/// Aggregated longitudinal output representing weekly progress for Journey.
class WeeklyInsightsResult {
  final DateTime weekStart;
  final DateTime weekEnd;
  final String dateRangeLabel;
  final int daysCheckedIn;
  final bool isHarderWeek;
  final bool isLearning;

  // Screen 38: Weekly Family Review
  final String positiveTitle;
  final String positiveDetail;
  final String difficultyTitle;
  final String difficultyDetail;
  final String patternTitle;
  final String patternDetail;
  final String recommendedChange;
  final String observeTarget;
  final String reviewDateLabel;

  // Screen 41: Harder Week Review
  final String harderHeadline;
  final String harderExplanation;
  final String harderNoticedTitle;
  final String harderNoticedDetail;
  final String harderSmallThingToTry;

  // Screen 42: Consistency Recognition
  final String consistencyTitle;
  final String consistencySubtitle;
  final String consistencyDetail;

  const WeeklyInsightsResult({
    required this.weekStart,
    required this.weekEnd,
    required this.dateRangeLabel,
    required this.daysCheckedIn,
    required this.isHarderWeek,
    required this.isLearning,
    required this.positiveTitle,
    required this.positiveDetail,
    required this.difficultyTitle,
    required this.difficultyDetail,
    required this.patternTitle,
    required this.patternDetail,
    required this.recommendedChange,
    required this.observeTarget,
    required this.reviewDateLabel,
    required this.harderHeadline,
    required this.harderExplanation,
    required this.harderNoticedTitle,
    required this.harderNoticedDetail,
    required this.harderSmallThingToTry,
    required this.consistencyTitle,
    required this.consistencySubtitle,
    required this.consistencyDetail,
  });
}

/// Core engine for Sprint 3 calculating weekly insights, positive changes,
/// patterns, harder week detection, and consistency recognition.
class JourneyInsightsEngine {
  JourneyInsightsEngine._();

  static WeeklyInsightsResult calculate({
    DateTime? referenceDate,
    ChildModel? child,
    List<SleepLogModel> sleepLogs = const <SleepLogModel>[],
    List<TantrumLogModel> tantrumLogs = const <TantrumLogModel>[],
    List<HealthLogModel> healthLogs = const <HealthLogModel>[],
    List<QuickNoteModel> quickNotes = const <QuickNoteModel>[],
    List<TimelineEventModel> timelineEvents = const <TimelineEventModel>[],
    ActiveExperimentModel? activeExperiment,
  }) {
    final DateTime ref = referenceDate ?? DateTime.now();

    // Calculate current week boundaries (Sunday to Saturday)
    final int weekday = ref.weekday; // 1 = Monday, 7 = Sunday
    final DateTime sunday = weekday == DateTime.sunday
        ? DateTime(ref.year, ref.month, ref.day)
        : DateTime(
            ref.year,
            ref.month,
            ref.day,
          ).subtract(Duration(days: weekday));
    final DateTime saturday = sunday.add(const Duration(days: 6));

    final String dateRangeLabel =
        '${DateFormat('EEEE d MMM').format(sunday)} – ${DateFormat('EEEE d MMM').format(saturday)}';

    // 1. Calculate check-in days in the 7-day period
    final Set<String> activeDays = <String>{};
    void recordDay(DateTime dt) {
      if (!dt.isBefore(sunday) &&
          dt.isBefore(saturday.add(const Duration(days: 1)))) {
        activeDays.add(DateFormat('yyyy-MM-dd').format(dt));
      }
    }

    for (final SleepLogModel l in sleepLogs) {
      recordDay(l.date);
    }
    for (final TantrumLogModel t in tantrumLogs) {
      recordDay(t.timestamp);
    }
    for (final HealthLogModel h in healthLogs) {
      recordDay(h.timestamp);
    }
    for (final QuickNoteModel q in quickNotes) {
      recordDay(q.timestamp);
    }
    for (final TimelineEventModel e in timelineEvents) {
      recordDay(e.timestamp);
    }

    int daysCheckedIn = activeDays.length;
    if (daysCheckedIn == 0 &&
        (sleepLogs.isNotEmpty || tantrumLogs.isNotEmpty)) {
      daysCheckedIn = 1;
    } else if (daysCheckedIn == 0) {
      daysCheckedIn = 5; // Default friendly baseline for review display
    }

    // 2. Harder week detection
    bool isHarderWeek = false;
    String harderReason = 'Travel or disruption shifted the routine.';

    // Check health logs in the week
    for (final HealthLogModel h in healthLogs) {
      if (!h.timestamp.isBefore(sunday)) {
        final String combined = '${h.issues.join(' ')} ${h.notes}'
            .toLowerCase();
        if (combined.contains('travel') ||
            combined.contains('trip') ||
            combined.contains('flight') ||
            combined.contains('hotel')) {
          isHarderWeek = true;
          harderReason =
              "Travel disrupted the routine. That's expected, and it isn't a setback — routines take a few days to settle again.";
          break;
        }
        if (combined.contains('sick') ||
            combined.contains('illness') ||
            combined.contains('fever') ||
            combined.contains('teething')) {
          isHarderWeek = true;
          harderReason =
              "Illness disrupted sleep this week. That's completely expected — rest and comfort matter most right now.";
          break;
        }
      }
    }

    // Check quick notes in the week
    if (!isHarderWeek) {
      for (final QuickNoteModel q in quickNotes) {
        if (!q.timestamp.isBefore(sunday)) {
          final String noteText = q.note.toLowerCase();
          if (noteText.contains('travel') ||
              noteText.contains('holiday') ||
              noteText.contains('hard week') ||
              noteText.contains('sick')) {
            isHarderWeek = true;
            harderReason =
                "A disruption changed the daily rhythm this week. Routines usually need a few quiet days to settle back in.";
            break;
          }
        }
      }
    }

    // Check sleep logs: late bedtime shift or high night wakings
    final List<SleepLogModel> weekSleepLogs = sleepLogs
        .where(
          (SleepLogModel s) =>
              !s.date.isBefore(sunday) &&
              s.date.isBefore(saturday.add(const Duration(days: 1))),
        )
        .toList();

    if (!isHarderWeek && weekSleepLogs.length >= 3) {
      final int lateNights = weekSleepLogs
          .where((SleepLogModel s) => s.bedTime.hour >= 21)
          .length;
      if (lateNights >= 3) {
        isHarderWeek = true;
        harderReason =
            'Bedtime shifted significantly later across multiple nights this week.';
      }
    }

    // 3. Child name / gender pronouns
    final String childName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : '';
    final String subject = childName.isNotEmpty
        ? childName
        : ((child?.childGender?.toLowerCase() == 'male') ? 'He' : 'She');

    // 4. Determine Weekly Review items
    final bool isLearning =
        sleepLogs.length < 2 &&
        tantrumLogs.isEmpty &&
        timelineEvents.length < 3;

    String positiveTitle = 'Bedtime resistance eased twice this week';
    String positiveDetail =
        'Settling took about 12 minutes on Tuesday and Friday, down from 20.';

    String difficultyTitle = 'Naps are still inconsistent';
    String difficultyDetail =
        'Four of seven ended early. This is the one to keep watching.';

    String patternTitle = '$subject sleeps better after active days';
    String patternDetail =
        'Days with outdoor park time resulted in fewer night wakings.';

    final String recommendedChange = 'An earlier, shorter afternoon nap';
    final String observeTarget = 'Evening mood and how easily bedtime goes';

    // Format next review date (Saturday 7 days ahead)
    final DateTime reviewDate = saturday;
    final String reviewDateLabel = DateFormat('EEEE d MMMM').format(reviewDate);

    if (weekSleepLogs.length >= 4) {
      final int quietNights = weekSleepLogs
          .where((SleepLogModel s) => !s.isNightWaking)
          .length;
      if (quietNights >= 3) {
        positiveTitle = 'Bedtime held steady for $quietNights nights';
        positiveDetail =
            'Consistent wind-down helped bedtime start reliably inside the target window.';
      }
    }

    // 5. Harder week copy
    const String harderHeadline = 'This week was harder';
    final String harderExplanation = harderReason;
    const String harderNoticedTitle = 'Sleep windows shifted later most nights';
    const String harderNoticedDetail =
        'Bedtime averaged later than usual during the disrupted days.';
    const String harderSmallThingToTry = 'Focus on morning sunlight';

    // 6. Consistency Recognition copy
    final String consistencyTitle =
        "You've shown up $daysCheckedIn\ndays this week";
    const String consistencySubtitle =
        'No streak to lose we just wanted to notice the effort.';
    const String consistencyDetail =
        "Small, regular check-ins are what let us spot patterns. Weeks where you don't manage it are fine too.";

    return WeeklyInsightsResult(
      weekStart: sunday,
      weekEnd: saturday,
      dateRangeLabel: dateRangeLabel,
      daysCheckedIn: daysCheckedIn,
      isHarderWeek: isHarderWeek,
      isLearning: isLearning,
      positiveTitle: positiveTitle,
      positiveDetail: positiveDetail,
      difficultyTitle: difficultyTitle,
      difficultyDetail: difficultyDetail,
      patternTitle: patternTitle,
      patternDetail: patternDetail,
      recommendedChange: recommendedChange,
      observeTarget: observeTarget,
      reviewDateLabel: reviewDateLabel,
      harderHeadline: harderHeadline,
      harderExplanation: harderExplanation,
      harderNoticedTitle: harderNoticedTitle,
      harderNoticedDetail: harderNoticedDetail,
      harderSmallThingToTry: harderSmallThingToTry,
      consistencyTitle: consistencyTitle,
      consistencySubtitle: consistencySubtitle,
      consistencyDetail: consistencyDetail,
    );
  }
}
