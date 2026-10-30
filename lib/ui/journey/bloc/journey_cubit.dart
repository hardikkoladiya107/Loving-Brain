import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/active_experiment_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/experiment_repo.dart';
import 'package:loving_brain/repo/mentorship_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'journey_state.dart';

class JourneyCubit extends Cubit<JourneyState> {
  JourneyCubit() : super(const JourneyState());

  static const int _twoWeekLogLimit = 40;

  void init() {
    emit(const JourneyState());
    _loadJourneyData();
  }

  void reset() {
    emit(const JourneyState());
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
    List<MoodLogModel> moodLogs = <MoodLogModel>[];
    List<TimelineEventModel> timelineEvents = <TimelineEventModel>[];
    ActiveExperimentModel? activeExperiment;
    Exception? loadError;

    if (childId.isNotEmpty) {
      try {
        final ApiResultStatus<List<SleepLogModel>> sleepRes = await SleepLogRepo
            .instance
            .getSleepLogsForChild(childId);
        if (sleepRes is Data<List<SleepLogModel>>) {
          sleepLogs = sleepRes.data;
        } else if (sleepRes is Error<List<SleepLogModel>>) {
          loadError = sleepRes.error;
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
      } catch (e) {
        loadError = Exception(e.toString());
      }
    }

    int savedCount = 0;
    final String uid = preferences.getUserModel()?.uid ?? '';
    if (uid.isNotEmpty) {
      try {
        final QuerySnapshot<Map<String, dynamic>> snap = await AuthRepo
            .instance
            .userCollection
            .doc(uid)
            .collection('saved_guidance')
            .get();
        savedCount = snap.docs.length;
      } catch (_) {}
    }

    bool isEnrolled = false;
    int currentWeek = 1;
    int totalWeeks = 6;
    if (childId.isNotEmpty) {
      try {
        final ApiResultStatus<EnrolledProgramModel?> progRes =
            await MentorshipRepo.instance.getEnrolledProgram(childId);
        if (progRes is Data<EnrolledProgramModel?> && progRes.data != null) {
          final EnrolledProgramModel program = progRes.data!;
          isEnrolled = true;
          currentWeek = program.currentWeek;
          totalWeeks = program.totalWeeks <= 0 ? 6 : program.totalWeeks;
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

    JourneyMode calculatedMode = JourneyMode.normal;
    if (activeExperiment != null && activeExperiment.status == 'active') {
      calculatedMode = JourneyMode.trying;
    } else if (insights.isHarderWeek) {
      calculatedMode = JourneyMode.harder;
    } else if (insights.isLearning) {
      calculatedMode = JourneyMode.learning;
    }

    changeProps(
      child: child,
      weeklyInsights: insights,
      activeExperiment: activeExperiment,
      mode: calculatedMode,
      savedGuidanceCount: savedCount,
      isSleepJourneyEnrolled: isEnrolled,
      sleepJourneyWeek: currentWeek,
      sleepJourneyTotalWeeks: totalWeeks,
      timelineEventCount: timelineEvents.length,
      fetchStatus: loadError == null
          ? const ApiResultStatus.data(data: null)
          : ApiResultStatus.error(error: loadError),
    );
  }

  void cycleMode() {
    final int nextIndex = (state.mode.index + 1) % JourneyMode.values.length;
    final JourneyMode nextMode = JourneyMode.values[nextIndex];
    changeProps(mode: nextMode);
  }
}
