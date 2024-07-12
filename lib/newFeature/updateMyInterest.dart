import 'package:fire/model/Me.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMyInterest extends StatefulWidget {
  final Me me;

  UpdateMyInterest({
    Key? key,
    required this.me,
  }) : super(key: key);

  @override
  State<UpdateMyInterest> createState() => _UpdateMyInterestState();
}

class _UpdateMyInterestState extends State<UpdateMyInterest> {
  final TextEditingController _interestController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addInterest() async {
    if (_interestController.text.isEmpty) return;

    String newInterest = _interestController.text;

    setState(() {
      widget.me.interests.add(newInterest);
    });

    _interestController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding interest...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await _firestore.collection('f_user').doc(widget.me.userId).update({
        'interests': FieldValue.arrayUnion([newInterest]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest added'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add interest: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteInterest(String interest) async {
    setState(() {
      widget.me.interests.remove(interest);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleting interest...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await _firestore.collection('f_user').doc(widget.me.userId).update({
        'interests': FieldValue.arrayRemove([interest]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete interest: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Interests'),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _interestController,
              decoration: InputDecoration(
                labelText: 'Custom Interest',
                hintText: 'Enter interest',
                suffixIcon: IconButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE94057),
                    elevation: 8,
                  ),
                  icon: Icon(Icons.add),
                  onPressed: _addInterest,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: widget.me.interests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () => _deleteInterest(interest),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
