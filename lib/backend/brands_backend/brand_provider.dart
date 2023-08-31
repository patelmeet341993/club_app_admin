import 'package:club_model/club_model.dart';
import 'package:club_model/utils/my_print.dart';
import 'package:flutter/foundation.dart';

class BrandProvider extends ChangeNotifier {
  List<BrandModel> _brandsList = [];

  List<BrandModel> get brandsList => _brandsList;

  void setBrandsList(List<BrandModel> value, {bool isNotify = true}) {
    _brandsList.clear();
    _brandsList = value;
    MyPrint.printOnConsole('Brand List Length is : ${_brandsList.length}');
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateEnableDisableOfList(bool value, int index,
      {bool isNotify = true}) {
    if(index < _brandsList.length){
      // _brandsList[index]. = value;
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  void addBrandModelInBrandList(BrandModel value, {bool isNotify = true}) {
    _brandsList.insert(0, value);
    if (isNotify) {
      notifyListeners();
    }
  }
}
