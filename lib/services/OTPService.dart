import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class OTPService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> sendOTP(String phoneNumber) async {
    Completer<String?> completer = Completer<String?>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to send OTP: ${e.message}');
          completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP sent successfully');
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Error sending OTP: $e');
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<String?> resendOTP(String phoneNumber) async {
    Completer<String?> completer = Completer<String?>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to resend OTP: ${e.message}');
          completer.completeError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('OTP resent successfully');
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Error resending OTP: $e');
      completer.completeError(e);
    }

    return completer.future;
  }
}
