import 'package:loving_brain/other/preferances.dart';

/// Persists a co-parent invitation id when the user opens an invite link while logged out.
///
/// [DeepLinkManager] saves the invitation before navigating to login.
/// [RegisterScreen], [LoginScreen], and [OtpScreen] read/clear it after accept succeeds.
class PendingInvitationManager {
  PendingInvitationManager._();

  /// Stores invitation id + invited email in SharedPreferences for post-login accept.
  ///
  /// A privacy-masked address such as `u***@yopmail.com` is not a real email,
  /// so it is stored as empty and never used to prefill login or signup.
  static Future<void> save({
    required String invitationId,
    required String invitationEmail,
  }) async {
    await preferences.putString(
      SharedPreference.pendingInvitationId,
      invitationId,
    );
    await preferences.putString(
      SharedPreference.pendingInvitationEmail,
      _usableEmail(invitationEmail),
    );
  }

  static String getId() {
    return preferences.getString(SharedPreference.pendingInvitationId) ?? '';
  }

  static String getEmail() {
    final String stored =
        preferences.getString(SharedPreference.pendingInvitationEmail) ?? '';
    return _usableEmail(stored);
  }

  /// Drops masked preview addresses so they cannot be typed into a form.
  static String _usableEmail(String email) {
    final String trimmed = email.trim();
    if (trimmed.contains('*')) {
      return '';
    }
    return trimmed;
  }

  static bool hasPending() {
    return getId().isNotEmpty;
  }

  /// True when [loggedEmail] matches the stored invitation email.
  static bool matchesEmail(String loggedEmail) {
    final String pendingEmail = getEmail().trim().toLowerCase();
    final String normalizedLoggedEmail = loggedEmail.trim().toLowerCase();
    return pendingEmail.isNotEmpty &&
        normalizedLoggedEmail.isNotEmpty &&
        pendingEmail == normalizedLoggedEmail;
  }

  /// Clears stored invitation after successful accept.
  static Future<void> clear() async {
    await preferences.putString(SharedPreference.pendingInvitationId, '');
    await preferences.putString(SharedPreference.pendingInvitationEmail, '');
  }
}
