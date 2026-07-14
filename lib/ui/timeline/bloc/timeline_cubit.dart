import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/timeline_repo.dart';
import 'package:loving_brain/ui/timeline/bloc/timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit() : super(const TimelineState());

  StreamSubscription<DocumentSnapshot<Object?>>? _childSubscription;

  void init() {
    final UserModel? userModel = preferences.getUserModel();
    emit(TimelineState(userModel: userModel));
    _listenToChild(userModel?.defaultChild);
  }

  void changeProps({
    UserModel? userModel,
    ChildModel? childModel,
    List<TimelineEventModel>? events,
    ApiResultStatus? loadStatus,
  }) {
    emit(
      state.copyWith(
        userModel: userModel ?? state.userModel,
        childModel: childModel ?? state.childModel,
        events: events ?? state.events,
        loadStatus: loadStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void _listenToChild(DocumentReference<Object?>? defaultChildRef) {
    _childSubscription?.cancel();
    _childSubscription = defaultChildRef?.snapshots().listen((
      DocumentSnapshot<Object?> event,
    ) async {
      if (event.data() != null) {
        final ChildModel childModel = ChildModel.fromJson(
          event.data() as Map<String, dynamic>,
          event.reference,
        );
        changeProps(childModel: childModel);
        await loadToday();
      }
    });
  }

  Future<void> loadToday() async {
    final String childId = state.childModel?.reference?.id ?? '';
    if (childId.isEmpty) {
      return;
    }
    changeProps(loadStatus: ApiResultStatus.loading());
    final ApiResultStatus<List<TimelineEventModel>> result =
        await TimelineRepo.instance.fetchTodayEvents(childId: childId);
    result.whenOrNull(
      data: (List<TimelineEventModel> events) {
        changeProps(events: events, loadStatus: ApiResultStatus.data(data: events));
      },
      error: (Exception error) {
        changeProps(loadStatus: ApiResultStatus.error(error: error));
      },
    );
  }

  @override
  Future<void> close() {
    _childSubscription?.cancel();
    return super.close();
  }
}
