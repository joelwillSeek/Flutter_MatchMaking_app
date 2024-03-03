import 'package:fire/other/pages/bottomSheetContent.dart';
import 'package:fire/other/pages/screens/bio.dart';
import 'package:fire/services/FirestoreFetcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tinder_swipe/flutter_tinder_swipe.dart';
//import 'package:fire/data/explore_json.dart';
import 'package:fire/theme/colors.dart';
import 'package:like_button/like_button.dart';

import '../../services/FirebaseService.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Person> itemsTemp = [];
  int itemLength = 0;
  int i = 0;
  String? _selectedGender;
  final CardController cardController = CardController();
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _fetchUsersAndProfiles();
  }

  Future<void> _fetchUsersAndProfiles() async {
    final fetcher = FirestoreFetcher();
    final data = await fetcher.fetchUsersAndProfiles();
    setState(() {
      itemsTemp = data;
      itemLength = data.length;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    cardController.swipeRight();

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Addis Ababa',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle settings button tap
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FilterBottomSheet(
                          selectedGender: _selectedGender ?? '',
                          onGenderSelected: (selectedGender) {
                            setState(() {
                              _selectedGender = selectedGender;
                            });
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 120,
            child: itemsTemp.isEmpty
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitPouringHourGlassRefined(
                        size: 100.0,
                        color: Color.fromARGB(255, 204, 72, 89),
                      ),
                      Text(
                        "please wait a few minute...",
                        style: TextStyle(
                            color: Color.fromARGB(212, 250, 78, 101),
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ],
                  ))
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Info()),
                      );
                    },
                    child: SwipeCard(
                      cardController: cardController,
                      totalNum: itemLength,
                      maxWidth: MediaQuery.of(context).size.width * 0.85,
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                      minWidth: MediaQuery.of(context).size.width * 0.75,
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                      cardBuilder: (context, index) {
                        i = index;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          itemsTemp[index].profileImageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        black.withOpacity(0.25),
                                        black.withOpacity(0),
                                      ],
                                      end: Alignment.topCenter,
                                      begin: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          itemsTemp[index].firstName,
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          itemsTemp[index].lastName,
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: green,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Recently Active",
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          children: List.generate(
                                            2,
                                            (indexLikes) => Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: white.withOpacity(0.4),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 3,
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                "bole,yeka",
                                                style: TextStyle(color: white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        if (align.x < 0) {
                          //Card is LEFT swiping
                          // print("disliked: ${itemsTemp[i].firstName}");
                        } else if (align.x > 0) {
                          //Card is RIGHT swiping
                          // print("liked: ${itemsTemp[i].firstName}");
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        if (orientation == CardSwipeOrientation.LEFT) {
                          // print("disliked: ${itemsTemp[index].firstName}");
                          User? user = _auth.currentUser;
                          String userId = user!.uid;
                          firebaseService.addDisLike(
                              DislikedUserID: itemsTemp[i].user_id,
                              DislikerID: userId);
                          if (itemsTemp.length - 1 == i) {
                            showMessage();
                          }
                        } else if (orientation == CardSwipeOrientation.RIGHT) {
                          // print("liked: ${itemsTemp[index].firstName}");
                          User? user = _auth.currentUser;
                          String userId = user!.uid;
                          firebaseService.addLike(
                            likedUserID: itemsTemp[i].user_id,
                            likerID: userId,
                          );
                          firebaseService.Request(
                              a_user: itemsTemp[i].user_id, r_user: userId);
                          if (itemsTemp.length - 1 == i) {
                            showMessage();
                          }
                        }
                      },
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(color: white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Dislike action
                        cardController.swipeLeft();
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cardController.swipeRight();
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: LikeButton(
                          onTap: onLikeButtonTapped,
                          size: 40,
                          circleColor: const CircleColor(
                            start: Colors.pink,
                            end: Colors.white,
                          ),
                          likeBuilder: (bool isLiked) {
                            return const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            );
                          },
                          circleSize: 150,
                          bubblesSize: 150,
                          animationDuration: Duration(milliseconds: 2000),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Colors.white,
                            dotSecondaryColor: Colors.red,
                            dotThirdColor: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Like action
                        cardController.swipeRight();
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: Colors.purple,
                        ),
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

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 28, 0),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffe8e6ea)),
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Filter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Interested In:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = 'Girls';
                  });
                },
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedGender == 'Girls'
                        ? Color(0xffe94057)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Girls',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _selectedGender == 'Girls'
                            ? Colors.white
                            : Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = 'Boys';
                  });
                },
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedGender == 'Boys'
                        ? Color(0xffe94057)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Boys',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _selectedGender == 'Boys'
                            ? Colors.white
                            : Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('hello there!😜'),
          backgroundColor: Color.fromARGB(147, 68, 159, 233),
          content: const Text(
            "You have finished viewing all suggestions for now, if you want more adjust your filter. We hope you are satisfied. Thank you, habeshaly.",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
