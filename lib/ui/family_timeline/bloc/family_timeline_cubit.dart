import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/repo/today_log_repo.dart';
import 'family_timeline_state.dart';

class FamilyTimelineCubit extends Cubit<FamilyTimelineState> {
  FamilyTimelineCubit() : super(const FamilyTimelineState());

  void init() {
    emit(const FamilyTimelineState());
    _loadTimeline();
  }

  void changeProps({
    List<TimelineEventModel>? allEvents,
    List<TimelineEventModel>? filteredEvents,
    String? selectedFilter,
    ChildModel? child,
    int? weeksWithLovingBrain,
    int? averageBedtimeShiftMinutes,
    ApiResultStatus? fetchStatus,
  }) {
    if (isClosed) return;
    emit(
      state.copyWith(
        allEvents: allEvents ?? state.allEvents,
        filteredEvents: filteredEvents ?? state.filteredEvents,
        selectedFilter: selectedFilter ?? state.selectedFilter,
        child: child ?? state.child,
        weeksWithLovingBrain:
            weeksWithLovingBrain ?? state.weeksWithLovingBrain,
        averageBedtimeShiftMinutes:
            averageBedtimeShiftMinutes ?? state.averageBedtimeShiftMinutes,
        fetchStatus: fetchStatus ?? const ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> _loadTimeline() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());

    try {
      await OfflineSyncRepo.instance.syncPendingUpdates();
    } catch (_) {}

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    List<TimelineEventModel> events = <TimelineEventModel>[];
    int bedtimeShift = 0;

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<TimelineEventModel>> result =
          await TodayLogRepo.instance.getTimelineEvents(childId);
      if (result is Data<List<TimelineEventModel>>) {
        events = List<TimelineEventModel>.from(result.data);
      }

      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 14);
      if (sleepResult is Data<List<SleepLogModel>> &&
          sleepResult.data.length >= 2) {
        final List<SleepLogModel> logs = sleepResult.data;
        final SleepLogModel latest = logs.first;
        final SleepLogModel oldest = logs.last;
        final DateTime latestBt = latest.bedTime;
        final DateTime oldestBt = oldest.bedTime;
        final int latestMinutes = latestBt.hour * 60 + latestBt.minute;
        final int oldestMinutes = oldestBt.hour * 60 + oldestBt.minute;
        bedtimeShift = (oldestMinutes - latestMinutes).clamp(-120, 120);
      }
    }

    // Merge any remaining local pending items so offline notes/logs show immediately
    try {
      final List<PendingLocalUpdateModel> pending = await OfflineSyncRepo
          .instance
          .getPendingUpdates();
      for (final PendingLocalUpdateModel p in pending) {
        if (p.childId == null || p.childId == childId || childId.isEmpty) {
          final String title = switch (p.type.toLowerCase()) {
            'note' => 'Quick note',
            'sleep' => 'Sleep update',
            'tantrum' || 'behaviour' => 'Tantrum update',
            'health' => 'Health update',
            'mood' => 'Mood check-in',
            _ => 'Update',
          };
          final String subtitle =
              (p.payload['note'] ??
                      p.payload['whatHappened'] ??
                      p.payload['subtitle'] ??
                      'Saved offline (pending sync)')
                  .toString();
          events.add(
            TimelineEventModel(
              id: p.id,
              type: p.type,
              title: title,
              subtitle: subtitle,
              timestamp: p.timestamp,
            ),
          );
        }
      }
      events.sort(
        (TimelineEventModel a, TimelineEventModel b) =>
            b.timestamp.compareTo(a.timestamp),
      );
    } catch (_) {}

    int weeks = 0;
    if (events.isNotEmpty) {
      DateTime? earliest;
      for (final TimelineEventModel e in events) {
        if (earliest == null || e.timestamp.isBefore(earliest)) {
          earliest = e.timestamp;
        }
      }
      if (earliest != null) {
        final int days = DateTime.now().difference(earliest).inDays;
        if (days >= 7) {
          weeks = (days / 7).floor();
        }
      }
    }

    final List<TimelineEventModel> filtered = _applyFilter(
      events,
      state.selectedFilter,
    );

    changeProps(
      allEvents: events,
      filteredEvents: filtered,
      child: child,
      weeksWithLovingBrain: weeks,
      averageBedtimeShiftMinutes: bedtimeShift,
      fetchStatus: const ApiResultStatus.data(data: null),
    );
  }

  void setFilter(String filter) {
    final List<TimelineEventModel> filtered = _applyFilter(
      state.allEvents,
      filter,
    );
    changeProps(selectedFilter: filter, filteredEvents: filtered);
  }

  List<TimelineEventModel> _applyFilter(
    List<TimelineEventModel> source,
    String filter,
  ) {
    if (filter == 'Sleep') {
      return source
          .where(
            (TimelineEventModel e) =>
                e.type.contains('sleep') || e.type == 'nap',
          )
          .toList();
    } else if (filter == 'Behaviour') {
      return source
          .where(
            (TimelineEventModel e) =>
                e.type.contains('tantrum') ||
                e.type.contains('mood') ||
                e.type.contains('state') ||
                e.type.contains('smart_moment'),
          )
          .toList();
    } else if (filter == 'Notes' || filter == 'Note') {
      return source
          .where((TimelineEventModel e) => e.type.contains('note'))
          .toList();
    } else if (filter == 'Mentorship') {
      return source
          .where(
            (TimelineEventModel e) =>
                e.type.contains('mentorship') ||
                e.type.contains('help') ||
                e.type.contains('guidance') ||
                e.type.contains('program') ||
                e.type.contains('milestone'),
          )
          .toList();
    }
    return source;
  }
}
