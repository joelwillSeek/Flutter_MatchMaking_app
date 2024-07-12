import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback/feedback.dart';
import 'package:fire/main.dart';
import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/home/settings.dart';
import 'package:fire/newFeature/aboutMe.dart';
import 'package:fire/newFeature/updateInfo.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/services/report.dart';
import 'package:fire/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseService firebaseService = FirebaseService();
  File? _image;
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
          final me = UserDataManager().me!;
          Report report = Report();
          report.submitReport(
              name: "${me.firstName} ${me.lastName}",
              platform: platformName,
              statement: feedback.text,
              screenshot: feedback.screenshot);
          print(platformName);
          print('Feedback text: ${feedback.text}');
        }
      },
    );
  }

  void updateUserProfile(File newProfilePic, BuildContext context) async {
    FirebaseService userProfileService = FirebaseService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'profile updating....',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
    int i = await userProfileService.updateUserProfilePicture(
      userId: FirebaseAuth.instance.currentUser!.uid,
      newProfilePic: newProfilePic,
    );
    if (i == 1) {
      _refresh(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated,🤙',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'There was error updating profile,🤯',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .fetchAndSetUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.2),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Stack(
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
        ),
      ), // Pass context to getBody method
    );
  }

  Widget getBody(BuildContext context) {
    // Add BuildContext parameter
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              if (profileProvider.isLoading) {
                return Container(
                  width: size.width,
                  height: size.height * 0.60,
                  child: Center(
                    child: SpinKitWaveSpinner(
                      size: 80.0,
                      trackColor: Color.fromARGB(255, 56, 13, 6),
                      waveColor: Color.fromARGB(255, 255, 153, 1),
                      color: const Color(0xFFE94057),
                    ),
                  ),
                );
              } else if (profileProvider.isError) {
                return Container(
                  width: size.width,
                  height: size.height * 0.60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/urban-dog.gif'),
                      Text(
                        'unable to get user profile',
                        style: GoogleFonts.lato(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              } else {
                final me = UserDataManager().me!;

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
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(me.profileUrl),
                              fit: BoxFit.cover,
                            ),
                          ), // Add missing bracket
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${me.firstName}  , " "${me.age}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Merienda'),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsPage()));
                                  },
                                  child: Container(
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
                                              colors: [
                                                primary_one,
                                                primary_two
                                              ],
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
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                            me: me,
                                                          )));
                                            },
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
                                            child: GestureDetector(
                                              onTap: () async {
                                                final picker = ImagePicker();
                                                final pickedFile =
                                                    await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                );
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    _image =
                                                        File(pickedFile.path);
                                                    updateUserProfile(
                                                        _image!, context);
                                                  });
                                                }
                                                //end
                                              },
                                              child: Center(
                                                child: Icon(Icons.add,
                                                    color: primary),
                                              ),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdatePersonalInfo(
                                                  me: me,
                                                )));
                                  },
                                  child: Container(
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
        ),
      ],
    );
  }
}
