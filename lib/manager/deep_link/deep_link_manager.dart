import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
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
  OverlayEntry? _fetchingEntry;
  bool _isHandlingInvitation = false;
  String? _activeInvitationId;
  String? _lastHandledInvitationId;
  DateTime? _lastHandledAt;

  bool get isHandlingInvitation => _isHandlingInvitation;

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
    if (_activeInvitationId == invitationId) {
      return;
    }
    final DateTime now = DateTime.now();
    if (_lastHandledInvitationId == invitationId &&
        _lastHandledAt != null &&
        now.difference(_lastHandledAt!) < const Duration(seconds: 3)) {
      return;
    }
    _activeInvitationId = invitationId;
    _isHandlingInvitation = true;
    _showFetchingInvitation();
    try {
      await _openInvitation(invitationId);
    } finally {
      _finishHandling(invitationId);
    }
  }

  Future<void> _openInvitation(String invitationId) async {
    final ApiResultStatus previewResult;
    try {
      previewResult = await CoParentRepo.instance.getInvitationPreview(
        invitationId: invitationId,
      );
    } catch (_) {
      _showError(LocaleKeys.deepLinkLoadFailed.tr());
      return;
    }

    String invitedEmail = '';
    String maskedEmail = '';
    String inviteStatus = '';
    String expiresAt = '';
    bool previewOk = false;
    previewResult.whenOrNull(
      data: (dynamic data) {
        if (data is Map) {
          previewOk = true;
          invitedEmail = (data['toParent']?.toString() ?? '').trim();
          maskedEmail = (data['invitedEmailMasked']?.toString() ?? '').trim();
          inviteStatus = (data['status']?.toString() ?? '').trim();
          expiresAt = (data['expiresAt']?.toString() ?? '').trim();
        }
      },
      error: (Exception error) {
        _showError(error.toString().replaceAll('Exception: ', ''));
      },
    );
    if (!previewOk) {
      return;
    }

    if (CoParentInvitationHelpers.isInvitationClosed(
      status: inviteStatus,
      expiresAt: expiresAt,
    )) {
      await PendingInvitationManager.clear();
      _showError(LocaleKeys.deepLinkInvitationInvalid.tr());
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
    final String messageEmail = invitedEmail.isNotEmpty
        ? invitedEmail
        : maskedEmail;
    _showInfo(
      LocaleKeys.deepLinkPleaseLoginWithEmail.tr(
        namedArgs: <String, String>{'email': messageEmail},
      ),
    );
  }

  void _finishHandling(String invitationId) {
    _hideFetchingInvitation();
    _isHandlingInvitation = false;
    if (_activeInvitationId == invitationId) {
      _activeInvitationId = null;
    }
    _lastHandledInvitationId = invitationId;
    _lastHandledAt = DateTime.now();
  }

  void _showFetchingInvitation() {
    _hideFetchingInvitation();
    final OverlayState? overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isHandlingInvitation || _fetchingEntry != null) {
          return;
        }
        _showFetchingInvitation();
      });
      return;
    }
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) {
        return const _FetchingInvitationMask();
      },
    );
    _fetchingEntry = entry;
    overlay.insert(entry);
  }

  void _hideFetchingInvitation() {
    final OverlayEntry? entry = _fetchingEntry;
    _fetchingEntry = null;
    entry?.remove();
    // Drop any EasyLoading mask left by an earlier invitation open.
    // Do not await: a stuck loader future must not keep this barrier up.
    try {
      unawaited(EasyLoading.dismiss(animation: false));
    } catch (_) {}
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

class _FetchingInvitationMask extends StatelessWidget {
  const _FetchingInvitationMask();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ModalBarrier(dismissible: false, color: Color(0x40000000)),
        Center(
          child: Material(
            color: const Color(0xFFFEF8F4),
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 22.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 36.w,
                    height: 36.w,
                    child: const CircularProgressIndicator(color: primaryColor),
                  ),
                  12.spaceH,
                  LocaleKeys.fetchingInvitation.tr().appText(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: greyColor9,
                    letterSpacing: 0.2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
