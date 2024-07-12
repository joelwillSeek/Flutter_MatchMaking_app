import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire/chat/chat_home.dart';
import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/model/message.dart';
import 'package:fire/services/ChatServices.dart';
import 'package:fire/services/FirestoreFetcher.dart';
import 'package:fire/services/NotificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final Person friend;
  const ChatRoom({Key? key, required this.friend}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final notificationService = NotificationService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  File? _image;
  void sendMessage() async {
    if (messageController.text.isNotEmpty || _image != null) {
      await _chatServices.sendMessage(
        widget.friend.user_id,
        messageController.text,
        photo: _image,
      );

      Future.delayed(Duration(milliseconds: 2), () {
        messageController.clear();
        setState(() {
          _image = null;
        });
      });
    }
  }

  void sendNotification(BuildContext context, String receiverToken,
      String message, String profile, String senderName) async {
    notificationService.sendChatNotification(
        receiverToken, profile, message, senderName);
  }

  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    FirestoreFetcher()
        .streamOnlineStatus(widget.friend.user_id)
        .listen((isOnline) {
      setState(() {
        this.isOnline = isOnline;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 60.0, right: 10.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatHome()));
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Color(0xFFE94057),
                  ),
                ),
                SizedBox(width: 16.0),
                // Example circular profile image
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(widget.friend.profileImageUrl),
                ),
                SizedBox(width: 16.0),
                Text(
                  widget.friend.firstName,
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.green : Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8.0),
                // Online/Offline indicator
                _buildOnlineIndicator(isOnline),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _buildMessageList(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                        final me = UserDataManager().me!;
                        sendNotification(
                            context,
                            widget.friend.deviceToken,
                            messageController.text,
                            me.profileUrl,
                            me.firstName);
                      },
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  _image = File(pickedFile.path);
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SelectedImageDialog(
                                      imageFile: _image!,
                                      onSend: () {
                                        sendMessage();
                                        final me = UserDataManager().me!;
                                        sendNotification(
                                            context,
                                            widget.friend.deviceToken,
                                            "sent new photo",
                                            me.profileUrl,
                                            me.firstName);
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            icon: Icon(Icons.image_rounded),
                            color: Color(0xFFE94057),
                          ),
                          Icon(
                            Icons.send_rounded,
                            color: Color(0xFFE94057),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineIndicator(bool isOnline) {
    return Row(
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(width: 4.0),
        Text(
          isOnline
              ? 'Online'
              : 'Last seen ${_lastSeenText(widget.friend.timestamp)}',
          style: TextStyle(
            color: isOnline ? Colors.green : Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _lastSeenText(Timestamp? lastSeen) {
    if (lastSeen == null) {
      return 'recently';
    }

    Timestamp now = Timestamp.now();
    Duration difference = Duration(seconds: now.seconds - lastSeen.seconds);

    if (difference.inDays == 0) {
      return 'recently';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return 'within a week';
    } else {
      return 'long time ago';
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _chatServices.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.friend.user_id,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Waiting for connection"));
        }

        // Sort the messages based on timestamp
        List<Message> sortedMessages = snapshot.data!;
        sortedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        List<Widget> messageItems = sortedMessages
            .map((message) => _buildMessageItem(message))
            .toList();

        return Column(
          children: messageItems,
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    var alignment = (message.senderID == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    IconData? statusIcon;
    if (message.senderID == _firebaseAuth.currentUser!.uid) {
      statusIcon = (message.isSeen == true)
          ? Icons.mark_chat_read
          : Icons.mark_chat_unread;
    }

    return GestureDetector(
      onTap: () {
        _showDeleteOption(context, message);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: (alignment == MainAxisAlignment.end)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.photoURL != null) // Check if message has a photo
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Image.network(
                      message.photoURL!, // Display photo from URL
                      fit: BoxFit.cover,
                    ),
                  ),
                if (message.message.isNotEmpty) // Check if message has text
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: message.senderID == _firebaseAuth.currentUser!.uid
                          ? Color(0xFFF3F3F3)
                          : Color(0xFFFDF1F3),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _formatTimeStamp(message.timestamp),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (statusIcon != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  statusIcon,
                  size: 16.0,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteOption(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Message"),
          content: Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Remove the message from the database
                _chatServices.deleteMessage(message);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

// Function to format timestamp
  String _formatTimeStamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime =
        DateFormat('h:mm a').format(dateTime); // Format: h:mm a
    return formattedTime;
  }
}

class SelectedImageDialog extends StatelessWidget {
  final File imageFile;
  final VoidCallback onSend;

  SelectedImageDialog({
    required this.imageFile,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(imageFile),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  onSend();
                  Navigator.pop(context);
                },
                child: Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
