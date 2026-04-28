import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/other/app_extentions.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../other/preferances.dart';
import '../../../repo/co_parent_repo.dart';
import 'link_co_parent_state.dart';

class LinkCoParentCubit extends Cubit<LinkCoParentState> {
  LinkCoParentCubit() : super(LinkCoParentState());

  void changeProps({
    String? selectedTab,
    String? coParentEmailError,
    String? selectChildrenError,
    String? coParentEmail,
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
        selectChildrenError: selectChildrenError ?? state.selectChildrenError,
        coParentEmail: coParentEmail ?? state.coParentEmail,
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
    final ApiResultStatus apiResults = await ChildRepo.instance.getChildren(
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

  bool _isValidate() {
    final String toEmail = (state.coParentEmail ?? '').trim();
    final String fromEmail = (state.userModel?.email ?? '').trim();
    if (state.selectedChildren.isEmpty || toEmail.isEmpty) {
      if (state.selectedChildren.isEmpty) {
        changeProps(selectChildrenError: LocaleKeys.pleaseSelectChild.tr());
      } else {
        changeProps(selectChildrenError: "");
      }

      if (toEmail.isEmpty) {
        changeProps(
          coParentEmailError: LocaleKeys.pleaseEnterCoParentEmail.tr(),
        );
      } else {
        changeProps(coParentEmailError: "");
      }
      return false;
    }

    if (!toEmail.isValidEmail) {
      changeProps(coParentEmailError: LocaleKeys.pleaseEnterValidEmail.tr());
      return false;
    }

    if (fromEmail.isNotEmpty &&
        fromEmail.toLowerCase() == toEmail.toLowerCase()) {
      changeProps(coParentEmailError: 'cannotInviteYourself'.tr());
      return false;
    }

    changeProps(coParentEmailError: "", selectChildrenError: "");
    return true;
  }

  Future<void> sendInvite() async {
    if (_isValidate()) {
      changeProps(createInvitation: ApiResultStatus.loading());
      final String fromEmail = (state.userModel?.email ?? '').trim();
      final String toEmail = (state.coParentEmail ?? '').trim();
      final String childrenValue = state.selectedChildren
          .map((ChildModel e) => e.reference?.id ?? '')
          .where((String e) => e.trim().isNotEmpty)
          .join(',');

      try {
        final bool exists =
            (await CoParentRepo.instance.coParentInvitationCollection
                    .where('from_parent', isEqualTo: fromEmail)
                    .where('to_parent', isEqualTo: toEmail)
                    .where('children', isEqualTo: childrenValue)
                    .where('status', isEqualTo: 'REQUESTED')
                    .limit(1)
                    .get())
                .docs
                .isNotEmpty;
        if (exists) {
          changeProps(
            createInvitation: ApiResultStatus.error(
              error: Exception('invitationAlreadySent'.tr()),
            ),
          );
          return;
        }
      } catch (_) {
        // If the query fails (index missing, etc.), still proceed to create invite.
      }

      final ApiResultStatus apiResponse = await CoParentRepo.instance
          .createInvitation(
            request: {
              "calender_events": state.calenderAndEvent,
              "childs_essentials": state.childEssentials,
              "from_parent": fromEmail,
              "to_parent": toEmail,
              "children": childrenValue,
              "status": "REQUESTED",
            },
          );
      changeProps(createInvitation: apiResponse);
    }
  }
}
