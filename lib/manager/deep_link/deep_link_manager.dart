import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/invitation_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/auth_repo.dart';
import 'package:loving_brain/repo/child_repo.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:go_router/go_router.dart';

/// Handles universal links for co-parent invitations (`https://www.lovingbrain.com/{id}`).
///
/// Call [init] once at app startup (see `main.dart`) so cold-start links are not lost.
class DeepLinkManager {
  DeepLinkManager._internal();

  static final DeepLinkManager _instance = DeepLinkManager._internal();

  static DeepLinkManager get instance => _instance;

  final AppLinks appLinks = AppLinks();

  StreamSubscription<Uri>? _appLinkStreamSubscription;

  /// Starts listening for invitation links (foreground + cold start).
  Future<void> init() async {
    await _handleInitialLink();
    listenToLinks();
  }

  /// Processes the link that opened the app from a terminated state.
  Future<void> _handleInitialLink() async {
    try {
      final Uri? initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleUri(initialUri);
      }
    } catch (_) {
      // Non-fatal — stream listener still handles links while app is running.
    }
  }

  /// Subscribes to links received while the app is already running.
  void listenToLinks() {
    _appLinkStreamSubscription?.cancel();
    _appLinkStreamSubscription = appLinks.uriLinkStream.listen((Uri uri) async {
      await _handleUri(uri);
    });
  }

  void disposeListenToLinks() {
    _appLinkStreamSubscription?.cancel();
  }

  /// Parses the invitation id from the URL path and runs accept / login / register routing.
  Future<void> _handleUri(Uri uri) async {
    final String? invitationId =
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri);
    if (invitationId == null) {
      return;
    }
    await _processInvitation(invitationId);
  }

  /// Loads the invitation from Firestore and routes based on auth state.
  Future<void> _processInvitation(String invitationId) async {
    // 1. Fetch invitation document.
    final DocumentSnapshot<Map<String, dynamic>> snap;
    try {
      snap = await CoParentRepo.instance.coParentInvitationCollection
          .doc(invitationId)
          .get();
    } catch (_) {
      _showError(LocaleKeys.deepLinkLoadFailed.tr());
      return;
    }

    if (!snap.exists || snap.data() == null) {
      _showError(LocaleKeys.deepLinkInvitationInvalid.tr());
      return;
    }

    final InvitationModel invitation = InvitationModel.fromJson(snap.data()!);

    // 2. Invitation must still be pending.
    if (invitation.status != CoParentInvitationHelpers.statusRequested) {
      _showError(
        invitation.status == CoParentInvitationHelpers.statusAccepted
            ? LocaleKeys.deepLinkInvitationAlreadyAccepted.tr()
            : LocaleKeys.deepLinkInvitationNoLongerValid.tr(),
      );
      return;
    }

    final String toEmail = CoParentInvitationHelpers.normalizeEmail(
      invitation.toParent ?? '',
    );
    if (toEmail.isEmpty) {
      _showError(LocaleKeys.deepLinkInvitationInvalidEmail.tr());
      return;
    }

    // 3. Branch on whether someone is already logged in.
    final UserModel? loggedUser = preferences.getUserModel();
    final bool isLoggedIn =
        preferences.getBool(SharedPreference.isLogin) ?? false;

    if (isLoggedIn && loggedUser != null) {
      final String loggedEmail = CoParentInvitationHelpers.normalizeEmail(
        loggedUser.email ?? '',
      );
      if (loggedEmail == toEmail) {
        // Logged in with the invited email → accept immediately.
        final ApiResultStatus result = await CoParentRepo.instance
            .addUserAsCoParent(invitationId);
        _showSuccessFromResult(result);
      } else {
        _showError(
          LocaleKeys.deepLinkWrongAccount.tr(
            namedArgs: <String, String>{
              'email': invitation.toParent ?? toEmail,
            },
          ),
        );
      }
    } else {
      // Not logged in — send to login or lightweight co-parent registration.
      final bool accountExists = await AuthRepo.instance
          .isAccountExistWithEmail(email: toEmail);

      if (accountExists) {
        await PendingInvitationManager.save(
          invitationId: invitationId,
          invitationEmail: toEmail,
        );
        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).go(RoutePaths.login);
        }
        _showInfo(
          LocaleKeys.deepLinkPleaseLoginWithEmail.tr(
            namedArgs: <String, String>{'email': toEmail},
          ),
        );
      } else {
        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).push(
            RoutePaths.coParentRegister,
            extra: <String, String>{
              'email': toEmail,
              'invitationId': invitationId,
            },
          );
        }
      }
    }
  }

  /// Navigates to the success screen after a deep-link accept.
  void _showSuccessFromResult(ApiResultStatus result) {
    result.whenOrNull(
      data: (data) async {
        if (data is! InvitationModel) {
          return;
        }
        final InvitationModel invitation = data;

        UserModel? fromParent;
        try {
          fromParent = await UserRepo.instance.getUserFromEmail(
            email: invitation.fromParent ?? '',
          );
        } catch (_) {}

        final List<String> childIds =
            CoParentInvitationHelpers.parseChildIdsFromCsv(invitation.children);

        String childDisplayName = LocaleKeys.yourChild.tr();
        try {
          final ApiResultStatus childResult = await ChildRepo.instance
              .getChildren(childrenIds: childIds);
          childResult.whenOrNull(
            data: (childData) {
              if (childData is List<ChildModel> && childData.isNotEmpty) {
                childDisplayName = childData
                    .map((ChildModel c) => c.childName ?? '')
                    .where((String n) => n.isNotEmpty)
                    .join(' & ');
              }
            },
          );
        } catch (_) {}

        final String senderName =
            fromParent?.parentName ??
            fromParent?.displayName ??
            LocaleKeys.yourCoParent.tr();

        final String message = LocaleKeys.coParentInvitationAcceptedMessage.tr(
          namedArgs: <String, String>{
            'senderName': senderName,
            'childName': childDisplayName,
          },
        );

        final BuildContext? ctx = navigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).push(RoutePaths.successScreen, extra: message);
        }
      },
      error: (Exception error) {
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
