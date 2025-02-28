import 'dart:ui';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fire/pages/home.dart';
import 'package:fire/services/FirebaseService.dart';
import 'package:fire/services/SocialMediaSignInOption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';

import '../biography.dart';

// ignore: must_be_immutable
class SocialMediaForm extends StatefulWidget {
  UserData? userData;
  SocialMediaForm({super.key, required this.userData});

  @override
  State<SocialMediaForm> createState() => _NameState();
}

class _NameState extends State<SocialMediaForm> {
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please take a few minutes to tell us about yourself to help us make personalized suggestions",
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 5),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 150, left: 10, top: 20),
                      child: Text(
                        "I am a:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 70,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = 'Male';
                      });
                    },
                    child: Card(
                      color: selectedGender == 'Male'
                          ? const Color(0xFFE94057)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                            color: Color.fromARGB(58, 158, 158, 158)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text(
                              'Male',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: selectedGender == 'Male'
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            const Spacer(),
                            const Icon(Icons.check, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 70,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = 'Female';
                      });
                    },
                    child: Card(
                      color: selectedGender == 'Female'
                          ? const Color(0xFFE94057)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                            color: Color.fromARGB(
                                73, 158, 158, 158)), // Border color
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Text(
                              'Female',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: selectedGender == 'Female'
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            const Spacer(),
                            const Icon(Icons.check, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedGender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'please select your gender!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      return;
                    }
                    if (selectedGender != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => mBio(
                            selectedGender: selectedGender,
                            userData: widget.userData,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE94057),
                    minimumSize: const Size(315, 70),
                    elevation: 8,
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class mBio extends StatefulWidget {
  UserData? userData;
  String? selectedGender;

  mBio({super.key, required this.userData, required this.selectedGender});

  @override
  State<mBio> createState() => _mBioState();
}

class _mBioState extends State<mBio> {
  late TextEditingController _bioController;
  int _remainingCharacters = 70;
  // ignore: unused_field
  int _exceedCounter = 0;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _remainingCharacters = 70 - _bioController.text.length;
    });
  }

  void _showExceedMessage() {
    _showSnackBar(context, 'Character limit reached!');
    _vibrate();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 15.0, right: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself with a few lines.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLength: null,
              maxLines: null,
              autocorrect: true,
              onChanged: (_) => _updateCharacterCount(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    maxLength: 70, onExceed: _onExceed),
              ],
              decoration: InputDecoration(
                hintText: 'Write your bio here...',
                counterText: '$_remainingCharacters characters left',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_bioController.text.isEmpty) {
              _showSnackBar(context,
                  "Cant submit empty bio, please write a few word that can describe you");
            }
            if (_bioController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => prefs(
                    bio: _bioController.text,
                    selectedGender: widget.selectedGender,
                    userData: widget.userData,
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFE94057),
            minimumSize: const Size(315, 60),
            elevation: 8,
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.lora(),
          ),
        ),
      ),
    );
  }

  void _onExceed(String value) {
    _exceedCounter++;
    _showExceedMessage();
  }
}

// ignore: must_be_immutable
class prefs extends StatefulWidget {
  UserData? userData;
  String? selectedGender, bio;

  prefs(
      {super.key,
      required this.userData,
      required this.bio,
      required this.selectedGender});

  @override
  State<prefs> createState() => _prefsState();
}

class _prefsState extends State<prefs> {
  List<String> interests = [
    "Friendship",
    "Buisness",
    "Entrepreneur",
    "Soulmate",
    "Employment",
    "Student",
    "Painting",
    "Music",
    "Coding",
    "Fashion",
    "Sports",
    "Writing",
    "Drawing",
    "Movies"
  ];
  List<String> selectedInterests = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your interests",
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
            SizedBox(height: 15.0),
            Text(
              "Select a few of your interests and let everyone know what you’re interested about.",
              style: TextStyle(
                fontFamily: "SFProText-Regular",
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 33.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 13.0,
                  crossAxisSpacing: 13.0,
                  childAspectRatio: 140 / 45,
                  children: interests.map((interest) {
                    bool isSelected = selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedInterests.remove(interest);
                          } else {
                            selectedInterests.add(interest);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFFE94057) : Colors.white,
                          borderRadius: BorderRadius.circular(22.5),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Color(0xFFE94057).withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        width: 140,
                        height: 45,
                        alignment: Alignment.center,
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedInterests.length < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select at least 5 interests."),
                      ),
                    );
                  } else {
                    // Perform save action here
                    print("before nav");
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => otherInfo(
                            bio: widget.bio,
                            selectedGender: widget.selectedGender,
                            selectedInterests: selectedInterests,
                            userData: widget.userData,
                          ),
                        ),
                      );
                    });
                    print("after nav");
                    // print(
                    //     "fname ${widget.f} \n ln ${widget.l} \n gender ${widget.gen} \n phone ${widget.ph}");
                    // for (int i = 0; i <= selectedInterests.length; i++) {
                    //   print(selectedInterests[i]);
                    // }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFE94057),
                  minimumSize: const Size(315, 60),
                  elevation: 8,
                ),
                child: Text("Save"),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class otherInfo extends StatefulWidget {
  UserData? userData;
  List<String> selectedInterests = [];
  String? selectedGender, bio;

  otherInfo(
      {super.key,
      this.userData,
      required this.bio,
      required this.selectedGender,
      required this.selectedInterests});
  final List<String> subCities = [
    "Arada, Addis Ababa",
    "Akaky Kaliti, Addis Ababa",
    "Bole, Addis Ababa",
    "Gullele, Addis Ababa",
    "Kirkos, Addis Ababa",
    "Kolfe Keranio, Addis Ababa",
    "Lideta, Addis Ababa",
    "Nifas Silk-Lafto, Addis Ababa",
    "Yeka, Addis Ababa",
  ];
  @override
  State<otherInfo> createState() => _otherInfoState();
}

