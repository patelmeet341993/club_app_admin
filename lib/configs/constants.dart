//App Version
const String appVersion = "1.0.0";

//Shared Preference Keys
class MySharePreferenceKeys {
  static const String isLogin = "isLogin";
}

class MyAppConstants {
  static const String cClubEnabled = "clubEnabled";

  static const String cAdminEnabled = "adminEnabled";
  static const String subAdminType = "sub_admin";
  static const String clubUserType = "club_user";
  static const String superAdminType = "super_admin";

  static const int userDocumentLimitForPagination = 15; //25 //5
  static const int userRefreshIndexForPagination = 5;

  static const int clubOperatorDocumentLimitForPagination = 15; //25 //5
  static const int clubOperatorRefreshIndexForPagination = 5;
}

class AppUIConfiguration {
  static double borderRadius = 7;
}
