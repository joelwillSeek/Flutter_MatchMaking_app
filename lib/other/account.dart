import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/feedback.dart';
import 'package:fire/data/account_json.dart';
import 'package:fire/main.dart';
import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/services/report.dart';
import 'package:fire/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseService firebaseService = FirebaseService();
  void signOut(BuildContext context) async {
    firebaseService.updateIsOnline(
        FirebaseAuth.instance.currentUser!.uid, false);
    firebaseService.updateLastSeen(
        FirebaseAuth.instance.currentUser!.uid, Timestamp.now());
    await FirebaseAuth.instance.signOut();
    MyApp.getRootNavigatorKey(context).currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => MyApp()),
        );
  }

  void submitFeedback(BuildContext context) async {
    BetterFeedback.of(context).show(
      (UserFeedback feedback) async {
        if (feedback.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'please tell us little about the problem',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          String platformName = Platform.operatingSystem;
          String f, l;
          f = context.read<ProfileProvider>().firstName!;
          l = context.read<ProfileProvider>().lastName!;
          Report report = Report();
          report.submitReport(
              name: "$f $l",
              platform: platformName,
              statement: feedback.text,
              screenshot: feedback.screenshot);
          print(platformName);
          print('Feedback text: ${feedback.text}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.2),
      body: Stack(
        children: [
          getBody(context),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 10.0, bottom: 10),
            child: GestureDetector(
              onTap: () => submitFeedback(context),
              child: Row(
                children: [
                  Icon(Icons.bug_report, color: primary),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("Report & Feedback",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  signOut(context);
                },
              ),
            ),
          ),
        ],
      ), // Pass context to getBody method
    );
  }

  Widget getBody(BuildContext context) {
    // Add BuildContext parameter
    var size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          if (profileProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (profileProvider.isError) {
            return Center(
              child: Text('Unable to get user details'),
            );
          } else {
            return Container(
              width: size.width,
              height: size.height * 0.60,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                  // changes position of shadow
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              profileProvider.userProfileUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ), // Add missing bracket
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${profileProvider.firstName}  , " +
                          account_json[0]['age'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primary_one, primary_two],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withOpacity(0.1),
                                    spreadRadius: 10,
                                    blurRadius: 15,
                                    // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.settings,
                                size: 35,
                                color: white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "SETTINGS",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: grey.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                width: 85,
                                height: 85,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [primary_one, primary_two],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: grey.withOpacity(0.1),
                                            spreadRadius: 10,
                                            blurRadius: 15,
                                            // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 45,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 0,
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: grey.withOpacity(0.1),
                                              spreadRadius: 10,
                                              blurRadius: 15,
                                              // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child:
                                              Icon(Icons.add, color: primary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "About Me",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: grey.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primary_one, primary_two],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withOpacity(0.1),
                                    spreadRadius: 10,
                                    blurRadius: 15,
                                    // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 35,
                                color: white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "EDIT INFO",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: grey.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
