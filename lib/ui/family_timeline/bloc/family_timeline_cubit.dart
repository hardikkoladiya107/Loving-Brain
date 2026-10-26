import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
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

    final ChildModel? child = preferences.getChildModel();
    final String childId = child?.reference?.id ?? '';

    List<TimelineEventModel> events = <TimelineEventModel>[];

    if (childId.isNotEmpty) {
      final ApiResultStatus<List<TimelineEventModel>> result =
          await TodayLogRepo.instance.getTimelineEvents(childId);
      if (result is Data<List<TimelineEventModel>>) {
        events = result.data;
      }
    }

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
      averageBedtimeShiftMinutes: 0,
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
