import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  SettingsProvider() {
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    notifyListeners();
    print('Preferences loaded: notificationsEnabled: $notificationsEnabled');
  }

  void setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', value);

    await FirebaseFirestore.instance
        .collection('f_user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'notificationsEnabled': value}, SetOptions(merge: true));
    notifyListeners();
  }

  static Future<bool> fetchNotificationsEnabledFromFirestore() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('f_user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return doc['notificationsEnabled'] ?? true;
  }
}
