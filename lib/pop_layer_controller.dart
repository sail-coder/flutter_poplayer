import 'package:flutter/cupertino.dart';

class PoplayerController extends ChangeNotifier {
  static const int AUTO_TO_TOP = 0;
  static const int AUTO_TO_BOTTOM = 1;
  static const int AUTO_TO_LEFT = 2;
  static const int AUTO_TO_RIGHT = 3;
  static const int TO_Y = 4;

  int event;
  double scrollDelta;

  PoplayerController();

  void autoToTop() {
    event = PoplayerController.AUTO_TO_TOP;
    notifyListeners();
  }

  void autoToBottom() {
    event = PoplayerController.AUTO_TO_BOTTOM;
    notifyListeners();
  }

  void autoToRight() {
    event = PoplayerController.AUTO_TO_RIGHT;
    notifyListeners();
  }

  void autoToLeft() {
    event = PoplayerController.AUTO_TO_LEFT;
    notifyListeners();
  }

  void toY(double delta) {
    event = PoplayerController.TO_Y;
    scrollDelta = delta;
    notifyListeners();
  }
}
