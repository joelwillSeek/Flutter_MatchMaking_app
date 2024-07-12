import 'package:fire/model/Me.dart';
import 'package:fire/newFeature/updateMyInterest.dart';
import 'package:fire/newFeature/updateMyPrefInterests.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

// ignore: must_be_immutable
class UpdatePersonalInfo extends StatefulWidget {
  Me me;
  UpdatePersonalInfo({
    Key? key,
    required this.me,
  }) : super(key: key);
  @override
  _UpdatePersonalInfoState createState() => _UpdatePersonalInfoState();
}

class _UpdatePersonalInfoState extends State<UpdatePersonalInfo> {
  bool firstNameSelected = false;
  bool lastNameSelected = false;
  bool bioSelected = false;
  bool ageSelected = false;
  bool genderSelected = false;
  bool addressSelected = false;

  String firstName = '';
  String lastName = '';
  String bio = '';
  int age = 0;
  String gender = 'Male';
  String address = 'Arada, Addis Ababa';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  void _updateData(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Updating selected info, please wait a few seconds.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
    User? user = _auth.currentUser;
    if (user != null) {
      String userID = user.uid;
      Map<String, dynamic> dataToUpdate = {};

      if (firstNameSelected && firstName.isNotEmpty)
        dataToUpdate['firstName'] = firstName;
      if (lastNameSelected && lastName.isNotEmpty)
        dataToUpdate['lastName'] = lastName;
      if (bioSelected && bio.isNotEmpty) dataToUpdate['bio'] = bio;
      if (ageSelected && age > 0) dataToUpdate['age'] = age;
      if (genderSelected && gender.isNotEmpty) dataToUpdate['gender'] = gender;
      if (addressSelected && address.isNotEmpty)
        dataToUpdate['address'] = address;

      try {
        await _firestore.collection('f_user').doc(userID).update(dataToUpdate);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Selected info updated',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        print('User data updated successfully!');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'There was an error updating the profile',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        print('Error updating user data: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please sign in properly!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      print('User not signed in.');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info Update'),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            buildCheckBoxWithTextField(
              label: 'First Name',
              selected: firstNameSelected,
              onChanged: (value) {
                setState(() {
                  firstNameSelected = value ?? false;
                });
              },
              onTextChanged: (value) {
                setState(() {
                  firstName = value;
                });
              },
            ),
            buildCheckBoxWithTextField(
              label: 'Last Name',
              selected: lastNameSelected,
              onChanged: (value) {
                setState(() {
                  lastNameSelected = value ?? false;
                });
              },
              onTextChanged: (value) {
                setState(() {
                  lastName = value;
                });
              },
            ),
            buildCheckBoxWithTextField(
              label: 'Bio',
              selected: bioSelected,
              onChanged: (value) {
                setState(() {
                  bioSelected = value ?? false;
                });
              },
              onTextChanged: (value) {
                setState(() {
                  bio = value;
                });
              },
            ),
            buildCheckBoxWithTextField(
              label: 'Age',
              selected: ageSelected,
              onChanged: (value) {
                setState(() {
                  ageSelected = value ?? false;
                });
              },
              onTextChanged: (value) {
                setState(() {
                  age = int.tryParse(value) ?? 0;
                });
              },
            ),
            buildCheckBoxWithDropdown(
              label: 'Gender',
              selected: genderSelected,
              onChanged: (value) {
                setState(() {
                  genderSelected = value ?? false;
                });
              },
              currentValue: gender,
              items: ['Male', 'Female'],
              onDropdownChanged: (value) {
                setState(() {
                  gender = value ?? 'Male';
                });
              },
            ),
            buildCheckBoxWithDropdown(
              label: 'Address',
              selected: addressSelected,
              onChanged: (value) {
                setState(() {
                  addressSelected = value ?? false;
                });
              },
              currentValue: address,
              items: [
                'Arada, Addis Ababa',
                'Akaky Kaliti, Addis Ababa',
                'Bole, Addis Ababa',
                'Gullele, Addis Ababa',
                'Kirkos, Addis Ababa',
                'Kolfe Keranio, Addis Ababa',
                'Lideta, Addis Ababa',
                'Nifas Silk-Lafto, Addis Ababa',
                'Yeka, Addis Ababa',
              ],
              onDropdownChanged: (value) {
                setState(() {
                  address = value ?? 'Arada, Addis Ababa';
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE94057),
                elevation: 8,
              ),
              onPressed: () => _updateData(context),
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            Text(
              'Advanced',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE94057),
                elevation: 8,
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateMyInterest(
                              me: widget.me,
                            )))
              },
              child: Text('Change/Add my Intresets'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE94057),
                elevation: 8,
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateMyPrefInterests())),
              },
              child: Text('Change/Add my preferred Intresets'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckBoxWithTextField({
    required String label,
    required bool selected,
    required ValueChanged<bool?> onChanged,
    required ValueChanged<String> onTextChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: onChanged,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        if (selected)
          TextField(
            decoration: InputDecoration(
              labelText: label,
              hintText: "Enter $label to be updated",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 16, 16, 16)),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFE94057)),
                gapPadding: 10,
              ),
            ),
            onChanged: onTextChanged,
          ),
      ],
    );
  }

  Widget buildCheckBoxWithDropdown({
    required String label,
    required bool selected,
    required ValueChanged<bool?> onChanged,
    required String currentValue,
    required List<String> items,
    required ValueChanged<String?> onDropdownChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: onChanged,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
        if (selected)
          DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            onChanged: onDropdownChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
      ],
    );
  }
}
