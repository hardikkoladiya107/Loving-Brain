import 'dart:convert';

import 'package:loving_brain/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const user = "user";
  static const isLogin = "isLogin";
  static const hasSeenOnboarding = "hasSeenOnboarding";
  static const energyBridgeStartTime = "energyBridgeStartTime";
  static const isHighEnergyActive = "isHighEnergyActive";

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

  Future<bool?> saveUserModel(UserModel value) async {
    try {
      if (_preferences == null) {
        return null;
      } else {
        return _preferences!.setString(
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

  Future<bool> clearUser() async {
    if (_preferences == null) {
      return false;
    }
    return await _preferences?.remove(user) ?? false;
  }
}
