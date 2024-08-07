import 'package:fire/pages/sign_in.dart';
import 'package:fire/pages/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class DataModel {
  final String title;
  final String imageName;
  final String description;
  DataModel(
    this.title,
    this.imageName,
    this.description,
  );
}

List<DataModel> dataList = [
  DataModel("Algorithm", "assets/images/girls/img_1.jpg",
      "Smart way to match you with random people who have interest like you"),
  DataModel("24/7 suggestions", "assets/images/girls/img_2.jpg",
      "24/7 suggestion based on your preference"),
  DataModel("Culture Friendly", "assets/images/girls/img_3.jpg",
      "Sign up today and enjoy life with your new friend, business partner, and find a job."),
  DataModel("Business partner?", "assets/images/girls/img_4.jpg",
      "We match you with people that have a large array of similar interests in the business area and investment like you"),
];

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentIndex, viewportFraction: 0.8);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
      requestNotificationPermission();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _storeOnBoardInfo() async {
    int isViewed = 0;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("onBoard", isViewed);
  }

  Future<void> requestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      print('Notification permission granted');
    } else if (status.isDenied) {
      print('Notification permission denied');

      await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      print('Notification permission permanently denied');
    } else if (status.isRestricted) {
      print('Notification permission restricted');
    }
  }

  Future<void> _requestPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
      Permission.storage,
    ].request();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(
        'photos_permission', statuses[Permission.photos]!.isGranted);
    await sharedPreferences.setBool(
        'camera_permission', statuses[Permission.camera]!.isGranted);
    await sharedPreferences.setBool(
        'storage_permission', statuses[Permission.storage]!.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.85,
                child: PageView.builder(
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return carouselCard(dataList[index], index);
                    }),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(dataList.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color(0xFFE94057)
                        : Colors.black12,
                  ),
                );
              }),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {
                  _storeOnBoardInfo();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFE94057),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: TextStyle(fontSize: 20),
                  minimumSize: const Size(305, 50),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.lora(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign in.',
                      style: GoogleFonts.lora(
                        color: Color(0xFFE94057),
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _storeOnBoardInfo();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => signin()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }

  Widget carouselCard(DataModel data, int currentIndex) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: data.imageName,
            child: GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _currentIndex == currentIndex
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage(data.imageName),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            data.title,
            style: GoogleFonts.lora(
              color: Color(0xFFE94057),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Color(0xFF323755),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
