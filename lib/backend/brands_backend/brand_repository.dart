import 'package:club_model/club_model.dart';
import 'package:club_model/configs/constants.dart';
import 'package:club_model/configs/typedefs.dart';
import 'package:club_model/utils/my_print.dart';

class BrandRepository {
  Future<List<BrandModel>> getBrandListRepo() async {
    List<BrandModel> brandList = [];

    try {
      MyFirestoreQuerySnapshot querySnapshot =
          await FirebaseNodes.brandCollectionReference.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot
            in querySnapshot.docs) {
          if (queryDocumentSnapshot.data().isNotEmpty) {
            brandList.add(BrandModel.fromMap(queryDocumentSnapshot.data()));
          } else {
            MyPrint.printOnConsole(
                "Brand Document Empty for Document Id:${queryDocumentSnapshot.id}");
          }
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in getBrandListRepo in BrandRepository $e');
      MyPrint.printOnConsole(s);
    }

    return brandList;
  }

  Future<void> AddBrandRepo(BrandModel brandModel) async {
    await FirebaseNodes.brandDocumentReference(brandId: brandModel.id)
        .set(brandModel.toMap());
  }
}
