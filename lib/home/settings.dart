import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/newFeature/security.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fire/manager/ThemeProvider.dart';
// import 'package:fire/services/SettingsPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final uri = Uri.parse("https://t.me/HabeshalyHelpBot");
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  void closeApp() {
    SystemNavigator.pop();
    exit(0);
  }

  Future<void> initSettings() async {
    await Settings.init(cacheProvider: SharePreferenceCache());
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    firestore.CollectionReference chatFriendCollection =
        firestore.FirebaseFirestore.instance.collection('Chat_Friend');
    if (user == null) {
      return;
    }
    final userId = user.uid;

    setState(() {
      _isLoading = true;
    });

    try {
      await firestore.FirebaseFirestore.instance
          .collection('f_user')
          .doc(userId)
          .delete();

      final chatFriendsQuery = await firestore.FirebaseFirestore.instance
          .collection('Chat_Friend')
          .where('Chat_FriendID', isEqualTo: userId)
          .get();

      for (var doc in chatFriendsQuery.docs) {
        await doc.reference.delete();
      }

      firestore.QuerySnapshot querySnapshot1 = await chatFriendCollection
          .where('Chat_FriendID', isEqualTo: userId)
          .get();

      firestore.QuerySnapshot querySnapshot2 = await chatFriendCollection
          .where('current_userID', isEqualTo: userId)
          .get();

      List<firestore.QueryDocumentSnapshot> allDocuments = [];
      allDocuments.addAll(querySnapshot1.docs);
      allDocuments.addAll(querySnapshot2.docs);

      final uniqueDocuments = allDocuments.toSet().toList();

      for (firestore.QueryDocumentSnapshot doc in uniqueDocuments) {
        await doc.reference.delete();
      }

      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');
      await storageRef.delete();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await user.delete();

      await FirebaseAuth.instance.signOut();

      closeApp();
    } catch (e) {
      print('Error deleting user account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Something went wrong, unable to delete the account')),
      );
      closeApp();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    // print("is darkmode= ${settingsProvider.isDarkMode}");
    return Scaffold(
      body: SettingsScreen(
        children: [
          SettingsGroup(
            title: 'Privacy & Security',
            children: [
              SimpleSettingsTile(
                title: 'Password Change',
                subtitle: 'Manage your password settings',
                leading: Icon(Icons.key),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Security()));
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Notifications',
            children: [
              SwitchSettingsTile(
                leading: settingsProvider.notificationsEnabled
                    ? Icon(Icons.notification_add_sharp)
                    : Icon(Icons.notification_add_outlined),
                title: 'Update Notification',
                settingKey: 'notficationEnabled',
                defaultValue: settingsProvider.notificationsEnabled,
                onChange: (value) {
                  settingsProvider.setNotificationsEnabled(value);
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Account',
            children: [
              SimpleSettingsTile(
                title: 'Delete Account',
                leading: Icon(Icons.delete),
                onTap: () async {
                  bool? confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Account😭'),
                        content: Text(
                            'Are you sure you want to do this? You may not be able to recover some of your data.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    await deleteUserAccount(context);
                  }
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Appearance',
            children: [
              SwitchSettingsTile(
                leading: Icon(Icons.dark_mode),
                title: 'Dark Mode',
                settingKey: 'dark_mode',
                defaultValue: settingsProvider.isDarkMode,
                onChange: (value) {
                  settingsProvider.setDarkMode(value);
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Information',
            children: [
              SimpleSettingsTile(
                title: 'About',
                leading: Icon(Icons.info),
                onTap: () async {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Telegram not found'),
                      ),
                    );
                  }
                },
              ),
              SimpleSettingsTile(
                title: 'Help',
                leading: Icon(Icons.help),
                onTap: () async {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Telegram not found'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
