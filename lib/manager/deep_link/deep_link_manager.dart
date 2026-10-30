import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/pending_invitation_manager.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/co_parent_repo.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:go_router/go_router.dart';

/// Handles universal links for co-parent invitations.
///
/// Call [init] once at app startup (see `main.dart`) so cold-start links are not lost.
class DeepLinkManager {
  DeepLinkManager._internal();

  static final DeepLinkManager _instance = DeepLinkManager._internal();

  static DeepLinkManager get instance => _instance;

  final AppLinks appLinks = AppLinks();

  StreamSubscription<Uri>? _appLinkStreamSubscription;

  Future<void> init() async {
    await _handleInitialLink();
    listenToLinks();
  }

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

  void listenToLinks() {
    _appLinkStreamSubscription?.cancel();
    _appLinkStreamSubscription = appLinks.uriLinkStream.listen(
      (Uri uri) async {
        await _handleUri(uri);
      },
      onError: (_) {
        _appLinkStreamSubscription?.cancel();
        _appLinkStreamSubscription = null;
      },
      cancelOnError: true,
    );
  }

  void disposeListenToLinks() {
    _appLinkStreamSubscription?.cancel();
  }

  Future<void> _handleUri(Uri uri) async {
    final String? invitationId =
        CoParentInvitationHelpers.parseInvitationIdFromUri(uri);
    if (invitationId == null) {
      return;
    }
    await _processInvitation(invitationId);
  }

  Future<void> _processInvitation(String invitationId) async {
    final ApiResultStatus previewResult = await CoParentRepo.instance
        .getInvitationPreview(invitationId: invitationId);

    String invitedEmail = '';
    bool previewOk = false;
    previewResult.whenOrNull(
      data: (dynamic data) {
        if (data is Map) {
          previewOk = true;
          invitedEmail = (data['toParent']?.toString() ?? '').trim();
          if (invitedEmail.isEmpty) {
            invitedEmail = (data['invitedEmailMasked']?.toString() ?? '')
                .trim();
          }
        }
      },
      error: (Exception error) {
        _showError(error.toString().replaceAll('Exception: ', ''));
      },
    );
    if (!previewOk) {
      return;
    }

    final UserModel? loggedUser = preferences.getUserModel();
    final bool isLoggedIn =
        (preferences.getBool(SharedPreference.isLogin) ?? false) &&
        (loggedUser?.uid?.trim().isNotEmpty ?? false);

    if (isLoggedIn && loggedUser != null) {
      final String loggedEmail = CoParentInvitationHelpers.normalizeEmail(
        loggedUser.email ?? '',
      );
      final String toEmail = CoParentInvitationHelpers.normalizeEmail(
        invitedEmail,
      );
      if (toEmail.isNotEmpty &&
          loggedEmail.isNotEmpty &&
          loggedEmail != toEmail &&
          !toEmail.contains('*')) {
        _showError(
          LocaleKeys.deepLinkWrongAccount.tr(
            namedArgs: <String, String>{'email': invitedEmail},
          ),
        );
        return;
      }
      await PendingInvitationManager.save(
        invitationId: invitationId,
        invitationEmail: loggedEmail.isNotEmpty ? loggedEmail : invitedEmail,
      );
      final BuildContext? ctx = navigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        GoRouter.of(ctx).push(
          RoutePaths.inviteRespond,
          extra: <String, dynamic>{'invitationId': invitationId},
        );
      }
      return;
    }

    await PendingInvitationManager.save(
      invitationId: invitationId,
      invitationEmail: CoParentInvitationHelpers.normalizeEmail(invitedEmail),
    );

    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      GoRouter.of(ctx).go(RoutePaths.register);
    }
    _showInfo(
      LocaleKeys.deepLinkPleaseLoginWithEmail.tr(
        namedArgs: <String, String>{'email': invitedEmail},
      ),
    );
  }

  void _showError(String message) {
    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      showSnackBar(message: message, type: SnackBarType.ERROR);
      final UserModel? loggedUser = preferences.getUserModel();
      final bool isLoggedIn =
          (preferences.getBool(SharedPreference.isLogin) ?? false) &&
          (loggedUser?.uid?.trim().isNotEmpty ?? false);
      if (!isLoggedIn) {
        GoRouter.of(ctx).go(RoutePaths.welcome);
      }
    }
  }

  void _showInfo(String message) {
    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      showSnackBar(message: message, type: SnackBarType.SUCCESS);
    }
  }
}
