import 'package:loving_brain/other/preferances.dart';

/// Persists a co-parent invitation id when the user opens an invite link while logged out.
///
/// [DeepLinkManager] saves the invitation before navigating to login.
/// [LoginScreen] and [CoParentRegisterCubit] read/clear it after accept succeeds.
class PendingInvitationManager {
  PendingInvitationManager._();

  /// Stores invitation id + invited email in SharedPreferences for post-login accept.
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

  static String getId() {
    return preferences.getString(SharedPreference.pendingInvitationId) ?? '';
  }

  static String getEmail() {
    return preferences.getString(SharedPreference.pendingInvitationEmail) ?? '';
  }

  static bool hasPending() {
    return getId().isNotEmpty;
  }

  /// Clears stored invitation after successful accept (or email mismatch on login).
  static Future<void> clear() async {
    await preferences.putString(SharedPreference.pendingInvitationId, '');
    await preferences.putString(SharedPreference.pendingInvitationEmail, '');
  }
}
