import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class searchMatch extends StatefulWidget {
  const searchMatch({Key? key}) : super(key: key);

  @override
  State<searchMatch> createState() => _SearchMatchState();
}

class _SearchMatchState extends State<searchMatch> {
  String? _selectedGender;
  final List<String> _images = [
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    'assets/images/IMG_20240207_220819_448.jpg',
    // Add more image paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: _images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Expanded(
                          child: Card(
                            child: Image.asset(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Perform action for like button
                                print('Liked image: $image');
                              },
                              child: const Text("Like"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Perform action for dislike button
                                print('Disliked image: $image');
                              },
                              child: const Text("Dislike"),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  // Handle page change
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomSheet();
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                          print(_selectedGender);
                        });
                      }
                    });
                  },
                  child: const Text("Filter"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Perform action for the button next to the carousel
                  },
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Gender",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildGenderCard("Male"),
              const SizedBox(width: 20),
              _buildGenderCard("Female"),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                // Close the bottom sheet and pass the selected gender
                Navigator.pop(context, _selectedGender);
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String gender) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Card(
        color: _selectedGender == gender ? Colors.blue : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            gender,
            style: TextStyle(
              color: _selectedGender == gender ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
