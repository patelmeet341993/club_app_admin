import 'package:club_model/models/club/data_model/club_user_model.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/foundation.dart';
import 'package:club_model/club_model.dart';

class ClubProvider extends ChangeNotifier {
  List<ClubModel> _clubsList = [];

  List<ClubModel> get clubsList => _clubsList;

  List<ClubUserModel> _clubUserList = [];

  List<ClubUserModel> get clubUserList => _clubUserList;

  ClubModel? _loggedInClubModel;

  ClubUserModel? _loggedInClubUserModel;


  void setClubList(List<ClubModel> value, {bool isNotify = true}) {
    _clubsList.clear();
    _clubsList = value;
    MyPrint.printOnConsole('Clubs List Length is : ${_clubsList.length}');
    if (isNotify) {
      notifyListeners();
    }
  }

  void setClubUserList(List<ClubUserModel> value, {bool isNotify = true}) {
    _clubUserList.clear();
    _clubUserList = value;
    MyPrint.printOnConsole('Clubs List Length is : ${_clubsList.length}');
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
  void addClubUserModelInClubUserList(ClubUserModel value, {bool isNotify = true}) {
    _clubUserList.insert(0, value);
    if (isNotify) {
      notifyListeners();
    }
  }


  ClubModel getLoggedInClubModel() {
    if (_loggedInClubModel != null) {
      return _loggedInClubModel!;
    } else {
      MyPrint.printOnConsole("Admin is Null");
      return ClubModel();
    }
  }

  ClubUserModel getLoggedInClubUserModel() {
    if (_loggedInClubUserModel != null) {
      return _loggedInClubUserModel!;
    } else {
      MyPrint.printOnConsole("Admin is Null");
      return ClubUserModel();
    }
  }

  void setClubModel(ClubModel value, {bool isNotify = true}) {
    _loggedInClubModel = value;
    if (isNotify) {
      notifyListeners();
    }
  }

}
