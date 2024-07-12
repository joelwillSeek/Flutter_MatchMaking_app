//import 'package:fire/services/MatchmakingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void findMatches(String currentUserId) async {
    print(currentUserId);
    // MatchmakingService matchmakingService = MatchmakingService();
    // List<u_person> potentialMatches =
    //     await matchmakingService.getRankedPotentialMatches(currentUserId);

    // for (var person in potentialMatches) {
    //   print(
    //       "Match: ${person.firstName} ${person.lastName}, Age: ${person.age}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () => findMatches(_auth.currentUser!.uid),
                child: const Text("Suggest Me!")),
          )
        ],
      ),
    );
  }
}
