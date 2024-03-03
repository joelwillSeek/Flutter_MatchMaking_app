import 'package:fire/firebase_options.dart';
import 'package:fire/introAnim.dart';
import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/manager/ChatFriendProvider.dart';
import 'package:fire/onBoard/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manager/RequestProvider.dart';

int? isViewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  MyApp({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> getRootNavigatorKey(BuildContext context) {
    final MyApp myApp = context.findAncestorWidgetOfExactType<MyApp>()!;
    return myApp.rootNavigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => RequestProvider()),
        ChangeNotifierProvider(create: (context) => ChatFriendProvider())
      ],
      child: MaterialApp(
        navigatorKey: rootNavigatorKey,
        home: isViewed != 0 ? OnBoard() : splash(),
      ),
    );
  }
}
