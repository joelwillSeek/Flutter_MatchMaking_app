import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/other/account.dart';
import 'package:fire/other/pages/explore.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fire/home/chat.dart';
import 'package:http/http.dart' as http;
//import 'package:fire/home/profile.dart';
import 'package:fire/home/requests.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  FirebaseService firebaseService = FirebaseService();
  final List<Widget> _tabs = [
    FeedNavigator(),
    RequestNavigator(),
    ChatNavigator(),
    ProfileNavigator(),
  ];

  Future<bool> isConnectedToInternet() async {
    try {
      final response = await http.get(Uri.parse('https://google.com'));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  void checkConnection() async {
    bool isConnected = await isConnectedToInternet();
    if (isConnected) {
      // Perform actions that require internet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'back to online',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 21, 234, 88),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'no internet connection',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 249, 21, 21),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add observer to listen for lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    Provider.of<ProfileProvider>(context, listen: false).fetchAndSetUserData();
  }

  @override
  void dispose() {
    // Remove observer when the state is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        // App is in the background
        print("paused");
        firebaseService.updateIsOnline(
            FirebaseAuth.instance.currentUser!.uid, false);
        // Perform cleanup or save data
        break;
      case AppLifecycleState.resumed:
        // App is in the foreground
        print("continued");
        checkConnection();
        firebaseService.updateIsOnline(
            FirebaseAuth.instance.currentUser!.uid, true);
        firebaseService.updateLastSeen(
            FirebaseAuth.instance.currentUser!.uid, Timestamp.now());
        // Resume any operations
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., in a phone call)
        break;
      case AppLifecycleState.detached:
        // App is terminated
        // Perform cleanup or final operations
        firebaseService.updateLastSeen(
            FirebaseAuth.instance.currentUser!.uid, Timestamp.now());
        performFinalOperations();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  void performFinalOperations() {
    // Perform your final operations here
    print("app closed");
    firebaseService.updateIsOnline(
        FirebaseAuth.instance.currentUser!.uid, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE94057),
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        selectedIconTheme: const IconThemeData(
          color: Color(0xFFE94057),
        ),
      ),
    );
  }
}

class FeedNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ExplorePage(),
        );
      },
    );
  }
}

class RequestNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => RequestScreen(),
        );
      },
    );
  }
}

class ChatNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => chat(),
        );
      },
    );
  }
}

class ProfileNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => AccountPage(),
        );
      },
    );
  }
}
