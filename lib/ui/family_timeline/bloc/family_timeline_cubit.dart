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

  void reset() {
    emit(const FamilyTimelineState());
  }

  void changeProps({
    List<TimelineEventModel>? allEvents,
    List<TimelineEventModel>? filteredEvents,
    String? selectedFilter,
    ChildModel? child,
    int? weeksWithLovingBrain,
    int? averageBedtimeShiftMinutes,
    bool? hasEnoughBedtimeHistory,
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
        hasEnoughBedtimeHistory:
            hasEnoughBedtimeHistory ?? state.hasEnoughBedtimeHistory,
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
    bool hasEnoughBedtimeHistory = false;
    Exception? loadError;

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<TimelineEventModel>> result =
          await TodayLogRepo.instance.getTimelineEvents(childId);
      if (result is Data<List<TimelineEventModel>>) {
        events = List<TimelineEventModel>.from(result.data);
      } else if (result is Error<List<TimelineEventModel>>) {
        loadError = result.error;
      }

      final ApiResultStatus<List<SleepLogModel>> sleepResult =
          await TodayLogRepo.instance.getRecentSleepLogs(childId, limit: 28);
      if (sleepResult is Data<List<SleepLogModel>>) {
        final List<SleepLogModel> nights = sleepResult.data
            .where((SleepLogModel s) => !s.isNap)
            .toList();
        nights.sort(
          (SleepLogModel a, SleepLogModel b) => a.date.compareTo(b.date),
        );
        if (nights.length >= 4) {
          final DateTime earliest = nights.first.date;
          final DateTime latest = nights.last.date;
          final int spanDays = latest.difference(earliest).inDays;
          if (spanDays >= 14) {
            hasEnoughBedtimeHistory = true;
            final int mid = nights.length ~/ 2;
            final List<SleepLogModel> earlierHalf = nights.sublist(0, mid);
            final List<SleepLogModel> laterHalf = nights.sublist(mid);
            final double earlierAvg = _averageBedMinutes(earlierHalf);
            final double laterAvg = _averageBedMinutes(laterHalf);
            bedtimeShift = (earlierAvg - laterAvg).round().clamp(-120, 120);
          }
        }
      }
    }

    try {
      final List<PendingLocalUpdateModel> pending = await OfflineSyncRepo
          .instance
          .getPendingUpdates();
      for (final PendingLocalUpdateModel p in pending) {
        if (p.childId == null || p.childId == childId || childId.isEmpty) {
          final String title = switch (p.type.toLowerCase()) {
            'note' => 'Quick Note',
            'sleep' => 'Sleep Log',
            'tantrum' || 'behaviour' => 'Tantrum update',
            'health' => 'Health update',
            'mood' =>
              (p.payload['childMood'] ??
                      p.payload['child_mood'] ??
                      'Mood check-in')
                  .toString(),
            _ => 'Update',
          };
          final String subtitle =
              (p.payload['note'] ??
                      p.payload['whatHappened'] ??
                      p.payload['subtitle'] ??
                      'Saved offline (pending sync)')
                  .toString();
          final String? author =
              (p.payload['authorName'] as String?) ??
              preferences.getUserModel()?.parentName ??
              preferences.getUserModel()?.displayName;
          events.add(
            TimelineEventModel(
              id: p.id,
              type: p.type,
              title: title,
              subtitle: subtitle,
              timestamp: p.timestamp,
              authorName: author,
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
      hasEnoughBedtimeHistory: hasEnoughBedtimeHistory,
      fetchStatus: loadError == null
          ? const ApiResultStatus.data(data: null)
          : ApiResultStatus.error(error: loadError),
    );
  }

  double _averageBedMinutes(List<SleepLogModel> logs) {
    if (logs.isEmpty) return 0;
    int total = 0;
    for (final SleepLogModel log in logs) {
      total += log.bedTime.hour * 60 + log.bedTime.minute;
    }
    return total / logs.length;
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
                e.type.contains('smart_moment') ||
                e.type.contains('behaviour'),
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
                e.type.contains('milestone') ||
                e.type.contains('experiment'),
          )
          .toList();
    }
    return source;
  }
}
