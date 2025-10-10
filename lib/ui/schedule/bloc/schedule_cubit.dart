import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_state.dart';
import '../../../model/child_model.dart';
import '../../../model/routine_model.dart';
import '../../../other/preferances.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState());

  void init() {
    emit(ScheduleState(userModel: preferences.getUserModel()));
    _listenToRoutine();
    _listenToSharedEvent();
  }

  void changeProps({int? tabIndex, ChildModel? childModel}) {
    emit(
      state.copyWith(
        tabIndex: tabIndex ?? state.tabIndex,

        childModel: childModel ?? state.childModel,
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
                  event.data() as Map<String, dynamic>,event.reference
                ),
              );
            }
          });
    }
  }

  void _listenToSharedEvent() {
    sharedEventStreamSubscription?.cancel();
    sharedEventStreamSubscription = CoParentRepo.instance
        .sharedEventListener()
        .listen((event) {});
  }
}
