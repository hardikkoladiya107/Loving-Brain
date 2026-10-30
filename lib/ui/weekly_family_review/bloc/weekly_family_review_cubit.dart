import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/v2_notification_scheduler.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'weekly_family_review_state.dart';

class WeeklyFamilyReviewCubit extends Cubit<WeeklyFamilyReviewState> {
  WeeklyFamilyReviewCubit() : super(const WeeklyFamilyReviewState());

  static const int _twoWeekLogLimit = 40;

  void init() {
    emit(const WeeklyFamilyReviewState());
    _loadReview();
  }

  void reset() {
    emit(const WeeklyFamilyReviewState());
  }

  void changeProps({
    ChildModel? child,
    WeeklyInsightsResult? insights,
    ActiveExperimentModel? activeExperiment,
    ApiResultStatus? fetchStatus,
    ApiResultStatus? saveStatus,
  }) {
    emit(
      state.copyWith(
        child: child ?? state.child,
        insights: insights ?? state.insights,
        activeExperiment: activeExperiment ?? state.activeExperiment,
        fetchStatus: fetchStatus ?? const ApiResultStatus.initial(),
        saveStatus: saveStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _loadReview() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];
    List<HealthLogModel> healthLogs = <HealthLogModel>[];
    List<QuickNoteModel> quickNotes = <QuickNoteModel>[];
    List<MoodLogModel> moodLogs = <MoodLogModel>[];
    List<TimelineEventModel> timelineEvents = <TimelineEventModel>[];
    ActiveExperimentModel? activeExperiment;

    if (childId.isNotEmpty) {
      try {
        final ApiResultStatus<List<SleepLogModel>> sleepRes = await SleepLogRepo
            .instance
            .getSleepLogsForChild(childId);
        if (sleepRes is Data<List<SleepLogModel>>) {
          sleepLogs = sleepRes.data;
        }

        final ApiResultStatus<List<TantrumLogModel>> tantrumRes =
            await TodayLogRepo.instance.getRecentTantrumLogs(
              childId,
              limit: _twoWeekLogLimit,
            );
        if (tantrumRes is Data<List<TantrumLogModel>>) {
          tantrumLogs = tantrumRes.data;
        }

        final ApiResultStatus<List<HealthLogModel>> healthRes =
            await TodayLogRepo.instance.getRecentHealthLogs(
              childId,
              limit: _twoWeekLogLimit,
            );
        if (healthRes is Data<List<HealthLogModel>>) {
          healthLogs = healthRes.data;
        }

        final ApiResultStatus<List<QuickNoteModel>> notesRes =
            await TodayLogRepo.instance.getRecentQuickNotes(
              childId,
              limit: _twoWeekLogLimit,
            );
        if (notesRes is Data<List<QuickNoteModel>>) {
          quickNotes = notesRes.data;
        }

        final ApiResultStatus<List<MoodLogModel>> moodRes = await TodayLogRepo
            .instance
            .getRecentMoodLogs(childId, limit: _twoWeekLogLimit);
        if (moodRes is Data<List<MoodLogModel>>) {
          moodLogs = moodRes.data;
        }

        final ApiResultStatus<List<TimelineEventModel>> eventsRes =
            await TodayLogRepo.instance.getTimelineEvents(childId);
        if (eventsRes is Data<List<TimelineEventModel>>) {
          timelineEvents = eventsRes.data;
        }

        final ApiResultStatus<ActiveExperimentModel?> expRes =
            await ExperimentRepo.instance.getActiveExperiment(childId: childId);
        if (expRes is Data<ActiveExperimentModel?>) {
          activeExperiment = expRes.data;
        }
      } catch (_) {}
    }

    final WeeklyInsightsResult insights = JourneyInsightsEngine.calculate(
      child: child,
      sleepLogs: sleepLogs,
      tantrumLogs: tantrumLogs,
      healthLogs: healthLogs,
      quickNotes: quickNotes,
      moodLogs: moodLogs,
      timelineEvents: timelineEvents,
      activeExperiment: activeExperiment,
    );

    changeProps(
      child: child,
      insights: insights,
      activeExperiment: activeExperiment,
      fetchStatus: const ApiResultStatus.data(data: null),
    );

    if (!insights.isLearning) {
      final DateTime now = DateTime.now();
      DateTime nextSunday = DateTime(now.year, now.month, now.day, 9, 0);
      int daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
      if (daysUntilSunday == 0 && now.hour >= 9) {
        daysUntilSunday = 7;
      }
      nextSunday = nextSunday.add(Duration(days: daysUntilSunday));
      await V2NotificationScheduler.scheduleWeeklyReview(
        sundayDate: nextSunday,
      );
    }
  }

  Future<void> startRecommendedExperiment() async {
    changeProps(saveStatus: const ApiResultStatus.loading());

    final ChildModel? child = state.child ?? preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';
    final WeeklyInsightsResult? insights = state.insights;

    if (insights == null || insights.isLearning) {
      changeProps(
        saveStatus: ApiResultStatus.error(
          error: Exception(
            'Keep logging daily check-ins before starting a recommendation.',
          ),
        ),
      );
      return;
    }

    if (state.activeExperiment != null &&
        state.activeExperiment!.status == 'active') {
      changeProps(saveStatus: const ApiResultStatus.data(data: 'existing'));
      return;
    }

    if (childId.isEmpty) {
      changeProps(
        saveStatus: ApiResultStatus.error(
          error: Exception('Please select a child profile first.'),
        ),
      );
      return;
    }

    final DateTime now = DateTime.now();
    final ActiveExperimentModel newExp = ActiveExperimentModel(
      id: now.millisecondsSinceEpoch.toString(),
      childId: childId,
      changeTitle: insights.recommendedChange,
      observeTarget: insights.observeTarget,
      startDate: now,
      targetDays: 7,
      reviewDate: now.add(const Duration(days: 7)),
      status: 'active',
      createdAt: now,
    );

    final ApiResultStatus<String> res = await ExperimentRepo.instance
        .startExperiment(childId: childId, experiment: newExp);
    if (res is Data<String>) {
      changeProps(
        activeExperiment: newExp.copyWith(id: res.data),
        saveStatus: res,
      );
      return;
    }

    changeProps(saveStatus: res);
  }

  String buildBrainyPrompt() {
    final WeeklyInsightsResult? i = state.insights;
    if (i == null) {
      return "Can you help me review this week's sleep and behaviour patterns?";
    }
    return "Can you help me review this week? We noticed: '${i.positiveTitle}', but '${i.difficultyTitle}'. What is the best way to approach trying '${i.recommendedChange}'?";
  }
}
