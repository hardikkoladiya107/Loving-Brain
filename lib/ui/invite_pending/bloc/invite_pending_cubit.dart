import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';

import 'invite_pending_state.dart';

/// Cubit managing Invite Pending (Screen 56).
class InvitePendingCubit extends Cubit<InvitePendingState> {
  InvitePendingCubit() : super(const InvitePendingState());

  void reset() {
    emit(const InvitePendingState());
  }

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

    final String invId = state.invitationId.trim();
    if (invId.isEmpty) {
      changeProps(
        isResending: false,
        actionStatus: ApiResultStatus.error(
          error: Exception('Missing invitation id'),
        ),
      );
      return;
    }

    final ApiResultStatus result = await CoParentRepo.instance
        .sendInvitationEmail(
          toEmail: state.recipientEmail.trim(),
          fromParentName: preferences.getUserModel()?.parentName ?? 'Parent',
          childrenNames: state.childName.isNotEmpty
              ? state.childName
              : 'your child',
          invitationId: invId,
        );

    result.whenOrNull(
      data: (_) {
        changeProps(
          isResending: false,
          daysUntilExpiry: 14,
          actionStatus: const ApiResultStatus.data(data: 'invite_resent'),
        );
      },
      error: (Exception err) {
        changeProps(
          isResending: false,
          actionStatus: ApiResultStatus.error(error: err),
        );
      },
    );
  }

  Future<void> cancelInvite() async {
    changeProps(actionStatus: const ApiResultStatus.loading());

    final String invId = state.invitationId.trim();
    if (invId.isEmpty) {
      changeProps(
        actionStatus: ApiResultStatus.error(
          error: Exception('Missing invitation id'),
        ),
      );
      return;
    }

    final ApiResultStatus result = await CoParentRepo.instance.cancelInvitation(
      invitationId: invId,
    );

    result.whenOrNull(
      data: (_) {
        changeProps(
          isCancelled: true,
          actionStatus: const ApiResultStatus.data(data: 'invite_cancelled'),
        );
      },
      error: (Exception err) {
        changeProps(actionStatus: ApiResultStatus.error(error: err));
      },
    );
  }
}
