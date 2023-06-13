import 'package:club_model/utils/my_print.dart';
import 'package:flutter/foundation.dart';
import 'package:club_model/club_model.dart';

class ClubProvider extends ChangeNotifier {
  List<ClubModel> _clubsList = [];

  List<ClubModel> get clubsList => _clubsList;

  void setClubList(List<ClubModel> value, {bool isNotify = true}) {
    _clubsList.clear();
    _clubsList = value;
    MyPrint.printOnConsole('Clubs List Length is : ${_clubsList.length}');
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableOfClubInList(bool value, int index,
      {bool isNotify = true}) {
    if (index < _clubsList.length) {
      _clubsList[index].clubEnabled = value;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableOfAdminInList(bool value, int index,
      {bool isNotify = true}) {
    if (index < _clubsList.length) {
      _clubsList[index].adminEnabled = value;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void addClubModelInClubList(ClubModel value, {bool isNotify = true}) {
    _clubsList.insert(0, value);
    if (isNotify) {
      notifyListeners();
    }
  }
}
