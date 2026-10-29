import 'dart:convert';

import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreference preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const user = "user";
  static const child = "child";
  static const isLogin = "isLogin";

  static const notificationPermissionRequested =
      "notificationPermissionRequested";
  static const energyBridgeStartTime = "energyBridgeStartTime";
  static const isHighEnergyActive = "isHighEnergyActive";
  static const pendingInvitationId = "pendingInvitationId";
  static const pendingInvitationEmail = "pendingInvitationEmail";
  static const energyBridgeExplainerSeen = "energyBridgeExplainerSeen";
  static const isFamilyConsentGranted = "isFamilyConsentGranted";
  static const micExplainerSeen = "micExplainerSeen";

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences == null
        ? defValue
        : _preferences!.getBool(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setBool(key, value);
    }
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null
        ? defValue
        : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putString(String key, String value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setString(key, value);
    }
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getInt(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setInt(key, value);
    }
  }

  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  Future<bool?> putStringList(String key, List<String> value) async {
    return _preferences?.setStringList(key, value);
  }

  Future<bool?> saveCaregiverPermissions(Map<String, dynamic> map) async {
    final String email = (map['caregiver_email'] ?? map['caregiverEmail'] ?? '')
        .toString();
    if (email.isEmpty) return null;
    return putString('caregiver_permissions_$email', json.encode(map));
  }

  Map<String, dynamic>? getCaregiverPermissions(String email) {
    final String? str = getString('caregiver_permissions_$email');
    if (str == null || str.isEmpty) return null;
    try {
      return json.decode(str) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<bool?> saveUserModel(UserModel value) async {
    try {
      if (_preferences == null) {
        return null;
      } else {
        return await _preferences!.setString(
          user,
          json.encode(value.toJson(forConvert: true)),
        );
      }
    } catch (e) {
      return null;
    }
  }

  UserModel? getUserModel() {
    try {
      if (_preferences == null) {
        return null;
      } else {
        return UserModel.fromJson(
          json.decode(_preferences!.getString(user)!),
          fromConvert: true,
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool?> saveChildModel(ChildModel value) async {
    try {
      if (_preferences == null) {
        return null;
      } else {
        return await _preferences!.setString(
          child,
          json.encode(value.toJson(forConvert: true)),
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool?> saveDefaultChildModel(ChildModel value) =>
      saveChildModel(value);

  ChildModel? getChildModel() {
    try {
      if (_preferences == null) {
        return null;
      } else {
        final String? str = _preferences?.getString(child);
        if (str == null) return null;
        return ChildModel.fromJson(json.decode(str));
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> clearChild() async {
    if (_preferences == null) {
      return false;
    }
    return await _preferences?.remove(child) ?? false;
  }

  Future<bool> clearUser() async {
    if (_preferences == null) {
      return false;
    }
    await clearOnboardingDraft();
    await _preferences?.remove(child);
    await _preferences?.remove(notificationPreferencesKey);
    await _preferences?.remove(energyBridgeStartTime);
    await _preferences?.remove(isHighEnergyActive);
    await _preferences?.remove(isFamilyConsentGranted);
    return await _preferences?.remove(user) ?? false;
  }

  Future<bool> clearAll() async {
    if (_preferences == null) {
      return false;
    }
    return await _preferences!.clear();
  }

  static const String notificationPreferencesKey =
      "notification_preferences_v2";

  Future<bool?> saveNotificationPreferences(
    Map<String, dynamic> jsonMap,
  ) async {
    try {
      if (_preferences == null) return null;
      return await _preferences!.setString(
        notificationPreferencesKey,
        json.encode(jsonMap),
      );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getNotificationPreferences() {
    try {
      if (_preferences == null) return null;
      final String? str = _preferences!.getString(notificationPreferencesKey);
      if (str == null || str.isEmpty) return null;
      return json.decode(str) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  static const String onboardingDraftKey = "onboardingDraft";

  String _getOnboardingDraftKey(String? uid) {
    if (uid != null && uid.isNotEmpty) {
      return "${onboardingDraftKey}_$uid";
    }
    return onboardingDraftKey;
  }

  Future<bool?> saveOnboardingDraft(
    Map<String, dynamic> draft, {
    String? uid,
  }) async {
    try {
      final String? targetUid = uid ?? draft['uid'] as String?;
      final String key = _getOnboardingDraftKey(targetUid);
      return await putString(key, json.encode(draft));
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getOnboardingDraft({String? uid}) {
    try {
      if (_preferences == null) return null;
      if (uid != null && uid.isNotEmpty) {
        final String? userScoped = _preferences!.getString(
          "${onboardingDraftKey}_$uid",
        );
        if (userScoped != null && userScoped.isNotEmpty) {
          final Map<String, dynamic>? decoded =
              json.decode(userScoped) as Map<String, dynamic>?;
          return decoded;
        }
      }
      final String? str = _preferences!.getString(onboardingDraftKey);
      if (str == null || str.isEmpty) return null;
      final Map<String, dynamic>? decoded =
          json.decode(str) as Map<String, dynamic>?;
      if (decoded != null) {
        final String? draftUid = decoded['uid'] as String?;
        if (draftUid != null && uid != null && draftUid != uid) {
          _preferences!.remove(onboardingDraftKey);
          return null;
        }
      }
      return decoded;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearOnboardingDraft({String? uid}) async {
    try {
      if (_preferences != null) {
        await _preferences!.remove(onboardingDraftKey);
        if (uid != null && uid.isNotEmpty) {
          await _preferences!.remove("${onboardingDraftKey}_$uid");
        }
        final Set<String> keys = _preferences!.getKeys();
        for (final String key in keys) {
          if (key.startsWith("${onboardingDraftKey}_")) {
            await _preferences!.remove(key);
          }
        }
      }
    } catch (_) {}
  }
}
