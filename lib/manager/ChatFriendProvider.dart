import 'package:flutter/material.dart';
import 'package:fire/services/FirestoreFetcher.dart'; // Import your FirestoreFetcher class

class ChatFriendProvider with ChangeNotifier {
  List<Person> _chatFriends = [];
  bool _isFetching = false;

  List<Person> get chatFriends => _chatFriends;
  bool get isFetching => _isFetching;

  Future<void> fetchChatFriends() async {
    _isFetching = true;
    notifyListeners();

    try {
      // Fetch chat friends data from Firestore
      _chatFriends = await FirestoreFetcher().fetchFriends();
      sortChatFriendsByLastClicked(); // Sort the list after fetching
    } catch (e) {
      // Handle error
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void sortChatFriendsByLastClicked() {
    _chatFriends.sort((a, b) => b.lastClicked.compareTo(a.lastClicked));
    notifyListeners(); // Notify consumers after sorting
  }

  void reset() {
    _chatFriends = [];
    _isFetching = false;
    notifyListeners();
  }
}
