import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_model/models/user/data_model/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _usersList = [];

  List<UserModel> _disabledUsersList = [];

  List<UserModel> get usersList => _usersList;

  List<UserModel> get disabledUsersList => _disabledUsersList;

  bool _usersLoading = false, _hasMoreUsers = false;

  bool _disabledUsersLoading = false, _hasMoredisabledUsers = false;

  DocumentSnapshot<Map<String, dynamic>>? _lastdocument;

  DocumentSnapshot<Map<String, dynamic>>? _disabledUserLastDocument;

  void setUsersList(List<UserModel> value, {bool isNotify = true}) {
    _usersList.clear();
    _usersList = value;
    if (isNotify) {
      notifyListeners();
    }
  }

  void setDisabledUsersList(List<UserModel> value, {bool isNotify = true}) {
    _disabledUsersList.clear();
    _disabledUsersList = value;
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateTestListSingleElement(UserModel usersFeedModel, int index,
      {bool isNotify = true}) {
    if (index < _usersList.length) {
      _usersList[index] = usersFeedModel;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void addAllUsersList(List<UserModel> value, {bool isNotify = true}) {
    _usersList.addAll(value);
    if (isNotify) {
      notifyListeners();
    }
  }

  void addAllDisabledUsersList(List<UserModel> value, {bool isNotify = true}) {
    _disabledUsersList.addAll(value);
    if (isNotify) {
      notifyListeners();
    }
  }

  int get usersListLength => _usersList.length;

  int get disabledUsersListLength => _disabledUsersList.length;

  bool get getHasMoreUsers => _hasMoreUsers;

  bool get getHasMoreDisabledUsers => _hasMoredisabledUsers;

  set setHasMoreUsers(bool hasMoreUser) => _hasMoreUsers = hasMoreUser;

  set setHasMoreDisabledUsers(bool hasMoreDisableUser) =>
      _hasMoredisabledUsers = hasMoreDisableUser;

  DocumentSnapshot<Map<String, dynamic>>? get getLastDocument => _lastdocument;
  set setLastDocument(
          DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) =>
      _lastdocument = documentSnapshot;

  DocumentSnapshot<Map<String, dynamic>>? get getDisabledUsersLastDocument =>
      _disabledUserLastDocument;
  set setDisabledUsersLastDocument(
          DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) =>
      _disabledUserLastDocument = documentSnapshot;

  void addUsersModelInTestList(UserModel value, {bool isNotify = true}) {
    _usersList.add(value);
    if (isNotify) {
      notifyListeners();
    }
  }

  bool get getIsUsersLoading => _usersLoading;
  void setIsUsersLoading(bool isUserLoading, {bool isNotify = true}) {
    _usersLoading = isUserLoading;
    if (isNotify) {
      notifyListeners();
    }
  }

  bool get getIsDisabledUsersLoading => _disabledUsersLoading;
  void setIsDisabledUsersLoading(bool isUserLoading, {bool isNotify = true}) {
    _disabledUsersLoading = isUserLoading;
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateUsersListSingleElement(UserModel userModel, int index,
      {bool isNotify = true}) {
    if (index < _usersList.length) {
      _usersList[index] = userModel;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void removeUsersFromList(int index, {bool isNotify = true}) {
    _usersList.removeAt(index);
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableOfList(bool value, int index,
      {bool isNotify = true}) {
    if (index < _usersList.length) {
      _usersList[index].adminEnabled = value;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableDisabledOfList(bool value, int index,
      {bool isNotify = true}) {
    if (index < _disabledUsersList.length) {
      _disabledUsersList[index].adminEnabled = value;
    }

    if (isNotify) {
      notifyListeners();
    }
  }
}
