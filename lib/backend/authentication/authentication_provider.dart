
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/cupertino.dart';

import '../../models/admin/admin_user_model.dart';

class AuthenticationProvider extends ChangeNotifier{
  AdminUserModel? _adminModel;

  AdminUserModel getAdminUserModel() {
    if(_adminModel != null){
      return _adminModel! ;
    }else{
      MyPrint.printOnConsole("Admin is Null");
      return AdminUserModel();
    }
  }

  void setAdminUserModel(AdminUserModel value,{bool isNotify = true}) {
    _adminModel = value;
    if(isNotify) {
      notifyListeners();
    }
  }
}