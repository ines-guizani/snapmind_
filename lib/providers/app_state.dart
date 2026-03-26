import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int score = 0;
  int level = 1;
  int streak = 0;

  void addXP(int xp) {
    score += xp;
    if (score > level * 100) {
      level++;
    }
    notifyListeners();
  }

  void increaseStreak() {
    streak++;
    notifyListeners();
  }
}