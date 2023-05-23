import 'package:club_model/configs/constants.dart';
import 'package:club_model/configs/typedefs.dart';
import 'package:club_model/models/product/data_model/product_model.dart';
import 'package:club_model/utils/my_print.dart';

class ProductRepository {
  Future<List<ProductModel>> getProductListRepo() async {
    List<ProductModel> productList = [];

    try {
      MyFirestoreQuerySnapshot querySnapshot =
          await FirebaseNodes.productsCollectionReference.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (MyFirestoreQueryDocumentSnapshot queryDocumentSnapshot
            in querySnapshot.docs) {
          if (queryDocumentSnapshot.data().isNotEmpty) {
            productList.add(ProductModel.fromMap(queryDocumentSnapshot.data()));
          } else {
            MyPrint.printOnConsole(
                "Product Document Empty for Document Id:${queryDocumentSnapshot.id}");
          }
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole(
          'Error in getProductListRepo in ProductRepository $e');
      MyPrint.printOnConsole(s);
    }

    return productList;
  }

  Future<void> AddProductRepo(ProductModel productModel) async {
    await FirebaseNodes.productDocumentReference(productId: productModel.id)
        .set(productModel.toMap());
  }
}
