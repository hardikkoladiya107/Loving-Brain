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
  }

  void changeProps({
    int? tabIndex,
    ChildModel? childModel,
    List<SharedEventModel>? sharedEventList,
    ApiResultStatus? deleteRoutineApiResultStatus,
  }) {
    emit(
      state.copyWith(
        tabIndex: tabIndex ?? state.tabIndex,
        childModel: childModel ?? state.childModel,
        sharedEventList: sharedEventList ?? state.sharedEventList,
        deleteRoutineApiResultStatus:
            deleteRoutineApiResultStatus ?? state.deleteRoutineApiResultStatus,
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
          list.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
          return list;
        }).listen((sharedEventList) {
          changeProps(sharedEventList: sharedEventList);
        });
  }

  Future<void> deleteRoutine(RoutineModel routine) async {
    changeProps(deleteRoutineApiResultStatus: ApiResultStatus.loading());
    var response = await ChildRepo.instance.removeRoutine(
      id: state.childModel?.reference?.id,
      request: routine.toJson(),
    );
    changeProps(deleteRoutineApiResultStatus: response);
  }
}
