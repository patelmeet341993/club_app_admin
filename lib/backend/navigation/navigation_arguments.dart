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
import 'package:club_model/models/brand/data_model/brand_model.dart';
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

class AddBrandScreenNavigationArguments extends NavigationArguments {
  BrandModel? brandModel;
  bool isEdit = false;
  int? index;
  AddBrandScreenNavigationArguments({this.isEdit= false,this.brandModel,this.index});
}
