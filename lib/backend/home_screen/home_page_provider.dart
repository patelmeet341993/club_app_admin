import 'package:flutter/cupertino.dart';

class HomePageProvider extends ChangeNotifier {
  int _homeTabIndex = 0;
  late BuildContext? _context;

  int get homeTabIndex => _homeTabIndex;

  BuildContext? get context => _context;

  void setHomeTabIndex(int index) {
    _homeTabIndex = index;
    notifyListeners();
  }

  void setBuildContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
}
