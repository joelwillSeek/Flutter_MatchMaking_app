import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserDataManager.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = true;
  bool isError = false;

  ProfileProvider() {
    fetchAndSetUserData();
  }

  Future<void> fetchAndSetUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await UserDataManager().fetchUserData(userId);

      if (UserDataManager().me != null) {
        isLoading = false;
      } else {
        isError = true;
      }
    } catch (e) {
      isError = true;
      print("Error fetching user details in chagne notifier: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reFetch() async {
    await fetchAndSetUserData();
  }
}
