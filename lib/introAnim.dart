// ignore_for_file: file_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fire/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

// ignore: camel_case_types
class _splashState extends State<splash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    bool flag = islogged();
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 200,
        splash: Image.asset(
          "assets/images/IMG_20240207_220819_448.jpg",
          height: 1000,
          width: 1000,
        ),
        nextScreen: flag ? const HomeScreen() : const signin(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 10,
      ),
    );
  }

  bool islogged() {
    User? user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      return true;
    } else {
      return false;
    }
  }
}
