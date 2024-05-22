import 'package:club_model/club_model.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _productsList = [];

  List<ProductModel> get productsList => _productsList;

  void setProductsList(List<ProductModel> value, {bool isNotify = true}) {
    _productsList.clear();
    _productsList = value;
    MyPrint.printOnConsole('Games List Length is : ${_productsList.length}');
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableOfList(bool value, int index,
      {bool isNotify = true}) {
    // if(index < _productsList.length){
    //   _productsList[index].enabled = value;
    // }

    if (isNotify) {
      notifyListeners();
    }
  }

  void addProductModelInGameList(ProductModel value, {bool isNotify = true}) {
    _productsList.insert(0, value);
    if (isNotify) {
      notifyListeners();
    }
  }
}
