import 'package:fire/pages/home.dart';
import 'package:fire/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/FirebaseService.dart';

// ignore: camel_case_types
class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

// ignore: camel_case_types
class _signinState extends State<signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("sign in"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "bros b4 hoes",
                  style: TextStyle(
                    color: Color(0xFFE94057),
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "this is sample flutter UI with firebase as the backend app, enjoy the trial version😎",
                  textAlign: TextAlign.center,
                ),
                const signinForm(),
                // Add a spacer to push the following content to the bottom
                const SizedBox(
                  height: 150,
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
                      onPressed: () {
                        // Google sign-in logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.apple,
                          size: 60, color: Color(0xFFE94057)),
                      onPressed: () {
                        // Apple sign-in logic
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
            padding: const EdgeInsets.all(8.0),
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Validation passed, proceed with login
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
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
                            const Text(
                              "please wait a few second...",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  User? user = await firebaseService.signInWithEmailAndPassword(
                    email: emailCont.text,
                    password: password.text,
                  );
                  if (user != null) {
                    // Check if email is verified
                    bool isEmailVerified =
                        await firebaseService.checkEmailVerification();
                    if (isEmailVerified) {
                      // Email is verified, navigate to the next screen
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    } else {
                      // Email is not verified, show a message or take appropriate action
                      // For example, you can display a snackbar or an alert dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please verify your email.')),
                      );
                    }
                  } else {
                    // Sign-in failed, show a message or take appropriate action
                    // For example, you can display a snackbar or an alert dialog
                    // ignore: use_build_context_synchronously

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Invalid email or password.')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE94057),
                minimumSize: const Size(315, 70),
                elevation: 8,
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
