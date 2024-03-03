import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/FirebaseFetchService.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFetchService fetchService = FirebaseFetchService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? userProfileUrl;
  bool isLoading = true;
  bool isError = false;

  ProfileProvider() {
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;

      Map<String, dynamic>? userDetails =
          await fetchService.getUserDetails(userId);
      if (userDetails != null) {
        firstName = userDetails['firstName'];
        lastName = userDetails['lastName'];
        gender = userDetails['gender'];
        email = userDetails['email'];
      }

      String? userProfileUrl = await fetchService.getUserProfileUrl(userId);
      if (userProfileUrl != null) {
        this.userProfileUrl = userProfileUrl;
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    firstName = null;
    lastName = null;
    gender = null;
    email = null;
    userProfileUrl = null;
    isLoading = true;
    isError = false;
    notifyListeners();
  }
}
