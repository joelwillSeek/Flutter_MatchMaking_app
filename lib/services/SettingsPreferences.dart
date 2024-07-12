import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  static const String _Tmode = 'switch_preference';
  static const String _notificationKey = 'notification_preference';

  // Default values for preferences
  static const bool _defaultSwitchValue = false;
  static const bool _defaultNotificationValue = true;

  // Method to update switch preference
  static Future<void> updateSwitchPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("updated value = $value");
    await prefs.setBool(_Tmode, value);
  }

  // Method to update notification preference
  static Future<void> updateNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, value);
  }

  // Method to read switch preference
  static Future<bool> readSwitchPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_Tmode) ?? _defaultSwitchValue;
  }

  // Method to read notification preference
  static Future<bool> readNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? _defaultNotificationValue;
  }
}
