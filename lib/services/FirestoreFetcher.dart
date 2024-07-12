import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Person {
  String user_id;
  String firstName;
  String lastName;
  String gender;
  String email;
  String address;
  String bio;
  String deviceToken;
  String? phoneNum;
  List<dynamic> interests;
  String profileImageUrl;
  bool? isOnline;
  int age;
  Timestamp? timestamp;
  DateTime lastClicked;

  Person(
      {required this.user_id,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.email,
      required this.profileImageUrl,
      required this.lastClicked,
      required this.age,
      required this.bio,
      required this.address,
      required this.deviceToken,
      required this.interests,
      this.phoneNum,
      this.timestamp,
      this.isOnline});

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      user_id: map['user_id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      interests: map['interests'] ?? '',
      isOnline: map['isOnline'] ?? false,
      timestamp: map['lastSeen'] ?? '',
      profileImageUrl: map['profile_url'] ?? '',
      lastClicked: map['lastClicked'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastClicked'])
          : DateTime.now(),
      age: map['age']?.toInt() ?? 0,
      bio: map['bio'] ?? '',
      address: map['address'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      phoneNum: map['phone_number'], // Use key with underscore
    );
  }
}

class FirestoreFetcher {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Future<List<Person>> fetchUsersAndProfiles() async {
  //   try {
  //     User? user = _auth.currentUser;
  //     String userId = user!.uid;
  //     final QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _firestore
  //         .collection('f_user')
  //         .where('user_id', isNotEqualTo: userId)
  //         .get();
  //     final QuerySnapshot<Map<String, dynamic>> profilesSnapshot =
  //         await _firestore.collection('user_profile').get();

  //     final List<Person> usersAndProfiles = [];

  //     // Merge user data with profile data based on userID
  //     for (final userDoc in usersSnapshot.docs) {
  //       final userId = userDoc['user_id'];

  //       final profileDoc = profilesSnapshot.docs.firstWhere(
  //         (profileDoc) => profileDoc['userID'] == userId,
  //       );

  //       final userData = userDoc.data();
  //       final profileData = profileDoc.data();
  //       final person = Person.fromMap({...userData, ...profileData});
  //       usersAndProfiles.add(person);
  //     }

  //     return usersAndProfiles;
  //   } catch (e) {
  //     print('Error fetching users and profiles: $e');
  //     return []; // Return an empty list in case of error
  //   }
  // }

  Future<List<Person>> fetchRequests() async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;
      print("current userID: $userId");
      final QuerySnapshot<Map<String, dynamic>> requestsSnapshot =
          await _firestore
              .collection('Request')
              .where('a_userID', isEqualTo: userId)
              .get();

      final List<Person> requesters = [];

      print('Total requests found: ${requestsSnapshot.docs.length}');

      for (final requestDoc in requestsSnapshot.docs) {
        final requesterId = requestDoc['r_userID'];
        print('Fetching details for requester ID: $requesterId');

        final userData =
            (await _firestore.collection('f_user').doc(requesterId).get())
                .data();
        print('User data for requester ID $requesterId: $userData');
        final person = Person.fromMap(userData!);
        requesters.add(person);
      }

      return requesters;
    } catch (e) {
      print('Error fetching requests: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<List<Person>> fetchFriends() async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;

      final QuerySnapshot<Map<String, dynamic>> friendsSnapshot =
          await _firestore
              .collection('Chat_Friend')
              .where('current_userID', isEqualTo: userId)
              .get();

      final List<Person> friends = [];

      for (final friendDoc in friendsSnapshot.docs) {
        final friendId = friendDoc['Chat_FriendID'];
        print('Fetching details for friend ID: $friendId');

        final userData =
            (await _firestore.collection('f_user').doc(friendId).get()).data();
        print('User data for friend ID $friendId: $userData');
        final person = Person.fromMap({...userData!});
        friends.add(person);
      }

      // Also query friend IDs where the current user is the Chat_FriendID
      final QuerySnapshot<Map<String, dynamic>> inverseFriendsSnapshot =
          await _firestore
              .collection('Chat_Friend')
              .where('Chat_FriendID', isEqualTo: userId)
              .get();

      for (final friendDoc in inverseFriendsSnapshot.docs) {
        final friendId = friendDoc['current_userID'];
        print('Fetching details for inverse friend ID: $friendId');

        final userData =
            (await _firestore.collection('f_user').doc(friendId).get()).data();
        print('User data for inverse friend ID $friendId: $userData');

        final person = Person.fromMap(userData!);
        friends.add(person);
      }

      return friends;
    } catch (e) {
      print('Error fetching friends: $e');
      return []; // Return an empty list in case of error
    }
  }

  Stream<bool> streamOnlineStatus(String userId) {
    return _firestore
        .collection('f_user')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['isOnline'] ?? false);
  }
}
