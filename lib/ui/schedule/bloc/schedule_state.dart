import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/child_model.dart';
import '../../../model/routine_model.dart';
import '../../../model/shared_event_model.dart';
import '../../../model/user_model.dart';

part 'schedule_state.freezed.dart';

@freezed
abstract class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    @Default("") String message,
    @Default(0) int tabIndex,
    @Default([]) List<SharedEventModel> sharedEventList,
    UserModel? userModel,
    ChildModel? childModel,
  }) = _ScheduleState;
}
