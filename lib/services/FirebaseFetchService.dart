import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('f_user').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data();
      }
      return null;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<String?> getUserProfileUrl(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> profileSnapshot =
          await _firestore.collection('user_profile').doc(userId).get();

      if (profileSnapshot.exists) {
        return profileSnapshot.get('profile_url');
      }
      return null;
    } catch (e) {
      print("Error fetching user profile URL: $e");
      return null;
    }
  }
}
