import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      updateIsOnline(_auth.currentUser!.uid, true);
      updateDeviceToken(_auth.currentUser!.uid);
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<bool> checkEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        user = _auth.currentUser;
        return user!.emailVerified;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking email verification: $e");
      return false;
    }
  }

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required String Bio,
    required String phoneNum,
    required List<String> interests,
    required int age,
    required String address,
    required bool verified,
    File? profilePic,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        if (verified == false) {
          await user.sendEmailVerification();
        }
        await _storeUserDetails(
            userId: user.uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            address: address,
            interests: interests,
            age: age,
            phoneNum: phoneNum,
            bio: Bio);

        if (profilePic != null) {
          await _uploadProfilePicture(userId: user.uid, profilePic: profilePic);
        }

        return user;
      }

      return null;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  Future<void> _storeUserDetails(
      {required String userId,
      required String email,
      required String firstName,
      required String lastName,
      required String gender,
      required String phoneNum,
      required List<String> interests,
      required int age,
      required String address,
      required String bio}) async {
    String prefGen;
    if (gender == "Male") {
      prefGen = "Female";
    } else {
      prefGen = "Male";
    }

    String? fcmToken;

    try {
      fcmToken = await messaging.getToken();
      print('FCM Token: $fcmToken');
    } on Exception catch (e) {
      print(e);
    }

    try {
      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .set({});
      await _firestore.collection('f_user').doc(userId).set({
        'firstName': firstName,
        'deviceToken': fcmToken,
        'lastName': lastName,
        'gender': gender,
        'email': email,
        'user_id': userId,
        'age': age,
        'phoneNumber': phoneNum,
        'bio': bio,
        'address': address,
        'isOnline': false,
        'notificationsEnabled': true,
        'profile_url': '',
        'interests': interests,
        'lastSeen': Timestamp.now(),
      }, SetOptions(merge: true));

      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .set({
        'interests': interests,
        'ageRange': {
          'min': 15,
          'max': 50,
        },
        'gender': prefGen,
        'address': address,
      }, SetOptions(merge: true));

      print("User details stored successfully!");
    } catch (e) {
      print("Error storing user details: $e");
    }
  }

  Future<void> _uploadProfilePicture({
    required String userId,
    required File profilePic,
  }) async {
    try {
      String imagePath = 'profile_pictures/$userId.jpg';
      Reference storageReference = _storage.ref().child(imagePath);

      await storageReference.putFile(profilePic);

      String downloadURL = await storageReference.getDownloadURL();

      await _firestore.collection('f_user').doc(userId).update({
        'profile_url': downloadURL,
      });

      print(
          "Profile picture uploaded successfully. Download URL: $downloadURL");
    } catch (e) {
      print("Error uploading profile picture: $e");
    }
  }

  Future<void> CreatingAccountWithotherSignInMethod(
      {String? userId,
      String? p_url,
      String? email,
      String? firstName,
      String? lastName,
      String? gender,
      String? phoneNum,
      List<String>? interests,
      int? age,
      String? address,
      String? bio}) async {
    String prefGen;
    if (gender == "Male") {
      prefGen = "Female";
    } else {
      prefGen = "Male";
    }

    String? fcmToken;

    try {
      fcmToken = await messaging.getToken();
      print('FCM Token: $fcmToken');
    } on Exception catch (e) {
      print(e);
    }
    try {
      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .set({});

      await _firestore.collection('f_user').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'email': email ?? 'habeshaly01@gmail.com',
        'user_id': userId,
        'age': age,
        'phoneNumber': phoneNum ?? '+25134918291',
        'bio': bio,
        'deviceToken': fcmToken,
        'address': address,
        'interests': interests,
        'isOnline': false,
        'notificationsEnabled': true,
        'profile_url': '',
        'lastSeen': Timestamp.now(),
      }, SetOptions(merge: true));

      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .set({
        'interests': interests,
        'ageRange': {
          'min': 15,
          'max': 50,
        },
        'gender': prefGen,
        'address': address,
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      print(e);
    }

    print("User details stored successfully!");
    await _firestore.collection('f_user').doc(userId).update({
      'profile_url': p_url,
    });
    print("User profile stored successfully!");
  }

  Future<void> addLike({
    required String likedUserID,
    required String likerID,
  }) async {
    try {
      await _firestore.collection('Likes').add({
        'LikedUserID': likedUserID,
        'LikerID': likerID,
        'Timestamp': FieldValue.serverTimestamp(),
      });
      print("Like added successfully!");
    } catch (e) {
      print("Error adding like: $e");
    }
  }

  Future<void> updateDeviceToken(String uid) async {
    try {
      String? fcmToken = await messaging.getToken();
      print('FCM Token: $fcmToken'); // For debugging purposes

      String userId = uid;
      await FirebaseFirestore.instance
          .collection('f_user')
          .doc(userId)
          .set({'deviceToken': fcmToken}, SetOptions(merge: true));

      print('Device token updated successfully');
    } catch (e) {
      print('Error updating device token: $e');
    }
  }

  Future<void> addDisLike({
    required String DislikedUserID,
    required String DislikerID,
  }) async {
    try {
      await _firestore.collection('DisLike').add({
        'DislikedUserID': DislikedUserID,
        'DislikerID': DislikerID,
        'Timestamp': FieldValue.serverTimestamp(),
      });
      print("disLike added successfully!");
    } catch (e) {
      print("Error adding dislike: $e");
    }
  }

  Future<void> Request({
    required String a_user,
    required String r_user,
  }) async {
    try {
      await _firestore.collection('Request').add({
        'a_userID': a_user,
        'r_userID': r_user,
        'Timestamp': FieldValue.serverTimestamp(),
      });
      print("request added successfully!");
    } catch (e) {
      print("Error adding request: $e");
    }
  }

  Future<bool> addFriend({
    required String c_user,
    required String f_user,
  }) async {
    try {
      await _firestore.collection('Chat_Friend').add({
        'Chat_FriendID': f_user,
        'current_userID': c_user,
      });
      print("friend added successfully!");
      return true;
    } catch (e) {
      print("Error adding friend: $e");
      return false;
    }
  }

  Future<void> deleteFromRequest({
    required String a_user,
    required String r_user,
  }) async {
    try {
      // Query documents in the Request collection where a_userID equals a_user and r_userID equals r_user
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('Request')
          .where('a_userID', isEqualTo: a_user)
          .where('r_userID', isEqualTo: r_user)
          .get();

      // Delete each document returned by the query
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Request deleted successfully!");
    } catch (e) {
      print("Error deleting request: $e");
    }
  }

  Future<void> updateIsOnline(String userID, bool value) async {
    try {
      await FirebaseFirestore.instance
          .collection('f_user')
          .doc(userID)
          .update({'isOnline': value});
      print('isOnline updated successfully for user: $userID');
    } catch (error) {
      print('Error updating isOnline for user: $userID\n$error');
    }
  }

  Future<void> updateLastSeen(String userID, Timestamp timestamp) async {
    try {
      await FirebaseFirestore.instance
          .collection('f_user')
          .doc(userID)
          .update({'lastSeen': timestamp});
      print('lastSeen updated successfully for user: $userID');
    } catch (error) {
      print('lastSeen updating for user: $userID\n$error');
    }
  }

  Future<void> deleteChatFriend(String toBeDeletedUserID) async {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Chat_Friend')
        .where('Chat_FriendID', isEqualTo: toBeDeletedUserID)
        .where('current_userID', isEqualTo: currentUserID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Delete each document found
        doc.reference.delete();
      });
    }).catchError((error) {
      // Handle errors here
      print("Error deleting document: $error");
    });
  }

  Future<bool> updatePreferences(
      int minAge, int maxAge, String gender, String address) async {
    String uid = _auth.currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('f_user')
          .doc(uid)
          .collection("preferences")
          .doc(uid)
          .update({
        'ageRange': {
          'min': minAge,
          'max': maxAge,
        },
        'gender': gender,
        'address': address,
      });

      // DocumentReference preferencesDoc = _firestore
      //     .collection('users')
      //     .doc(userId)
      //     .collection('preferences')
      //     .doc(userId);

      // await preferencesDoc.update({
      //   'ageRange': {
      //     'min': minAge,
      //     'max': maxAge,
      //   },
      //   'gender': gender,
      //   'address': address,
      // });
      print("updated ");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> updateUserProfilePicture({
    required String userId,
    required File newProfilePic,
  }) async {
    try {
      String newImagePath = 'profile_pictures/$userId.jpg';
      Reference newStorageReference = _storage.ref().child(newImagePath);

      DocumentSnapshot userDoc =
          await _firestore.collection('f_user').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('profile_url')) {
          String oldProfileUrl = userData['profile_url'];
          Reference oldStorageReference = _storage.refFromURL(oldProfileUrl);

          await oldStorageReference.delete();
          print("Previous profile picture deleted successfully.");
        }
      }

      await newStorageReference.putFile(newProfilePic);
      String newDownloadURL = await newStorageReference.getDownloadURL();

      await _firestore.collection('f_user').doc(userId).update({
        'profile_url': newDownloadURL,
      });

      print(
          "Profile picture uploaded and updated successfully. Download URL: $newDownloadURL");
      return 1;
    } catch (e) {
      print("Error updating profile picture: $e");
      return 0;
    }
  }
}
