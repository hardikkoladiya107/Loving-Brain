import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/core/journey_insights_engine.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/health_log_model.dart';
import 'package:loving_brain/model/mood_log_model.dart';
import 'package:loving_brain/model/quick_note_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/tantrum_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'harder_week_state.dart';

class HarderWeekCubit extends Cubit<HarderWeekState> {
  HarderWeekCubit() : super(const HarderWeekState());

  static const int _twoWeekLogLimit = 40;

  void init() {
    emit(const HarderWeekState());
    _loadHarderWeekData();
  }

  void reset() {
    emit(const HarderWeekState());
  }

  void changeProps({
    ChildModel? child,
    WeeklyInsightsResult? insights,
    ApiResultStatus? fetchStatus,
  }) {
    emit(
      state.copyWith(
        child: child ?? state.child,
        insights: insights ?? state.insights,
        fetchStatus: fetchStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _loadHarderWeekData() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    List<SleepLogModel> sleepLogs = <SleepLogModel>[];
    List<TantrumLogModel> tantrumLogs = <TantrumLogModel>[];
    List<HealthLogModel> healthLogs = <HealthLogModel>[];
    List<QuickNoteModel> quickNotes = <QuickNoteModel>[];
    List<MoodLogModel> moodLogs = <MoodLogModel>[];
    List<TimelineEventModel> timelineEvents = <TimelineEventModel>[];

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
    );

    changeProps(
      child: child,
      insights: insights,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  String buildBrainyDisruptionPrompt() {
    final String name = state.child?.childName ?? 'our family';
    final String reason =
        state.insights?.harderExplanation ??
        'Travel or illness disrupted our usual routine';
    return "This week was harder for $name. $reason. How can we gently get back to our rhythm without putting extra pressure on anyone?";
  }
}
