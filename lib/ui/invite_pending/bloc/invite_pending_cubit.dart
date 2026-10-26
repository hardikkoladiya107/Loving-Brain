import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loving_brain/model/api_result_status.dart';

import 'invite_pending_state.dart';

/// Cubit managing Invite Pending (Screen 56).
/// Conforms to AGENTS.md Rule 4.2.
class InvitePendingCubit extends Cubit<InvitePendingState> {
  InvitePendingCubit() : super(const InvitePendingState());

  void init({String? recipient, String? role, int? daysUntilExpiry}) {
    changeProps(
      recipientEmail: recipient ?? '',
      role: role ?? 'Caregiver',
      daysUntilExpiry: daysUntilExpiry ?? 14,
      isCancelled: false,
      isResending: false,
      actionStatus: const ApiResultStatus.initial(),
    );
  }

  void changeProps({
    String? recipientEmail,
    String? role,
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

    await Future.delayed(const Duration(milliseconds: 300));

    changeProps(
      isResending: false,
      daysUntilExpiry: 14,
      actionStatus: const ApiResultStatus.data(data: 'invite_resent'),
    );
  }

  Future<void> cancelInvite() async {
    changeProps(
      isCancelled: true,
      actionStatus: const ApiResultStatus.data(data: 'invite_cancelled'),
    );
  }
}
