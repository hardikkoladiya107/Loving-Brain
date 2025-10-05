import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/user_model.dart';

part 'add_shared_event_state.freezed.dart';

@freezed
abstract class AddSharedEventState with _$AddSharedEventState {
  const factory AddSharedEventState({
    UserModel? userModel,
    @Default("") String title,
    @Default("") String note,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    @Default("") String selectedChild,
    @Default("") String assignedTo,
    @Default("") String titleError,
    @Default("") String noteError,
    @Default("") String dateError,
    @Default("") String startTimeError,
    @Default("") String endTimeError,
    @Default(false) bool requiredApproval,
    @Default("") String selectedChildError,
    @Default("") String assignedToError,
    @Default(ApiResultStatus.initial()) ApiResultStatus requestApprovalApiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus getChildApiResultStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus getCoParentApiResultStatus,
  }) = _AddSharedEventState;
}
