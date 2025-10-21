import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/shared_event_model.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import '../../../model/user_model.dart';
import 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit() : super(EventDetailState());

  void init(SharedEventModel sharedEvent) {
    emit(EventDetailState(sharedEvent: sharedEvent));
    _getAssignedToUsers(sharedEvent);
    _getChildren(sharedEvent);
    _getCreatedBy(sharedEvent);
  }

  void changeProps({
    SharedEventModel? sharedEvent,
    ApiResultStatus? getAssigneeApiResult,
    List<UserModel>? assignedUserList,
    List<ChildModel>? childrenList,
    ApiResultStatus? getChildrenResult,
    ApiResultStatus? getCreatedByUserApiResult,
    UserModel? createdByUser,
  }) {
    emit(
      state.copyWith(
        sharedEvent: sharedEvent ?? state.sharedEvent,
        assignedUserList: assignedUserList ?? state.assignedUserList,
        getChildrenResult: getChildrenResult ?? ApiResultStatus.initial(),
        childrenList: childrenList ?? state.childrenList,
        getAssigneeApiResult: getAssigneeApiResult ?? ApiResultStatus.initial(),
        getCreatedByUserApiResult:
            getCreatedByUserApiResult ?? ApiResultStatus.initial(),
        createdByUser: createdByUser ?? state.createdByUser,
      ),
    );
  }

  Future<void> _getAssignedToUsers(SharedEventModel sharedEvent) async {
    var assignedTo = state.sharedEvent?.assignedTo ?? "";
    var listOfAssignedTo = assignedTo.split(",");
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
}
