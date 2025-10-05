import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import '../../../generated/locale_keys.g.dart';
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
    String? locationText,
    String? locationError,
  }) {
    emit(
      state.copyWith(
        title: title ?? state.title,
        locationText: locationText ?? state.locationText,
        locationError: locationError ?? state.locationError,
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
            requestApprovalApiResultStatus ?? ApiResultStatus.initial(),
        getChildApiResultStatus:
            getChildApiResultStatus ?? ApiResultStatus.initial(),
        getCoParentApiResultStatus:
            getCoParentApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  bool isValidate() {
    if (state.title.isEmpty ||
        state.selectedDate == null ||
        state.startTime == null ||
        state.endTime == null ||
        state.locationText.isEmpty ||
        state.selectedChild.isEmpty ||
        state.assignedTo.isEmpty) {
      if (state.title.isEmpty) {
        changeProps(titleError: LocaleKeys.pleaseEnterTitle.tr());
      } else {
        changeProps(titleError: "");
      }
      if (state.selectedDate == null) {
        changeProps(dateError: LocaleKeys.pleaseSelectDate.tr());
      } else {
        changeProps(dateError: "");
      }
      if (state.startTime == null) {
        changeProps(startTimeError: LocaleKeys.pleaseSelectStartTime.tr());
      } else {
        changeProps(startTimeError: "");
      }
      if (state.endTime == null) {
        changeProps(endTimeError: LocaleKeys.pleaseSelectEndTime.tr());
      } else {
        changeProps(endTimeError: "");
      }
      if (state.locationText.isEmpty) {
        changeProps(locationText: LocaleKeys.pleaseEnterLocation.tr());
      } else {
        changeProps(locationError: "");
      }
      if (state.selectedChild.isEmpty) {
        changeProps(selectedChild: LocaleKeys.pleaseChooseChild.tr());
      } else {
        changeProps(selectedChildError: "");
      }
      if (state.assignedTo.isEmpty) {
        changeProps(assignedTo: LocaleKeys.pleaseChooseAssignedTo.tr());
      } else {
        changeProps(assignedToError: "");
      }
      return false;
    }
    return true;
  }

  Future<void> requestApproval() async {
    if (isValidate()) {
      changeProps(requestApprovalApiResultStatus: ApiResultStatus.loading());
      var apiResult = await CoParentRepo.instance.addSharedEvent(
        request: {
          "created_by": state.userModel?.uid,
          "assigned_to": "",
          "children": "",
          "note": state.note,
          "title": state.title,
          "date": Timestamp.fromDate(state.selectedDate!),
          "start_time": Timestamp.fromDate(state.startTime!),
          "end_time": Timestamp.fromDate(state.endTime!),
          "location": state.locationText,
        },
      );
      changeProps(requestApprovalApiResultStatus: apiResult);
    }
  }
}
