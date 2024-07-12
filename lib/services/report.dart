import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Report {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> submitReport({
    required String name,
    required String statement,
    required String platform,
    Uint8List? screenshot,
  }) async {
    String c_userID = _auth.currentUser!.uid;
    String? c_userEmail = _auth.currentUser!.email;
    await _storeReport(
        userId: c_userID,
        email: c_userEmail,
        platform: platform,
        Name: name,
        statement: statement);

    if (screenshot != null) {
      await _storeReportScreenShot(userId: c_userID, profilePic: screenshot);
    }
  }

  Future<void> _storeReport({
    required String userId,
    required String? email,
    required String platform,
    required String Name,
    required String statement,
  }) async {
    try {
      await _firestore.collection('Report').doc(userId).set({
        'Reported_By': Name,
        'problem': statement,
        'platform': platform,
        'email': email,
        'user_id': userId,
        'screenshot': '',
        'Reported_On': Timestamp.now(),
      });
      print("report submited successfully!");
    } catch (e) {
      print("Error storing user details: $e");
    }
  }

  Future<void> _storeReportScreenShot({
    required String userId,
    required Uint8List profilePic,
  }) async {
    try {
      String imagePath = 'Report_screenshot/$userId.jpg';
      Reference storageReference = _storage.ref().child(imagePath);

      await storageReference.putData(profilePic);

      String downloadURL = await storageReference.getDownloadURL();

      await _firestore.collection('Report').doc(userId).update({
        'screenshot': downloadURL,
      });

      print(
          "Report ScreenShot uploaded successfully. Download URL: $downloadURL");
    } catch (e) {
      print("Error uploading profile picture: $e");
    }
  }

  Future<bool> reportAbuse(
      {required String reporterName,
      required String accusedFullName,
      required String accusedUID,
      required String reason}) async {
    try {
      String c_userID = _auth.currentUser!.uid;
      String? c_userEmail = _auth.currentUser!.email;
      await _firestore.collection('Report').doc(c_userID).set({
        'Reported_By': reporterName,
        'problem': reason,
        'ReporterUID': c_userID,
        'email': c_userEmail,
        'accused_UserFullName': accusedFullName,
        'accusedUID': accusedUID,
        'Reported_On': Timestamp.now(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
