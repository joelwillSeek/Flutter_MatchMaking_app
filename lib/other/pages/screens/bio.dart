import 'package:fire/manager/SettingsProvider.dart';
import 'package:fire/manager/UserDataManager.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/services/FirestoreFetcher.dart';
import 'package:fire/services/NotificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Info extends StatefulWidget {
  Person selectedPerson;
  final Function(bool) done;
  Info({
    Key? key,
    required this.selectedPerson,
    required this.done,
  }) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> with TickerProviderStateMixin {
  bool _showHeart = false;
  //bool _finn = false;
  int count = 0;
  late String msg;
  FirebaseService firebaseService = FirebaseService();
  final notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final me = UserDataManager().me!;

  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller!)
          ..addListener(() {
            setState(() {});
          });

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -30),
    ).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
  }

  void liked() async {
    if (count < 1) {
      firebaseService.addLike(
        likedUserID: widget.selectedPerson.user_id,
        likerID: _auth.currentUser!.uid,
      );
      firebaseService.Request(
          a_user: widget.selectedPerson.user_id,
          r_user: _auth.currentUser!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Liked🤩',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      msg = 'you already Liked this user😎';
      sendNotification(context, widget.selectedPerson.deviceToken, me.firstName,
          me.profileUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 175, 76, 101),
        ),
      );
    }
    setState(() {
      count++;
    });
  }

  void disliked() async {
    if (count < 1) {
      firebaseService.addDisLike(
          DislikedUserID: widget.selectedPerson.user_id,
          DislikerID: _auth.currentUser!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'disLiked👎',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      msg = 'you already disliked this user🥱';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 175, 76, 101),
        ),
      );
    }
    setState(() {
      count++;
    });
  }

  void _triggerHeartAnimation() {
    print("triggred");
    setState(() {
      if (count < 1) {
        liked();
        count++;
      }
      _showHeart = true;
    });
    _controller?.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showHeart = false;
        });
      });
    });
  }

  void sendNotification(BuildContext context, String receiverToken,
      String matchedName, String profile) async {
    notificationService.sendMatchNotification(
        receiverToken, profile, matchedName);
  }

  @override
  void dispose() {
    _controller?.dispose();
    count = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);
    String city = widget.selectedPerson.address;
    List<String> cty = city.split(",");
    city = cty[0];
    int wordCount = city.split(' ').length;
    if (wordCount > 4) {
      city = city.split(' ').sublist(0, 5).join(' ');
    }
    double fem = 1.0;
    double ffem = 0.8;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 900 * fem,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                GestureDetector(
                  onDoubleTap: _triggerHeartAnimation,
                  child: Positioned(
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          40 * fem, 44 * fem, 40 * fem, 44 * fem),
                      width: 375 * fem,
                      height: 415 * fem,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              widget.selectedPerson.profileImageUrl),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 243 * fem, 275 * fem),
                            padding:
                                EdgeInsets.all(8 * fem), // Adjusted padding
                            width: 52 * fem,
                            height: 52 * fem,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffe8e6ea)),
                              color: Color(0x33ffffff),
                              borderRadius: BorderRadius.circular(15 * fem),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (count > 0) {
                                    widget.done(true);
                                  }
                                });
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 24 * fem,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (_showHeart)
                            Center(
                              child: Transform.translate(
                                offset: _positionAnimation!.value,
                                child: Transform.scale(
                                  scale: _scaleAnimation!.value,
                                  child: Opacity(
                                    opacity: _opacityAnimation!.value,
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 80 * fem,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (_showGIF)
                //   Positioned(
                //     top: 100,
                //     left: 70,
                //     child: Container(
                //       width: 200 * fem,
                //       height: 200 * fem,
                //       child: Image.asset('assets/images/urban-dog.gif'),
                //     ),
                //   ),
                Positioned(
                  left: 0 * fem,
                  top: 386 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 375 * fem,
                      height: 939 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30 * fem),
                            topRight: Radius.circular(30 * fem),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Add other Positioned widgets with updated image paths here
                Positioned(
                  // interests2eT (309:5938)
                  left: 40 * fem,
                  top: 691 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 108 * fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interests',
                          style: GoogleFonts.lora(
                            fontSize: 17 * ffem,
                            fontWeight: FontWeight.w900,
                            height: 1.5 * ffem / fem,
                            color: Color(0xffe94057),
                          ),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          child: Wrap(
                            spacing: 10 * fem,
                            runSpacing: 10 * fem,
                            children:
                                widget.selectedPerson.interests.map((interest) {
                              return Container(
                                width: (295 - 20) * fem / 3,
                                height: 32 * fem,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: themeProvider.isDarkMode
                                      ? Colors.black12
                                      : Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    interest.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // aboutYib (309:5957)
                  left: 40 * fem,
                  top: 619 * fem,
                  child: Container(
                    width: 279 * fem,
                    height: 118 * fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // aboutTKm (309:5960)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 5 * fem),
                          child: Text(
                            'About',
                            style: GoogleFonts.lora(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w900,
                              height: 1.5 * ffem / fem,
                              color: Color(0xffe94057),
                            ),
                          ),
                        ),
                        Container(
                          // iamgraphicsdesignerandiwanttom (309:5959)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 26 * fem),
                          constraints: BoxConstraints(
                            maxWidth: 279 * fem,
                          ),
                          child: Text(
                            "'- ${widget.selectedPerson.bio}'",
                            style: GoogleFonts.inter(
                              fontSize: 17 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5 * ffem / fem,
                              color: Color(0xffe94057),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // locationoY3 (309:5961)
                  left: 40 * fem,
                  top: 529 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 50 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // autogroup9xm9Xiw (TgkL6zyhxYdkLZFKkV9Xm9)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 80 * fem, 0 * fem),
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // locationFuq (309:5967)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                child: Text(
                                  'Location',
                                  style: GoogleFonts.lora(
                                    fontSize: 17 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xffe94057),
                                  ),
                                ),
                              ),
                              Text(
                                // boleaddisababanes (309:5966)
                                widget.selectedPerson.address,
                                style: GoogleFonts.inter(
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xffe94057),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // locationiconvm5 (309:5962)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 16 * fem),
                          padding: EdgeInsets.fromLTRB(
                              15.04 * fem, 8 * fem, 15 * fem, 8 * fem),
                          decoration: BoxDecoration(
                            color: Color(0x19e94057),
                            borderRadius: BorderRadius.circular(7 * fem),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // Adjusted this line
                            children: [
                              Container(
                                // localtwoEFy (309:5965)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 3.04 * fem, 0 * fem),
                                child: Icon(Icons.location_on_outlined,
                                    size: 24, color: Color(0xffe94057)),
                              ),
                              Text(
                                // bole8cF (309:5964)
                                city,
                                style: GoogleFonts.lora(
                                  fontSize: 17 * ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5 * ffem / fem,
                                  color: Color(0xffe94057),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // name5XV (309:5968)
                  left: 40 * fem,
                  top: 476 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 56 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // autogroupxpytbkj (TgkLLKvqMy4yGcVXTYXPYT)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 18 * fem, 0 * fem),
                          width: 225 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // selamyohannes29nqD (309:5973)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 225 * fem,
                                    height: 36 * fem,
                                    child: Text(
                                      '${widget.selectedPerson.firstName} ${widget.selectedPerson.lastName}, ${widget.selectedPerson.age}',
                                      style: GoogleFonts.lora(
                                        fontSize: 24 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5 * ffem / fem,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //start

                //end
                Positioned(
                  // buttons7m1 (309:5974)
                  left: 40 * fem,
                  top: 337 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 99 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 10 * fem, 0 * fem, 11 * fem),
                          padding: EdgeInsets.all(31.5 * fem),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(39 * fem),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x11000000),
                                offset: Offset(0 * fem, 20 * fem),
                                blurRadius: 25 * fem,
                              ),
                            ],
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                disliked();
                              },
                              child: Transform.scale(
                                scale:
                                    2.0, // Increase the scale factor as needed
                                child: Icon(Icons.close,
                                    size: 15 * fem,
                                    color:
                                        Color(0xFFF27121) // Original icon size
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        Container(
                          // likeoXM (309:5975)
                          padding: EdgeInsets.fromLTRB(28.25 * fem, 32.5 * fem,
                              28.25 * fem, 30.03 * fem),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffe94057),
                            borderRadius: BorderRadius.circular(49.5 * fem),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x33e94057),
                                offset: Offset(0 * fem, 15 * fem),
                                blurRadius: 7.5 * fem,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: liked,
                            child: Center(
                              // like7H9 (309:5977)
                              child: SizedBox(
                                width: 42.5 * fem,
                                height: 36.47 * fem,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20 * fem,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 10 * fem, 0 * fem, 11 * fem),
                          padding: EdgeInsets.all(31.5 * fem),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(39 * fem),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x11000000),
                                offset: Offset(0 * fem, 20 * fem),
                                blurRadius: 25 * fem,
                              ),
                            ],
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                liked();
                              },
                              child: Transform.scale(
                                scale: 2.0,
                                child: Icon(Icons.star,
                                    size: 15 * fem, color: Color(0xFF8A2387)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
