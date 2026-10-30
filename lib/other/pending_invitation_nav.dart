import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

/// After login/register/OTP, open the respond screen when an invite is pending.
Future<bool> navigateForPendingInvitation({
  required BuildContext context,
  required UserModel userModel,
  required GoRouter router,
}) async {
  String invitationId = '';
  if (PendingInvitationManager.hasPending()) {
    invitationId = PendingInvitationManager.getId();
    final String loggedEmail = (userModel.email ?? '').trim().toLowerCase();
    if (!PendingInvitationManager.matchesEmail(loggedEmail) &&
        PendingInvitationManager.getEmail().isNotEmpty) {
      showSnackBar(
        message: LocaleKeys.coParentInvitationEmailMismatch.tr(),
        type: SnackBarType.ERROR,
      );
      return false;
    }
  } else {
    final String loggedEmail = (userModel.email ?? '').trim().toLowerCase();
    if (loggedEmail.isNotEmpty) {
      invitationId =
          await CoParentRepo.instance.checkPendingInvitationForUser(
            loggedEmail,
          ) ??
          '';
    }
  }

  if (invitationId.trim().isEmpty) {
    return false;
  }

  if (!context.mounted) return false;
  router.go(
    RoutePaths.inviteRespond,
    extra: <String, dynamic>{'invitationId': invitationId.trim()},
  );
  return true;
}
