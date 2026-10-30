import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'invite_caregiver_state.dart';

/// Cubit managing Invite a Caregiver (Screen 55).
class InviteCaregiverCubit extends Cubit<InviteCaregiverState> {
  InviteCaregiverCubit() : super(const InviteCaregiverState());

  void reset() {
    emit(const InviteCaregiverState());
  }

  void init() {
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    changeProps(
      childName: cName,
      selectedRole: '',
      email: '',
      emailError: '',
      isSending: false,
      sendStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    String? selectedRole,
    String? childName,
    String? email,
    String? emailError,
    bool? isSending,
    String? createdInvitationId,
    ApiResultStatus? sendStatus,
  }) {
    emit(
      state.copyWith(
        selectedRole: selectedRole ?? state.selectedRole,
        childName: childName ?? state.childName,
        email: email ?? state.email,
        emailError: emailError ?? state.emailError,
        isSending: isSending ?? state.isSending,
        createdInvitationId: createdInvitationId ?? state.createdInvitationId,
        sendStatus: sendStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void selectRole(String role) => changeProps(selectedRole: role);

  void updateEmail(String val) {
    if (state.emailError.isNotEmpty) {
      changeProps(email: val, emailError: '');
    } else {
      changeProps(email: val);
    }
  }

  void updateEmailOrPhone(String val) => updateEmail(val);

  bool isSelfEmail(String inputEmail) {
    final String clean = inputEmail.trim().toLowerCase();
    if (clean.isEmpty) {
      return false;
    }

    final UserModel? user = preferences.getUserModel();
    final String? userEmail = user?.email?.trim().toLowerCase();
    if (userEmail != null && userEmail.isNotEmpty && userEmail == clean) {
      return true;
    }

    final String? parentEmail = user?.parentEmail?.trim().toLowerCase();
    if (parentEmail != null && parentEmail.isNotEmpty && parentEmail == clean) {
      return true;
    }

    try {
      final String? authEmail = FirebaseAuth.instance.currentUser?.email
          ?.trim()
          .toLowerCase();
      if (authEmail != null && authEmail.isNotEmpty && authEmail == clean) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<bool> sendInvite() async {
    final String cleanRecipient = state.email.trim().toLowerCase();
    if (cleanRecipient.isEmpty) {
      final String errorMsg = LocaleKeys.pleaseEnterEmailAddress.tr();
      changeProps(
        emailError: errorMsg,
        sendStatus: ApiResultStatus.error(error: Exception(errorMsg)),
      );
      return false;
    }

    if (!cleanRecipient.isValidEmail) {
      final String errorMsg = LocaleKeys.pleaseEnterValidEmail.tr();
      changeProps(
        emailError: errorMsg,
        sendStatus: ApiResultStatus.error(error: Exception(errorMsg)),
      );
      return false;
    }

    if (isSelfEmail(cleanRecipient)) {
      final String errorMsg = LocaleKeys.cannotInviteYourselfCaregiver.tr();
      changeProps(
        emailError: errorMsg,
        sendStatus: ApiResultStatus.error(error: Exception(errorMsg)),
      );
      return false;
    }

    if (state.selectedRole.trim().isEmpty) {
      final String errorMsg = 'Please select a relationship role.';
      changeProps(
        emailError: errorMsg,
        sendStatus: ApiResultStatus.error(error: Exception(errorMsg)),
      );
      return false;
    }

    final String childId = preferences.getChildModel()?.reference?.id ?? '';
    if (childId.isEmpty) {
      final String errorMsg = LocaleKeys.somethingWentWrong.tr();
      changeProps(
        emailError: errorMsg,
        sendStatus: ApiResultStatus.error(error: Exception(errorMsg)),
      );
      return false;
    }

    changeProps(
      emailError: '',
      isSending: true,
      sendStatus: const ApiResultStatus.loading(),
    );

    final String fromParentName =
        (preferences.getUserModel()?.parentName?.trim().isNotEmpty == true)
        ? preferences.getUserModel()!.parentName!.trim()
        : ((preferences.getUserModel()?.displayName?.trim().isNotEmpty == true)
              ? preferences.getUserModel()!.displayName!.trim()
              : 'Your co-parent');

    final ApiResultStatus res = await CoParentRepo.instance.createInvitation(
      toEmail: cleanRecipient,
      role: state.selectedRole,
      childIds: <String>[childId],
      fromParentName: fromParentName,
    );

    bool isSuccess = false;
    String invitationId = '';
    bool emailSent = true;
    res.whenOrNull(
      data: (dynamic data) {
        isSuccess = true;
        if (data is Map) {
          invitationId = data['invitationId']?.toString() ?? '';
          emailSent = data['emailSent'] != false;
        }
      },
      error: (_) => isSuccess = false,
    );

    if (isSuccess && invitationId.isNotEmpty && !emailSent) {
      changeProps(
        isSending: false,
        createdInvitationId: invitationId,
        emailError:
            'Invitation created but email could not be sent. You can resend.',
        sendStatus: ApiResultStatus.error(
          error: Exception(
            'Invitation created but email could not be sent. You can resend.',
          ),
        ),
      );
      return true;
    }

    changeProps(
      isSending: false,
      createdInvitationId: invitationId,
      sendStatus: res,
    );

    return isSuccess;
  }
}
