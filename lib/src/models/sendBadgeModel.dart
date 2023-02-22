import 'package:flutter/material.dart';

class BadgeModel extends ChangeNotifier {
  int badgeNumber = 0;
  void updateBadge(int num) {
    badgeNumber = num;
    onChange();
  }

  void increaseBadge() {
    badgeNumber++;
    onChange();
  }

  void decreaseBadge() {
    if (badgeNumber > 0) badgeNumber--;
    onChange();
  }

  void onChange() {
    notifyListeners();
  }
}
