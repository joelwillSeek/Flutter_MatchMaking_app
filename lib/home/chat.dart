import 'package:fire/chat/chat_home.dart';
import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: ChatHome(),
=======
      body: const ChatHome(),
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
    );
  }
}
