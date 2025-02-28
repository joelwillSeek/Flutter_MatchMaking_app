import 'package:fire/services/FirebaseFetchService.dart';
import 'package:flutter/material.dart';
import '../model/Me.dart';

class UserDataManager {
  static final UserDataManager _singleton = UserDataManager._internal();
  Me? me;

  factory UserDataManager() {
    return _singleton;
  }

  UserDataManager._internal();

  Future<void> fetchUserData(String userId) async {
    try {
      FirebaseFetchService fetchService = FirebaseFetchService();
      Map<String, dynamic>? userData =
          await fetchService.getUserDetails(userId);

      if (userData != null && userData.isNotEmpty) {
        final userDataMap = userData['userData'] as Map<String, dynamic>?;
        final preferencesDataMap =
            userData['preferencesData'] as Map<String, dynamic>?;
        if (userDataMap != null && preferencesDataMap != null) {
          me = Me.fromFirestore(
            userDataMap,
            preferencesDataMap,
          );
        } else {
          if (userDataMap == null) {
            print("User data map is null or empty.");
          }
          if (preferencesDataMap == null) {
            print("Preferences data map is null or empty.");
          }
          print(
              "User details retrieval failed: userDataMap: $userDataMap, preferencesDataMap: $preferencesDataMap");
        }
      } else {
        print("User data is null or empty.");
      }
    } catch (e, stackTrace) {
      print("Error fetching user details ub getcgyserdata: $e");
      print("StackTrace: $stackTrace");
    }
  }
}
