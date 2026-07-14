import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/repo/child_repo.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/api_result_status.dart';
import '../../../other/preferances.dart';
import '../../../repo/co_parent_repo.dart';
import 'link_co_parent_state.dart';

/// Sends co-parent invitations: validates form → Firestore doc → Brevo email.
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
    bool? emailDeliveryFailed,
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
        emailDeliveryFailed: emailDeliveryFailed ?? state.emailDeliveryFailed,
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

  /// Toggles a child in the multi-select list for the invitation.
  void selectChild(ChildModel child) {
    changeProps(
      selectedChildren: CoParentInvitationHelpers.toggleChildSelection<ChildModel>(
        selected: state.selectedChildren,
        child: child,
        idForItem: (ChildModel item) => item.reference?.id,
      ),
    );
  }

  bool _isValidate() {
    final InviteFormValidationResult validation =
        CoParentInvitationHelpers.validateSendInviteForm(
          toEmail: state.coParentEmail ?? '',
          fromEmail: state.userModel?.email ?? '',
          selectedChildrenCount: state.selectedChildren.length,
          isValidEmailFormat: (String email) => email.isValidEmail,
        );

    if (!validation.isValid) {
      changeProps(
        coParentEmailError: _localizedFieldError(
          validation.coParentEmailErrorKey,
        ),
        selectChildrenError: _localizedFieldError(
          validation.selectChildrenErrorKey,
        ),
      );
      return false;
    }

    changeProps(coParentEmailError: '', selectChildrenError: '');
    return true;
  }

  String _localizedFieldError(String localeKeyName) {
    if (localeKeyName.isEmpty) {
      return '';
    }
    switch (localeKeyName) {
      case 'pleaseSelectChild':
        return LocaleKeys.pleaseSelectChild.tr();
      case 'pleaseEnterCoParentEmail':
        return LocaleKeys.pleaseEnterCoParentEmail.tr();
      case 'pleaseEnterValidEmail':
        return LocaleKeys.pleaseEnterValidEmail.tr();
      case 'cannotInviteYourself':
        return LocaleKeys.cannotInviteYourself.tr();
      default:
        return '';
    }
  }

  /// Creates the invitation document and sends the email with the universal link.
  Future<void> sendInvite() async {
    if (!_isValidate()) {
      return;
    }

    changeProps(
      createInvitation: ApiResultStatus.loading(),
      emailDeliveryFailed: false,
    );

    final String fromEmail = (state.userModel?.email ?? '').trim();
    final String toEmail = (state.coParentEmail ?? '').trim();
    final String childrenValue = CoParentInvitationHelpers.buildChildrenCsv(
      state.selectedChildren.map(
        (ChildModel child) => child.reference?.id ?? '',
      ),
    );

    // Prevent duplicate pending invites for the same parent/child combo.
    try {
      final bool exists =
          (await CoParentRepo.instance.coParentInvitationCollection
                  .where('from_parent', isEqualTo: fromEmail)
                  .where('to_parent', isEqualTo: toEmail)
                  .where('children', isEqualTo: childrenValue)
                  .where(
                    'status',
                    isEqualTo: CoParentInvitationHelpers.statusRequested,
                  )
                  .limit(1)
                  .get())
              .docs
              .isNotEmpty;
      if (exists) {
        changeProps(
          createInvitation: ApiResultStatus.error(
            error: Exception(LocaleKeys.invitationAlreadySent.tr()),
          ),
        );
        return;
      }
    } catch (_) {
      // Missing composite index should not block sending a new invite.
    }

    final ApiResultStatus apiResponse = await CoParentRepo.instance
        .createInvitation(
          request: <String, dynamic>{
            'calender_events': state.calenderAndEvent,
            'childs_essentials': state.childEssentials,
            'from_parent': fromEmail,
            'to_parent': toEmail,
            'children': childrenValue,
            'status': CoParentInvitationHelpers.statusRequested,
          },
        );

    bool emailDeliveryFailed = false;

    await apiResponse.whenOrNull(
      data: (dynamic invitationId) async {
        final String fromParentName =
            state.userModel?.parentName ??
            state.userModel?.displayName ??
            LocaleKeys.yourCoParent.tr();
        final String childrenNames = state.selectedChildren
            .map((ChildModel child) => child.childName ?? '')
            .where((String name) => name.isNotEmpty)
            .join(' & ');

        final ApiResultStatus emailResult = await CoParentRepo.instance
            .sendInvitationEmail(
              toEmail: toEmail,
              fromParentName: fromParentName,
              childrenNames: childrenNames,
              invitationId: invitationId.toString(),
            );

        emailResult.whenOrNull(error: (_) => emailDeliveryFailed = true);
      },
    );

    changeProps(
      createInvitation: apiResponse,
      emailDeliveryFailed: emailDeliveryFailed,
    );
  }
}
