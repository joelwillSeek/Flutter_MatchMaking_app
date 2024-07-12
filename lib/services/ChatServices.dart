import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
    String receiverID,
    String message, {
    File? photo,
  }) async {
    try {
      final String currentUserID = _firebaseAuth.currentUser!.uid;
      final Timestamp timestamp = Timestamp.now();
      String? photoURL;

      if (photo != null) {
        final photoRef = FirebaseStorage.instance
            .ref()
            .child('chat_photos')
            .child('$currentUserID${DateTime.now()}.jpg');
        final uploadTask = photoRef.putFile(photo);
        await uploadTask.whenComplete(() async {
          photoURL = await photoRef.getDownloadURL();
        });
      }

      Message newMessage = Message(
        senderID: currentUserID,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
        photoURL: photoURL,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join("_");

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Stream<List<Message>> getMessages(String userID, String otherUserID) {
    try {
      List<String> ids = [userID, otherUserID];
      ids.sort();
      String chatRoomID = ids.join("_");

      // Update isSeen field for received messages
      _updateIsSeenField(chatRoomID);

      return _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
    } catch (error) {
      print("Error getting messages: $error");
      return Stream.empty();
    }
  }

  Future<void> _updateIsSeenField(String chatRoomID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    QuerySnapshot querySnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverID', isEqualTo: currentUserID)
        .where('isSeen', isEqualTo: false)
        .get();

    List<DocumentSnapshot> docs = querySnapshot.docs;
    docs.forEach((doc) {
      _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .doc(doc.id)
          .update({'isSeen': true});
    });
  }

  Future<void> deleteMessage(Message message) async {
    try {
      // Determine chat room ID
      List<String> ids = [message.senderID, message.receiverID];
      ids.sort();
      String chatRoomID = ids.join("_");

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .where('senderID', isEqualTo: message.senderID)
          .where('receiverID', isEqualTo: message.receiverID)
          .where('message', isEqualTo: message.message)
          .where('timestamp', isEqualTo: message.timestamp)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (error) {
      print("Error deleting message: $error");
    }
  }

  Stream<Message?> streamLastChat(String currentUserID, String otherUserID) {
    try {
      List<String> ids = [currentUserID, otherUserID];
      ids.sort();
      String chatRoomID = ids.join("_");

      return _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return null;
        }

        return Message.fromFirestore(querySnapshot.docs.first);
      });
    } catch (error) {
      print("Error streaming last chat: $error");
      return Stream.value(null);
    }
  }

  Stream<List<Message>> streamNewMessages(String userID, String otherUserID) {
    try {
      List<String> ids = [userID, otherUserID];
      ids.sort();
      String chatRoomID = ids.join("_");

      return _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .where('receiverID', isEqualTo: userID)
          .where('isSeen', isEqualTo: false)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
    } catch (error) {
      print("Error streaming new messages: $error");
      return Stream.value([]);
    }
  }
}
