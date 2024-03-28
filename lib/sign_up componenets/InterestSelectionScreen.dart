import 'dart:io';

<<<<<<< HEAD
import 'package:fire/sign_up%20componenets/biography.dart';
=======
import 'package:fire/pages/sign_up.dart';
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
import 'package:flutter/material.dart';

class InterestSelectionScreen extends StatefulWidget {
  final String? f, l, gen, ph;
  final File? img;
  final int age;

  const InterestSelectionScreen(
      {super.key,
      required this.f,
      required this.l,
      required this.gen,
      required this.img,
      required this.ph,
      required this.age});

  @override
  _InterestSelectionScreenState createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  List<String> interests = [
    "Traveling",
    "Reading",
    "Cooking",
    "Photography",
    "Fitness",
    "Gardening",
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
<<<<<<< HEAD
                          builder: (context) => Bio(
=======
                          builder: (context) => credentialEmPas(
>>>>>>> 2e9195651c5f68ffb5d31115dfa0f794f9487a76
                            f: widget.f,
                            l: widget.l,
                            gen: widget.gen,
                            img: widget.img,
                            ph: widget.ph,
                            selectedInterests: selectedInterests,
                            age: widget.age,
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
                  backgroundColor:
                      const Color(0xFFE94057), // Change the text color
                  minimumSize:
                      const Size(315, 60), // Change the width and height
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
