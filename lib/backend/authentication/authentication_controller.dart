
import 'package:club_model/club_model.dart';

import '../../configs/constants.dart';

class AuthenticationController{
  static AuthenticationController? _instance;

  factory AuthenticationController() {
    _instance ??= AuthenticationController._();
    return _instance!;
  }

  AuthenticationController._();

  Future<bool> checkUserLoginForFirstTime() async {

    // MyPrint.printOnConsole("In the method of checkUserLoginForFirstTime");
    // User? user = await FirebaseAuth.instance.authStateChanges().first;
    // UserProvider userProvider = Provider.of<UserProvider>(NavigationController.mainScreenNavigator.currentContext!,listen: false);
    // MyPrint.printOnConsole("User in checkUserLoginForFirstTime $user");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isPageLogin =  preferences.getBool(MySharePreferenceKeys.isLogin);

    if(isPageLogin != null){
      return isPageLogin;
    }else{
      return false;
    }

  }

}