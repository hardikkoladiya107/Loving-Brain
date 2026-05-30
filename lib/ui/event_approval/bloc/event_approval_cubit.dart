import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../../../model/child_model.dart';
import '../../../model/shared_event_model.dart';
import '../../../model/user_model.dart';
import '../../../repo/auth_repo.dart';
import '../../../repo/co_parent_repo.dart';
import 'event_approval_state.dart';

class EventApprovalCubit extends Cubit<EventApprovalState> {
  EventApprovalCubit() : super(EventApprovalState());

  void init(SharedEventModel sharedEvent) {
    emit(EventApprovalState(sharedEvent: sharedEvent));
    _getAssignedToUsers();
    _getChildren(sharedEvent);
    _getCreatedBy(sharedEvent);
    _listenToEvent();
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

  void changeProps({
    SharedEventModel? sharedEvent,
    ApiResultStatus? getAssigneeApiResult,
    ApiResultStatus? getChildrenResult,
    ApiResultStatus? getCreatedByUserApiResult,
    UserModel? createdByUser,
    UserModel? userModel,
    List<UserModel>? assignedUserList,
    List<ChildModel>? childrenList,
    ApiResultStatus? updatedSharedEventApiResult,
  }) {
    emit(
      state.copyWith(
        sharedEvent: sharedEvent ?? state.sharedEvent,
        getAssigneeApiResult: getAssigneeApiResult ?? ApiResultStatus.initial(),
        getChildrenResult: getChildrenResult ?? ApiResultStatus.initial(),
        getCreatedByUserApiResult:
            getCreatedByUserApiResult ?? ApiResultStatus.initial(),
        createdByUser: createdByUser ?? state.createdByUser,
        userModel: userModel ?? state.userModel,
        assignedUserList: assignedUserList ?? state.assignedUserList,
        childrenList: childrenList ?? state.childrenList,
        updatedSharedEventApiResult:
            updatedSharedEventApiResult ?? ApiResultStatus.initial(),
      ),
    );
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

  Future<void> approveReject(String status) async {
    if (state.sharedEvent?.reference?.id != null) {
      changeProps(updatedSharedEventApiResult: ApiResultStatus.loading());
      var response = await CoParentRepo.instance.updateSharedEvent(
        request: {'status': status},
        documentReference: state.sharedEvent!.reference!.id,
      );
      changeProps(updatedSharedEventApiResult: response);
    }
  }
}
