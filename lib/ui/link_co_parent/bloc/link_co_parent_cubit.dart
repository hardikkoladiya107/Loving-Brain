import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/repo/child_repo.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../other/app_utils.dart';
import '../../../other/preferances.dart';
import '../../../repo/co_parent_repo.dart';
import 'link_co_parent_state.dart';

class LinkCoParentCubit extends Cubit<LinkCoParentState> {
  LinkCoParentCubit() : super(LinkCoParentState());

  void changeProps({
    String? selectedTab,
    String? coParentEmailError,
    ApiResultStatus? getApiResultStatus,
    ApiResultStatus? createInvitation,
    List<ChildModel>? children,
    List<ChildModel>? selectedChildren,
    bool? calenderAndEvent,
    bool? childEssentials,
  }) {
    emit(
      state.copyWith(
        selectedTab: selectedTab ?? state.selectedTab,
        coParentEmailError: coParentEmailError ?? state.coParentEmailError,
        children: children ?? state.children,
        selectedChildren: selectedChildren ?? state.selectedChildren,
        calenderAndEvent: calenderAndEvent ?? state.calenderAndEvent,
        childEssentials: childEssentials ?? state.childEssentials,
        getApiResultStatus: getApiResultStatus ?? ApiResultStatus.initial(),
        createInvitation: createInvitation ?? ApiResultStatus.initial(),
      ),
    );
  }

  void init() {
    emit(LinkCoParentState(userModel: preferences.getUserModel()));
    _getMyChildren();
  }

  Future<void> _getMyChildren() async {
    changeProps(getApiResultStatus: ApiResultStatus.loading());
    var apiResults = await ChildRepo.instance.getChildren(
      childrenIds: state.userModel?.children?.map((e) => e.id).toList() ?? [],
    );
    changeProps(getApiResultStatus: apiResults);
    apiResults.whenOrNull(
      data: (data) {
        if (data is List<ChildModel>) {
          changeProps(children: data);
        }
      },
    );
  }

  void selectChild(ChildModel child) {
    List<ChildModel> childrenList = [];
    childrenList.addAll(state.selectedChildren ?? []);
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

  bool _isValidate() {
    if ((state.coParentEmail ?? "").isEmpty) {
      changeProps(coParentEmailError: LocaleKeys.pleaseEnterCoParentEmail.tr());
      return false;
    } else {
      changeProps(coParentEmailError: "");
    }
    return true;
  }

  Future<void> sendInvite() async {
    if (_isValidate()) {
      changeProps(createInvitation: ApiResultStatus.loading());
      var apiResponse = await CoParentRepo.instance.createInvitation(
        request: {
          "calender_events": state.calenderAndEvent,
          "childs_essentials": state.childEssentials,
          "from_parent": state.userModel?.email ?? "",
          "to_parent": state.coParentEmail,
          "children": state.selectedChildren
              .map((e) => e.reference?.id)
              .join(","),
        },
      );
      apiResponse.whenOrNull(
        data: (data) {
          getInvitationLink(data.toString());
        },
      );
      changeProps(createInvitation: apiResponse);
    }
  }


  sendInvitationMail(){

  }
}
