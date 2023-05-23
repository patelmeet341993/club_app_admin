import 'package:club_model/backend/common/common_provider.dart';
import 'package:club_model/club_model.dart';

class AdminProvider extends CommonProvider {
  PropertyModel _propertyModel = PropertyModel();
  PropertyModel get propertyModel => _propertyModel;

  PropertyModel getPropertyModel({bool isNewInstance = true}) {
    if (isNewInstance) {
      return PropertyModel.fromMap(_propertyModel.toMap());
    } else {
      return _propertyModel;
    }
  }

  void setPropertyModel(PropertyModel value, {bool isNotify = true}) {
    _propertyModel = PropertyModel.fromMap(value.toMap());
    notify(isNotify: isNotify);
  }

  List<String> getBannerImages() {
    return propertyModel.bannerImages;
  }
}
