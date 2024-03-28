import 'dart:async';

import 'package:fire/model/message.dart';
import 'package:fire/services/ChatServices.dart';
<<<<<<< HEAD
import 'package:fire/services/FirebaseService.dart';
=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../manager/ChatFriendProvider.dart';
import '../services/FirestoreFetcher.dart';
import 'chat_room.dart';

class ChatHome extends StatelessWidget {
<<<<<<< HEAD
  ChatHome({Key? key}) : super(key: key);
=======
  const ChatHome({Key? key}) : super(key: key);
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76

  Future<void> _refresh(BuildContext context) {
    return Future.delayed(
      Duration(seconds: 5),
      () {
        Provider.of<ChatFriendProvider>(context, listen: false)
            .fetchChatFriends();
      },
    );
  }

<<<<<<< HEAD
  final FirebaseService _firebaseService = FirebaseService();
  Future<bool> _deleteFriend(
      BuildContext context, String toBeDeletedUserID) async {
    try {
      await _firebaseService.deleteChatFriend(toBeDeletedUserID);
      return true;
    } catch (error) {
      return false;
    }
  }

=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Consumer<ChatFriendProvider>(
          builder: (context, provider, child) {
            if (!provider.isFetching && provider.chatFriends.isEmpty) {
              provider.fetchChatFriends();
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.isFetching && provider.chatFriends.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // Sort the list based on the last clicked time
              provider.chatFriends
                  .sort((a, b) => b.lastClicked.compareTo(a.lastClicked));

              return RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: ListView.builder(
                  itemCount: provider.chatFriends.length,
                  itemBuilder: (context, index) {
                    final friend = provider.chatFriends[index];
                    return ChatListItem(
                      friend: friend,
                      onTap: () {
                        friend.lastClicked = DateTime.now();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(friend: friend),
                          ),
                        );
                      },
<<<<<<< HEAD
                      onDeletePressed: () async {
                        // Implement delete logic here
                        // For now, just show a confirmation dialog
                        bool? deleted = await showDialog<bool>(
=======
                      onDeletePressed: () {
                        // Implement delete logic here
                        // For now, just show a confirmation dialog
                        showDialog(
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Chat"),
                              content: Text(
<<<<<<< HEAD
                                  "Are you sure you want to delete this chat? You will never match with this user again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // Cancelled
=======
                                  "Are you sure you want to delete this chat?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
<<<<<<< HEAD
                                  onPressed: () async {
                                    bool deletionResult = await _deleteFriend(
                                        context, friend.user_id);
                                    Navigator.of(context).pop(deletionResult);
=======
                                  onPressed: () {
                                    // Perform delete action
                                    // Add your logic here
                                    Navigator.of(context).pop();
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
<<<<<<< HEAD

                        if (deleted!) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'chat deleted successfully',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          provider.removeChatFriend(friend);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete chat'),
                            ),
                          );
                        }
=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ChatListItem extends StatefulWidget {
  final Person friend;
  final VoidCallback onTap;
  final VoidCallback onDeletePressed;

  const ChatListItem({
    Key? key,
    required this.friend,
    required this.onTap,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

<<<<<<< HEAD
class _ChatListItemState extends State<ChatListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  bool isOnline = false; // Initially set to false
  String? lastChat; // Holds the last chat message
  String subtitleText = 'no Recent chat'; // Default subtitle text
  bool isNewMessage = false;
=======
class _ChatListItemState extends State<ChatListItem> {
  bool isOnline = false; // Initially set to false
  String? lastChat; // Holds the last chat message
  String subtitleText = 'no Recent chat'; // Default subtitle text
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
  final ChatServices _chatServices = ChatServices();
  late StreamSubscription<Message?> _lastChatSubscription;
  late StreamSubscription<List<Message>> _newMessageSubscription;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _colorAnimation = _controller.drive(TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.red, end: Colors.blue),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.blue, end: Colors.yellow),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.yellow, end: Colors.red),
          weight: 1,
        ),
      ],
    ));

    _controller.repeat();

=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
    // Listen to changes in the friend's online status
    FirestoreFetcher()
        .streamOnlineStatus(widget.friend.user_id)
        .listen((isOnline) {
      setState(() {
        this.isOnline = isOnline;
      });
    });
    // Listen for new messages
    _newMessageSubscription = _chatServices
        .streamNewMessages(
      FirebaseAuth.instance.currentUser!.uid,
      widget.friend.user_id,
    )
        .listen((messages) {
      if (messages.isNotEmpty) {
        setState(() {
          final lastMessage = messages.first;
          if (lastMessage.photoURL != null) {
            subtitleText = '📷 New photo';
          } else {
            subtitleText = '♨️ New message';
          }
<<<<<<< HEAD
          lastChat = lastMessage.message; // Update last chat with new message
          _controller.reset(); // Reset animation controller
          _controller.repeat(); // Start animation
          isNewMessage = true; // Start color animation
=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
        });
      }
    });
    // Stream and set the last chat message
    _lastChatSubscription = _chatServices
        .streamLastChat(
      FirebaseAuth.instance.currentUser!.uid,
      widget.friend.user_id,
    )
        .listen((message) {
      setState(() {
<<<<<<< HEAD
        updateSubtitle(message);
        isNewMessage = false; // Update subtitle based on last message
=======
        lastChat = message?.message;
        updateSubtitle(message);
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
      });
    });
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _controller.dispose();
=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
    _lastChatSubscription.cancel();
    _newMessageSubscription.cancel();
    super.dispose();
  }

  // Update the subtitle based on the last message
  void updateSubtitle(Message? message) {
    if (message == null) {
      subtitleText = 'no Recent chat';
    } else if (message.photoURL != null) {
      subtitleText = '📷 Photo';
    } else {
      subtitleText = message.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
<<<<<<< HEAD
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friend.profileImageUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? Colors.green : Colors.red,
                ),
=======
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.friend.profileImageUrl),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.friend.firstName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Dot indicator for online status
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? Colors.green : Colors.red,
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
              ),
            ),
          ],
        ),
<<<<<<< HEAD
        title: Text(
          widget.friend.firstName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return isNewMessage
                ? Text(
                    subtitleText,
                    style: TextStyle(
                      color: _colorAnimation.value,
                    ),
                  )
                : Text(subtitleText);
          },
        ),
=======
        subtitle: Text(subtitleText),
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: ListTile(
                title: Text("Delete"),
                onTap: widget.onDeletePressed,
              ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
