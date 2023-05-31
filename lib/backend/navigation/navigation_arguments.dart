/*
class LoginScreenNavigationArguments extends NavigationArguments{
  final AdminUserProvider adminUserProvider;
  final String adminAppType;

  const LoginScreenNavigationArguments({
    required this.adminUserProvider,
    required this.adminAppType,
  });
}
*/

import 'package:club_model/club_model.dart';

class AddProductScreenNavigationArguments extends NavigationArguments {
  ProductModel? productModel;
  bool isEdit = false;
  int? index;
  AddProductScreenNavigationArguments({this.isEdit= false,this.productModel,this.index});
}

class AddBrandScreenNavigationArguments extends NavigationArguments {
  BrandModel? brandModel;
  bool isEdit = false;
  int? index;
  AddBrandScreenNavigationArguments({this.isEdit= false,this.brandModel,this.index});
}
