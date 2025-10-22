import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import '../../../model/user_model.dart';
import '../../../other/preferances.dart';
import '../../../repo/co_parent_repo.dart';
import 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit() : super(EventDetailState());

  void init(SharedEventModel sharedEvent) {
    emit(
      EventDetailState(
        sharedEvent: sharedEvent,
        userModel: preferences.getUserModel(),
      ),
    );
    _getAssignedToUsers();
    _getChildren(sharedEvent);
    _getCreatedBy(sharedEvent);
    _listenToEvent();
  }

  void changeProps({
    SharedEventModel? sharedEvent,
    ApiResultStatus? getAssigneeApiResult,
    ApiResultStatus? uploadDocumentApiResultStatus,
    List<UserModel>? assignedUserList,
    List<ChildModel>? childrenList,
    ApiResultStatus? getChildrenResult,
    ApiResultStatus? getCreatedByUserApiResult,
    UserModel? createdByUser,
    UserModel? userModel,
  }) {
    emit(
      state.copyWith(
        sharedEvent: sharedEvent ?? state.sharedEvent,
        userModel: userModel ?? state.userModel,
        assignedUserList: assignedUserList ?? state.assignedUserList,
        getChildrenResult: getChildrenResult ?? ApiResultStatus.initial(),
        childrenList: childrenList ?? state.childrenList,
        getAssigneeApiResult: getAssigneeApiResult ?? ApiResultStatus.initial(),
        uploadDocumentApiResultStatus:
            uploadDocumentApiResultStatus ?? ApiResultStatus.initial(),
        getCreatedByUserApiResult:
            getCreatedByUserApiResult ?? ApiResultStatus.initial(),
        createdByUser: createdByUser ?? state.createdByUser,
      ),
    );
  }

  Future<void> _getAssignedToUsers() async {
    var listOfAssignedTo = state.sharedEvent?.assignedTo ?? [];
    if (listOfAssignedTo.isNotEmpty) {
      var apiResult = await AuthRepo.instance.getUsersFromList(
        listOfAssignedTo,
      );
      changeProps(getAssigneeApiResult: apiResult);
      apiResult.whenOrNull(
        data: (data) {
          if (data is List<UserModel>) {
            changeProps(assignedUserList: data);
          }
        },
      );
    }
  }

  Future<void> _getChildren(SharedEventModel sharedEvent) async {
    var children = state.sharedEvent?.children ?? "";
    var listOfChild = children.split(",");
    if (listOfChild.isNotEmpty) {
      var apiResult = await AuthRepo.instance.getChildrenFromList(listOfChild);
      changeProps(getChildrenResult: apiResult);
      apiResult.whenOrNull(
        data: (data) {
          if (data is List<ChildModel>) {
            changeProps(childrenList: data);
          }
        },
      );
    }
  }

  Future<void> _getCreatedBy(SharedEventModel sharedEvent) async {
    if ((sharedEvent.createdBy ?? "").isNotEmpty) {
      var response = await AuthRepo.instance.getUserFromUid(
        uId: sharedEvent.createdBy!,
      );
      changeProps(createdByUser: response);
    }
  }

  Future<void> uploadToFirebaseStorage(String fileLocalPath) async {
    changeProps(uploadDocumentApiResultStatus: ApiResultStatus.loading());
    var uploadedFilePath = await CoParentRepo.instance
        .uploadFileToFirebaseStorage(
          file: File(fileLocalPath),
          referenceId: state.userModel?.uid,
        );
    uploadedFilePath.whenOrNull(
      data: (data) async {
        changeProps(
          uploadDocumentApiResultStatus: ApiResultStatus.data(data: ""),
        );
        if (data is TaskSnapshot) {
          var imageNetworkUrl = await data.ref.getDownloadURL();
          _updateEvent(imageNetworkUrl);
        }
      },
      error: (error) {
        changeProps(
          uploadDocumentApiResultStatus: ApiResultStatus.error(error: error),
        );
      },
    );
  }

  Future<void> _updateEvent(String imageNetworkUrl) async {
    if (state.sharedEvent?.reference?.id != null) {
      await CoParentRepo.instance.updateSharedEvent(
        documentReference: state.sharedEvent!.reference!.id,
        request: {
          'documents': FieldValue.arrayUnion([imageNetworkUrl]),
        },
      );
    }
  }

  StreamSubscription? profileSubscription;

  void _listenToEvent() {
    if (state.sharedEvent?.reference?.id != null) {
      profileSubscription?.cancel();
      profileSubscription = CoParentRepo.instance.sharedEventCollection
          .doc(state.sharedEvent?.reference?.id)
          .snapshots()
          .listen((event) async {
            if (event.data() != null) {
              var sharedEventModel = SharedEventModel.fromJson(
                event.data()!,
                event.reference,
              );
              changeProps(sharedEvent: sharedEventModel);
            }
          });
    }
  }
}
