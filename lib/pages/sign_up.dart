import 'dart:async';
import 'dart:ui';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:fire/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/FirebaseService.dart';
import '../sign_up componenets/PhoneNumberRegistration.dart';

void main() {
  runApp(SignUpScreen());
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? firstName;
  String? lastName;
  String? selectedGender, dob;

  File? _imageFile;
  final formKey = GlobalKey<FormState>();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    final nameReg = RegExp(r'^[a-zA-Z]+\s*$', caseSensitive: false);
    if (!nameReg.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Permissions Denied'),
        content: Text(
            'This app needs storage and gallery access to function properly. Please grant permissions in your app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool storagePermission =
        sharedPreferences.getBool('storage_permission') ?? false;
    if (storagePermission) {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _getImageFromCamera() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool cameraPermission =
        sharedPreferences.getBool('camera_permission') ?? false;
    if (cameraPermission) {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      }
    } else {
      _showPermissionDeniedDialog();
      Permission.photos.request();
    }
  }

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text(
        "Select your birthdate",
        style: GoogleFonts.inter(
            color: Color(0xFFE94057),
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Stack(
                    children: [
                      Container(
                        width: 100, // Adjust width as needed
                        height: 100, // Adjust height as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust border radius as needed
                          border: Border.all(
                              color: const Color.fromARGB(45, 170, 170, 170),
                              width: 2), // Add border
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust border radius as needed
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.person,
                                size: 50), // Placeholder icon
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              color: Color(0xFFE94057)),
                          onPressed: _getImageFromCamera,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon:
                              const Icon(Icons.image, color: Color(0xFFE94057)),
                          onPressed: _getImageFromGallery,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (value) {
                    firstName = value;
                  },
                  validator: _validateName,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFE94057)),
                      gapPadding: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (value) {
                    lastName = value;
                  },
                  validator: _validateName,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFE94057)),
                      gapPadding: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 60,
                  width: 304,
                  child: TextButton(
                    onPressed: () => {
                      _openDatePicker(context)
                    }, // Replace with your desired action
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
                Padding(
                  padding: const EdgeInsets.only(top: 70, bottom: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the next screen
                      if (_imageFile == null) {
                        showError();
                        return;
                      }
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
                      if (formKey.currentState!.validate()) {
                        print(dob);
                        print(age);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenderSelectionScreen(
                                    f: firstName,
                                    l: lastName,
                                    img: _imageFile,
                                    age: age,
                                  )),
                        ).then((value) {
                          setState(() {
                            selectedGender = value;
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFE94057),
                      minimumSize: const Size(315, 70),
                      elevation: 8,
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void showError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Habeshaly',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          content: const Text(
            "please set profile picture take selfie or set profile picture from your storage",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

class GenderSelectionScreen extends StatefulWidget {
  final String? f, l;
  final int age;
  final File? img;

  const GenderSelectionScreen(
      {super.key,
      required this.f,
      required this.l,
      required this.img,
      required this.age});

  @override
  // ignore: library_private_types_in_public_api
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Gender'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                        color:
                            Color.fromARGB(58, 158, 158, 158)), // Border color
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
            const SizedBox(height: 20.0),
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
                        color:
                            Color.fromARGB(73, 158, 158, 158)), // Border color
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
            const Spacer(),
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
                      builder: (context) => PhoneNumberRegistration(
                        f: widget.f,
                        l: widget.l,
                        gen: selectedGender,
                        img: widget.img,
                        age: widget.age,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color(0xFFE94057), // Change the text color
                minimumSize: const Size(315, 70), // Change the width and height
                elevation: 8,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class credentialEmPas extends StatefulWidget {
  final String? f, l, gen, ph, bio;
  final File? img;
  List<String> selectedInterests = [];
  final int age;
  credentialEmPas(
      {super.key,
      required this.f,
      required this.l,
      required this.gen,
      required this.img,
      required this.ph,
      required this.selectedInterests,
      required this.age,
      required this.bio});

  @override
  State<credentialEmPas> createState() => _credentialEmPasState();
}

// ignore: camel_case_types
class _credentialEmPasState extends State<credentialEmPas> {
  bool _isObscured = true;
  String? _selectedSubCity;

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
  TextEditingController emailCont = TextEditingController();
  TextEditingController password = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegExp =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\s*$', caseSensitive: false);
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signUp() async {
    if (subCities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'please select your location!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 234, 8, 8),
        ),
      );
      return;
    }
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      User? user = await firebaseService.registerWithEmailAndPassword(
        email: emailCont.text,
        password: password.text,
        firstName: widget.f!,
        lastName: widget.l!,
        gender: widget.gen!,
        profilePic: widget.img,
        Bio: widget.bio!,
        address: _selectedSubCity!,
        age: widget.age,
        interests: widget.selectedInterests,
        phoneNum: widget.ph!,
        verified: false,
      );

      isLoading.value = false;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const signin()),
        );
      } else {
        // Handle registration failure
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: const Text('Registration Failed'),
              content: const Text('Failed to register user.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email and Password"),
      ),
      body: Stack(children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailCont,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "XongXina@gmail.com",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 42, vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 8, 8, 8)),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Color(0xFFE94057)),
                        gapPadding: 10,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  validator: _validatePassword,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 42, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 16, 16, 16)),
                      gapPadding: 10,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(color: Color(0xFFE94057)),
                      gapPadding: 10,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      child: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 240,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(49, 11, 9, 10),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Location',
                        style: TextStyle(
                          color: Color.fromARGB(178, 3, 3, 3),
                          fontSize: 16,
                        ),
                      ),
                      value: _selectedSubCity,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Color.fromARGB(189, 7, 7, 7),
                        fontSize: 16,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubCity = newValue;
                        });
                      },
                      items: subCities.map<DropdownMenuItem<String>>(
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (subCities.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'please select your location!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color.fromARGB(255, 234, 8, 8),
                        ),
                      );
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      _signUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE94057),
                    minimumSize: const Size(315, 70),
                    elevation: 8,
                  ),
                  child: const Text('submit'),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, value, child) {
            if (value) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SpinKitThreeInOut(
                          size: 50.0,
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: index.isEven
                                    ? const Color(0xFFE94057)
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Please check your mail inbox to verify your email...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(171, 26, 15, 15),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ]),
    );
  }

  @override
  void dispose() {
    emailCont.dispose();
    password.dispose();
    super.dispose();
  }
}
