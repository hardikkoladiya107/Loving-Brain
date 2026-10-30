import 'package:intl/intl.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
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

class _WeekSleepMetrics {
  final int nightCount;
  final int nightWakingCount;
  final int? medianBedMinutes;
  final int lateBedCount;

  const _WeekSleepMetrics({
    required this.nightCount,
    required this.nightWakingCount,
    required this.medianBedMinutes,
    required this.lateBedCount,
  });
}

/// Core engine calculating weekly insights from real family logs.
class JourneyInsightsEngine {
  JourneyInsightsEngine._();

  static WeeklyInsightsResult calculate({
    DateTime? referenceDate,
    ChildModel? child,
    List<SleepLogModel> sleepLogs = const <SleepLogModel>[],
    List<TantrumLogModel> tantrumLogs = const <TantrumLogModel>[],
    List<HealthLogModel> healthLogs = const <HealthLogModel>[],
    List<QuickNoteModel> quickNotes = const <QuickNoteModel>[],
    List<MoodLogModel> moodLogs = const <MoodLogModel>[],
    List<TimelineEventModel> timelineEvents = const <TimelineEventModel>[],
    ActiveExperimentModel? activeExperiment,
  }) {
    final DateTime ref = referenceDate ?? DateTime.now();

    final int weekday = ref.weekday;
    final DateTime sunday = weekday == DateTime.sunday
        ? DateTime(ref.year, ref.month, ref.day)
        : DateTime(
            ref.year,
            ref.month,
            ref.day,
          ).subtract(Duration(days: weekday));
    final DateTime saturday = sunday.add(const Duration(days: 6));
    final DateTime weekEndExclusive = saturday.add(const Duration(days: 1));
    final DateTime prevSunday = sunday.subtract(const Duration(days: 7));
    final DateTime prevSaturday = saturday.subtract(const Duration(days: 7));
    final DateTime prevWeekEndExclusive = prevSaturday.add(
      const Duration(days: 1),
    );

    final String dateRangeLabel =
        '${DateFormat('EEEE d MMM').format(sunday)} – ${DateFormat('EEEE d MMM').format(saturday)}';

    final Set<String> activeDays = <String>{};
    void recordDay(DateTime dt) {
      if (!dt.isBefore(sunday) && dt.isBefore(weekEndExclusive)) {
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
    for (final MoodLogModel m in moodLogs) {
      recordDay(m.logTime);
    }

    final int daysCheckedIn = activeDays.length;
    final bool hasEnoughWeeklyData = activeDays.length >= 4;
    final bool isLearning = !hasEnoughWeeklyData;

    final String? rawChildName = child?.childName?.trim();
    final String childName = (rawChildName != null && rawChildName.isNotEmpty)
        ? rawChildName
        : '';
    final String subject = childName.isNotEmpty ? childName : 'your child';

    bool isHarderWeek = false;
    String harderReason =
        'A disruption changed the daily rhythm this week. Routines usually need a few quiet days to settle back in.';
    String harderNoticedTitle = 'The usual rhythm was interrupted';
    String harderNoticedDetail =
        'Travel, illness, or another context change made this week less typical.';
    String harderSmallThingToTry = 'Keep comfort and rest as the focus';

    if (hasEnoughWeeklyData) {
      for (final HealthLogModel h in healthLogs) {
        if (h.timestamp.isBefore(sunday) ||
            !h.timestamp.isBefore(weekEndExclusive)) {
          continue;
        }
        final String combined = '${h.issues.join(' ')} ${h.notes}'
            .toLowerCase();
        if (combined.contains('travel') ||
            combined.contains('trip') ||
            combined.contains('flight') ||
            combined.contains('hotel')) {
          isHarderWeek = true;
          harderReason =
              "Travel disrupted the routine. That's expected, and it isn't a setback — routines take a few days to settle again.";
          harderNoticedTitle = 'Travel changed the usual sleep window';
          harderNoticedDetail =
              'Bedtimes and wake-ups were less predictable while away from home.';
          harderSmallThingToTry = 'Return to the usual wind-down cues gently';
          break;
        }
        if (combined.contains('sick') ||
            combined.contains('illness') ||
            combined.contains('fever') ||
            combined.contains('teething')) {
          isHarderWeek = true;
          harderReason =
              "Illness disrupted sleep this week. That's completely expected — rest and comfort matter most right now.";
          harderNoticedTitle = 'Illness made nights less settled';
          harderNoticedDetail =
              'Sleep looked different while $subject needed more comfort.';
          harderSmallThingToTry =
              'Prioritise rest and comfort over the routine';
          break;
        }
      }

      if (!isHarderWeek) {
        for (final QuickNoteModel q in quickNotes) {
          if (q.timestamp.isBefore(sunday) ||
              !q.timestamp.isBefore(weekEndExclusive)) {
            continue;
          }
          final String noteText = q.note.toLowerCase();
          if (noteText.contains('travel') ||
              noteText.contains('holiday') ||
              noteText.contains('hard week') ||
              noteText.contains('sick')) {
            isHarderWeek = true;
            harderReason =
                "A disruption changed the daily rhythm this week. Routines usually need a few quiet days to settle back in.";
            harderNoticedTitle = 'A disruption shifted the week';
            harderNoticedDetail =
                'Your note helped us see that this week was not a typical week.';
            harderSmallThingToTry = 'Keep one familiar calm cue each evening';
            break;
          }
        }
      }
    }

    final List<SleepLogModel> weekSleepLogs = _sleepInRange(
      sleepLogs,
      sunday,
      weekEndExclusive,
    );
    final List<SleepLogModel> prevSleepLogs = _sleepInRange(
      sleepLogs,
      prevSunday,
      prevWeekEndExclusive,
    );
    final List<TantrumLogModel> weekTantrums = tantrumLogs
        .where(
          (TantrumLogModel t) =>
              !t.timestamp.isBefore(sunday) &&
              t.timestamp.isBefore(weekEndExclusive),
        )
        .toList();
    final List<TantrumLogModel> prevTantrums = tantrumLogs
        .where(
          (TantrumLogModel t) =>
              !t.timestamp.isBefore(prevSunday) &&
              t.timestamp.isBefore(prevWeekEndExclusive),
        )
        .toList();

    final _WeekSleepMetrics currentMetrics = _metricsFor(weekSleepLogs);
    final _WeekSleepMetrics previousMetrics = _metricsFor(prevSleepLogs);

    String positiveTitle;
    String positiveDetail;
    String difficultyTitle;
    String difficultyDetail;
    String patternTitle;
    String patternDetail;
    String recommendedChange;
    String observeTarget;

    if (isLearning) {
      positiveTitle = 'Gathering baseline rhythm';
      positiveDetail = daysCheckedIn == 0
          ? 'Check in daily to begin learning $subject\'s unique weekly patterns.'
          : 'Checked in $daysCheckedIn day${daysCheckedIn == 1 ? '' : 's'} so far. Patterns emerge after several days of logs.';
      difficultyTitle = 'Learning sleep rhythms';
      difficultyDetail =
          'We need a few more days of check-ins to spot what is challenging.';
      patternTitle = 'Patterns in progress';
      patternDetail =
          'Loving Brain learns your child\'s rhythm from real logs over time.';
      recommendedChange = 'Keep logging daily check-ins';
      observeTarget = 'Notice wake windows and energy levels';
    } else {
      final _InsightPick pick = _buildReadyInsights(
        subject: subject,
        current: currentMetrics,
        previous: previousMetrics,
        weekTantrumCount: weekTantrums.length,
        prevTantrumCount: prevTantrums.length,
        isHarderWeek: isHarderWeek,
      );
      positiveTitle = pick.positiveTitle;
      positiveDetail = pick.positiveDetail;
      difficultyTitle = pick.difficultyTitle;
      difficultyDetail = pick.difficultyDetail;
      patternTitle = pick.patternTitle;
      patternDetail = pick.patternDetail;
      recommendedChange = pick.recommendedChange;
      observeTarget = pick.observeTarget;
    }

    final DateTime reviewDate = saturday;
    final String reviewDateLabel = DateFormat('EEEE d MMMM').format(reviewDate);

    const String harderHeadline = 'This week was harder';

    final String consistencyTitle = daysCheckedIn == 0
        ? "Starting your family\njourney"
        : (daysCheckedIn == 1
              ? "You've checked in 1\nday this week"
              : (daysCheckedIn == 5
                    ? "You've shown up five\ndays this week"
                    : "You've checked in $daysCheckedIn\ndays this week"));
    const String consistencySubtitle =
        'No streak to lose — we just wanted to notice the effort.';
    final String consistencyDetail = daysCheckedIn < 4
        ? 'Small, regular check-ins are what let us spot patterns. After 4 days, weekly reviews appear.'
        : "Small, regular check-ins are what let us spot patterns. Weeks where you don't manage it are fine too.";

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
      harderExplanation: harderReason,
      harderNoticedTitle: harderNoticedTitle,
      harderNoticedDetail: harderNoticedDetail,
      harderSmallThingToTry: harderSmallThingToTry,
      consistencyTitle: consistencyTitle,
      consistencySubtitle: consistencySubtitle,
      consistencyDetail: consistencyDetail,
    );
  }

  /// Builds a short result note when an experiment review date arrives.
  static String compareExperimentOutcome({
    required ActiveExperimentModel experiment,
    required List<SleepLogModel> sleepLogs,
    required List<TantrumLogModel> tantrumLogs,
  }) {
    final DateTime start = DateTime(
      experiment.startDate.year,
      experiment.startDate.month,
      experiment.startDate.day,
    );
    final DateTime end = DateTime(
      experiment.reviewDate.year,
      experiment.reviewDate.month,
      experiment.reviewDate.day,
    ).add(const Duration(days: 1));
    final DateTime baselineStart = start.subtract(const Duration(days: 7));

    final _WeekSleepMetrics during = _metricsFor(
      _sleepInRange(sleepLogs, start, end),
    );
    final _WeekSleepMetrics before = _metricsFor(
      _sleepInRange(sleepLogs, baselineStart, start),
    );
    final int tantrumsDuring = tantrumLogs
        .where(
          (TantrumLogModel t) =>
              !t.timestamp.isBefore(start) && t.timestamp.isBefore(end),
        )
        .length;
    final int tantrumsBefore = tantrumLogs
        .where(
          (TantrumLogModel t) =>
              !t.timestamp.isBefore(baselineStart) &&
              t.timestamp.isBefore(start),
        )
        .length;

    final List<String> helped = <String>[];
    if (during.nightCount >= 2 &&
        before.nightCount >= 2 &&
        during.nightWakingCount < before.nightWakingCount) {
      helped.add('fewer nights with waking');
    }
    if (during.medianBedMinutes != null &&
        before.medianBedMinutes != null &&
        during.medianBedMinutes! + 10 < before.medianBedMinutes!) {
      helped.add('an earlier bedtime');
    }
    if (tantrumsDuring < tantrumsBefore) {
      helped.add('fewer hard moments');
    }

    if (helped.isNotEmpty) {
      return 'This change may have helped: ${helped.join(', ')}.';
    }
    return 'We did not see a clear shift yet. One small change is still useful to try again or adjust.';
  }

  static List<SleepLogModel> _sleepInRange(
    List<SleepLogModel> sleepLogs,
    DateTime startInclusive,
    DateTime endExclusive,
  ) {
    return sleepLogs
        .where(
          (SleepLogModel s) =>
              !s.date.isBefore(startInclusive) && s.date.isBefore(endExclusive),
        )
        .toList();
  }

  static _WeekSleepMetrics _metricsFor(List<SleepLogModel> logs) {
    final List<SleepLogModel> nights = logs
        .where((SleepLogModel s) => !s.isNap)
        .toList();
    final int waking = nights
        .where((SleepLogModel s) => s.isNightWaking)
        .length;
    final List<int> bedMinutes = nights
        .map((SleepLogModel s) => s.bedTime.hour * 60 + s.bedTime.minute)
        .toList();
    bedMinutes.sort();
    int? median;
    if (bedMinutes.isNotEmpty) {
      median = bedMinutes[bedMinutes.length ~/ 2];
    }
    final int late = nights
        .where((SleepLogModel s) => s.bedTime.hour >= 21)
        .length;
    return _WeekSleepMetrics(
      nightCount: nights.length,
      nightWakingCount: waking,
      medianBedMinutes: median,
      lateBedCount: late,
    );
  }

  static _InsightPick _buildReadyInsights({
    required String subject,
    required _WeekSleepMetrics current,
    required _WeekSleepMetrics previous,
    required int weekTantrumCount,
    required int prevTantrumCount,
    required bool isHarderWeek,
  }) {
    String positiveTitle = 'No clear positive change yet';
    String positiveDetail =
        'We compared this week with the previous one and did not see a clear improvement yet.';
    String difficultyTitle = 'Still learning what is hard';
    String difficultyDetail =
        'Keep logging the usual check-ins so we can spot what stays difficult.';
    String patternTitle = 'A weekly rhythm is forming';
    String patternDetail =
        'With enough days logged, we can compare this week with the one before.';
    String recommendedChange = 'Keep one steady evening wind-down';
    String observeTarget = 'How easily bedtime starts each night';

    final bool canCompareSleep =
        current.nightCount >= 2 && previous.nightCount >= 2;
    final bool wakingImproved =
        canCompareSleep && current.nightWakingCount < previous.nightWakingCount;
    final bool bedtimeEarlier =
        canCompareSleep &&
        current.medianBedMinutes != null &&
        previous.medianBedMinutes != null &&
        current.medianBedMinutes! + 10 < previous.medianBedMinutes!;
    final bool tantrumsImproved = weekTantrumCount < prevTantrumCount;

    if (wakingImproved) {
      positiveTitle = 'Fewer nights with waking this week';
      positiveDetail =
          'Night waking dropped from ${previous.nightWakingCount} to ${current.nightWakingCount} across logged nights.';
    } else if (bedtimeEarlier) {
      final int delta = previous.medianBedMinutes! - current.medianBedMinutes!;
      positiveTitle = 'Bedtime moved about $delta minutes earlier';
      positiveDetail =
          'Compared with last week, bedtime started earlier on the nights you logged.';
    } else if (tantrumsImproved && prevTantrumCount > 0) {
      positiveTitle = 'Fewer hard moments this week';
      positiveDetail =
          'Logged hard moments went from $prevTantrumCount to $weekTantrumCount.';
    } else if (current.nightCount >= 3 && current.nightWakingCount == 0) {
      positiveTitle = 'Quiet nights held for ${current.nightCount} nights';
      positiveDetail =
          'None of the logged nights this week included night waking.';
    }

    final bool wakingHarder =
        canCompareSleep && current.nightWakingCount > previous.nightWakingCount;
    final bool bedtimeLater =
        canCompareSleep &&
        current.medianBedMinutes != null &&
        previous.medianBedMinutes != null &&
        current.medianBedMinutes! > previous.medianBedMinutes! + 10;
    final bool lateBeds = current.nightCount >= 3 && current.lateBedCount >= 3;
    final bool tantrumsHarder = weekTantrumCount > prevTantrumCount;

    if (isHarderWeek) {
      difficultyTitle = 'A disruption made this week harder';
      difficultyDetail =
          'Travel or illness changed the usual comparisons, so we are keeping the focus gentle.';
      recommendedChange = 'Prioritise rest and one familiar calm cue';
      observeTarget = 'Energy and comfort through the evening';
    } else if (wakingHarder ||
        (current.nightCount >= 3 &&
            current.nightWakingCount >= (current.nightCount / 2).ceil())) {
      difficultyTitle = 'Night waking is still hard';
      difficultyDetail = wakingHarder
          ? 'Night waking rose from ${previous.nightWakingCount} to ${current.nightWakingCount} this week.'
          : 'Night waking showed up on most of the nights you logged.';
      recommendedChange = 'Keep one steady response to night waking';
      observeTarget = 'How long settling takes after a waking';
    } else if (lateBeds || bedtimeLater) {
      difficultyTitle = 'Bedtime is running later';
      difficultyDetail = lateBeds
          ? 'Bedtime was after 9:00 PM on ${current.lateBedCount} of ${current.nightCount} logged nights.'
          : 'Median bedtime moved later than last week.';
      recommendedChange = 'Start the wind-down a little earlier';
      observeTarget = 'How the evening mood looks after an earlier wind-down';
    } else if (tantrumsHarder || weekTantrumCount >= 3) {
      difficultyTitle = 'Hard moments are still showing up';
      difficultyDetail = tantrumsHarder
          ? 'Logged hard moments rose from $prevTantrumCount to $weekTantrumCount.'
          : 'There were $weekTantrumCount hard moments logged this week.';
      recommendedChange = 'Use one short, calm response plan';
      observeTarget = 'What helps most when a hard moment starts';
    } else if (current.nightCount < 2) {
      difficultyTitle = 'Sleep pattern still settling';
      difficultyDetail =
          'A few more night logs will make the weekly comparison clearer.';
      recommendedChange = 'Keep logging bedtime and wake time';
      observeTarget = 'Wake windows and evening energy';
    }

    if (current.nightCount >= 3 &&
        current.nightWakingCount >= (current.nightCount / 2).ceil()) {
      patternTitle = 'Night waking shows up on most nights';
      patternDetail =
          '${current.nightWakingCount} of ${current.nightCount} logged nights included waking.';
    } else if (lateBeds) {
      patternTitle = 'Later bedtimes are repeating';
      patternDetail =
          'Bedtime was after 9:00 PM on most of the nights you logged.';
    } else if (bedtimeLater) {
      patternTitle = 'Bedtime is later than last week';
      patternDetail =
          'Compared with the previous week, bedtime started later on logged nights.';
    } else if (weekTantrumCount >= 3) {
      patternTitle = 'Hard moments are clustering this week';
      patternDetail =
          '$weekTantrumCount hard moments were logged across the week.';
    } else if (current.nightCount >= 3 && current.nightWakingCount == 0) {
      patternTitle = '$subject had quieter nights this week';
      patternDetail = 'Logged nights stayed free of night waking.';
    }

    return _InsightPick(
      positiveTitle: positiveTitle,
      positiveDetail: positiveDetail,
      difficultyTitle: difficultyTitle,
      difficultyDetail: difficultyDetail,
      patternTitle: patternTitle,
      patternDetail: patternDetail,
      recommendedChange: recommendedChange,
      observeTarget: observeTarget,
    );
  }
}

class _InsightPick {
  final String positiveTitle;
  final String positiveDetail;
  final String difficultyTitle;
  final String difficultyDetail;
  final String patternTitle;
  final String patternDetail;
  final String recommendedChange;
  final String observeTarget;

  const _InsightPick({
    required this.positiveTitle,
    required this.positiveDetail,
    required this.difficultyTitle,
    required this.difficultyDetail,
    required this.patternTitle,
    required this.patternDetail,
    required this.recommendedChange,
    required this.observeTarget,
  });
}
