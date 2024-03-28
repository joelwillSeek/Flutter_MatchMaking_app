import 'dart:io';

import 'package:fire/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

// ignore: must_be_immutable
class Bio extends StatefulWidget {
  final String? f, l, gen, ph;
  final File? img;
  List<String> selectedInterests = [];
  final int age;

  Bio(
      {super.key,
      required this.f,
      required this.l,
      required this.gen,
      required this.img,
      required this.ph,
      required this.selectedInterests,
      required this.age});

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
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
    if (await Vibrate.canVibrate) {
      Vibrate.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              maxLength: null, // Remove maxLength for formatter
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
                  builder: (context) => credentialEmPas(
                    f: widget.f,
                    l: widget.l,
                    gen: widget.gen,
                    img: widget.img,
                    ph: widget.ph,
                    selectedInterests: widget.selectedInterests,
                    age: widget.age,
                    bio: _bioController.text,
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

class LengthLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLength;
  final ValueChanged<String>? onExceed;

  LengthLimitingTextInputFormatter({required this.maxLength, this.onExceed});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > maxLength) {
      onExceed?.call(newValue.text);
      return TextEditingValue(
        selection: newValue.selection,
        text: oldValue.text.substring(0, maxLength),
      );
    }
    return newValue;
  }
}
