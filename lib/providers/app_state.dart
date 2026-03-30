import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int score = 0;
  int level = 1;
  int streak = 0;

  // Auth state
  String? userName;
  String? userEmail;
  bool get isLoggedIn => userName != null;

  void signIn(String name, String email) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void signOut() {
    userName = null;
    userEmail = null;
    notifyListeners();
  }

  void addXP(int xp) {
    score += xp;
    if (score >= level * 100) {
      level++;
    }
    notifyListeners();
  }

  void increaseStreak() {
    streak++;
    notifyListeners();
  }
}