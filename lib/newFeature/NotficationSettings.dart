// import 'package:fire/manager/SettingsProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
// import 'package:provider/provider.dart';

// class NotficationSettings extends StatefulWidget {
//   const NotficationSettings({super.key});

//   @override
//   State<NotficationSettings> createState() => _NotficationSettingsState();
// }

// class _NotficationSettingsState extends State<NotficationSettings> {
//   @override
//   void initState() {
//     super.initState();
//     initSettings();
//   }

//   Future<void> initSettings() async {
//     await Settings.init(cacheProvider: SharePreferenceCache());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settingsProvider = Provider.of<SettingsProvider>(context);
//     return Scaffold(
//       body: SettingsScreen(
//         title: "Notification Settings🔔",
//         children: [
//           SettingsGroup(
//             title: 'Notfication',
//             children: [
//               SwitchSettingsTile(
//                 leading: settingsProvider.newMsgNotificationsEnabled
//                     ? Icon(Icons.notification_add_sharp)
//                     : Icon(Icons.notification_add_outlined),
//                 title: 'Message Notification',
//                 settingKey: 'msg_notificationEnabled',
//                 defaultValue: settingsProvider.newMsgNotificationsEnabled,
//                 onChange: (value) {
//                   settingsProvider.setNewMessageNotificationEnabled(value);
//                 },
//               ),
//               SizedBox(height: 10),
//               SwitchSettingsTile(
//                 leading: settingsProvider.notifyMeEnabled
//                     ? Icon(Icons.notification_add_sharp)
//                     : Icon(Icons.notification_add_outlined),
//                 title: 'Request Notification',
//                 settingKey: 'r_notficationEnabled',
//                 defaultValue: settingsProvider.notifyMeEnabled,
//                 onChange: (value) {
//                   settingsProvider.setLikedNotificationEnabled(value);
//                 },
//               ),
//               SizedBox(height: 10),
//               SwitchSettingsTile(
//                 leading: settingsProvider.notificationsEnabled
//                     ? Icon(Icons.notification_add_sharp)
//                     : Icon(Icons.notification_add_outlined),
//                 title: 'Update Notification',
//                 settingKey: 'notficationEnabled',
//                 defaultValue: settingsProvider.notificationsEnabled,
//                 onChange: (value) {
//                   settingsProvider.setNotificationsEnabled(value);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
