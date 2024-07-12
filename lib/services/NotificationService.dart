import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/manager/SettingsProvider.dart';
// import 'package:fire/manager/SettingsProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService() {
    _initializeLocalNotifications();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message data: ${message.data}");
      print("Notification: ${message.notification}");
      handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap
      Map<String, dynamic> data = message.data;
      String? type = data['type'];
      if (type == 'match') {
        //_showMatchNotification(data);
      } else if (type == 'chat') {
        //_showChatNotification(data);
        print("true it was chat");
      } else {
        // Handle other notification types if needed
        // _showDefaultNotification(message);
      }
    });
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void handleNotification(RemoteMessage message) async {
    bool notificationsEnabled =
        await SettingsProvider.fetchNotificationsEnabledFromFirestore();

    print("status in handle = $notificationsEnabled");

    if (notificationsEnabled) {
      Map<String, dynamic> data = message.data;
      String? type = data['type'];
      print("show not called");
      if (type == 'match') {
        _showMatchNotification(data);
      } else if (type == 'chat') {
        _showChatNotification(data);
      } else {
        _showDefaultNotification(message);
      }
    } else {
      print("Notifications are disabled.");
    }
  }

  Future<void> _showMatchNotification(Map<String, dynamic> data) async {
    String title = 'New Match!';
    String body = '${data['matchedUserName']} has matched with you!';
    String imageUrl = data['matchedUserPic'];
    print("show match called");
    Uint8List? bigPicture = await _downloadImage(imageUrl);

    BigPictureStyleInformation? bigPictureStyleInformation;
    if (bigPicture != null) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap(bigPicture),
        largeIcon: ByteArrayAndroidBitmap(bigPicture),
        contentTitle: title,
        summaryText: body,
      );
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'match_channel',
      'Match Notification',
      channelDescription: 'Notifications for new matches',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      data.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: data['route'],
    );
  }

  Future<void> _showChatNotification(Map<String, dynamic> data) async {
    String title = 'New Message! ${data['senderName']}';
    String body = data['messageContent'];
    String imageUrl = data['senderProfilePic'];
    print("show chat called");
    Uint8List? largeIcon = await _downloadImage(imageUrl);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chat_channel',
      'Chat Notification',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: largeIcon != null ? ByteArrayAndroidBitmap(largeIcon) : null,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      data.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: data['route'],
    );
  }

  Future<void> _showDefaultNotification(RemoteMessage message) async {
    String? title = message.notification?.title;
    String? body = message.notification?.body;

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel',
      'Default Notification',
      channelDescription: 'Default notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: message.data['route'],
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Error downloading image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }

  Future<String?> getUserFcmToken(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('f_user')
          .doc(userId)
          .get();
      return userDoc['deviceToken'];
    } catch (e) {
      print('Error getting user FCM token: $e');
      return null;
    }
  }

  Future<void> sendChatNotification(String fcmToken, String senderProfilePic,
      String messageContent, String senderName) async {
    //String? fcmToken = await getUserFcmToken(receiverUserId);
    print("send message called");
    await _sendFcmMessage(fcmToken, {
      'type': 'chat',
      'senderName': senderName,
      'senderProfilePic': senderProfilePic,
      'messageContent': messageContent,
    });
  }

  Future<void> sendMatchNotification(
      String fcmToken, String matchedUserPic, String matchedUserName) async {
    //String? fcmToken = await getUserFcmToken(receiverUserId);
    print("send match not called");
    await _sendFcmMessage(fcmToken, {
      'type': 'match',
      'matchedUserPic': matchedUserPic,
      'matchedUserName': matchedUserName,
    });
  }

  Future<void> _sendFcmMessage(
      String fcmToken, Map<String, dynamic> data) async {
    try {
      //requestNotificationPermission();
      print("send fcm called");
      final serviceAccountKey = json.decode(await loadServiceAccountKey());
      final _credentials =
          ServiceAccountCredentials.fromJson(serviceAccountKey);
      final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final authClient = await clientViaServiceAccount(_credentials, _scopes);

      final response = await authClient.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/test-7643a/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'message': {
            'token': fcmToken,
            'data': data,
          },
        }),
      );

      //print('FCM message response: ${response.statusCode}, ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to send FCM message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending FCM message: $e');
    }
  }

  Future<String> loadServiceAccountKey() async {
    return await rootBundle.loadString('assets/test-7643a-212cc705bb90.json');
  }
}
