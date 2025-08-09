import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const unlockedTemplate = "unlockedTemplate";
  static const mobileUniqueCode = "mobile_unique_code";
  static const isDarkMode = "is_dark_mode";

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
}
