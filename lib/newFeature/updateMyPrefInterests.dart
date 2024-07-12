import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateMyPrefInterests extends StatefulWidget {
  const UpdateMyPrefInterests({super.key});

  @override
  State<UpdateMyPrefInterests> createState() => _UpdateMyPrefInterestsState();
}

class _UpdateMyPrefInterestsState extends State<UpdateMyPrefInterests> {
  final TextEditingController _interestController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<String>> _futureInterests;
  String userId = "";

  @override
  void initState() {
    super.initState();
    _futureInterests = _fetchInterests();
  }

  Future<List<String>> _fetchInterests() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    userId = user.uid;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .get();

      if (doc.exists) {
        List<dynamic> interestsData = doc['interests'] ?? [];
        return List<String>.from(interestsData);
      } else {
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch interests: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return [];
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _futureInterests = _fetchInterests();
    });
  }

  void _addInterest() async {
    if (_interestController.text.isEmpty) return;

    String newInterest = _interestController.text;

    setState(() {
      _futureInterests = _futureInterests.then((interests) {
        interests.add(newInterest);
        return interests;
      });
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
      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .update({
        'interests': FieldValue.arrayUnion([newInterest]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest added'),
          backgroundColor: Colors.green,
        ),
      );
      await _refresh();
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
      _futureInterests = _futureInterests.then((interests) {
        interests.remove(interest);
        return interests;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleting interest...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await _firestore
          .collection('f_user')
          .doc(userId)
          .collection('preferences')
          .doc(userId)
          .update({
        'interests': FieldValue.arrayRemove([interest]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest deleted'),
          backgroundColor: Colors.green,
        ),
      );
      await _refresh();
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
        title: Text('Update Preferred Match'),
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
              child: FutureBuilder<List<String>>(
                future: _futureInterests,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No interests found.'));
                  } else {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: snapshot.data!.map((interest) {
                        return Chip(
                          label: Text(interest),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () => _deleteInterest(interest),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
