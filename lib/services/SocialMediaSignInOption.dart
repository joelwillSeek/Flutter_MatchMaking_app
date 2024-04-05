import 'package:fire/pages/home.dart';
import 'package:fire/sign_up%20componenets/option/socialMediaForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialMediaSignInOption {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        final User? user = authResult.user;

        if (user != null) {
          final docSnapshot =
              await _firestore.collection('f_user').doc(user.uid).get();

          if (docSnapshot.exists) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            final userData = UserData(
              userId: user.uid,
              firstName: user.displayName?.split(' ')[0],
              lastName: user.displayName?.split(' ')[1],
              email: user.email,
              phoneNumber: user.phoneNumber,
              profilePicUrl: user.photoURL,
              emailVerified: user.emailVerified,
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SocialMediaForm(
                          userData: userData,
                        )));
          }
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }
}

class UserData {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicUrl;
  final bool? emailVerified;

  UserData({
    required this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePicUrl,
    this.emailVerified,
  });
}