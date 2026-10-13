import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'invite_caregiver_state.dart';

/// Cubit managing Invite a Caregiver (Screen 55).
/// Conforms to AGENTS.md Rule 4.2.
class InviteCaregiverCubit extends Cubit<InviteCaregiverState> {
  InviteCaregiverCubit() : super(const InviteCaregiverState());

  void init() {
    final ChildModel? child = preferences.getChildModel();
    final String cName =
        (child?.childName != null && child!.childName!.trim().isNotEmpty)
        ? child.childName!.trim()
        : 'your child';

    changeProps(
      childName: cName,
      selectedRole: 'Grandparent',
      emailOrPhone: '',
      isSending: false,
      sendStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    String? selectedRole,
    String? childName,
    String? emailOrPhone,
    bool? isSending,
    ApiResultStatus? sendStatus,
  }) {
    emit(
      state.copyWith(
        selectedRole: selectedRole ?? state.selectedRole,
        childName: childName ?? state.childName,
        emailOrPhone: emailOrPhone ?? state.emailOrPhone,
        isSending: isSending ?? state.isSending,
        sendStatus: sendStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  void selectRole(String role) => changeProps(selectedRole: role);
  void updateEmailOrPhone(String val) => changeProps(emailOrPhone: val);

  Future<bool> sendInvite() async {
    final String cleanRecipient = state.emailOrPhone.trim();
    if (cleanRecipient.isEmpty) {
      changeProps(
        sendStatus: ApiResultStatus.error(
          error: Exception('Please enter an email or phone number'),
        ),
      );
      return false;
    }

    changeProps(
      isSending: true,
      sendStatus: const ApiResultStatus.loading(),
    );

    final String fromEmail = preferences.getUserModel()?.email ?? 'parent@lovingbrain.com';
    final String childId = preferences.getChildModel()?.reference?.id ?? 'child_local';

    final Map<String, dynamic> request = <String, dynamic>{
      'from_parent': fromEmail,
      'to_parent': cleanRecipient,
      'role': state.selectedRole,
      'children': childId,
      'status': 'PENDING',
      'created_at': DateTime.now().toIso8601String(),
      'expires_at': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
    };

    final ApiResultStatus res = await CoParentRepo.instance.createInvitation(request: request);

    bool isSuccess = false;
    res.whenOrNull(
      data: (_) => isSuccess = true,
      error: (_) => isSuccess = false,
    );

    changeProps(
      isSending: false,
      sendStatus: res,
    );

    return isSuccess;
  }
}
