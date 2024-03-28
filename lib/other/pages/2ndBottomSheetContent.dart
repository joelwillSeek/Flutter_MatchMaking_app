<<<<<<< HEAD
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationCheckPage extends StatefulWidget {
//   @override
//   _LocationCheckPageState createState() => _LocationCheckPageState();
// }

// class _LocationCheckPageState extends State<LocationCheckPage> {
//   bool _isInsideAddisAbaba = false;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocation();
//   }

//   Future<void> _checkLocation() async {
//     // Request location permissions
//     PermissionStatus status = await Permission.location.request();

//     if (status.isGranted) {
//       try {
//         // Retrieve the current position
//         _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );

//         // Calculate the distance from Addis Ababa
//         double distanceInMeters = await Geolocator.distanceBetween(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//           9.005401, // Addis Ababa latitude
//           38.763611, // Addis Ababa longitude
//         );

//         // Check if the user is within the defined range
//         if (distanceInMeters <= 100000) {
//           // Increased range to 5000 meters
//           setState(() {
//             _isInsideAddisAbaba = true;
//           });
//         } else if (distanceInMeters > 100000) {
//           _showOutsideAddisAbabaPopup();
//         }
//       } catch (error) {
//         // Handle any errors that might occur during location retrieval
//         print('Error getting location: $error');
//       }
//     } else if (status.isDenied || status.isRestricted) {
//       // Location permission denied or restricted, prompt user to grant permissions again
//       await Permission.location.request();
//       _checkLocation(); // Retry checking location after permission is granted
//     }
//   }

//   void _showOutsideAddisAbabaPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Attention"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                   'assets/images/urban-dog.gif'), // Adjust the path accordingly
//               Text(
//                   "We didn't start our service outside Addis Ababa.\nIf you are out of Addis Ababa, we will come back soon."),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location Check"),
//       ),
//       body: Center(
//         child: _isInsideAddisAbaba
//             ? Text("You are inside Addis Ababa.")
//             : CircularProgressIndicator(), // You can replace this with your main UI
=======
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FilterBottomSheet extends StatefulWidget {
//   final String selectedGender;
//   final Function(String) onGenderSelected;
//   final List<String> subCities = [
//     "Arada, Addis Ababa",
//     "Akaky Kaliti, Addis Ababa",
//     "Bole, Addis Ababa",
//     "Gullele, Addis Ababa",
//     "Kirkos, Addis Ababa",
//     "Kolfe Keranio, Addis Ababa",
//     "Lideta, Addis Ababa",
//     "Nifas Silk-Lafto, Addis Ababa",
//     "Yeka, Addis Ababa",
//   ];

//   FilterBottomSheet({
//     Key? key,
//     required this.selectedGender,
//     required this.onGenderSelected,
//   }) : super(key: key);

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   double fem = 1.0; // Assuming the value of 'fem'
//   double ffem = 0.8;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // autogrouphaesUNK (TgkMKYnVKDiwtEuAgMHaes)
//       width: double.infinity,
//       height: 649 * fem,
//       child: Stack(
//         children: [
//           Positioned(
//             // container1t3 (309:6000)
//             left: 0 * fem,
//             top: 3 * fem,
//             child: Align(
//               child: SizedBox(
//                 width: 375 * fem,
//                 height: 646 * fem,
//                 child: Image.asset(
//                   'assets/images/girls/img_5.jpg',
//                   width: 375 * fem,
//                   height: 646 * fem,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             // ageJs9 (309:6008)
//             left: 40 * fem,
//             top: 335 * fem,
//             child: Container(
//               width: 295 * fem,
//               height: 84 * fem,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     // autogroupcfm1qMH (TgkMXNn7cP5t8s8VmccFm1)
//                     margin: EdgeInsets.fromLTRB(
//                         0 * fem, 0 * fem, 0 * fem, 20 * fem),
//                     width: double.infinity,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Container(
//                           // ageAPZ (309:6015)
//                           margin: EdgeInsets.fromLTRB(
//                               0 * fem, 0 * fem, 226 * fem, 0 * fem),
//                           child: Text(
//                             'Age',
//                             style: GoogleFonts.lora(
//                               fontSize: 16 * ffem,
//                               fontWeight: FontWeight.w700,
//                               height: 1.5 * ffem / fem,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           // fr7 (309:6014)
//                           '20-28',
//                           textAlign: TextAlign.right,
//                           style: GoogleFonts.lora(
//                             fontSize: 16 * ffem,
//                             fontWeight: FontWeight.w700,
//                             height: 1.5 * ffem / fem,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     // slidercmM (309:6009)
//                     width: 295 * fem,
//                     height: 40 * fem,
//                     child: Image.asset(
//                       'assets/images/girls/img_5.jpg',
//                       width: 375 * fem,
//                       height: 646 * fem,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             // btncontinue9FV (309:6016)
//             left: 40 * fem,
//             top: 559 * fem,
//             child: Container(
//               width: 295 * fem,
//               height: 56 * fem,
//               decoration: BoxDecoration(
//                 color: Color(0xffe94057),
//                 borderRadius: BorderRadius.circular(15 * fem),
//               ),
//               child: Center(
//                 child: Text(
//                   'Continue',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.lora(
//                     fontSize: 16 * ffem,
//                     fontWeight: FontWeight.w700,
//                     height: 1.5 * ffem / fem,
//                     color: Color(0xff000000),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             // interestedinoL3 (309:6019)
//             left: 40 * fem,
//             top: 92 * fem,
//             child: Container(
//               width: 295 * fem,
//               height: 102 * fem,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     // interestedinvvT (309:6027)
//                     margin: EdgeInsets.fromLTRB(
//                         0 * fem, 0 * fem, 0 * fem, 20 * fem),
//                     child: Text(
//                       'Interested in',
//                       style: GoogleFonts.lora(
//                         fontSize: 16 * ffem,
//                         fontWeight: FontWeight.w700,
//                         height: 1.5 * ffem / fem,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     // autogroupet3hebZ (TgkMonUSWnHN2CMGdoet3H)
//                     padding: EdgeInsets.fromLTRB(
//                         0 * fem, 0 * fem, 28 * fem, 0 * fem),
//                     width: double.infinity,
//                     height: 58 * fem,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Color(0xffe8e6ea)),
//                       color: Color(0xffffffff),
//                       borderRadius: BorderRadius.circular(15 * fem),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           // autogroup8og39oD (TgkMvs6ydnaPTHhW748og3)
//                           margin: EdgeInsets.fromLTRB(
//                               0 * fem, 0 * fem, 43 * fem, 0 * fem),
//                           width: 154 * fem,
//                           height: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Color(0xffe94057),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15 * fem),
//                               bottomLeft: Radius.circular(15 * fem),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Girls',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.lora(
//                                 fontSize: 16 * ffem,
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.5 * ffem / fem,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           // divider2cwh (309:6023)
//                           margin: EdgeInsets.fromLTRB(
//                               0 * fem, 0 * fem, 36 * fem, 0 * fem),
//                           width: 1 * fem,
//                           height: 22 * fem,
//                           child: Image.asset(
//                             'assets/images/girls/img_5.jpg',
//                             width: 375 * fem,
//                             height: 646 * fem,
//                           ),
//                         ),
//                         Container(
//                           // boysM8b (309:6024)
//                           margin: EdgeInsets.fromLTRB(
//                               0 * fem, 1 * fem, 0 * fem, 0 * fem),
//                           child: Text(
//                             'Boys',
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.lora(
//                               fontSize: 16 * ffem,
//                               fontWeight: FontWeight.w700,
//                               height: 1.5 * ffem / fem,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             // inputtextnonessd (309:6029)
//             left: 40 * fem,
//             top: 224 * fem,
//             child: Container(
//               width: 295 * fem,
//               height: 67 * fem,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     // containercaK (309:6030)
//                     left: 0 * fem,
//                     top: 9 * fem,
//                     child: Align(
//                       child: SizedBox(
//                         width: 295 * fem,
//                         height: 58 * fem,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15 * fem),
//                             border: Border.all(color: Color(0xffe8e6ea)),
//                             color: Color(0xffffffff),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     // iconbackwhite8Yf (309:6031)
//                     left: 251 * fem,
//                     top: 26 * fem,
//                     child: Align(
//                       child: SizedBox(
//                         width: 24 * fem,
//                         height: 24 * fem,
//                         child: Image.asset(
//                           'assets/images/girls/img_5.jpg',
//                           width: 375 * fem,
//                           height: 646 * fem,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     // whitelinerDm (309:6032)
//                     left: 20 * fem,
//                     top: 9 * fem,
//                     child: Align(
//                       child: SizedBox(
//                         width: 64 * fem,
//                         height: 1 * fem,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     // texthereB19 (309:6033)
//                     left: 28 * fem,
//                     top: 0 * fem,
//                     child: Align(
//                       child: SizedBox(
//                         width: 49 * fem,
//                         height: 18 * fem,
//                         child: Text(
//                           'Location',
//                           style: GoogleFonts.lora(
//                             fontSize: 16 * ffem,
//                             fontWeight: FontWeight.w700,
//                             height: 1.5 * ffem / fem,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     // alex5sD (309:6034)
//                     left: 20 * fem,
//                     top: 27 * fem,
//                     child: Align(
//                       child: SizedBox(
//                         width: 29 * fem,
//                         height: 21 * fem,
//                         child: Text(
//                           'Bole',
//                           style: GoogleFonts.lora(
//                             fontSize: 16 * ffem,
//                             fontWeight: FontWeight.w700,
//                             height: 1.5 * ffem / fem,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             // indicatorBvF (309:6035)
//             left: 174 * fem,
//             top: 0 * fem,
//             child: Align(
//               child: SizedBox(
//                 width: 27 * fem,
//                 height: 12.06 * fem,
//                 child: Image.asset(
//                   'assets/images/girls/img_5.jpg',
//                   width: 375 * fem,
//                   height: 646 * fem,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             // headeri9V (309:6038)
//             left: 150 * fem,
//             top: 26 * fem,
//             child: Container(
//               width: 185 * fem,
//               height: 36 * fem,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     // filtersT75 (309:6040)
//                     margin: EdgeInsets.fromLTRB(
//                         0 * fem, 0 * fem, 69 * fem, 0 * fem),
//                     child: Text(
//                       'Filters',
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.lora(
//                         fontSize: 16 * ffem,
//                         fontWeight: FontWeight.w700,
//                         height: 1.5 * ffem / fem,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     // skipNE3 (309:6039)
//                     margin:
//                         EdgeInsets.fromLTRB(0 * fem, 6 * fem, 0 * fem, 0 * fem),
//                     child: Text(
//                       'Clear',
//                       textAlign: TextAlign.right,
//                       style: GoogleFonts.lora(
//                         fontSize: 16 * ffem,
//                         fontWeight: FontWeight.w700,
//                         height: 1.5 * ffem / fem,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
//       ),
//     );
//   }
// }
<<<<<<< HEAD

// void main() {
//   runApp(MaterialApp(
//     home: LocationCheckPage(),
//   ));
// }
=======
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
