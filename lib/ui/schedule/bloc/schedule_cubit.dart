import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/ui/schedule/bloc/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState());

  void changeProps({int? tabIndex}) {
    emit(state.copyWith(tabIndex: tabIndex ?? state.tabIndex));
  }
}
