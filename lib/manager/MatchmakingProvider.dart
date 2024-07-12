import 'package:fire/services/FirestoreFetcher.dart';
import 'package:fire/services/MatchmakingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MatchmakingProvider with ChangeNotifier {
  final MatchmakingService _matchmakingService = MatchmakingService();
  List<Person> _matches = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool _hasFetchedMatches = false;

  List<Person> get matches => _matches;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMatches() async {
    if (_hasFetchedMatches) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _matches =
          await _matchmakingService.getRankedPotentialMatches(_currentUserId);
      print("started");
      _hasFetchedMatches = true;

      if (_matches.isEmpty) {
        _errorMessage =
            "Oups, no suggestion for today please adjust your preference";
      }
    } catch (e) {
      _errorMessage = "Oups, unknown error occurred";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshMatches() async {
    _hasFetchedMatches = false;
    await fetchMatches();
  }

  void resetFetchedState() {
    _hasFetchedMatches = false;
  }

  void removeMatch(int index) {
    _matches.removeAt(index);
  }
}
