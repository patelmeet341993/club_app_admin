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
import 'package:club_model/backend/navigation/navigation_arguments.dart';
import 'package:club_model/models/product/data_model/product_model.dart';

class AddEditProductNavigationArgument extends NavigationArguments {
  ProductModel? productModel;
  bool isEdit = false;
  int? index;

  AddEditProductNavigationArgument({
    this.productModel,
    this.isEdit = false,
    this.index,
  });
}

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
