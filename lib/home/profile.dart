import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            if (profileProvider.isLoading) {
              return const CircularProgressIndicator();
            } else if (profileProvider.isError) {
              return const Text('Unable to get user details');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: ClipOval(
                      child: CircleAvatar(
                        child: Image.network(
                          profileProvider.userProfileUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("First name : ${profileProvider.firstName}"),
                        Text("Last name : ${profileProvider.lastName}"),
                        Text("Email address : ${profileProvider.email}"),
                        Text("Gender : ${profileProvider.gender}"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const signin()),
                      );
                    },
                    child: const Text("Sign out"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
