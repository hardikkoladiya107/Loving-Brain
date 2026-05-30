import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/success_screen/success_screen.dart';
import 'package:go_router/go_router.dart';

class DeepLinkManager {
  DeepLinkManager._internal();

  static final DeepLinkManager _instance = DeepLinkManager._internal();

  static DeepLinkManager get instance => _instance;

  final appLinks = AppLinks();

  StreamSubscription? appLinkStreamSubscription;

  void listenToLinks() {
    appLinkStreamSubscription?.cancel();
    appLinkStreamSubscription = appLinks.uriLinkStream.listen((uri) async {
      await _handleUri(uri);
    });
  }

  void disposeListenToLinks() {
    appLinkStreamSubscription?.cancel();
  }

  // ---------------------------------------------------------------------------
  // Main handler — called both from stream and initial link on cold start
  // ---------------------------------------------------------------------------
  Future<void> _handleUri(Uri uri) async {
    final String path = uri.path.trim();
    if (path.isEmpty || path == '/') return;

    // Extract invitation ID — last segment of the path
    final String invitationId = path.split('/').where((s) => s.isNotEmpty).last;
    if (invitationId.isEmpty) return;

    await _processInvitation(invitationId);
  }

  // ---------------------------------------------------------------------------
  // Core invitation processing logic
  // ---------------------------------------------------------------------------
  Future<void> _processInvitation(String invitationId) async {
    // 1. Fetch the invitation document
    final DocumentSnapshot<Map<String, dynamic>> snap;
    try {
      snap = await CoParentRepo.instance.coParentInvitationCollection
          .doc(invitationId)
          .get();
    } catch (_) {
      _showError('Failed to load invitation. Please try again.');
      return;
    }

    if (!snap.exists || snap.data() == null) {
      _showError('This invitation link is invalid or has expired.');
      return;
    }

    final InvitationModel invitation = InvitationModel.fromJson(snap.data()!);

    // 2. Check invitation status
    if (invitation.status != 'REQUESTED') {
      _showError(
        invitation.status == 'ACCEPTED'
            ? 'This invitation has already been accepted.'
            : 'This invitation link is no longer valid.',
      );
      return;
    }

    final String toEmail = (invitation.toParent ?? '').trim().toLowerCase();
    if (toEmail.isEmpty) {
      _showError('This invitation link is invalid.');
      return;
    }

    // 3. Check if user is currently logged in
    final UserModel? loggedUser = preferences.getUserModel();
    final bool isLoggedIn =
        preferences.getBool(SharedPreference.isLogin) ?? false;

    if (isLoggedIn && loggedUser != null) {
      // ── CASE A: User is logged in ──────────────────────────────────────────
      final String loggedEmail = (loggedUser.email ?? '').trim().toLowerCase();
      if (loggedEmail == toEmail) {
        // Email matches → accept invitation directly
        final ApiResultStatus result =
            await CoParentRepo.instance.addUserAsCoParent(invitationId);
        _showSuccessFromResult(result);
      } else {
        _showError(
          'This invitation was sent to $toEmail. Please log in with that account.',
        );
      }
    } else {
      // ── CASE B: User is NOT logged in ─────────────────────────────────────
      // Check if an account exists for the invited email
      final bool accountExists =
          await AuthRepo.instance.isAccountExistWithEmail(email: toEmail);

      if (accountExists) {
        // Account exists → save pending invitation and navigate to login
        await PendingInvitationManager.save(
          invitationId: invitationId,
          invitationEmail: toEmail,
        );
        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).go(RoutePaths.login);
        }
        _showInfo(
          'Please log in with $toEmail to accept the invitation.',
        );
      } else {
        // No account → navigate to CoParent password-only registration screen
        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).push(
            RoutePaths.coParentRegister,
            extra: {
              'email': toEmail,
              'invitationId': invitationId,
            },
          );
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Success display after invitation accepted
  // ---------------------------------------------------------------------------
  void _showSuccessFromResult(ApiResultStatus result) {
    result.whenOrNull(
      data: (data) async {
        if (data is! InvitationModel) return;
        final InvitationModel invitation = data;

        // Fetch sender name for a personalised message
        UserModel? fromParent;
        try {
          fromParent = await UserRepo.instance.getUserFromEmail(
            email: invitation.fromParent ?? '',
          );
        } catch (_) {}

        // Fetch child names
        final List<String> childIds = (invitation.children ?? '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        String childDisplayName = 'your child';
        try {
          final ApiResultStatus childResult =
              await ChildRepo.instance.getChildren(childrenIds: childIds);
          childResult.whenOrNull(
            data: (childData) {
              if (childData is List<ChildModel> && childData.isNotEmpty) {
                childDisplayName = childData
                    .map((c) => c.childName ?? '')
                    .where((n) => n.isNotEmpty)
                    .join(' & ');
              }
            },
          );
        } catch (_) {}

        final String senderName =
            fromParent?.parentName ?? fromParent?.displayName ?? 'Your co-parent';

        final String message =
            "You've successfully accepted $senderName's invitation to be a co-parent of $childDisplayName.";

        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => SucessScreen(successText: message),
            ),
          );
        }
      },
      error: (error) {
        _showError(error.toString().replaceAll('Exception: ', ''));
      },
    );
  }

  void _showError(String message) {
    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      showSnackBar(message: message, type: SnackBarType.ERROR);
    }
  }

  void _showInfo(String message) {
    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      showSnackBar(message: message, type: SnackBarType.SUCCESS);
    }
  }
}
