import 'package:club_app_admin/backend/brands_backend/brand_repository.dart';
import 'package:club_model/club_model.dart';

import 'brand_provider.dart';

class BrandController {
  late BrandProvider brandProvider;
  late BrandRepository brandRepository;

  BrandController(
      {required this.brandProvider, BrandRepository? repository}) {
    brandRepository = repository ?? BrandRepository();
  }

  Future<void> getBrandList() async {
    List<BrandModel> brandList = [];
    brandList = await brandRepository.getBrandListRepo();
    if (brandList.isNotEmpty) {
      brandProvider.setBrandsList(brandList);
    }
  }

  Future<void> EnableDisableBrandInFirebase(
      {required Map<String, dynamic> editableData,
      required String id,
      required int listIndex}) async {
    try {
      // await FirebaseNodes.gameDocumentReference(gameId: id)
      //     .update(editableData).then((value) {
      //   MyPrint.printOnConsole("user data: ${editableData["enabled"]}");
      //   gameProvider.updateEnableDisableOfList(editableData["enabled"] , listIndex);
      // });
    } catch (e, s) {
      MyPrint.printOnConsole(
          "Error in Enable Disable rand in firebase in Brand Controller $e");
      MyPrint.printOnConsole(s);
    }
  }

  Future<void> AddBrandToFirebase(BrandModel brandModel,{bool isAdInProvider = false}) async {
    try {
      await brandRepository.AddBrandRepo(brandModel);
      if(isAdInProvider) brandProvider.addBrandModelInBrandList(brandModel);
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in Add Brand to Firebase in Brand Controller $e');
      MyPrint.printOnConsole(s);
    }
  }
}
