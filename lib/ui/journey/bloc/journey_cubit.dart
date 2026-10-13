import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'journey_state.dart';

class JourneyCubit extends Cubit<JourneyState> {
  JourneyCubit() : super(const JourneyState());

  void init() {
    emit(const JourneyState());
    _loadJourneyData();
  }

  void changeProps({
    JourneyMode? mode,
    ChildModel? child,
    WeeklyInsightsResult? weeklyInsights,
    ActiveExperimentModel? activeExperiment,
    int? savedGuidanceCount,
    int? timelineEventCount,
    bool? isSleepJourneyEnrolled,
    int? sleepJourneyWeek,
    int? sleepJourneyTotalWeeks,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        mode: mode ?? state.mode,
        child: child ?? state.child,
        weeklyInsights: weeklyInsights ?? state.weeklyInsights,
        activeExperiment: activeExperiment ?? state.activeExperiment,
        savedGuidanceCount: savedGuidanceCount ?? state.savedGuidanceCount,
        timelineEventCount: timelineEventCount ?? state.timelineEventCount,
        isSleepJourneyEnrolled:
            isSleepJourneyEnrolled ?? state.isSleepJourneyEnrolled,
        sleepJourneyWeek: sleepJourneyWeek ?? state.sleepJourneyWeek,
        sleepJourneyTotalWeeks:
            sleepJourneyTotalWeeks ?? state.sleepJourneyTotalWeeks,
        fetchStatus: fetchStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _loadJourneyData() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];
    List<HealthLogModel> healthLogs = <HealthLogModel>[];
    List<QuickNoteModel> quickNotes = <QuickNoteModel>[];
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
            await TodayLogRepo.instance.getRecentTantrumLogs(childId);
        if (tantrumRes is Data<List<TantrumLogModel>>) {
          tantrumLogs = tantrumRes.data;
        }

        final ApiResultStatus<List<HealthLogModel>> healthRes =
            await TodayLogRepo.instance.getRecentHealthLogs(childId);
        if (healthRes is Data<List<HealthLogModel>>) {
          healthLogs = healthRes.data;
        }

        final ApiResultStatus<List<QuickNoteModel>> notesRes =
            await TodayLogRepo.instance.getRecentQuickNotes(childId);
        if (notesRes is Data<List<QuickNoteModel>>) {
          quickNotes = notesRes.data;
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
      timelineEvents: timelineEvents,
      activeExperiment: activeExperiment,
    );

    JourneyMode calculatedMode = JourneyMode.normal;
    if (activeExperiment != null && activeExperiment.status == 'active') {
      calculatedMode = JourneyMode.trying;
    } else if (insights.isHarderWeek) {
      calculatedMode = JourneyMode.harder;
    }

    changeProps(
      child: child,
      weeklyInsights: insights,
      activeExperiment: activeExperiment,
      mode: calculatedMode,
      timelineEventCount: timelineEvents.length,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  void cycleMode() {
    final int nextIndex = (state.mode.index + 1) % JourneyMode.values.length;
    final JourneyMode nextMode = JourneyMode.values[nextIndex];
    changeProps(mode: nextMode);
  }
}
