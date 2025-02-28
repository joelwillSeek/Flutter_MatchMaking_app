// import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/manager/ChangeNotifier.dart';
import 'package:fire/manager/MatchmakingProvider.dart';
import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/manager/UserDataManager.dart';
// import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/other/pages/bottomSheetContent.dart';
import 'package:fire/other/pages/screens/bio.dart';
import 'package:fire/services/FirestoreFetcher.dart';
import 'package:fire/services/MatchmakingService.dart';
import 'package:fire/services/NotificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:flutter_tinder_swipe/flutter_tinder_swipe.dart';
//import 'package:fire/data/explore_json.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fire/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

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
  final notificationService = NotificationService();

  final CardSwiperController _cardSwiperController = CardSwiperController();

  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchmakingProvider>(context, listen: false).fetchMatches();
      // final profileProvider = Provider.of<ProfileProvider>(context);
    });
    // _fetchUsersAndProfiles();
  }

  Future<void> _fetchUsersAndProfiles() async {
    final fetcher = MatchmakingService();
    final data = await fetcher
        .getRankedPotentialMatches(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      itemsTemp = data;
      itemLength = data.length;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    // cardController.swipeRight();
    return !isLiked;
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void sendNotification(BuildContext context, String receiverToken,
      String matchedName, String profile) async {
    notificationService.sendMatchNotification(
        receiverToken, profile, matchedName);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);

    // final profileProvider =
    //     Provider.of<ProfileProvider>(context, listen: false);
    // final me = UserDataManager().me!;

    // if (profileProvider.isError) {
    //   print("error");
    // }
    return Scaffold(
      body: Consumer<MatchmakingProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return loading();
        } else if (provider.errorMessage.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showMessage(provider.errorMessage);
          });
          return Stack(
            children: [
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    exploreTextWidget(),
                    searchFilterBottomSheet(context, provider, themeProvider),
                  ],
                ),
              ),
              helpfulTip(),
            ],
          );
        } else if (provider.matches.isEmpty) {
          return Stack(
            children: [
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          exploreTextWidget(),
                          searchFilterBottomSheet(
                              context, provider, themeProvider),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              noMatchTextWidget(),
            ],
          );
        } else {
          return Stack(
            children: [
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    exploreTextWidget(),
                    searchFilterBottomSheet(context, provider, themeProvider),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                bottom: 120,
                child: provider.matches.isEmpty
                    ? plsWaitWidget()
                    : GestureDetector(
                        onTap: () {
                          goToInfopage(context, provider);
                        },
                        child: CardSwiper(
                          controller: _cardSwiperController,
                          cardsCount: provider.matches.length,
                          numberOfCardsDisplayed: provider.matches.length > 3
                              ? 3
                              : provider.matches.length,
                          // maxWidth: MediaQuery.of(context).size.width * 0.85,
                          // maxHeight: MediaQuery.of(context).size.height * 0.7,
                          // minWidth: MediaQuery.of(context).size.width * 0.75,
                          // minHeight: MediaQuery.of(context).size.height * 0.6,
                          cardBuilder: (context, index, horizontalThreshold,
                              verticalThreshold) {
                            i = index;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withValues(alpha: 0.3),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    profileImageWidget(provider, index),
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            black.withValues(alpha: 0.25),
                                            black.withValues(alpha: 0),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            firstNameWidget(provider, index),
                                            SizedBox(height: 5),
                                            lastNameWidget(provider, index),
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
                                                recentlyActiveTextWidget(),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Wrap(
                                              spacing: 8,
                                              children: List.generate(
                                                1,
                                                (indexLikes) => Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: white,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: white.withValues(
                                                        alpha: .4),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 10,
                                                  ),
                                                  child: Text(
                                                    "Age ${provider.matches[i].age}",
                                                    style:
                                                        TextStyle(color: white),
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
                          // swipeUpdateCallback:
                          //     (DragUpdateDetails details, Alignment align) {
                          //   if (align.x < 0) {
                          //     //Card is LEFT swiping
                          //     // print("disliked: ${itemsTemp[i].firstName}");
                          //   } else if (align.x > 0) {
                          //     //Card is RIGHT swiping
                          //     // print("liked: ${itemsTemp[i].firstName}");
                          //   }
                          // },
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (direction.name != "left" ||
                                direction.name != "right") return false;
                            if (direction.name == "left") {
                              // print("disliked: ${provider.matches[index].firstName}");
                              User? user = _auth.currentUser;
                              String userId = user!.uid;
                              firebaseService.addDisLike(
                                  DislikedUserID: provider.matches[i].user_id,
                                  DislikerID: userId);
                              // if (itemsTemp.length - 1 == i) {
                              //   showMessage("oups -1== $i");
                              // } //useless

                              return true;
                            } else if (direction.name == "right") {
                              // print("liked: ${provider.matches[index].firstName}");
                              User? user = _auth.currentUser;
                              String userId = user!.uid;
                              firebaseService.addLike(
                                likedUserID: provider.matches[i].user_id,
                                likerID: userId,
                              );
                              firebaseService.Request(
                                  a_user: provider.matches[i].user_id,
                                  r_user: userId);
                              final me = UserDataManager().me!;
                              sendNotification(
                                  context,
                                  provider.matches[i].deviceToken,
                                  me.firstName,
                                  me.profileUrl);
                              // if (itemsTemp.length - 1 == i) {
                              //   showMessage("oups -1== $i");
                              // }//useless

                              return true;
                            }
                            setState(() {
                              provider.matches.removeAt(i);
                            });

                            return false;
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Dislike action
                            _cardSwiperController
                                .swipe(CardSwiperDirection.left);
                          },
                          child: Container(
                            padding: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withValues(alpha: 0.1),
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
                            _cardSwiperController
                                .swipe(CardSwiperDirection.right);
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
                            _cardSwiperController
                                .swipe(CardSwiperDirection.right);
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
          );
        }
      }),
    );
  }

  Text recentlyActiveTextWidget() {
    return Text(
      "Recently Active",
      style: TextStyle(
        color: white,
        fontSize: 14,
      ),
    );
  }

  Text lastNameWidget(MatchmakingProvider provider, int index) {
    return Text(
      provider.matches[index].lastName,
      style: TextStyle(
        color: white,
        fontSize: 16,
      ),
    );
  }

  Text firstNameWidget(MatchmakingProvider provider, int index) {
    return Text(
      provider.matches[index].firstName,
      style: TextStyle(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container profileImageWidget(MatchmakingProvider provider, int index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(provider.matches[index].profileImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void goToInfopage(BuildContext context, MatchmakingProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Info(
                selectedPerson: provider.matches[i],
                done: (value) {
                  if (value) {
                    setState(() {
                      provider.matches.removeAt(i);
                    });
                  }
                },
              )),
    );
  }

  Center plsWaitWidget() {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitPumpingHeart(
          size: 100.0,
          color: Color.fromARGB(255, 204, 72, 89),
        ),
        Text(
          "please wait a few minute...",
          style: TextStyle(
              color: Color(0xFFE94057),
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      ],
    ));
  }

  Center noMatchTextWidget() {
    return Center(
      child: Text(
        "No matches available",
        style: TextStyle(
            color: Color(0xFFE94057),
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }

  Column helpfulTip() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset('assets/images/icons8-broken-heart.gif'),
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Adjust your preference🤧!",
                style: GoogleFonts.habibi(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector searchFilterBottomSheet(BuildContext context,
      MatchmakingProvider provider, SettingsProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return FilterBottomSheet(
              // me: me,
              update: false,
              onUpdated: (onUpdated) {
                if (onUpdated) {
                  print("updating $onUpdated");
                  provider.refreshMatches();
                }
              },
              selectedGender: _selectedGender ?? '',
              onGenderSelected: (selectedGender) {
                setState(() {
                  _selectedGender = selectedGender;
                });
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
            color: themeProvider.isDarkMode
                ? const Color.fromARGB(154, 244, 67, 54)
                : Colors.white,
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
            color: themeProvider.isDarkMode ? Colors.white : Colors.red,
          ),
        ),
      ),
    );
  }

  Expanded exploreTextWidget() {
    return const Expanded(
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
          ],
        ),
      ),
    );
  }

  Center loading() {
    return const Center(
      child: SpinKitPumpingHeart(
        size: 100.0,
        color: Color.fromARGB(255, 204, 72, 89),
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

  // void showMessage() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('hello there!😜'),
  //         backgroundColor: Color.fromARGB(147, 68, 159, 233),
  //         content: const Text(
  //           "You have finished viewing all suggestions for now, if you want more adjust your filter. We hope you are satisfied. Thank you, habeshaly.",
  //           style: TextStyle(
  //             fontSize: 14,
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
