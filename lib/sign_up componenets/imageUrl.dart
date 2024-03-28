import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureSelector extends StatefulWidget {
  const ProfilePictureSelector({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePictureSelectorState createState() => _ProfilePictureSelectorState();
}

class _ProfilePictureSelectorState extends State<ProfilePictureSelector> {
  File? _imageFile;

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100, // Adjust width as needed
          height: 100, // Adjust height as needed
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(10), // Adjust border radius as needed
            border: Border.all(color: Colors.black, width: 2), // Add border
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
              : const Icon(Icons.person, size: 50), // Placeholder icon
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _getImageFromCamera,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.image),
            onPressed: _getImageFromGallery,
          ),
        ),
      ],
    );
  }
}
