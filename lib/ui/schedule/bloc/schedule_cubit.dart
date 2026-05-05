/// Cubit for the Schedule screen: listens to child doc (routines) and shared
/// events, exposes delete actions for routine and shared event.
library;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_state.dart';
import 'package:rxdart/rxdart.dart';
import '../../../model/api_result_status.dart';
import '../../../model/child_model.dart';
import '../../../model/routine_model.dart';
import '../../../model/shared_event_model.dart';
import '../../../other/preferances.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState());

  void init() {
    emit(ScheduleState(userModel: preferences.getUserModel()));
    _listenToRoutine();
    _listenToSharedEvent(state);
    _checkCoParentLinkStatus();
  }

  void changeProps({
    int? tabIndex,
    ChildModel? childModel,
    List<SharedEventModel>? sharedEventList,
    bool? hasLinkedCoParent,
    ApiResultStatus? deleteRoutineApiResultStatus,
    ApiResultStatus? deleteSharedEventApiResultStatus,
  }) {
    emit(
      state.copyWith(
        tabIndex: tabIndex ?? state.tabIndex,
        childModel: childModel ?? state.childModel,
        sharedEventList: sharedEventList ?? state.sharedEventList,
        hasLinkedCoParent: hasLinkedCoParent ?? state.hasLinkedCoParent,
        deleteRoutineApiResultStatus:
            deleteRoutineApiResultStatus ?? state.deleteRoutineApiResultStatus,
        deleteSharedEventApiResultStatus:
            deleteSharedEventApiResultStatus ??
            state.deleteSharedEventApiResultStatus,
      ),
    );
  }

  StreamSubscription? routineStreamSubscription;
  StreamSubscription? sharedEventStreamSubscription;

  void _listenToRoutine() {
    if (state.userModel?.defaultChild != null) {
      routineStreamSubscription?.cancel();
      routineStreamSubscription = state.userModel?.defaultChild!
          .snapshots()
          .listen((event) {
            if (event.data() != null) {
              changeProps(
                childModel: ChildModel.fromJson(
                  event.data() as Map<String, dynamic>,
                  event.reference,
                ),
              );
            }
          });
    }
  }

  void _listenToSharedEvent(ScheduleState state) {
    sharedEventStreamSubscription?.cancel();
    final createdByStream = CoParentRepo.instance.sharedEventCollection
        .where("created_by", isEqualTo: state.userModel?.uid)
        .snapshots();
    final assignedToStream = CoParentRepo.instance.sharedEventCollection
        .where("assigned_to", arrayContains: state.userModel?.uid)
        .snapshots();
    sharedEventStreamSubscription =
        Rx.combineLatest2(createdByStream, assignedToStream, (
          QuerySnapshot createdSnap,
          QuerySnapshot assignedSnap,
        ) {
          final allDocs = {
            ...createdSnap.docs,
            ...assignedSnap.docs,
          }; // merge unique docs
          final list = allDocs
              .map((e) => SharedEventModel.fromJson(e.data(), e.reference))
              .toList();
          // Upcoming first; null startTime last.
          list.sort((SharedEventModel a, SharedEventModel b) {
            final DateTime? at = a.startTime;
            final DateTime? bt = b.startTime;
            if (at == null && bt == null) return 0;
            if (at == null) return 1;
            if (bt == null) return -1;
            return at.compareTo(bt);
          });
          return list;
        }).listen((sharedEventList) {
          changeProps(sharedEventList: sharedEventList);
        });
  }

  Future<void> deleteRoutine(RoutineModel routine) async {
    changeProps(deleteRoutineApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await ChildRepo.instance.removeRoutine(
      id: state.childModel?.reference?.id,
      request: routine.toJson(),
    );
    changeProps(deleteRoutineApiResultStatus: response);
  }

  Future<void> deleteSharedEvent(SharedEventModel sharedEvent) async {
    final String? docId = sharedEvent.reference?.id;
    if (docId == null || docId.isEmpty) return;
    changeProps(deleteSharedEventApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await CoParentRepo.instance
        .deleteSharedEvent(documentId: docId);
    changeProps(deleteSharedEventApiResultStatus: response);
  }

  Future<void> _checkCoParentLinkStatus() async {
    final ApiResultStatus response = await CoParentRepo.instance
        .getMyCoParents();
    response.whenOrNull(
      data: (dynamic data) {
        if (data is List && data.isNotEmpty) {
          changeProps(hasLinkedCoParent: true);
          return;
        }
        changeProps(hasLinkedCoParent: false);
      },
      error: (Exception _) {
        changeProps(hasLinkedCoParent: false);
      },
    );
  }

  @override
  Future<void> close() {
    routineStreamSubscription?.cancel();
    sharedEventStreamSubscription?.cancel();
    return super.close();
  }
}
