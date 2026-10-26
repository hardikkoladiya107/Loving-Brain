import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'invite_pending_state.dart';

/// Cubit managing Invite Pending (Screen 56).
/// Conforms to AGENTS.md Rule 4.2.
class InvitePendingCubit extends Cubit<InvitePendingState> {
  InvitePendingCubit() : super(const InvitePendingState());

  void init({
    String? recipient,
    String? role,
    String? invitationId,
    String? childName,
    int? daysUntilExpiry,
  }) {
    changeProps(
      recipientEmail: recipient ?? '',
      role: role ?? 'Caregiver',
      invitationId: invitationId ?? '',
      childName: childName ?? 'your child',
      daysUntilExpiry: daysUntilExpiry ?? 14,
      isCancelled: false,
      isResending: false,
      actionStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    String? recipientEmail,
    String? role,
    String? invitationId,
    String? childName,
    int? daysUntilExpiry,
    List<String>? sharedCategories,
    bool? isResending,
    bool? isCancelled,
    ApiResultStatus? actionStatus,
  }) {
    emit(
      state.copyWith(
        recipientEmail: recipientEmail ?? state.recipientEmail,
        role: role ?? state.role,
        invitationId: invitationId ?? state.invitationId,
        childName: childName ?? state.childName,
        daysUntilExpiry: daysUntilExpiry ?? state.daysUntilExpiry,
        sharedCategories: sharedCategories ?? state.sharedCategories,
        isResending: isResending ?? state.isResending,
        isCancelled: isCancelled ?? state.isCancelled,
        actionStatus: actionStatus ?? ApiResultStatus.initial(),
      ),
    );
  }

  Future<void> resendInvite() async {
    changeProps(
      isResending: true,
      actionStatus: const ApiResultStatus.loading(),
    );

    final String recipient = state.recipientEmail.trim();
    final String invId = state.invitationId.trim();

    if (recipient.isNotEmpty && invId.isNotEmpty) {
      final String fromParentName =
          (preferences.getUserModel()?.parentName?.trim().isNotEmpty == true)
          ? preferences.getUserModel()!.parentName!.trim()
          : ((preferences.getUserModel()?.displayName?.trim().isNotEmpty ==
                    true)
                ? preferences.getUserModel()!.displayName!.trim()
                : (preferences.getUserModel()?.email?.split('@').first ??
                      'Your co-parent'));

      await CoParentRepo.instance.sendInvitationEmail(
        toEmail: recipient,
        fromParentName: fromParentName,
        childrenNames: state.childName.isNotEmpty
            ? state.childName
            : 'your child',
        invitationId: invId,
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    changeProps(
      isResending: false,
      daysUntilExpiry: 14,
      actionStatus: const ApiResultStatus.data(data: 'invite_resent'),
    );
  }

  Future<void> cancelInvite() async {
    changeProps(actionStatus: const ApiResultStatus.loading());

    if (state.invitationId.trim().isNotEmpty) {
      await CoParentRepo.instance.cancelInvitation(
        invitationId: state.invitationId.trim(),
      );
    }

    changeProps(
      isCancelled: true,
      actionStatus: const ApiResultStatus.data(data: 'invite_cancelled'),
    );
  }
}
