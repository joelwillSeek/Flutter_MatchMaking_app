// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:fire/sign_up%20componenets/PhoneVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberRegistration extends StatelessWidget {
  final String? f, l, gen;
  final File? img;
  final int age;
  const PhoneNumberRegistration(
      {super.key,
      required this.f,
      required this.l,
      required this.gen,
      required this.img,
      required this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: PhoneNumberRegistrationForm(
          f: f,
          l: l,
          gen: gen,
          img: img,
          age: age,
        ),
      ),
    );
  }
}

class PhoneNumberRegistrationForm extends StatefulWidget {
  final String? f, l, gen;
  final File? img;
  final int age;

  const PhoneNumberRegistrationForm(
      {super.key,
      required this.f,
      required this.l,
      required this.gen,
      required this.img,
      required this.age});
  @override
  _PhoneNumberRegistrationFormState createState() =>
      _PhoneNumberRegistrationFormState();
}

class _PhoneNumberRegistrationFormState
    extends State<PhoneNumberRegistrationForm> {
  TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My mobile',
                style: GoogleFonts.lora(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Please enter your valid phone number. We will send you a 6-digit code to verify your account.',
                style: GoogleFonts.lora(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, top: 5.0, bottom: 5.0, right: 5.0),
                      child: Text(
                        '(+251) |',
                        style: GoogleFonts.lora(fontSize: 16.0),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            hintText: '912345678',
                            hintStyle: GoogleFonts.lora(),
                            labelStyle: GoogleFonts.lora(),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      _validatePhoneNumber(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xFFE94057),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.lora(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _validatePhoneNumber(BuildContext context) {
    String phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      _showSnackBar(context, 'Please enter your phone number.');
    } else if (phoneNumber.length != 9) {
      _showSnackBar(context, 'Please input a proper phone number.');
    } else {
      phoneNumber = "+251$phoneNumber";
      print('Processing phone number: $phoneNumber');
      print("fname ${widget.f} \n ln ${widget.l} \n gender ${widget.gen}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneVerificationScreen(
            f: widget.f!,
            l: widget.l!,
            gen: widget.gen!,
            img: widget.img,
            ph: phoneNumber,
            age: widget.age,
          ),
        ),
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
