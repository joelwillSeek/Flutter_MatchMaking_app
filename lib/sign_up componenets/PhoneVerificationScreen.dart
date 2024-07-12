import 'dart:async';
import 'dart:io';

import 'package:fire/services/OTPService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'InterestSelectionScreen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String f, l, gen, ph;
  final File? img;
  final int age;

  const PhoneVerificationScreen({
    super.key,
    required this.f,
    required this.l,
    required this.gen,
    required this.img,
    required this.ph,
    required this.age,
  });
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  int _counter = 60;
  bool _isResendClickable = false;
  late Timer _timer;
  List<String> _otp = ['', '', '', '', '', ''];
  int _currentIndex = 0;
  String? vID;
  FirebaseAuth _auth = FirebaseAuth.instance;
  OTPService _otpService = OTPService();

  @override
  void initState() {
    super.initState();
    startTimer();
    _sendOTP();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _isResendClickable = true;
          _timer.cancel();
        }
      });
    });
  }

  void onNumberTap(int number) {
    setState(() {
      if (_currentIndex < _otp.length) {
        _otp[_currentIndex] = number.toString();
        if (_currentIndex < _otp.length - 1) {
          _currentIndex++;
        } else {
          performOperation();
        }
      }
    });
  }

  void performOperation() async {
    bool allFilled = _otp.every((element) => element.isNotEmpty);
    if (allFilled) {
      String concatenatedDigits = _otp.join();
      print('Performing operation with OTP code: $concatenatedDigits');
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: vID!,
          smsCode: concatenatedDigits,
        );
        await _auth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InterestSelectionScreen(
              f: widget.f,
              l: widget.l,
              gen: widget.gen,
              img: widget.img,
              ph: widget.ph,
              age: widget.age,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Incorrect input. Please enter correct OTP.'),
          ),
        );
      }
    }
  }

  void onDelete() {
    setState(() {
      if (_currentIndex >= 0) {
        _otp[_currentIndex] = '';
        if (_currentIndex > 0) {
          _currentIndex--;
        }
      }
    });
  }

  void _sendOTP() {
    _otpService.sendOTP(widget.ph).then((verificationId) {
      if (verificationId != null) {
        setState(() {
          vID = verificationId;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending OTP'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _resendOTP() {
    _otpService.resendOTP(widget.ph).then((verificationId) {
      if (verificationId != null) {
        setState(() {
          vID = verificationId;
          _counter = 60; // Reset the timer
          _isResendClickable = false;
          startTimer(); // Restart the timer
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resending OTP'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f6fb),
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$_counter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Type the verification code we’ve sent you',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => GestureDetector(
                        onTap: () => onDelete(),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _otp[index].isEmpty
                                ? Colors.white
                                : Color(0xFFE94057),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Color.fromARGB(124, 233, 64, 87)
                                  : Color.fromARGB(110, 155, 150, 150),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _otp[index],
                              style: TextStyle(
                                color: _otp[index].isEmpty
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(
                      9,
                      (index) => GestureDetector(
                        onTap: () => onNumberTap(index + 1),
                        child: Container(
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )..add(
                        GestureDetector(
                          onTap: () => onNumberTap(0),
                          child: Container(
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isResendClickable
                        ? () {
                            _resendOTP();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'resending, please wait a few second!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      'Resend New Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isResendClickable
                            ? Color(0xFFE94057)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
