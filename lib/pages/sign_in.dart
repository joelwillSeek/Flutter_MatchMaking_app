import 'dart:ui';

import 'package:fire/pages/ForgotPasswordScreen.dart';
import 'package:fire/pages/home.dart';
import 'package:fire/pages/sign_up.dart';
import 'package:fire/services/SocialMediaSignInOption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import '../services/FirebaseService.dart';

// ignore: camel_case_types
class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

// ignore: camel_case_types
class _signinState extends State<signin> {
  final SocialMediaSignInOption _socialMediaSignInOption =
      SocialMediaSignInOption();
  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<String?> _getCityFromLocation() async {
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return place.locality;
    }
    return null;
  }

  //void _loginWithFb() async {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //Addis Ababa
    checkLocation();
  }

  void checkLocation() async {
    final city = await _getCityFromLocation();
    if (city == null) {
      print("null");
    }
    print(city.toString());
    if (city.toString() != 'Addis Ababa') {
      _showOutsideAddisAbabaPopup();
    }
  }

  void _showOutsideAddisAbabaPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/urban-dog.gif'),
              Text(
                  "We didn't start our service outside Addis Ababa.\nIf you are out of Addis Ababa, we will come back soon."),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Banner(
      location: BannerLocation.topEnd,
      message: "UNITY",
      child: Scaffold(
        body: Stack(
          children: [
            const RiveAnimation.asset("assets/rive_assets/shapes.riv"),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                child: const SizedBox(),
              ),
            ),
            ListView(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/IMG_20240207_220819_448.jpg',
                        cacheWidth: 150,
                        cacheHeight: 150,
                      ),
                      Text(
                        "Habeshaly",
                        style: TextStyle(
                          fontFamily: 'Merienda',
                          color: Color(0xFFE94057),
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        "Introducing Habeshaly 0.0: Experience the inaugural version powered by Firebase backend😎",
                        textAlign: TextAlign.center,
                      ),
                      const signinForm(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "-----------sign in methods-----------",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.facebook,
                              size: 60,
                              color: Color(0xFFE94057),
                            ),
                            onPressed: () async {
                              await _socialMediaSignInOption
                                  .signInWithFacebook(context);
                            },
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/icons8-twitter-48.png',
                              width: 70.0,
                              height: 70.0,
                              color: Color(0xFFE94057),
                            ),
                            onPressed: () async {
                              await _socialMediaSignInOption
                                  .signInWithX(context);
                            },
                          ),
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.apple,
                          //     size: 60,
                          //     color: Color(0xFFE94057),
                          //   ),
                          //   onPressed: () async {
                          //     await _socialMediaSignInOption.signInWithApple(context);
                          //   },
                          // ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/icons8-google-48.png',
                              width: 60.0,
                              height: 60.0,
                              color: Color(0xFFE94057),
                            ),
                            onPressed: () async {
                              await _socialMediaSignInOption
                                  .signInWithGoogle(context);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: 'Click here.',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class signinForm extends StatefulWidget {
  const signinForm({super.key});

  @override
  State<signinForm> createState() => _signinFormState();
}

// ignore: camel_case_types
class _signinFormState extends State<signinForm> {
  bool _isObscured = true;
  TextEditingController emailCont = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      User? user = await firebaseService.signInWithEmailAndPassword(
        email: emailCont.text,
        password: password.text,
      );

      isLoading.value = false;

      if (user != null) {
        bool isEmailVerified = await firebaseService.checkEmailVerification();
        if (isEmailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ).then((value) {
            firebaseService.updateDeviceToken(user.uid);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please verify your email.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegExp =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\s*$', caseSensitive: false);
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailCont,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "XongXina@gmail.com",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 8, 8, 8)),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Color(0xFFE94057)),
                    gapPadding: 10,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: TextFormField(
              controller: password,
              keyboardType: TextInputType.visiblePassword,
              validator: _validatePassword,
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 16, 16, 16)),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: Color(0xFFE94057)),
                  gapPadding: 10,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFFE94057)),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
            child: ElevatedButton(
              onPressed:
                  //  () async {
                  //   if (formKey.currentState!.validate()) {
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   builder: (BuildContext context) {
                  //     return Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           SpinKitThreeInOut(
                  //             size: 50.0,
                  //             itemBuilder: (_, int index) {
                  //               return DecoratedBox(
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(25),
                  //                   color: index.isEven
                  //                       ? const Color(0xFFE94057)
                  //                       : Colors.grey,
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //           const Text(
                  //             "please wait a few second...",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 16),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // );
                  //     User? user = await firebaseService.signInWithEmailAndPassword(
                  //       email: emailCont.text,
                  //       password: password.text,
                  //     );
                  //     if (user != null) {
                  //       // Check if email is verified
                  //       bool isEmailVerified =
                  //           await firebaseService.checkEmailVerification();
                  //       if (isEmailVerified) {
                  //         // Email is verified, navigate to the next screen
                  //         // ignore: use_build_context_synchronously
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const HomeScreen()),
                  //         ).then((value) {
                  //           firebaseService.updateDeviceToken(user.uid);
                  //         });
                  //       } else {
                  //         // Email is not verified, show a message or take appropriate action
                  //         // For example, you can display a snackbar or an alert dialog
                  //         // ignore: use_build_context_synchronously
                  //         Navigator.pop(context);

                  //         // ignore: use_build_context_synchronously
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(
                  //               content: Text('Please verify your email.')),
                  //         );
                  //       }
                  //     } else {
                  //       // Sign-in failed, show a message or take appropriate action
                  //       // For example, you can display a snackbar or an alert dialog
                  //       // ignore: use_build_context_synchronously

                  //       // ignore: use_build_context_synchronously
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //             content: Text('Invalid email or password.')),
                  //       );
                  //     }
                  //   }
                  // }
                  _login,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE94057),
                minimumSize: const Size(315, 70),
                elevation: 8,
              ),
              child: Text(
                "Login",
                style:
                    GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, child) {
              if (value) {
                return Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpinKitThreeInOut(
                            size: 50.0,
                            itemBuilder: (_, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: index.isEven
                                      ? const Color(0xFFE94057)
                                      : Colors.grey,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "please wait a few second...",
                            style: TextStyle(
                              color: Color.fromARGB(158, 16, 13, 13),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
