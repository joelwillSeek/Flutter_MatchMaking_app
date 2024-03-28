import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String message;
  final Timestamp timestamp;
  final bool? isSeen;
  final String? photoURL; // New field for photo URL

  Message({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    this.isSeen = false,
    this.photoURL, // Initialize with null
  });

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Message(
      senderID: data['senderID'],
      receiverID: data['receiverID'],
      message: data['message'],
      timestamp: data['timestamp'],
      isSeen: data['isSeen'],
      photoURL: data['photoURL'], // Initialize with value from Firestore
    );
  }

  Map<String, dynamic> toMap() => {
        'senderID': senderID,
        'receiverID': receiverID,
        'message': message,
        'timestamp': timestamp,
        'isSeen': isSeen,
        'photoURL': photoURL, // Include photoURL in toMap method
      };
}
