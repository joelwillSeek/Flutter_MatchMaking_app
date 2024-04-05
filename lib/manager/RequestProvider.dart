import 'package:flutter/material.dart';
import '../services/FirestoreFetcher.dart'; // Import your FirestoreFetcher class

class RequestProvider extends ChangeNotifier {
  final FirestoreFetcher _firestoreFetcher = FirestoreFetcher();
  List<Person> _requests = [];
  bool _isLoading = false;

  List<Person> get requests => _requests;
  bool get isLoading => _isLoading;

  Future<void> fetchRequests() async {
    _isLoading = true;
    notifyListeners();
    try {
      _requests = await _firestoreFetcher.fetchRequests();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching requests: $e');
    }
  }

  void reset() {
    _requests = [];
    _isLoading = false;
    notifyListeners();
  }
}
