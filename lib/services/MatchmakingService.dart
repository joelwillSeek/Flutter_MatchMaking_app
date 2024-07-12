import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/services/FirestoreFetcher.dart';

class MatchmakingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Set<String>> _getLikedAndDislikedUserIds(
      String currentUserId, String p_id) async {
    Set<String> excludedUserIds = {};

    try {
      print("get lD called");

      final likedFuture = _firestore
          .collection('Likes')
          .where('LikerID', isEqualTo: currentUserId)
          .get();
      final alreadyliked = _firestore
          .collection('Likes')
          .where('LikerID', isEqualTo: p_id)
          .where('LikedUserID', isEqualTo: currentUserId)
          .get();
      final dislikedFuture = _firestore
          .collection('DisLike')
          .where('DislikerID', isEqualTo: currentUserId)
          .get();

      final results =
          await Future.wait([likedFuture, dislikedFuture, alreadyliked]);
      final likedSnapshot = results[0];
      final dislikedSnapshot = results[1];
      final alreadyLiked = results[2];

      likedSnapshot.docs.forEach((doc) {
        excludedUserIds.add(doc['LikedUserID']);
      });
      dislikedSnapshot.docs.forEach((doc) {
        excludedUserIds.add(doc['DislikedUserID']);
      });
      alreadyLiked.docs.forEach((doc) {
        excludedUserIds.add(doc['LikerID']);
      });
    } catch (e) {
      print('Error fetching liked/disliked users: $e');
    }
    print("excluded: $excludedUserIds");
    return excludedUserIds;
  }

  Future<Map<String, dynamic>?> _fetchUserPreferences(
      String currentUserId) async {
    try {
      print("get pref called");

      DocumentSnapshot prefDoc = await _firestore
          .collection('f_user')
          .doc(currentUserId)
          .collection('preferences')
          .doc(currentUserId)
          .get();

      if (prefDoc.exists) {
        return prefDoc.data() as Map<String, dynamic>;
      } else {
        print("Preferences document not found");
        return null;
      }
    } catch (e) {
      print("Error fetching preferences: $e");
      return null;
    }
  }

  Future<List<Person>> _getPotentialMatches(
      String currentUserId, Map<String, dynamic> prefData) async {
    List<Person> potentialMatches = [];

    try {
      print("get pot called");

      List<String> userInterests = List<String>.from(prefData['interests']);
      int minAge = prefData['ageRange']['min'];
      int maxAge = prefData['ageRange']['max'];
      String preferredGender = prefData['gender'];
      String preferredAddress = prefData['address'];

      QuerySnapshot querySnapshot = await _firestore
          .collection('f_user')
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('age', isLessThanOrEqualTo: maxAge)
          .where('gender', isEqualTo: preferredGender)
          .where('address', isEqualTo: preferredAddress)
          .get();

      for (var doc in querySnapshot.docs) {
        Set<String> excludedUserIds =
            await _getLikedAndDislikedUserIds(currentUserId, doc.id);
        if (doc.id != currentUserId && !excludedUserIds.contains(doc.id)) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          List<String> potentialInterests =
              List<String>.from(data['interests']);

          if (userInterests
              .any((interest) => potentialInterests.contains(interest))) {
            final person = Person.fromMap(data);
            potentialMatches.add(person);
            // potentialMatches.add(Person(
            //   user_id: doc.id,
            //   firstName: data['firstName'],
            //   lastName: data['lastName'],
            //   gender: data['gender'],
            //   deviceToken: data['deviceToken'],
            //   email: data['email'],
            //   profileImageUrl: data['profile_url'],
            //   isOnline: data['isOnline'],
            //   bio: data['bio'],
            //   age: data['age'],
            //   address: data['address'],
            //   timestamp: data['lastSeen'],
            //   phoneNum: data['phoneNumber'],
            //   lastClicked: data['lastLiked'],
            //   interests: potentialInterests,
            // ));
          }
        }
      }
    } catch (e) {
      print("Error fetching potential matches: $e");
    }
    return potentialMatches;
  }

  Future<List<Person>> _rankMatches(
      List<Person> matches, Map<String, dynamic> prefData) async {
    try {
      print("get match called");

      List<String> userInterests = List<String>.from(prefData['interests']);

      matches.sort((a, b) {
        int scoreA = userInterests
            .where((interest) => a.interests.contains(interest))
            .length;
        int scoreB = userInterests
            .where((interest) => b.interests.contains(interest))
            .length;
        return scoreB.compareTo(scoreA);
      });
    } catch (e) {
      print('Error ranking matches: $e');
    }
    print("total match ${matches.length}");
    return matches;
  }

  Future<List<Person>> getRankedPotentialMatches(String currentUserId) async {
    try {
      print("get ranked called");
      Map<String, dynamic>? prefData =
          await _fetchUserPreferences(currentUserId);
      if (prefData == null) return [];

      List<Person> matches =
          await _getPotentialMatches(currentUserId, prefData);
      matches = await _rankMatches(matches, prefData);
      return matches;
    } catch (e) {
      print('Error fetching and ranking matches: $e');
      return [];
    }
  }
}
