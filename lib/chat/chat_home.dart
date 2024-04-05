import 'dart:async';

import 'package:fire/model/message.dart';
import 'package:fire/services/ChatServices.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../manager/ChatFriendProvider.dart';
import '../services/FirestoreFetcher.dart';
import 'chat_room.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  late ChatFriendProvider _chatFriendProvider;

  @override
  void initState() {
    super.initState();
    _chatFriendProvider =
        Provider.of<ChatFriendProvider>(context, listen: false);
    _fetchFriendIfNeeded();
  }

  void _fetchFriendIfNeeded() {
    if (!_chatFriendProvider.isFetching &&
        _chatFriendProvider.chatFriends.isEmpty) {
      _chatFriendProvider.fetchChatFriends();
    }
  }

  Future<void> _refresh(BuildContext context) async {
    await _chatFriendProvider.fetchChatFriends();
  }

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
            provider.chatFriends
                .sort((a, b) => b.lastClicked.compareTo(a.lastClicked));
            // Display loading spinner if fetching
            if (provider.isFetching) {
              return Center(
                child: SpinKitWave(
                  size: 50.0,
                  color: Color(0xFFE94057),
                ),
              );
            }

            // Display chat list if available
            if (provider.chatFriends.isNotEmpty) {
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
                      onDeletePressed: () async {
                        bool? deleted = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Chat"),
                              content: Text(
                                  "Are you sure you want to delete this chat? You will never match with this user again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool deletionResult = await _deleteFriend(
                                        context, friend.user_id);
                                    Navigator.of(context).pop(deletionResult);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );

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
                      },
                    );
                  },
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/bubble-gum-error-404.gif'),
                  Text(
                    'No chat found, oops! 😕',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
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

class _ChatListItemState extends State<ChatListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  bool isOnline = false; // Initially set to false
  String? lastChat; // Holds the last chat message
  String subtitleText = 'no Recent chat'; // Default subtitle text
  bool isNewMessage = false;
  final ChatServices _chatServices = ChatServices();
  late StreamSubscription<Message?> _lastChatSubscription;
  late StreamSubscription<List<Message>> _newMessageSubscription;

  @override
  void initState() {
    super.initState();
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
          lastChat = lastMessage.message; // Update last chat with new message
          _controller.reset(); // Reset animation controller
          _controller.repeat(); // Start animation
          isNewMessage = true; // Start color animation
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
        updateSubtitle(message);
        isNewMessage = false; // Update subtitle based on last message
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
              ),
            ),
          ],
        ),
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
