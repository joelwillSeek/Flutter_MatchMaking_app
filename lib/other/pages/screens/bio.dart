import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Assuming the value of 'fem'
    double ffem = 0.8;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 1325 * fem,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Stack(
              children: [
                Positioned(
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
                        image: AssetImage("assets/images/girls/img_5.jpg"),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 243 * fem, 275 * fem),
                      padding: EdgeInsets.all(8 * fem), // Adjusted padding
                      width: 52 * fem,
                      height: 52 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffe8e6ea)),
                        color: Color(0x33ffffff),
                        borderRadius: BorderRadius.circular(15 * fem),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 24 * fem, // Adjust the size as needed
                            color: Colors.white, // Adjust the color as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0 * fem,
                  top: 386 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 375 * fem,
                      height: 939 * fem,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
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
                  top: 791 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 108 * fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // interestskaT (309:5956)
                          'Interests',
                          style: GoogleFonts.lora(
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5 * ffem / fem,
                            color: Color(0xffe94057),
                          ),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        Container(
                          // autogroupvktzsQB (TgkKRbwgjVdrhH8W67vkTZ)
                          width: double.infinity,
                          height: 32 * fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // 52P (309:5945)
                                width: 92 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    'Music',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10 * fem,
                              ),
                              Container(
                                // 52P (309:5945)
                                width: 92 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    'Coding',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 7 * fem,
                              ),
                              Container(
                                // 52P (309:5945)
                                width: 92 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    'Coding',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        Container(
                          // autogroupae7q6y5 (TgkKdBSjBH9kAfXMQkaE7q)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 101 * fem, 0 * fem),
                          width: double.infinity,
                          height: 32 * fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // osV (309:5942)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                width: 92 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    'Dancing',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // GWB (309:5939)
                                width: 92 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffe8e6ea)),
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5 * fem),
                                ),
                                child: Center(
                                  child: Text(
                                    'Modeling',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 14 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xffe94057),
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
                Positioned(
                  // aboutYib (309:5957)
                  left: 40 * fem,
                  top: 643 * fem,
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
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w700,
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
                            'i am graphics designer and i want to make new friend',
                            style: GoogleFonts.inter(
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5 * ffem / fem,
                              color: Color(0xffe94057),
                            ),
                          ),
                        ),
                        Text(
                          // readmoreev3 (309:5958)
                          'Read more',
                          style: GoogleFonts.lora(
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.5 * ffem / fem,
                            color: Color(0xffe94057),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // locationoY3 (309:5961)
                  left: 40 * fem,
                  top: 563 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 50 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // autogroup9xm9Xiw (TgkL6zyhxYdkLZFKkV9Xm9)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 114 * fem, 0 * fem),
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
                                    fontSize: 14 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5 * ffem / fem,
                                    color: Color(0xffe94057),
                                  ),
                                ),
                              ),
                              Text(
                                // boleaddisababanes (309:5966)
                                'Bole, Addis ababa',
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
                              12.04 * fem, 8 * fem, 10 * fem, 8 * fem),
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
                                    0 * fem, 0 * fem, 4.04 * fem, 0 * fem),
                                child: Icon(Icons.location_on_outlined,
                                    size: 23, color: Color(0xffe94057)),
                              ),
                              Text(
                                // bole8cF (309:5964)
                                'Bole',
                                style: GoogleFonts.lora(
                                  fontSize: 14 * ffem,
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
                                // graphicsdesignervY7 (309:5972)
                                left: 0 * fem,
                                top: 35 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 121 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      'Graphics designer',
                                      style: GoogleFonts.lora(
                                        fontSize: 24 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // selamyohannes29nqD (309:5973)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 225 * fem,
                                    height: 36 * fem,
                                    child: Text(
                                      'Selam Yohannes, 29',
                                      style: GoogleFonts.lora(
                                        fontSize: 24 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5 * ffem / fem,
                                        color: Color(0xff000000),
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
                Positioned(
                  // galleryAhD (309:5870)
                  left: 40 * fem,
                  top: 929 * fem,
                  child: Container(
                    width: 295 * fem,
                    height: 356 * fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // autogroup6nyv6Ky (TgkGnM1ib9dnydpBSx6NyV)
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Gallery',
                                    style: GoogleFonts.lora(
                                      fontSize: 24 * ffem,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5 * ffem / fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        Container(
                          // autogrouphxlbchd (TgkGsbMyU4PoMeNEcEHXLb)
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // photoNgo (I309:5871;174:1)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                width: 142 * fem,
                                height: 190 * fem,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/girls/img_2.jpg'),
                                  ),
                                ),
                              ),
                              Container(
                                // photoqqH (I309:5875;174:1)
                                width: 143 * fem,
                                height: 190 * fem,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/girls/img_2.jpg'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10 * fem,
                        ),
                        Container(
                          // autogroupd3pjj9y (TgkGzbAKJc59CKme9wD3pj)
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // photoGQo (I309:5872;174:1)
                                width: 92 * fem,
                                height: 122 * fem,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/girls/img_2.jpg'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10 * fem,
                              ),
                              Container(
                                // photoCJT (I309:5873;174:1)
                                width: 91 * fem,
                                height: 122 * fem,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/girls/img_2.jpg'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10 * fem,
                              ),
                              Container(
                                // photoVYT (I309:5874;174:1)
                                width: 92 * fem,
                                height: 122 * fem,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/girls/img_2.jpg'),
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
                                // Handle close icon tap
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
                                // Handle close icon tap
                              },
                              child: Transform.scale(
                                scale:
                                    2.0, // Increase the scale factor as needed
                                child: Icon(Icons.star,
                                    size: 15 * fem,
                                    color:
                                        Color(0xFF8A2387) // Original icon size
                                    ),
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
