import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import '../../../model/api_result_status.dart';
import '../../../other/preferances.dart';
import 'add_shared_event_state.dart';

class AddSharedEventCubit extends Cubit<AddSharedEventState> {
  AddSharedEventCubit() : super(AddSharedEventState());

  void init() {
    emit(AddSharedEventState(userModel: preferences.getUserModel()));
  }

  void changeProps({
    String? title,
    String? note,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    String? selectedChild,
    String? assignedTo,
    String? titleError,
    String? noteError,
    String? dateError,
    String? startTimeError,
    String? endTimeError,
    bool? requiredApproval,
    String? selectedChildError,
    String? assignedToError,
    ApiResultStatus? requestApprovalApiResultStatus,
    ApiResultStatus? getChildApiResultStatus,
    ApiResultStatus? getCoParentApiResultStatus,
  }) {
    emit(
      state.copyWith(
        title: title ?? state.title,
        note: note ?? state.note,
        selectedDate: selectedDate ?? state.selectedDate,
        startTime: startTime ?? state.startTime,
        endTime: endTime ?? state.endTime,
        selectedChild: selectedChild ?? state.selectedChild,
        assignedTo: assignedTo ?? state.assignedTo,
        titleError: titleError ?? state.titleError,
        noteError: noteError ?? state.noteError,
        dateError: dateError ?? state.dateError,
        startTimeError: startTimeError ?? state.startTimeError,
        endTimeError: endTimeError ?? state.endTimeError,
        requiredApproval: requiredApproval ?? state.requiredApproval,
        selectedChildError: selectedChildError ?? state.selectedChildError,
        assignedToError: assignedToError ?? state.assignedToError,
        requestApprovalApiResultStatus:
            requestApprovalApiResultStatus ??
            state.requestApprovalApiResultStatus,
        getChildApiResultStatus:
            getChildApiResultStatus ?? state.getChildApiResultStatus,
        getCoParentApiResultStatus:
            getCoParentApiResultStatus ?? state.getCoParentApiResultStatus,
      ),
    );
  }

  bool isValidate() {
    return false;
  }

  Future<void> requestApproval() async {
    if (isValidate()) {
      var apiResult = await CoParentRepo.instance.addSharedEvent(
        request: {
          "created_by": state.userModel?.uid,
          "assigned_to": "",
          "children": "",
          "note": "",
          "title": "",
          "date": "",
          "start_time": "",
          "end_time": "",
          "location": "",
        },
      );
    }
  }
}
