import 'dart:async';

import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/model/message.dart';
import 'package:fire/services/ChatServices.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/services/report.dart';
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
    final themeProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages',
            style: TextStyle(
                fontFamily: 'Merienda',
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey[900])),
        backgroundColor:
            themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Consumer<ChatFriendProvider>(
          builder: (context, provider, child) {
            provider.chatFriends
                .sort((a, b) => b.lastClicked.compareTo(a.lastClicked));

            if (provider.isFetching) {
              return Center(
                child: SpinKitWave(
                  size: 50.0,
                  color: Color(0xFFE94057),
                ),
              );
            }

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
                              content: Text('Chat deletion canceled(402)'),
                            ),
                          );
                        }
                      },
                      onReport: () async {
                        final bool? reportResult = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController _reportController =
                                TextEditingController();
                            bool _isSubmitEnabled = false;

                            void _checkSubmitEnabled() {
                              if (_reportController.text.split(' ').length >=
                                  10) {
                                _isSubmitEnabled = true;
                              } else {
                                _isSubmitEnabled = false;
                              }
                            }

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text("Report on ${friend.firstName}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "Write a description of what you want to report on this user (minimum 10 words)."),
                                      TextField(
                                        controller: _reportController,
                                        maxLines: 5,
                                        onChanged: (text) {
                                          setState(() {
                                            _checkSubmitEnabled();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              "Enter report description...",
                                          errorText: _isSubmitEnabled
                                              ? null
                                              : "Minimum 10 words required",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: _isSubmitEnabled
                                          ? () async {
                                              final me = UserDataManager().me!;
                                              final reporterName =
                                                  "${me.firstName} ${me.lastName}";
                                              final accusedFullName =
                                                  friend.firstName +
                                                      ' ' +
                                                      friend.lastName;
                                              final accusedUID = friend.user_id;
                                              final reason =
                                                  _reportController.text;

                                              bool reportResult =
                                                  await Report().reportAbuse(
                                                reporterName: reporterName,
                                                accusedFullName:
                                                    accusedFullName,
                                                accusedUID: accusedUID,
                                                reason: reason,
                                              );

                                              Navigator.of(context)
                                                  .pop(reportResult);
                                            }
                                          : null,
                                      child: Text("Submit"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );

                        if (reportResult != null && reportResult) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Thanks for reporting, we will review your report.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.deepPurple[400],
                            ),
                          );
                        } else if (reportResult != null && !reportResult) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Report canceled (403)'),
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
  final VoidCallback onReport;
  const ChatListItem(
      {Key? key,
      required this.friend,
      required this.onTap,
      required this.onDeletePressed,
      required this.onReport})
      : super(key: key);

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  final int maxLength = 25;
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
          if (lastMessage.photoURL != null && lastMessage.isSeen == false) {
            print("status of the new msg === ${lastMessage.isSeen}");
            subtitleText = '📷 New photo';
          } else if (lastMessage.isSeen == false) {
            print("status of the new msg === ${lastMessage.isSeen}");
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
    } else if (message.message.length > maxLength) {
      subtitleText = '${message.message.substring(0, maxLength)}...';
    } else {
      subtitleText = message.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);
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
              color:
                  themeProvider.isDarkMode ? Colors.white : Colors.grey[900]),
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
                : Text(
                    subtitleText,
                    style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.grey[900]),
                  );
          },
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert,
              color:
                  themeProvider.isDarkMode ? Colors.white : Colors.grey[900]),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Column(
                children: [
                  ListTile(
                    title: Text("Delete"),
                    onTap: widget.onDeletePressed,
                  ),
                  ListTile(
                    title: Text("Report"),
                    onTap: widget.onReport,
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
