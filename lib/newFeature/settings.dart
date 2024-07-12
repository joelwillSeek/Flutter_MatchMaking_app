import 'package:fire/manager/ThemeProvider.dart';
import 'package:fire/services/SettingsPreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final uri = Uri.parse("https://t.me/+9C4Yv_0yzOZmNDZk");
  bool switchValue = false;
  bool notificationValue = true;
  @override
  void initState() {
    super.initState();
    initSettings();
    _loadPreferences();
  }

  void _loadPreferences() async {
    switchValue = await SettingsPreferences.readSwitchPreference();
    notificationValue = await SettingsPreferences.readNotificationPreference();
    setState(() {});
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider
        .setThemeMode(switchValue ? ThemeModeType.Dark : ThemeModeType.Light);
    print(switchValue);
  }

  Future<void> initSettings() async {
    await Settings.init(cacheProvider: SharePreferenceCache());
    setState(() {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider
          .setThemeMode(switchValue ? ThemeModeType.Dark : ThemeModeType.Light);
      print(switchValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SettingsScreen(
        children: [
          SettingsGroup(
            title: 'Privacy & Security',
            children: [
              SimpleSettingsTile(
                title: 'Security',
                subtitle: 'Manage your security settings',
                leading: Icon(Icons.security),
                onTap: () {
                  // Navigate to security settings
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Notifications',
            children: [
              SimpleSettingsTile(
                title: 'Notification Settings',
                leading: Icon(Icons.notifications),
                onTap: () {
                  // Navigate to notification settings
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
                onTap: () {
                  // Show confirmation dialog and delete account
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
                defaultValue: switchValue,
                onChange: (value) async {
                  setState(() {
                    switchValue = value;
                  });
                  // Update switch preference in shared preferences
                  await SettingsPreferences.updateSwitchPreference(value);
                  // Apply theme change
                  themeProvider.setThemeMode(
                      switchValue ? ThemeModeType.Dark : ThemeModeType.Light);
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
                onTap: () {
                  // Navigate to about screen
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
        ],
      ),
    );
  }
}
