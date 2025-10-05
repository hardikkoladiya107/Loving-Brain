import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_state.dart';
import '../../../model/routine_model.dart';
import '../../../other/preferances.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState());

  void init() {
    emit(ScheduleState(userModel: preferences.getUserModel()));
    _listenToRoutine();
    _listenToSharedEvent();
  }

  void changeProps({int? tabIndex, List<RoutineModel>? routineList}) {
    emit(
      state.copyWith(
        tabIndex: tabIndex ?? state.tabIndex,
        routineList: routineList ?? state.routineList,
      ),
    );
  }

  StreamSubscription? routineStreamSubscription;
  StreamSubscription? sharedEventStreamSubscription;

  void _listenToRoutine() {
    if (state.userModel?.defaultChild != null) {
      routineStreamSubscription?.cancel();
      routineStreamSubscription = state.userModel?.defaultChild!
          .collection("routines")
          .orderBy("time_stamp", descending: true)
          .snapshots()
          .listen((event) {
            changeProps(
              routineList: event.docs
                  .map((e) => RoutineModel.fromJson(e.data()))
                  .toList(),
            );
          });
    }
  }

  void _listenToSharedEvent() {
    sharedEventStreamSubscription?.cancel();
    sharedEventStreamSubscription = CoParentRepo.instance
        .sharedEventListener()
        .listen((event) {

    });
  }
}
