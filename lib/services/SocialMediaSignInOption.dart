import 'package:fire/pages/home.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/sign_up%20componenets/option/socialMediaForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

//import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class SocialMediaSignInOption {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TwitterLogin twitterLogin = TwitterLogin(
    apiKey: '**********************',
    apiSecretKey: '******************************',
    redirectURI: 'socialauth://',
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService firebaseService = FirebaseService();

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
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ).then((value) {
              firebaseService.updateDeviceToken(user.uid);
            });
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

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;

        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        final User? user = authResult.user;

        if (user != null) {
          final docSnapshot =
              await _firestore.collection('f_user').doc(user.uid).get();

          if (docSnapshot.exists) {
            // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
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
      print("Error signing in with Facebook: $error");
    }
  }

  Future<void> signInWithX(BuildContext context) async {
    try {
      final authResult = await twitterLogin.loginV2();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        try {
          final credential = TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!);
          final UserCredential res =
              await _auth.signInWithCredential(credential);
          final User? user = res.user;
          if (user != null) {
            final docSnapshot =
                await _firestore.collection('f_user').doc(user.uid).get();

            if (docSnapshot.exists) {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()))
                  .then((value) {
                firebaseService.updateDeviceToken(user.uid);
              });
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
        } catch (e) {}
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> signInWithApple(BuildContext context) async {
  //   TheAppleSignIn();
  //   try {
  //     final result = await TheAppleSignIn.performRequests(
  //       [
  //         AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //       ],
  //     );

  //     final appleIdCredential = result.credential;
  //     final oAuthProvider = OAuthProvider("apple.com");
  //     final credential = oAuthProvider.credential(
  //       idToken:
  //           String.fromCharCodes(appleIdCredential!.identityToken!.toList()),
  //       accessToken:
  //           String.fromCharCodes(appleIdCredential.authorizationCode!.toList()),
  //     );

  //     final authResult = await _auth.signInWithCredential(credential);
  //     final user = authResult.user;

  //     if (user != null) {
  //       final docSnapshot =
  //           await _firestore.collection('f_user').doc(user.uid).get();

  //       if (docSnapshot.exists) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //       } else {
  //         final userData = UserData(
  //           userId: user.uid,
  //           firstName: user.displayName?.split(' ')[0],
  //           lastName: user.displayName?.split(' ')[1],
  //           email: user.email,
  //           phoneNumber: user.phoneNumber,
  //           profilePicUrl: user.photoURL,
  //           emailVerified: user.emailVerified,
  //         );
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SocialMediaForm(userData: userData),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (error) {
  //     print("Error signing in with Apple: $error");
  //   }
  // }
}

class UserData {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicUrl;
  final bool? emailVerified;

  UserData({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePicUrl,
    this.emailVerified,
  });
}
