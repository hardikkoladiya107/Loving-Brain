import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/routine_model.dart';
import '../../../model/user_model.dart';

part 'schedule_state.freezed.dart';

@freezed
abstract class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default("message") String message,
    @Default(0) int tabIndex,
    UserModel? userModel,
    @Default([]) List<RoutineModel> routineList,
  }) = _ScheduleState;
}
