import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../model/child_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/child_repo.dart';
import 'add_shared_event_state.dart';

class AddSharedEventCubit extends Cubit<AddSharedEventState> {
  AddSharedEventCubit() : super(AddSharedEventState());

  Future<void> init() async {
    emit(AddSharedEventState(userModel: preferences.getUserModel()));
    await _getMyCoParent();
    await _getMyChildren();
  }

  void changeProps({
    String? title,
    String? note,
    DateTime? selectedDate,
    DateTime? startTime,
    DateTime? endTime,
    String? titleError,
    String? noteError,
    String? dateError,
    String? startTimeError,
    String? endTimeError,
    bool? requiredApproval,
    String? selectedChildError,
    String? assignedToError,
    ApiResultStatus? uploadDocumentApiResultStatus,
    ApiResultStatus? requestApprovalApiResultStatus,
    ApiResultStatus? getChildApiResultStatus,
    ApiResultStatus? getCoParentApiResultStatus,
    String? locationText,
    String? locationError,
    List<UserModel>? coParentList,
    List<UserModel>? selectedCoParentList,
    List<ChildModel>? children,
    List<ChildModel>? selectedChildren,
    List<String>? documentsList,
  }) {
    emit(
      state.copyWith(
        title: title ?? state.title,
        coParentList: coParentList ?? state.coParentList,
        documentsList: documentsList ?? state.documentsList,
        selectedCoParentList:
            selectedCoParentList ?? state.selectedCoParentList,
        locationText: locationText ?? state.locationText,
        locationError: locationError ?? state.locationError,
        note: note ?? state.note,
        selectedDate: selectedDate ?? state.selectedDate,
        startTime: startTime ?? state.startTime,
        endTime: endTime ?? state.endTime,
        titleError: titleError ?? state.titleError,
        noteError: noteError ?? state.noteError,
        dateError: dateError ?? state.dateError,
        startTimeError: startTimeError ?? state.startTimeError,
        endTimeError: endTimeError ?? state.endTimeError,
        requiredApproval: requiredApproval ?? state.requiredApproval,
        selectedChildError: selectedChildError ?? state.selectedChildError,
        assignedToError: assignedToError ?? state.assignedToError,
        children: children ?? state.children,
        selectedChildren: selectedChildren ?? state.selectedChildren,
        uploadDocumentApiResultStatus:
            uploadDocumentApiResultStatus ?? ApiResultStatus.initial(),
        requestApprovalApiResultStatus:
            requestApprovalApiResultStatus ?? ApiResultStatus.initial(),
        getChildApiResultStatus:
            getChildApiResultStatus ?? ApiResultStatus.initial(),
        getCoParentApiResultStatus:
            getCoParentApiResultStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void selectChild(ChildModel child) {
    final List<ChildModel> childrenList = List<ChildModel>.from(
      state.selectedChildren,
    );
    if (childrenList.any(
      (element) => element.reference?.id == child.reference?.id,
    )) {
      childrenList.removeWhere(
        (element) => element.reference?.id == child.reference?.id,
      );
    } else {
      childrenList.add(child);
    }
    changeProps(selectedChildren: childrenList);
  }

  void selectParent(UserModel user) {
    final List<UserModel> coParentList = List<UserModel>.from(
      state.selectedCoParentList,
    );
    if (coParentList.any((element) => element.uid == user.uid)) {
      coParentList.removeWhere((element) => element.uid == user.uid);
    } else {
      coParentList.add(user);
    }
    changeProps(selectedCoParentList: coParentList);
  }

  bool isValidate() {
    if (state.title.isEmpty ||
        state.selectedDate == null ||
        state.startTime == null ||
        state.endTime == null ||
        state.locationText.isEmpty ||
        state.selectedChildren.isEmpty ||
        state.selectedCoParentList.isEmpty) {
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
        changeProps(locationError: LocaleKeys.pleaseEnterLocation.tr());
      } else {
        changeProps(locationError: "");
      }
      if (state.selectedChildren.isEmpty) {
        changeProps(selectedChildError: LocaleKeys.pleaseChooseChild.tr());
      } else {
        changeProps(selectedChildError: "");
      }
      if (state.selectedCoParentList.isEmpty) {
        changeProps(assignedToError: LocaleKeys.pleaseChooseAssignedTo.tr());
      } else {
        changeProps(assignedToError: "");
      }
      return false;
    }
    changeProps(
      assignedToError: "",
      selectedChildError: "",
      locationError: "",
      endTimeError: "",
      startTimeError: "",
      dateError: "",
      titleError: "",
    );
    return true;
  }

  Future<void> requestApproval() async {
    if (isValidate()) {
      changeProps(requestApprovalApiResultStatus: ApiResultStatus.loading());
      final ApiResultStatus apiResult = await CoParentRepo.instance
          .addSharedEvent(
            request: {
              "created_by": state.userModel?.uid,
              "assigned_to": state.selectedCoParentList.map((e) => e.uid), //
              "children": state.selectedChildren
                  .map((e) => e.reference?.id)
                  .join(","),
              "note": state.note,
              "title": state.title,
              "date": Timestamp.fromDate(state.selectedDate!),
              "start_time": Timestamp.fromDate(state.startTime!),
              "end_time": Timestamp.fromDate(state.endTime!),
              "location": state.locationText,
              "documents": state.documentsList,
              "required_approval": state.requiredApproval,
              "created_date": Timestamp.now(),
              if (state.requiredApproval) ...{
                "status": "REQUESTED",
              } else ...{
                "status": "NONE",
              },
            },
          );
      changeProps(requestApprovalApiResultStatus: apiResult);
    }
  }

  Future<void> _getMyCoParent() async {
    changeProps(getCoParentApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus response = await CoParentRepo.instance
        .getMyCoParents();
    changeProps(getCoParentApiResultStatus: response);
    response.whenOrNull(
      data: (data) {
        if (data is List<UserModel>) {
          changeProps(coParentList: data);
        }
      },
    );
  }

  Future<void> _getMyChildren() async {
    changeProps(getChildApiResultStatus: ApiResultStatus.loading());
    final ApiResultStatus apiResults = await ChildRepo.instance.getChildren(
      childrenIds: state.userModel?.children?.map((e) => e.id).toList() ?? [],
    );
    changeProps(getChildApiResultStatus: apiResults);
    apiResults.whenOrNull(
      data: (data) {
        if (data is List<ChildModel>) {
          changeProps(children: data);
        }
      },
    );
  }

  Future<void> uploadToFirebaseStorage(String? fileLocalPath) async {
    if (fileLocalPath != null) {
      changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());
      final ApiResultStatus uploadedFilePath = await CoParentRepo.instance
          .uploadFileToFirebaseStorage(
            file: File(fileLocalPath),
            referenceId: state.userModel?.uid,
          );
      uploadedFilePath.whenOrNull(
        data: (dynamic data) async {
          changeProps(
            uploadDocumentApiResultStatus: ApiResultStatus.data(data: ''),
          );
          if (data is TaskSnapshot) {
            final String imageNetworkUrl = await data.ref.getDownloadURL();
            final List<String> documentsList = [];
            documentsList.addAll(state.documentsList);
            documentsList.add(imageNetworkUrl);
            changeProps(documentsList: documentsList);
          }
        },
        error: (error) {
          changeProps(
            uploadDocumentApiResultStatus: ApiResultStatus.error(error: error),
          );
        },
      );
    }
  }
}
