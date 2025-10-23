import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/ui/propose_change/bloc/propose_change_state.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../repo/co_parent_repo.dart';

class ProposeChangeCubit extends Cubit<ProposeChangeState> {
  ProposeChangeCubit() : super(ProposeChangeState());

  void init(SharedEventModel sharedEvent) {
    emit(ProposeChangeState(sharedEvent: sharedEvent));
  }

  void changeProps({
    DateTime? endTime,
    DateTime? startTime,
    DateTime? selectedDate,
    SharedEventModel? sharedEvent,
    String? dateError,
    String? startTimeError,
    String? endTimeError,
    String? noteForCoParent,
    ApiResultStatus? sendProposalApiResultStatus,
  }) {
    emit(
      state.copyWith(
        endTime: endTime ?? state.endTime,
        sharedEvent: sharedEvent ?? state.sharedEvent,
        startTime: startTime ?? state.startTime,
        selectedDate: selectedDate ?? state.selectedDate,
        dateError: dateError ?? state.dateError,
        startTimeError: startTimeError ?? state.startTimeError,
        endTimeError: endTimeError ?? state.endTimeError,
        noteForCoParent: noteForCoParent ?? state.noteForCoParent,
        sendProposalApiResultStatus:
            sendProposalApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  bool isValidate() {
    if (state.selectedDate == null ||
        state.startTime == null && state.endTime == null) {
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
      return false;
    }
    changeProps(endTimeError: "", startTimeError: "", dateError: "");
    return true;
  }

  Future<void> sendProposal(ProposeChangeState state) async {
    if (isValidate()) {
      if (state.sharedEvent?.reference?.id != null) {
        changeProps(sendProposalApiResultStatus: ApiResultStatus.initial());
        var response = await CoParentRepo.instance.addProposeToSharedEvent(
          docId: state.sharedEvent!.reference!.id,
          request: {
            "date": Timestamp.fromDate(state.selectedDate!),
            "start_time": Timestamp.fromDate(state.startTime!),
            "end_time": Timestamp.fromDate(state.endTime!),
            "note_for_co_parent": state.noteForCoParent,
          },
        );
        changeProps(sendProposalApiResultStatus: response);
      }
    }
  }
}
