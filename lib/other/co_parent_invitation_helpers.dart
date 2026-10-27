/// Pure helpers for the co-parent invitation flow (send, deep link, accept).
///
/// Kept free of Firebase/UI so logic can be unit-tested without mocks.
class CoParentInvitationHelpers {
  CoParentInvitationHelpers._();

  /// Firestore status while waiting for the invited co-parent to accept.
  static const String statusRequested = 'REQUESTED';

  /// Firestore status after the co-parent successfully accepts.
  static const String statusAccepted = 'ACCEPTED';

  /// Base URL embedded in invitation emails (must match Android manifest + iOS entitlements).
  static const String invitationBaseUrl = 'https://www.lovingbrain.com';

  /// Google Play Store URL for Loving Brain.
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.app.loving_brain';

  /// Apple App Store URL for Loving Brain.
  static const String appStoreUrl =
      'https://apps.apple.com/app/loving-brain/id6470000000';

  /// Builds the universal link sent in the invitation email.
  static String buildInvitationLink(String invitationId) {
    final String id = invitationId.trim();
    return '$invitationBaseUrl/$id';
  }

  /// Builds the custom scheme link for direct app launch (`lovingbrain://invite/{id}`).
  static String buildCustomSchemeInvitationLink(String invitationId) {
    final String id = invitationId.trim();
    return 'lovingbrain://invite/$id';
  }

  /// Normalizes emails for comparison (trim + lowercase).
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// Returns true when both emails refer to the same account.
  static bool emailsMatch(String emailA, String emailB) {
    return normalizeEmail(emailA) == normalizeEmail(emailB);
  }

  /// Extracts the Firestore invitation document id from any invitation URI.
  ///
  /// Supports:
  /// - Universal links: `https://www.lovingbrain.com/abc123` → `abc123`
  /// - Without www: `https://lovingbrain.com/abc123/` → `abc123`
  /// - Explicit path: `https://www.lovingbrain.com/invite/abc123` → `abc123`
  /// - Query parameter: `https://www.lovingbrain.com/invite.html?id=abc123` → `abc123`
  /// - Custom scheme with path: `lovingbrain://invite/abc123` → `abc123`
  /// - Custom scheme direct: `lovingbrain://abc123` → `abc123`
  static String? parseInvitationIdFromUri(Uri uri) {
    // 1. Check query parameter `id` or `invitationId`
    final String? queryId =
        uri.queryParameters['id'] ?? uri.queryParameters['invitationId'];
    if (queryId != null && queryId.trim().isNotEmpty) {
      return queryId.trim();
    }

    // 2. Check path segments (e.g. /abc123 or /invite/abc123)
    final List<String> segments = uri.pathSegments
        .where((String segment) => segment.trim().isNotEmpty)
        .toList();
    if (segments.isNotEmpty) {
      final String candidate = segments.last.trim();
      if (candidate.isNotEmpty &&
          candidate != 'invite' &&
          candidate != 'invite.html') {
        return candidate;
      }
    }

    // 3. Fallback for custom schemes where host is the id: lovingbrain://abc123
    if (uri.scheme == 'lovingbrain' &&
        uri.host.isNotEmpty &&
        uri.host != 'invite') {
      return uri.host.trim();
    }

    return null;
  }

  /// Parses comma-separated child document ids stored on the invitation.
  static List<String> parseChildIdsFromCsv(String? childrenCsv) {
    if (childrenCsv == null || childrenCsv.trim().isEmpty) {
      return <String>[];
    }
    return childrenCsv
        .split(',')
        .map((String id) => id.trim())
        .where((String id) => id.isNotEmpty)
        .toList();
  }

  /// Builds the comma-separated child id string stored on invitations.
  static String buildChildrenCsv(Iterable<String> childIds) {
    return childIds
        .map((String id) => id.trim())
        .where((String id) => id.isNotEmpty)
        .join(',');
  }

  /// Validates whether the current user may accept an invitation.
  ///
  /// Returns a [LocaleKeys] string name when invalid, or `null` when valid.
  static String? validateInvitationForAccept({
    required String? invitedEmail,
    required String? loggedInEmail,
    required String? invitationStatus,
  }) {
    final String invited = normalizeEmail(invitedEmail ?? '');
    final String loggedIn = normalizeEmail(loggedInEmail ?? '');

    if (invited.isEmpty) {
      return 'deepLinkInvitationInvalidEmail';
    }
    if (loggedIn.isEmpty || loggedIn != invited) {
      return 'thisInvitationIsNotForYou';
    }
    if (invitationStatus != statusRequested) {
      return 'invitationAlreadyUsed';
    }
    return null;
  }

  /// Toggles a child in the multi-select list (matched by Firestore document id).
  static List<T> toggleChildSelection<T>({
    required List<T> selected,
    required T child,
    required String? Function(T item) idForItem,
  }) {
    final String? childId = idForItem(child);
    final List<T> updated = List<T>.from(selected);
    if (updated.any((T item) => idForItem(item) == childId)) {
      updated.removeWhere((T item) => idForItem(item) == childId);
    } else {
      updated.add(child);
    }
    return updated;
  }

  /// Validates the send-invite form before creating a Firestore invitation.
  static InviteFormValidationResult validateSendInviteForm({
    required String toEmail,
    required String fromEmail,
    required int selectedChildrenCount,
    required bool Function(String email) isValidEmailFormat,
  }) {
    final String trimmedTo = toEmail.trim();
    final String trimmedFrom = fromEmail.trim();

    if (selectedChildrenCount == 0) {
      return InviteFormValidationResult(
        isValid: false,
        selectChildrenErrorKey: 'pleaseSelectChild',
        coParentEmailErrorKey: trimmedTo.isEmpty
            ? 'pleaseEnterCoParentEmail'
            : '',
      );
    }

    if (trimmedTo.isEmpty) {
      return const InviteFormValidationResult(
        isValid: false,
        coParentEmailErrorKey: 'pleaseEnterCoParentEmail',
      );
    }

    if (!isValidEmailFormat(trimmedTo)) {
      return const InviteFormValidationResult(
        isValid: false,
        coParentEmailErrorKey: 'pleaseEnterValidEmail',
      );
    }

    if (trimmedFrom.isNotEmpty &&
        normalizeEmail(trimmedFrom) == normalizeEmail(trimmedTo)) {
      return const InviteFormValidationResult(
        isValid: false,
        coParentEmailErrorKey: 'cannotInviteYourself',
      );
    }

    return const InviteFormValidationResult(isValid: true);
  }
}

/// Result of validating the link-co-parent send form.
class InviteFormValidationResult {
  const InviteFormValidationResult({
    required this.isValid,
    this.coParentEmailErrorKey = '',
    this.selectChildrenErrorKey = '',
  });

  final bool isValid;

  /// LocaleKeys field name for co-parent email field error (empty = no error).
  final String coParentEmailErrorKey;

  /// LocaleKeys field name for children selection error (empty = no error).
  final String selectChildrenErrorKey;
}