class _otherInfoState extends State<otherInfo> {
  String? _selectedSubCity, dob;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text("Select your birthdate",
          style: GoogleFonts.inter(
              color: Color(0xFFE94057),
              fontWeight: FontWeight.bold,
              fontSize: 18)),
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: GoogleFonts.lora(
          color: Color(0xFFE94057), fontWeight: FontWeight.bold, fontSize: 18),
      onChange: (bd) {
        dob = bd.toString();
      },
      buttonAlignment: MainAxisAlignment.center,
      buttonContent: Text(
        "Select",
        textAlign: TextAlign.center,
        style:
            GoogleFonts.lora(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      buttonStyle: BoxDecoration(
        color: Color(0xFFE94057),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFE94057),
        ),
      ),
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  int calculateAgeFromDateOfBirth(String dobString) {
    DateTime dob = DateTime.parse(dobString);
    DateTime now = DateTime.now();

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
    }

    return years;
  }

  Future<void> createAccount(int age) async {
    final FirebaseService firebaseService = FirebaseService();
    isLoading.value = true;
    print("started");
    await firebaseService.CreatingAccountWithotherSignInMethod(
        userId: widget.userData?.userId,
        p_url: widget.userData?.profilePicUrl,
        email: widget.userData?.email,
        firstName: widget.userData?.firstName,
        lastName: widget.userData?.lastName,
        gender: widget.selectedGender,
        address: _selectedSubCity,
        age: age,
        bio: widget.bio,
        interests: widget.selectedInterests,
        phoneNum: widget.userData?.phoneNumber);
    isLoading.value = false;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    ).then((value) {
      firebaseService.updateDeviceToken(widget.userData!.userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: 304,
              child: TextButton(
                onPressed: () => {_openDatePicker(context)},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE94057),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Choose birthday date",
                      style: TextStyle(
                        color: Color(0xFFE94057),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFFfcecef)),
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  overlayColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.blueGrey.shade800;
                      }
                      return Colors.white; // No color change on hover
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 270,
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFE94057),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Select Location",
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("example Bole,addis ababa"),
                      value: _selectedSubCity,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubCity = newValue;
                        });
                      },
                      items: widget.subCities.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 140.0,
                right: 15,
                left: 15,
              ),
              child: ElevatedButton(
                  onPressed: () async {
                    if (dob == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'please select your birth date',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    int age = calculateAgeFromDateOfBirth(dob!);
                    if (age < 15) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '!underage 15+,minmum age allowed is 15',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_selectedSubCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'please select your location',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    createAccount(age);
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: false,
                    //   builder: (BuildContext context) {
                    //     return const Center(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           SpinKitWaveSpinner(
                    //             size: 50.0,
                    //             color: Color(0xFFE94057),
                    //             trackColor: Colors.amber,
                    //             waveColor: Color(0xFFE94057),
                    //           ),
                    //           SizedBox(
                    //               height:
                    //                   20), // Add some spacing below the spinner
                    //           Flexible(
                    //             child: Padding(
                    //               padding: EdgeInsets.symmetric(horizontal: 20),
                    //               child: Text(
                    //                 "creating account few a sec left...",
                    //                 textAlign: TextAlign
                    //                     .center, // Center the text horizontally
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.w700,
                    //                   fontSize: 16,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // );

                    // print("user details");
                    // print(widget.userData?.email);
                    // print(widget.userData?.firstName);
                    // print(widget.userData?.phoneNumber);
                    // print(widget.userData?.profilePicUrl);
                    // print(widget.userData?.emailVerified);
                    // print(widget.bio);
                    // print(widget.selectedGender);
                    // print("age = $age");
                    // for (int i = 0; i <= widget.selectedInterests.length; i++) {
                    //   print(widget.selectedInterests[i]);
                    // }
                    // print(_selectedSubCity);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE94057),
                    minimumSize: const Size(315, 60),
                    elevation: 8,
                  ),
                  child: Text("finish")),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, value, child) {
                if (value) {
                  return Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SpinKitWaveSpinner(
                              size: 50.0,
                              color: Color(0xFFE94057),
                              trackColor: Colors.amber,
                              waveColor: Color(0xFFE94057),
                            ),
                            SizedBox(
                                height:
                                    20), // Add some spacing below the spinner
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "creating account few a sec left...",
                                  textAlign: TextAlign
                                      .center, // Center the text horizontally
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
