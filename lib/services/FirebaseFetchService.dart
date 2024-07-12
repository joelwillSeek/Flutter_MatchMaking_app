import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('f_user').doc(userId).get();
      DocumentSnapshot<Map<String, dynamic>> preferencesSnapshot =
          await _firestore
              .collection('f_user')
              .doc(userId)
              .collection('preferences')
              .doc(userId)
              .get();

      if (userSnapshot.exists && preferencesSnapshot.exists) {
        final userData = userSnapshot.data()!;
        final preferencesData = preferencesSnapshot.data()!;
        print("User data retrieved successfully: $userData");
        print("Preferences data retrieved successfully: $preferencesData");
        return {
          'userData': userData,
          'preferencesData': preferencesData,
        };
      } else {
        print("User data or preferences data does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}
