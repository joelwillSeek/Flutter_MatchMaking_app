//test
// import 'package:fire/services/NotificationService.dart';
// import 'package:flutter/material.dart';

// class test extends StatefulWidget {
//   const test({super.key});

//   @override
//   State<test> createState() => _testState();
// }

// void notifayMe() {
//   //final notificationService = NotificationService();

//   // notificationService.sendChatNotification(
//   //     '2WLo81Xn55PcWbWBWekj0XPvxPl2',
//   //     'https://firebasestorage.googleapis.com/v0/b/test-7643a.appspot.com/o/profile_pictures%2F2WLo81Xn55PcWbWBWekj0XPvxPl2.jpg?alt=media&token=6f225ba7-b835-4e0d-a043-9e1f7fc77b71',
//   //     'Hello there!',);
//   // notificationService.sendMatchNotification(
//   //     '2WLo81Xn55PcWbWBWekj0XPvxPl2',
//   //     'https://firebasestorage.googleapis.com/v0/b/test-7643a.appspot.com/o/profile_pictures%2F2WLo81Xn55PcWbWBWekj0XPvxPl2.jpg?alt=media&token=6f225ba7-b835-4e0d-a043-9e1f7fc77b71',
//   //     'Abel');
// }

// class _testState extends State<test> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notification"),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Center(
//               child: Row(
//                 children: [
//                   ElevatedButton(onPressed: notifayMe, child: Text("send"))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//test end

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
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: LocationCheckPage(),
//   ));
// }
