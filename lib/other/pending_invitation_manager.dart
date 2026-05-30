import 'package:loving_brain/other/preferances.dart';

/// Manages a pending co-parent invitation that arrives via deep link
/// when the user is not yet logged in or has no account.
class PendingInvitationManager {
  PendingInvitationManager._();

  /// Saves a pending invitation so it can be processed after login/register.
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
      invitationEmail,
    );
  }

  /// Returns the stored pending invitation ID, or empty string if none.
  static String getId() {
    return preferences.getString(SharedPreference.pendingInvitationId) ?? '';
  }

  /// Returns the stored pending invitation email, or empty string if none.
  static String getEmail() {
    return preferences.getString(SharedPreference.pendingInvitationEmail) ?? '';
  }

  /// Returns true if there is a pending invitation waiting to be processed.
  static bool hasPending() {
    return getId().isNotEmpty;
  }

  /// Clears the stored pending invitation after it has been processed.
  static Future<void> clear() async {
    await preferences.putString(SharedPreference.pendingInvitationId, '');
    await preferences.putString(SharedPreference.pendingInvitationEmail, '');
  }
}
