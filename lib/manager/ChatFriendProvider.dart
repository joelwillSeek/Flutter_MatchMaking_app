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
      _isFetching = true;
      notifyListeners();
      List<Person> fetchedFriends = await FirestoreFetcher().fetchFriends();
      if (fetchedFriends.isNotEmpty) {
        _chatFriends = fetchedFriends;
        sortChatFriendsByLastClicked();
      } else {
        _isFetching = false;
        notifyListeners();
      }
    } catch (e) {
      _isFetching = false;
      notifyListeners();
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

  void removeChatFriend(Person friend) {
    // Remove the friend from the list
    _chatFriends.remove(friend);
    // Notify listeners that the list has changed
    notifyListeners();
  }
}
