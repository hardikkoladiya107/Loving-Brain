import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/shared_event_model.dart';

part 'propose_change_state.freezed.dart';

@freezed
abstract class ProposeChangeState with _$ProposeChangeState {
  const factory ProposeChangeState({
    @Default("") String dateError,
    @Default("") String startTimeError,
    @Default("") String endTimeError,
    @Default("") String noteForCoParent,
    @Default(ApiResultStatus.initial()) ApiResultStatus sendProposalApiResultStatus,
    SharedEventModel? sharedEvent,
    DateTime? endTime,
    DateTime? startTime,
    DateTime? selectedDate,
  }) = _ProposeChangeState;
}
